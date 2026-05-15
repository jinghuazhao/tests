#' Meta-analysis of p values
#'
#' @param data data frame.
#' @param N Number of studies.
#' @param verbose Control of detailed output.
#' @param prefixp Prefix of p value, with default value "p".
#' @param prefixn Preifx of sample size, with default value "n".
#'
#' @details
#' This function is the method of meta-analysis used in the Genetic Investigation
#' of ANThropometric Traits (GIANT) consortium, which is based on normal approximation
#' of p values and weighted by sample sizes from individual studies.
#'
#' @details
#' Two meta-analysis methods are computed for each row of the input data.
#'
#' ## Fisher's method
#' For p-values \eqn{p_i} from \eqn{N} studies:
#'
#' \deqn{X^2 = -2 \sum_{i=1}^N \log(p_i)}
#'
#' Under the null hypothesis:
#'
#' \deqn{X^2 \sim \chi^2_{2N}}
#'
#' The combined p-value is:
#'
#' \deqn{p_{Fisher} = P(\chi^2_{2N} \ge X^2)}
#'
#'
#' ## Weighted Stouffer Z method
#'
#' First convert two-sided p-values to Z-scores:
#'
#' \deqn{z_i = \Phi^{-1}(1 - p_i/2)}
#'
#' Weights are proportional to the square root of sample size:
#'
#' \deqn{w_i = \frac{\sqrt{n_i}}{\sqrt{\sum_i n_i}}}
#'
#' The combined Z statistic is:
#'
#' \deqn{Z_{meta} = \sum_i w_i z_i
#'        = \frac{\sum_i \sqrt{n_i}\, z_i}{\sqrt{\sum_i n_i}}}
#'
#' Combined p-values:
#'
#' One-sided:
#' \deqn{p_1 = \Phi(-|Z_{meta}|)}
#'
#' Two-sided:
#' \deqn{p_2 = 2\Phi(-|Z_{meta}|)}
#'
#' @export
#' @return
#' - x2 Fisher's chi-squared statistics.
#' - p P values from Fisher's method according to chi-squared distribution with 2*N degree(s) of freedom.
#' - z Combined z value.
#' - p1 One-sided p value.
#' - p2 Two-sided p value.
#'
#' @examples
#' \dontrun{
#' # Weighted Z meta-analysis example
#' s <- data.frame(
#'   p1 = 0.1^rep(8:2, each = 7),
#'   n1 = rep(32000, 49),
#'   p2 = 0.1^rep(8:2, times = 7),
#'   n2 = rep(8000, 49)
#' )
#' cbind(s, metap(s, 2))
#'
#' # Speliotes, Elizabeth K., M.D. [ESPELIOTES@PARTNERS.ORG]
#' # 22-2-2008 MRC-Epid JHZ
#'
#' np <- 7
#' p  <- 0.1^((np + 1):2)
#' z  <- qnorm(1 - p/2)
#' n  <- c(32000, 8000)
#'
#' grid <- expand.grid(i = seq_len(np), j = seq_len(np))
#' za <- z[grid$i]
#' zb <- z[grid$j]
#' metaz_equalN   <- (sqrt(n[1]) * za + sqrt(n[1]) * zb) / sqrt(n[1] + n[1])
#' metaz_unequalN <- (sqrt(n[1]) * za + sqrt(n[2]) * zb) / sqrt(n[1] + n[2])
#' metap_equalN   <- pnorm(-abs(metaz_equalN))
#' metap_unequalN <- pnorm(-abs(metaz_unequalN))
#'
#' results <- data.frame(
#'   k = seq_len(nrow(grid)),
#'   p_i = p[grid$i],
#'   p_j = p[grid$j],
#'   metap_equalN, metaz_equalN,
#'   metap_unequalN, metaz_unequalN
#' )
#' print(results)
#'
#' q  <- -log10(sort(p, decreasing = TRUE))
#' t1 <- matrix(-log10(sort(metap_equalN,   decreasing = TRUE)), np, np)
#' t2 <- matrix(-log10(sort(metap_unequalN, decreasing = TRUE)), np, np)
#'
#' par(mfrow = c(1,2), bg = "white", mar = c(4.2,3.8,0.2,0.2))
#' persp(q, q, t1, main = "Equal sample sizes")
#' persp(q, q, t2, main = "Unequal sample sizes")
#' }
#'
#' @seealso [`metareg`]
#'
#' @author Jing Hua Zhao
#'
metap <- function(data, N, verbose = TRUE, prefixp = "p", prefixn = "n") {
  stopifnot(is.data.frame(data), N >= 1)
  p_cols <- paste0(prefixp, seq_len(N))
  n_cols <- paste0(prefixn, seq_len(N))
  if (!all(p_cols %in% names(data)))
    stop("Missing p-value columns: ", paste(setdiff(p_cols, names(data)), collapse=", "))
  if (!all(n_cols %in% names(data)))
    stop("Missing sample-size columns: ", paste(setdiff(n_cols, names(data)), collapse=", "))
  P <- as.matrix(data[p_cols])   # M x N matrix of p-values
  Nmat <- as.matrix(data[n_cols])# M x N matrix of sample sizes
  if (any(P <= 0 | P > 1, na.rm = TRUE))
    stop("p-values must be in (0,1]")
# Fisher’s method
  x2 <- -2 * rowSums(log(P))
  fisher_p <- pchisq(x2, df = 2 * N, lower.tail = FALSE)
# Weighted Stouffer Z
  weights <- sqrt(Nmat)
  weights <- weights / sqrt(rowSums(weights^2))
  Z <- qnorm(1 - P / 2)
  metaz <- rowSums(weights * Z)
  metap1 <- pnorm(-abs(metaz))
  metap2 <- 2 * metap1
  out <- data.frame(
    x2 = x2,
    fisher_p = fisher_p,
    z = metaz,
    stouffer_p_one = metap1,
    stouffer_p_two = metap2
  )
  if (verbose) {
    cat("\nFisher method:\n")
    print(out[, c("x2", "fisher_p")], row.names = FALSE)
    cat("\nWeighted Stouffer Z:\n")
    print(out[, c("z", "stouffer_p_one", "stouffer_p_two")], row.names = FALSE)
  }
  return(out)
}

