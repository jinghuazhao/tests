#' Power for population-based association design
#'
#' @param kp population disease prevalence.
#' @param gamma genotype relative risk assuming multiplicative model.
#' @param p frequency of disease allele.
#' @param alpha type I error rate.
#' @param beta type II error rate.
#'
#' @details
#' This function implements \insertCite{scott97;textual}{gap} statistics for population-based
#' association design using a non-centrality parameter approximation.
#'
#' @return
#' A scalar containing the required sample size.
#'
#' @references
#' \insertAllCited{}
#' \insertRef{scott97}{gap}
#' \insertRef{rosner00}{gap}
#' \insertRef{armitage05}{gap}
#'
#' @seealso [`fbsize`]
#'
#' @examples
#' kp <- c(0.01,0.05,0.10,0.2)
#' models <- matrix(c(
#'     4.0, 0.01,
#'     4.0, 0.10,
#'     4.0, 0.50,
#'     4.0, 0.80,
#'     2.0, 0.01,
#'     2.0, 0.10,
#'     2.0, 0.50,
#'     2.0, 0.80,
#'     1.5, 0.01,
#'     1.5, 0.10,
#'     1.5, 0.50,
#'     1.5, 0.80), ncol=2, byrow=TRUE)
#'
#' @author Jing Hua Zhao
#' @keywords misc

pbsize <- function(kp, gamma = 4.5, p = 0.15, alpha = 5e-8, beta = 0.2)
{
  if (!is.finite(kp) || !is.finite(gamma) || !is.finite(p))
    stop("invalid input")

  if (kp <= 0 || kp >= 1 || p <= 0 || p >= 1 || gamma <= 0)
    stop("invalid parameter range")

  z1alpha <- qnorm(1 - alpha / 2)
  zbeta <- qnorm(1 - beta)

  q <- 1 - p
  denom <- (gamma * p + q)^2

  if (!is.finite(denom) || denom <= kp)
    return(NA_real_)

  pi <- kp / denom

  lambda <- pi * p * q * (gamma - 1)^2 / (1 - kp)

  if (!is.finite(lambda) || lambda <= 0)
    return(NA_real_)

  n <- (z1alpha - zbeta)^2 / lambda
  n
}
