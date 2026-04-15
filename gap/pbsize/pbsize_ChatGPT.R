pbsize <- function (kp, gamma = 4.5, p = 0.15, alpha = 5e-8, beta = 0.2)
{
  # input validation
  if (any(!is.finite(c(kp, gamma, p, alpha, beta)))) {
    stop("invalid input")
  }
  if (kp <= 0 || kp >= 1) stop("invalid input")
  if (p <= 0 || p >= 1) stop("invalid input")
  if (alpha <= 0 || alpha >= 1) stop("invalid input")
  if (beta <= 0 || beta >= 1) stop("invalid input")
  if (gamma <= 0) stop("invalid input")

  z1alpha <- qnorm(1 - alpha / 2)
  zbeta <- qnorm(beta)

  q <- 1 - p

  pi <- kp / (gamma * p + q)^2
  lambda <- pi * p * q * (gamma - 1)^2 / (1 - kp)

  # numerical stability checks
  if (is.nan(lambda) || is.infinite(lambda) || lambda <= 0) {
    warning("numerical issue")
    return(NA_real_)
  }

  if (abs(gamma - 1) < 1e-3) {
    warning("gamma too close to 1: near-null effect, sample size may be extremely large")
  }

  if ((1 - kp) <= .Machine$double.eps) {
    warning("kp too close to 1: instability risk")
    return(NA_real_)
  }

  n <- (z1alpha - zbeta)^2 / lambda

  if (!is.finite(n) || n <= 0) {
    warning("numerical issue")
    return(NA_real_)
  }

  if (n > 1e8) {
    warning("very large sample size (>1e8): design likely infeasible")
  }

  class(n) <- c("pbsize", class(n))

  n
}