metap3 <- function(
  data, N,
  sided = c("two","one"),
  verbose = TRUE,
  prefixp="p", prefixn="n",
  prefixbeta=NULL, prefixdir=NULL
){
  sided <- match.arg(sided)

  p_cols <- paste0(prefixp, seq_len(N))
  n_cols <- paste0(prefixn, seq_len(N))

  P <- as.matrix(data[p_cols])
  Nmat <- as.matrix(data[n_cols])

  M <- nrow(P)

  ## --- optional direction ---
  sign_mat <- matrix(1, M, N)
  if (!is.null(prefixbeta)) {
    B <- as.matrix(data[paste0(prefixbeta, seq_len(N))])
    sign_mat <- sign(B)
  }
  if (!is.null(prefixdir)) {
    sign_mat <- as.matrix(data[paste0(prefixdir, seq_len(N))])
  }

  ## --- convert p to Z ---
  if (sided=="two") Z <- qnorm(1 - P/2)
  if (sided=="one") Z <- qnorm(1 - P)
  Z <- Z * sign_mat

  ## --- prepare outputs ---
  fisher_p <- stouffer_FE <- stouffer_RE <- rep(NA, M)
  Q <- I2 <- tau2 <- rep(NA, M)

  for (j in seq_len(M)) {

    keep <- which(!is.na(P[j,]) & !is.na(Nmat[j,]))
    if (length(keep) < 1) next

    pj <- P[j,keep]
    nj <- Nmat[j,keep]
    zj <- Z[j,keep]
    k  <- length(keep)

    ## Fisher
    x2 <- -2 * sum(log(pj))
    fisher_p[j] <- pchisq(x2, df = 2*k, lower.tail=FALSE)

    ## Fixed-effect Stouffer
    w <- sqrt(nj)
    w <- w / sqrt(sum(w^2))
    z_FE <- sum(w * zj)
    stouffer_FE[j] <- 2*pnorm(-abs(z_FE))

    ## --- Random effects ---
    wi <- nj  # inverse-variance approx
    z_bar <- sum(wi*zj)/sum(wi)
    Q[j] <- sum(wi*(zj - z_bar)^2)

    cval <- sum(wi) - sum(wi^2)/sum(wi)
    tau2[j] <- max(0, (Q[j]-(k-1))/cval)

    wi_star <- 1/(1/wi + tau2[j])
    z_RE <- sum(wi_star*zj)/sqrt(sum(wi_star))
    stouffer_RE[j] <- 2*pnorm(-abs(z_RE))

    I2[j] <- max(0, (Q[j]-(k-1))/Q[j])
  }

  out <- data.frame(
    fisher_p,
    stouffer_FE,
    stouffer_RE,
    Q, I2, tau2
  )

  if (verbose) print(head(out))
  out
}
