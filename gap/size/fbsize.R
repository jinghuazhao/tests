#' Sample size for family-based linkage and association design
#'
#' @param gamma genotype relative risk assuming multiplicative model.
#' @param p frequency of disease allele.
#' @param alpha Type I error rates for ASP linkage, TDT and ASP-TDT.
#' @param beta Type II error rate.
#' @param debug verbose output.
#' @param error 0 = use correct formula, 1 = original paper approximation.
#'
#' @details
#' This function implements Risch and Merikangas (1996) statistics
#' for affected sib pair (ASP), TDT, and combined ASP-TDT designs.
#'
#' @return A list containing:
#' \describe{
#'   \item{gamma}{input genotype relative risk}
#'   \item{p}{allele frequency}
#'   \item{y}{ASP parameter}
#'   \item{n1}{ASP sample size}
#'   \item{pA}{allele transmission probability}
#'   \item{h1}{TDT parameter}
#'   \item{n2}{TDT sample size}
#'   \item{h2}{ASP-TDT parameter}
#'   \item{n3}{ASP-TDT sample size}
#'   \item{lambdao}{overall sibling risk}
#'   \item{lambdas}{sibling risk under model}
#' }
#'
#' @references
#' \insertAllCited{}
#' \insertRef{risch96}{gap}
#' \insertRef{risch97}{gap}
#' \insertRef{scott97}{gap}
#'
#' @seealso [`pbsize`]
#'
#' @examples
#' models <- matrix(c(
#'    4.0, 0.01,
#'    4.0, 0.10,
#'    4.0, 0.50,
#'    4.0, 0.80,
#'    2.0, 0.01,
#'    2.0, 0.10,
#'    2.0, 0.50,
#'    2.0, 0.80,
#'    1.5, 0.01,
#'    1.5, 0.10,
#'    1.5, 0.50,
#'    1.5, 0.80), ncol=2, byrow=TRUE)
#'
#' @author Jing Hua Zhao
#' @keywords misc

fbsize <- function(gamma, p,
                   alpha = c(1e-4, 1e-8, 1e-8),
                   beta = 0.2,
                   debug = 0,
                   error = 0)
{
  if (!is.finite(gamma) || !is.finite(p))
    stop("invalid input")

  if (gamma <= 0 || p <= 0 || p >= 1)
    stop("invalid parameter range")

  sn <- function(all, alpha, beta, op)
  {
    m <- all[1]
    v <- all[2]

    if (!is.finite(m) || !is.finite(v) || v < 0)
      return(NA_real_)

    z1beta <- qnorm(1 - beta)
    zalpha <- qnorm(1 - alpha)

    s <- ((zalpha - sqrt(v) * z1beta) / m)^2 / 2
    if (op == 3) s <- s / 2
    s
  }

  q <- 1 - p
  denom <- (p * gamma + q)

  if (!is.finite(denom) || denom <= 0)
    return(list(gamma=gamma,p=p,n1=NA,n2=NA,n3=NA))

  w <- p * q * (gamma - 1)^2 / denom^2

  y <- (1 + w) / (2 + w)
  lambdas <- (1 + 0.5 * w)^2
  lambdao <- 1 + w

  h1 <- p * q * (gamma + 1) / denom
  pA <- gamma / (gamma + 1)

  # ASP
  aa <- c(2 * y - 1,
          ifelse(error == 1, 0, 4 * y * (1 - y)))
  n1 <- sn(aa, alpha[1], beta, 1)

  # TDT
  aa <- c(sqrt(h1) * (gamma - 1) / (gamma + 1),
          1 - h1 * ((gamma - 1) / (gamma + 1))^2)
  n2 <- sn(aa, alpha[2], beta, 2)

  # ASP-TDT
  h2 <- p * q * (gamma + 1)^2 /
        (2 * (p * gamma + q)^2 + p * q * (gamma - 1)^2)

  aa <- c(sqrt(h2) * (gamma - 1) / (gamma + 1),
          1 - h2 * ((gamma - 1) / (gamma + 1))^2)

  n3 <- sn(aa, alpha[3], beta, 3)

  if (debug == 1)
    cat("gamma=",gamma," p=",p," n1=",n1," n2=",n2," n3=",n3,"\n")

  list(
    gamma = gamma,
    p = p,
    y = y,
    n1 = n1,
    pA = pA,
    h1 = h1,
    n2 = n2,
    h2 = h2,
    n3 = n3,
    lambdao = lambdao,
    lambdas = lambdas
  )
}
