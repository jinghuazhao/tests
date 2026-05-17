#' Unified multivariate meta-analysis (FE/ML/REML)
#'
#' @param b Numeric matrix of dimension \eqn{k \times p} containing the observed
#'   study-specific effect estimates. Missing outcomes must be coded as `NA`.
#' @param V List of length \eqn{k}. Each element must be a \eqn{p \times p}
#'   within-study covariance matrix corresponding to the same row of `b`.
#' @param method Character string specifying the estimation method.
#'   Must be one of `"FE"`, `"ML"`, or `"REML"`.
#' @param control List of control arguments passed to `optim()`.
#'
#' @description
#' From-first-principles implementation of multivariate meta-analysis using
#' only base R linear algebra. The estimator is computed via a blockwise
#' generalized least-squares formulation using per-study Cholesky
#' factorisation and without constructing large Kronecker-product matrices.
#'
#' Fixed-effects, maximum likelihood, and restricted maximum likelihood
#' estimators are provided within a unified framework.
#'
#' @details
#' \strong{Model}
#'
#' Multivariate random-effects meta-analysis assumes
#' \deqn{y_i \sim N_p(\beta, V_i + \Psi)}
#' where
#' \eqn{y_i} denotes the observed effect vector for study \eqn{i},
#' \eqn{V_i} is the within-study covariance matrix,
#' \eqn{\Psi} is the between-study covariance matrix,
#' and \eqn{\beta} represents the pooled effects.
#'
#' Studies may report only a subset of outcomes. Missing values are handled
#' by constructing study-specific likelihood contributions based only on
#' the observed components.
#'
#' \strong{Blockwise GLS formulation}
#'
#' For each study the marginal covariance matrix is
#' \deqn{\Sigma_i = V_i + \Psi}
#' and generalized least-squares normal equations are accumulated across
#' studies to obtain the pooled estimator
#' \deqn{\hat{\beta} = (X^T\Sigma^{-1}X)^{-1}X^T\Sigma^{-1}y.}
#'
#' \strong{Likelihood estimation of heterogeneity}
#'
#' The between-study covariance matrix is parameterised through a Cholesky
#' factorisation \eqn{\Psi = LL^T}. The likelihood is profiled with respect to
#' the fixed effects and maximised using `optim()`. REML estimation includes
#' the additional Jacobian term \eqn{\log|X^T\Sigma^{-1}X|}.
#'
#' \strong{Heterogeneity}
#'
#' Multivariate Cochran's Q statistic is computed from GLS residuals as
#' \deqn{Q = \sum_i r_i^T \Sigma_i^{-1} r_i}
#' with degrees of freedom \eqn{n_{obs} - p}.
#'
#' A small diagonal regularisation term (controlled by control$jitter)
#' is added to the between-study covariance matrix to guarantee positive
#' definiteness during optimisation. This may cause tiny numerical
#' differences in the estimated covariance and correlation matrices.
#'
#' @return
#' A list containing the pooled effect estimates, their covariance and
#' correlation matrices, the estimated between-study covariance matrix,
#' heterogeneity statistics, likelihood-based information criteria, and
#' optimisation diagnostics.
#'
#' The element `beta` is the vector of pooled effects \eqn{\hat{\beta}}.
#' The element `cov.beta` is the covariance matrix of the pooled effects
#' equal to \eqn{(X^T\Sigma^{-1}X)^{-1}}. The element `cor.beta` is the
#' corresponding correlation matrix.
#'
#' The element `Psi` contains the estimated between-study covariance matrix.
#' The elements `Q`, `df`, and `pvalue` provide the multivariate Cochran
#' heterogeneity test.
#'
#' The elements `logLik`, `AIC`, and `BIC` contain likelihood-based model
#' fit statistics (not available for the fixed-effects model).
#'
#' The element `convergence` reports the optimisation convergence code
#' returned by `optim()`. The element `method` indicates the estimation
#' method used.
#'
#' @references
#' Jackson D, Riley R, White IR (2011).
#' Multivariate meta-analysis: potential and promise.
#' \emph{Statistics in Medicine}, 30(20), 2481–2498.
#'
#' Gasparrini A, Armstrong B, Kenward MG (2012).
#' Multivariate meta-analysis for non-linear and other multi-parameter
#' associations. \emph{Statistics in Medicine}, 31(29), 3821–3839.
#'
#' @examples
#' \donttest{
#' # Example 1: simulated multivariate meta-analysis
#' set.seed(1)
#' k <- 6; p <- 5
#' beta_true <- c(0.8,1.4,1.7,2.2,2.1)
#' Psi_true <- diag(c(0.05,0.07,0.08,0.09,0.06))
#'
#' rmvnorm_chol <- function(n, mu, Sigma) {
#'   L <- chol(Sigma)
#'   matrix(rnorm(n * length(mu)), n) %*% L + 
#'     matrix(mu, n, length(mu), byrow = TRUE)
#' }
#' b <- matrix(NA,k,p)
#' Vlist <- vector("list",k)
#' for(i in 1:k){
#'   Si <- diag(runif(p,0.02,0.06))
#'   Vlist[[i]] <- Si
#' # b[i,] <- MASS::mvrnorm(1, beta_true, Psi_true + Si)
#'   b[i,] <- rmvnorm_chol(1, beta_true, Psi_true + Si)
#' }
#' b[2,1] <- NA; b[3,3] <- NA; b[4,4] <- NA
#' mvmeta_unified(b, Vlist, "REML")
#'
#' # Example 2: structured covariance matrices
#' b <- matrix(c(
#' 0.808,1.308,1.379,NA,NA,
#' NA,1.266,1.828,1.962,NA,
#' NA,1.835,NA,2.568,NA,
#' NA,1.272,NA,NA,2.038,
#' 1.171,2.024,2.423,3.159,NA,
#' 0.681,NA,NA,NA,NA), ncol=5, byrow=TRUE)
#'
#' psi1 <- psi2 <- psi3 <- psi4 <- psi5 <- psi6 <- matrix(0,5,5)
#' psi1[1,1]=0.0985; psi1[1,2]=0.0611; psi1[1,3]=0.0623
#' psi1[2,2]=0.1142; psi1[2,3]=0.0761; psi1[3,3]=0.1215
#' psi2[2,2]=0.0713; psi2[2,3]=0.0539; psi2[2,4]=0.0561
#' psi2[3,3]=0.0938; psi2[3,4]=0.0698; psi2[4,4]=0.0981
#' psi3[2,2]=0.1228; psi3[2,4]=0.1119; psi3[4,4]=0.1790
#' psi4[2,2]=0.0562; psi4[2,5]=0.0459; psi4[5,5]=0.0815
#' psi5[1,1]=0.0895; psi5[1,2]=0.0729; psi5[1,3]=0.0806; psi5[1,4]=0.0950
#' psi5[2,2]=0.1350; psi5[2,3]=0.1151; psi5[2,4]=0.1394
#' psi5[3,3]=0.1669; psi5[3,4]=0.1609; psi5[4,4]=0.2381
#' psi6[1,1]=0.0223
#'
#' Vlist <- list(psi1,psi2,psi3,psi4,psi5,psi6)
#' mvmeta_unified(b, Vlist, "REML")
#' }
#' @export
#'
mvmeta_unified <- function(b, V, method = c("FE","ML","REML"),
                           control = list(maxit = 1000, jitter = 1e-10))
{
  if(!is.matrix(b))
    stop("b must be a numeric matrix")
  if(!is.list(V))
    stop("V must be a list of covariance matrices")
  if(length(V) != nrow(b))
    stop("length(V) must equal number of studies (nrow(b))")
  method <- match.arg(method)

  k <- nrow(b)
  p <- ncol(b)
  Xi_full <- diag(1, p)

  chol_solve <- function(L, y)
    backsolve(L, forwardsolve(t(L), y))

  jitter <- if (is.null(control$jitter)) 1e-10 else control$jitter

  optim_control <- control
  optim_control$jitter <- NULL 

  build_Psi <- function(theta) {
    L <- matrix(0, p, p)
    L[lower.tri(L, TRUE)] <- theta
    Psi <- L %*% t(L)
    Psi + diag(jitter, p)
  }

  # ---------- GLS FIT ----------
  gls_fit <- function(Psi) {

    XtVX <- matrix(0, p, p)
    XtVy <- rep(0, p)
    nobs <- 0

    for(i in 1:k) {
      bi <- b[i, ]
      obs <- !is.na(bi)

      yi <- bi[obs]
      Xi <- Xi_full[obs,,drop=FALSE]
      Vi <- V[[i]][obs,obs,drop=FALSE] + Psi[obs,obs,drop=FALSE]

      L <- tryCatch(chol(Vi), error = function(e) return(NULL))
      if(is.null(L)) return(-1e30)
      Vi_inv_y <- chol_solve(L, yi)
      Vi_inv_X <- chol_solve(L, Xi)

      XtVX <- XtVX + crossprod(Xi, Vi_inv_X)
      XtVy <- XtVy + crossprod(Xi, Vi_inv_y)
      nobs <- nobs + length(yi)
    }

  XtVX_inv <- solve(XtVX)
  beta <- XtVX_inv %*% XtVy

  list(
    beta = drop(beta),
    cov.beta = XtVX_inv,
    XtVX = XtVX,
    nobs = nobs
  )
  }

  # ---------- LOG-LIKELIHOOD ----------
  logLik_fun <- function(theta) {

    Psi <- build_Psi(theta)
    gls <- gls_fit(Psi)
    if(!is.list(gls)) return(-1e30)
    beta <- gls$beta
    ll <- 0

    for(i in 1:k) {
      bi <- b[i, ]
      obs <- !is.na(bi)

      yi <- bi[obs]
      Xi <- Xi_full[obs,,drop=FALSE]
      Vi <- V[[i]][obs,obs,drop=FALSE] + Psi[obs,obs,drop=FALSE]

      L <- chol(Vi)
      ri <- yi - Xi %*% beta
      zi <- forwardsolve(t(L), ri)

      ll <- ll - sum(log(diag(L))) - 0.5 * sum(zi^2)
    }

    if(method == "REML") {
      Lx <- chol(gls$XtVX)
      ll <- ll - sum(log(diag(Lx)))
    }

    as.numeric(ll)
  }

  # ---------- ESTIMATE PSI ----------
  if(method == "FE") {
    Psi <- matrix(0,p,p)
    opt <- list(convergence = 0, value = NA)
  } else {

    theta0 <- rep(0.01, p*(p+1)/2)

    opt <- optim(theta0,
                 fn = function(th) -logLik_fun(th),
                 method = "BFGS",
                 control = optim_control)

    if(opt$convergence != 0)
      warning("optim did not converge", call. = FALSE)

    Psi <- build_Psi(opt$par)
  }

  # ---------- FINAL GLS ----------
  fit <- gls_fit(Psi)
  if(!is.list(fit))
    stop("Final GLS failed: covariance matrix not positive definite.")

  # ---------- HETEROGENEITY Q ----------
  compute_Q <- function() {
    Q <- 0
    n <- 0

    for(i in 1:k) {
      bi <- b[i, ]
      obs <- !is.na(bi)

      yi <- bi[obs]
      Xi <- Xi_full[obs,,drop=FALSE]
      Vi <- V[[i]][obs,obs,drop=FALSE] + Psi[obs,obs,drop=FALSE]

      L <- chol(Vi)
      ri <- yi - Xi %*% fit$beta
      zi <- forwardsolve(t(L), ri)

      Q <- Q + sum(zi^2)
      n <- n + length(yi)
    }

    list(Q = Q, df = n - p)
  }

  Qres <- compute_Q()

  # ---------- IC ----------
  ll <- if(method=="FE") NA else -opt$value
  if(method == "FE") {
    ll  <- NA
    AIC <- NA
    BIC <- NA
  } else {
    ll <- -opt$value
    npar <- if(method=="ML")
               length(fit$beta) + p*(p+1)/2
            else
               p*(p+1)/2
    AIC <- -2*ll + 2*npar
    BIC <- -2*ll + log(fit$nobs)*npar
  }

  sd <- sqrt(diag(fit$cov.beta))
  cor.beta <- fit$cov.beta / (sd %o% sd)
  diag(cor.beta) <- 1

  list(
    beta = fit$beta,
    cov.beta = fit$cov.beta,
    cor.beta = cor.beta,
    Psi = Psi,
    Q = Qres$Q,
    df = Qres$df,
    pvalue = 1 - pchisq(Qres$Q, Qres$df),
    logLik = ll,
    AIC = AIC,
    BIC = BIC,
    convergence = opt$convergence,
    method = method
  )
}

