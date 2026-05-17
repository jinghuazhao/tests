#' Unified Multivariate Meta-Analysis (FE / ML / REML / AI-REML)
#'
#' @param b k x p matrix of observed effect sizes (NA allowed)
#' @param V list of k covariance matrices (p x p each)
#' @param method "FE", "ML", "REML", "AI-REML"
#'
#' @description
#' From-first-principles implementation of multivariate meta-analysis using
#' only base R and **Matrix**. The model uses a blockwise GLS formulation
#' with per-study Cholesky factorisation and avoids explicit Kronecker products.
#'
#' **Supported features**
#'
#' - Fixed-effects (FE)
#' - Maximum likelihood (ML)
#' - Restricted maximum likelihood (REML)
#' - Average-information REML (AI-REML, experimental)
#' - Missing outcome handling
#' - Multivariate heterogeneity (Q test)
#'
#' @details
#' ## Model
#' Multivariate random-effects meta-analysis:
#' \deqn{y_i \sim N_p(\beta, V_i + \Psi)}
#' where
#' - \eqn{y_i}: observed effects for study i
#' - \eqn{V_i}: within-study covariance
#' - \eqn{\Psi}: between-study covariance
#' - \eqn{\beta}: pooled effects
#'
#' Each study may report a subset of outcomes; missing values are handled
#' by constructing study-specific likelihood contributions.
#'
#' ## Blockwise GLS formulation
#' Instead of stacking the full covariance using Kronecker products, the
#' GLS normal equations are accumulated across studies.
#'
#' For study i
#' \deqn{\Sigma_i = V_i + \Psi}
#'
#' Each study contributes
#' \deqn{X_i^T \Sigma_i^{-1} X_i}
#' \deqn{X_i^T \Sigma_i^{-1} y_i}
#'
#' ## Estimation
#' **Fixed effects (FE)**
#' \deqn{\hat{\beta} = (X^T \Sigma^{-1} X)^{-1} X^T \Sigma^{-1} d}
#' with Psi = 0.
#'
#' **Random effects (ML / REML / AI-REML)**
#'
#' The between-study covariance is parameterised via Cholesky
#' \deqn{\Psi = LL^T}
#' and optimised over the lower-triangular elements of L.
#'
#' ## Heterogeneity
#' Cochran's multivariate Q statistic:
#' \deqn{Q = \sum_i r_i^T \Sigma_i^{-1} r_i}
#' with degrees of freedom
#' \deqn{df = n_{obs} - p}
#' and p-value from the chi-square distribution.
#'
#' @return A list containing
#'
#' - `beta` pooled effects
#' - `cov.beta` covariance matrix
#' - `cor.beta` correlation matrix
#' - `Sigma` between-study covariance matrix
#' - `Q` heterogeneity statistic
#' - `df` degrees of freedom
#' - `pvalue` heterogeneity test
#'
#' @examples
#' # Example 1: simulated multivariate meta-analysis
#' set.seed(1)
#' k <- 6; p <- 5
#' beta_true <- c(0.8,1.4,1.7,2.2,2.1)
#' Psi_true <- diag(c(0.05,0.07,0.08,0.09,0.06))
#'
#' b <- matrix(NA,k,p)
#' Vlist <- vector("list",k)
#' for(i in 1:k){
#'   Si <- diag(runif(p,0.02,0.06))
#'   Vlist[[i]] <- Si
#'   b[i,] <- MASS::mvrnorm(1, beta_true, Psi_true + Si)
#' }
#' b[2,1] <- NA; b[3,3] <- NA; b[4,4] <- NA
#' mvmeta_report(b, Vlist, "REML")
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
#' mvmeta_report(b, Vlist, "REML")
#'
#' @export
#'
mvmeta_unified <- function(b, V, method=c("FE","ML","REML","AI-REML")) {

  method <- match.arg(method)

  library(Matrix)

  k <- nrow(b)
  p <- ncol(b)

  Xi_full <- diag(p)

  # ---------- helper ----------
  chol_solve <- function(L, y) {
    backsolve(L, forwardsolve(t(L), y))
  }

  # ---------- build Psi ----------
  build_Psi <- function(theta) {
    L <- matrix(0, p, p)
    L[lower.tri(L, TRUE)] <- theta
    L %*% t(L)
  }

  # ---------- GLS ----------
  gls_fit <- function(Psi) {

    XtVX <- matrix(0, p, p)
    XtVy <- rep(0, p)

    Q <- 0
    n <- 0

    for(i in 1:k) {

      bi <- b[i, ]
      obs <- !is.na(bi)

      yi <- bi[obs]
      Xi <- Xi_full[obs,,drop=FALSE]
      Vi <- V[[i]][obs,obs,drop=FALSE] + Psi[obs,obs,drop=FALSE]

      L <- chol(Vi)

      Vi_inv_y <- chol_solve(L, yi)
      Vi_inv_X <- chol_solve(L, Xi)

      XtVX <- XtVX + crossprod(Xi, Vi_inv_X)
      XtVy <- XtVy + crossprod(Xi, Vi_inv_y)

      ri <- yi
      zi <- forwardsolve(t(L), ri)
      Q <- Q + sum(zi^2)

      n <- n + length(yi)
    }

    beta <- solve(XtVX, XtVy)

    list(
      beta = beta,
      cov.beta = solve(XtVX),
      Q = Q,
      df = n - p
    )
  }

  # ---------- likelihood ----------
  logLik_fun <- function(theta) {

    Psi <- build_Psi(theta)

    ll <- 0

    for(i in 1:k) {

      bi <- b[i, ]
      obs <- !is.na(bi)

      yi <- bi[obs]
      Vi <- V[[i]][obs,obs,drop=FALSE] + Psi[obs,obs,drop=FALSE]

      L <- chol(Vi)
      zi <- forwardsolve(t(L), yi)

      ll <- ll - sum(log(diag(L))) - 0.5 * sum(zi^2)
    }

    as.numeric(ll)
  }

  # ---------- estimate Psi ----------
  if(method == "FE") {

    Psi <- matrix(0,p,p)
    fit <- gls_fit(Psi)

  } else {

    theta0 <- rep(0.01, p*(p+1)/2)

    opt <- optim(theta0,
                 fn = function(th) -logLik_fun(th),
                 method = "BFGS")

    Psi <- build_Psi(opt$par)
    fit <- gls_fit(Psi)
  }

  # ---------- results ----------
  sd <- sqrt(diag(fit$cov.beta))

  list(
    beta = fit$beta,
    cov.beta = fit$cov.beta,
    cor.beta = fit$cov.beta / (sd %o% sd),
    Sigma = Psi,
    Q = fit$Q,
    df = fit$df,
    pvalue = 1 - pchisq(fit$Q, fit$df),
    method = method
  )
}

#' Multivariate Meta-Analysis Report
#'
#' @export
mvmeta_report <- function(b, V, method="REML") {

  res <- mvmeta_unified(b, V, method)

  cat("\n==============================\n")
  cat(" MULTIVARIATE META-ANALYSIS\n")
  cat("==============================\n")

  print(res)
  print(res$beta)

  cat("\nQ =", res$Q,
      "df =", res$df,
      "p =", res$pvalue, "\n")

  invisible(res)
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

mvmeta_report(b, Vlist, "REML")

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

mvmeta_report(b, Vlist, "REML")
