#' Power and sample size for case-cohort design
#'
#' @param n the total number of subjects in the cohort.
#' @param q the sampling fraction of the subcohort.
#' @param pD the proportion of the failures in the full cohort.
#' @param p1 proportions of the two groups (p2=1-p1).
#' @param theta log-hazard ratio for two groups.
#' @param alpha type I error -- significance level.
#' @param beta type II error.
#' @param power logical; if TRUE compute power, otherwise sample size.
#' @param verbose logical; print diagnostic messages.
#'
#' @details
#' The power of the test is
#' \deqn{
#' \Phi\left(Z_\alpha + \sqrt{nq}\,\theta\sqrt{p_1 p_2 p_D}\right)
#' }{
#' Phi(Z_alpha + sqrt(n*q)*theta*sqrt(p1*p2*pD))
#' }
#'
#' where \eqn{\alpha}{alpha} is the significance level, \eqn{\theta}{theta}
#' is the log-hazard ratio, \eqn{p_1, p_2}{p1,p2} are group proportions,
#' \eqn{n}{n} is cohort size, \eqn{q}{q} is subcohort sampling fraction,
#' and \eqn{p_D}{pD} is event proportion.
#'
#' The required subcohort size \eqn{m} is
#' \deqn{
#' m = \frac{n B p_D}{n - B (1 - p_D)}
#' }{
#' m = n*B*pD / (n - B*(1-pD))
#' }
#'
#' where
#' \deqn{
#' B = \frac{(Z_{1-\alpha} + Z_\beta)^2}{\theta^2 p_1 p_2 p_D}
#' }{
#' B = (Z_{1-alpha}+Z_beta)^2/(theta^2*p1*p2*pD)
#' }
#'
#' When infeasible configurations are specified (denominator ≤ 0),
#' NA is returned.
#'
#' @return
#' A numeric value: power (if power=TRUE) or required subcohort size.
#'
#' @references
#' Cai J, Zeng D (2004). Sample size/power calculation for case-cohort studies.
#' Biometrics 60: 1015–1024.
#'
#' @examples
#' \dontrun{
#' # ---- Table 1 of Cai & Zeng (2004) ----
#' alpha <- 0.05
#'
#' table1 <- rbind(
#'   transform(
#'     within(expand.grid(
#'       pD = c(0.10, 0.05),
#'       p1 = c(0.3, 0.5),
#'       theta = c(0.5, 1.0),
#'       q = c(0.1, 0.2)
#'     ), {
#'       n <- 1000
#'       power <- mapply(ccsize,
#'         n = n, q = q, pD = pD, p1 = p1, theta = theta,
#'         MoreArgs = list(alpha = alpha)
#'       )
#'     }),
#'     power = signif(power, 3)
#'   ),
#'   transform(
#'     within(expand.grid(
#'       pD = c(0.05, 0.01),
#'       p1 = c(0.3, 0.5),
#'       theta = c(0.5, 1.0),
#'       q = c(0.01, 0.02)
#'     ), {
#'       n <- 5000
#'       power <- mapply(ccsize,
#'         n = n, q = q, pD = pD, p1 = p1, theta = theta,
#'         MoreArgs = list(alpha = alpha)
#'       )
#'     }),
#'     power = signif(power, 3)
#'   )
#' )
#'
#' # ---- ARIC study ----
#' aric <- within(
#'   data.frame(
#'     n = 15792,
#'     pD = 0.03,
#'     p1 = 0.25,
#'     hr = c(1.35, 1.40, 1.45),
#'     q = c(1463, 722, 468) / 15792
#'   ), {
#'     alpha <- 0.05
#'     beta <- 0.2
#'     power <- mapply(ccsize,
#'       n = n, q = q, pD = pD, p1 = p1, theta = log(hr),
#'       MoreArgs = list(alpha = alpha)
#'     )
#'     ssize <- mapply(ccsize,
#'       n = n, q = q, pD = pD, p1 = p1, theta = log(hr),
#'       MoreArgs = list(alpha = alpha, beta = beta, power = FALSE)
#'     )
#'     power <- signif(power, 3)
#'   }
#' )
#'
#' # ---- EPIC study ----
#' epic <- within(
#'   expand.grid(
#'     pD = c(0.3, 0.2, 0.1, 0.05),
#'     p1 = seq(0.1, 0.5, by = 0.1),
#'     hr = seq(1.1, 1.4, by = 0.1)
#'   ), {
#'     n <- 25000
#'     q <- 0.1
#'     alpha <- 5e-8
#'     beta <- 0.2
#'     ssize <- mapply(ccsize,
#'       n = n, q = q, pD = pD, p1 = p1, theta = log(hr),
#'       MoreArgs = list(alpha = alpha, beta = beta, power = FALSE)
#'     )
#'   }
#' )
#' epic <- subset(epic, !is.na(ssize) & ssize > 0)
#'
#' # ---- Exhaustive search ----
#' search <- within(
#'   expand.grid(
#'     pD = c(0.3, 0.2, 0.1, 0.05),
#'     p1 = seq(0.1, 0.5, by = 0.1),
#'     hr = seq(1.1, 1.4, by = 0.1),
#'     q  = seq(0.01, 0.5, by = 0.01)
#'   ), {
#'     n <- 25000
#'     alpha <- 5e-8
#'     power <- mapply(ccsize,
#'       n = n, q = q, pD = pD, p1 = p1, theta = log(hr),
#'       MoreArgs = list(alpha = alpha)
#'     )
#'     nq <- n * q
#'   }
#' )
#'
#' @export

ccsize <- function(n, q, pD, p1, theta, alpha,
                   beta = 0.2, power = TRUE, verbose = FALSE)
{
  # Input validation
  if (!is.numeric(n) || length(n) != 1 || n <= 0)
    stop("n must be a positive number")
  if (!is.numeric(q) || length(q) != 1 || q <= 0 || q >= 1)
    stop("q must be in (0, 1)")
  if (!is.numeric(pD) || length(pD) != 1 || pD <= 0 || pD >= 1)
    stop("pD must be in (0, 1)")
  if (!is.numeric(p1) || length(p1) != 1 || p1 <= 0 || p1 >= 1)
    stop("p1 must be in (0, 1)")
  if (!is.numeric(alpha) || length(alpha) != 1 || alpha <= 0 || alpha >= 1)
    stop("alpha must be in (0, 1)")
  if (!is.numeric(beta) || length(beta) != 1 || beta <= 0 || beta >= 1)
    stop("beta must be in (0, 1)")

  p2 <- 1 - p1

  if (power) {
    ## ---- Power calculation ----
    ## Cai & Zeng (2004) use full cohort variance: p1 * p2 * pD
    z_alpha <- qnorm(alpha)
    z <- z_alpha +
      sqrt(n * q) * theta * sqrt(p1 * p2 * pD)

    if (is.nan(z) || is.infinite(z)) {
      warning("Numerical error in power calculation")
      return(NA)
    }

    return(pnorm(z))
  } else {
    ## ---- Sample size calculation ----
    z_alpha <- qnorm(1 - alpha)
    z_beta  <- qnorm(1 - beta)

    B <- (z_alpha + z_beta)^2 / (theta^2 * p1 * p2 * pD)

    if (is.nan(B) || is.infinite(B) || B < 0) {
      warning("Numerical error in sample size calculation")
      return(NA)
    }

    denom <- n - B * (1 - pD)

    if (denom <= 0) {
      if (verbose)
        message("Infeasible configuration")
      return(NA)
    }

    m <- n * B * pD / denom
    return(ceiling(m))
  }
}