set.seed(1)

k <- 6
p <- 5

beta_true <- c(0.8,1.4,1.7,2.2,2.1)
Psi_true <- diag(c(0.05,0.07,0.08,0.09,0.06))

b <- matrix(NA,k,p)
Vlist <- vector("list",k)

for(i in 1:k){

  Si <- diag(runif(p,0.02,0.06))
  Vlist[[i]] <- Si

  b[i,] <- MASS::mvrnorm(1, beta_true, Psi_true + Si)
}

b[2,1] <- NA
b[3,3] <- NA
b[4,4] <- NA

mvmeta_unified(b, Vlist, "REML")

b <- matrix(c(
0.808,1.308,1.379,NA,NA,
NA,1.266,1.828,1.962,NA,
NA,1.835,NA,2.568,NA,
NA,1.272,NA,NA,2.038,
1.171,2.024,2.423,3.159,NA,
0.681,NA,NA,NA,NA
), ncol=5, byrow=TRUE)

psi1 <- psi2 <- psi3 <- psi4 <- psi5 <- psi6 <- matrix(0,5,5)

psi1[1,1]=0.0985; psi1[1,2]=0.0611; psi1[1,3]=0.0623
psi1[2,2]=0.1142; psi1[2,3]=0.0761; psi1[3,3]=0.1215

psi2[2,2]=0.0713; psi2[2,3]=0.0539; psi2[2,4]=0.0561
psi2[3,3]=0.0938; psi2[3,4]=0.0698; psi2[4,4]=0.0981

psi3[2,2]=0.1228; psi3[2,4]=0.1119; psi3[4,4]=0.1790
psi4[2,2]=0.0562; psi4[2,5]=0.0459; psi4[5,5]=0.0815

psi5[1,1]=0.0895; psi5[1,2]=0.0729; psi5[1,3]=0.0806; psi5[1,4]=0.0950
psi5[2,2]=0.1350; psi5[2,3]=0.1151; psi5[2,4]=0.1394
psi5[3,3]=0.1669; psi5[3,4]=0.1609; psi5[4,4]=0.2381

psi6[1,1]=0.0223

Vlist <- list(psi1,psi2,psi3,psi4,psi5,psi6)

mvmeta_unified(b, Vlist, "REML", control = list(maxit = 1000, jitter = 0))
mvmeta_unified(b, Vlist, "FE", control = list(maxit = 1000, jitter = 0))
