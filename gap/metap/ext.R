#' Meta-analysis of p-values, z-scores and effect sizes
#'
#' Combines evidence across studies using Fisher’s method, Stouffer’s Z,
#' and (optionally) inverse-variance meta-analysis when effect sizes
#' are available. Designed for GWAS-scale meta-analysis where some
#' studies may only provide p-values.
#'
#' @param data data.frame containing study statistics.
#' @param N number of studies.
#' @param prefixp prefix for p-value columns (default "p").
#' @param prefixn prefix for sample-size columns (default "n").
#' @param prefixbeta optional prefix for beta columns.
#' @param prefixse optional prefix for standard-error columns.
#' @param sided 1 or 2 for one/two-sided p-values.
#' @param random logical; compute DerSimonian–Laird random effects.
#' @param cor.matrix optional study correlation matrix (sample overlap).
#' @param verbose print results.
#'
#' @return data.frame with meta-analysis statistics.
#'
#' @details
#' ## Methods implemented
#'
#' ### Fisher’s method
#' Tests the global null hypothesis:
#' \deqn{X^2 = -2\sum \log(p_i) \sim \chi^2_{2k}}
#'
#' ### Stouffer’s Z (sample-size weighted)
#' Converts p-values to z-scores and combines:
#' \deqn{Z = \frac{\sum w_i Z_i}{\sqrt{\sum w_i^2}}}
#' with weights \eqn{w_i = \sqrt{n_i}}.
#'
#' Supports:
#' * one- or two-sided p-values
#' * missing studies
#' * correlated studies (sample overlap)
#'
#' If correlation matrix R is supplied:
#' \deqn{Var(Z) = w^T R w}
#'
#' ### Effect-size meta-analysis (optional)
#'
#' If beta/SE available:
#'
#' Fixed effect:
#' \deqn{\hat\beta = \frac{\sum w_i \beta_i}{\sum w_i}},\quad w_i = 1/SE_i^2
#'
#' Cochran's Q:
#' \deqn{Q = \sum w_i (\beta_i - \hat\beta)^2}
#'
#' Heterogeneity:
#' * \eqn{I^2 = max(0,(Q-(k-1))/Q)}
#'
#' Random effects (DerSimonian–Laird):
#' \deqn{\tau^2 = \max\left(0,\frac{Q-(k-1)}{\sum w_i - \sum w_i^2/\sum w_i}\right)}
#'
#' Random-effects weights:
#' \deqn{w_i^* = 1/(SE_i^2 + \tau^2)}
#'
#' These statistics are returned when beta/SE columns exist.
#'
#' @export
metap <- function(
  data, N,
  prefixp="p", prefixn="n",
  prefixbeta=NULL, prefixse=NULL,
  sided=2,
  random=TRUE,
  cor.matrix=NULL,
  verbose=FALSE)
{
  M <- nrow(data)

  ## helper
  get_cols <- function(prefix)
    as.matrix(data[paste0(prefix,1:N)])

  P  <- get_cols(prefixp)
  NN <- get_cols(prefixn)

  if (sided==2)
    Z <- qnorm(1 - P/2)
  else
    Z <- qnorm(1 - P)

  out <- lapply(1:M, function(j){

    p <- P[j,]; n <- NN[j,]; z <- Z[j,]
    keep <- !is.na(p) & !is.na(n)
    p <- p[keep]; n <- n[keep]; z <- z[keep]
    k <- length(p)

    if(k==0) return(rep(NA,12))

    ## Fisher
    x2 <- -2*sum(log(p))
    fisher_p <- pchisq(x2, df=2*k, lower.tail=FALSE)

    ## Stouffer weights
    w <- sqrt(n)

    if(is.null(cor.matrix)){
      z_meta <- sum(w*z)/sqrt(sum(w^2))
    } else {
      R <- cor.matrix[keep,keep]
      z_meta <- sum(w*z)/sqrt(as.numeric(t(w)%*%R%*%w))
    }

    stouffer_p <- if(sided==2) 2*pnorm(-abs(z_meta)) else pnorm(-z_meta)

    ## effect-size meta-analysis if available
    fe_beta=fe_se=re_beta=re_se=Q=I2=tau2 <- NA

    if(!is.null(prefixbeta) & !is.null(prefixse)){
      B  <- as.numeric(data[j,paste0(prefixbeta,1:N)])
      SE <- as.numeric(data[j,paste0(prefixse,1:N)])

      keep2 <- !is.na(B) & !is.na(SE)
      B <- B[keep2]; SE <- SE[keep2]

      if(length(B)>0){
        w_iv <- 1/SE^2

        ## fixed effect
        fe_beta <- sum(w_iv*B)/sum(w_iv)
        fe_se   <- sqrt(1/sum(w_iv))

        ## heterogeneity
        Q <- sum(w_iv*(B-fe_beta)^2)
        df <- length(B)-1
        I2 <- max(0,(Q-df)/Q)

        if(random & df>0){
          tau2 <- max(0,(Q-df)/(sum(w_iv)-sum(w_iv^2)/sum(w_iv)))
          w_re <- 1/(SE^2+tau2)
          re_beta <- sum(w_re*B)/sum(w_re)
          re_se   <- sqrt(1/sum(w_re))
        }
      }
    }

    c(x2,fisher_p,z_meta,stouffer_p,
      fe_beta,fe_se,re_beta,re_se,Q,I2,tau2,k)
  })

  out <- as.data.frame(do.call(rbind,out))
  names(out) <- c("fisher_x2","fisher_p","stouffer_z","stouffer_p",
                  "fe_beta","fe_se","re_beta","re_se",
                  "Q","I2","tau2","k")

  if(verbose) print(summary(out))
  out
}
