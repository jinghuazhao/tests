#' Power and sample size for case-cohort design (non-rare events)
#'
#' Extension of Cai & Zeng (2004) for non-rare events.
#'
#' Cai & Zeng (2004) provided power calculations based on asymptotic
#' theory assuming rare events. Cai & Zeng (2007) extends this to
#' handle NON-RARE events using improved variance estimators.
#'
#' @param n the total number of subjects in the cohort.
#' @param q the sampling fraction of the subcohort.
#' @param pD the proportion of the failures in the full cohort.
#' @param p1 proportions of the two groups (p2=1-p1).
#' @param theta log-hazard ratio for two groups.
#' @param alpha type I error -- significance level.
#' @param beta type II error.
#' @param power logical; if TRUE compute power, otherwise sample size.
#' @param method character; variance estimation method: "2004" (original),
#'        "A1" (improved for non-rare events), or "A2" (alternative).
#' @param verbose logical; print diagnostic messages.
#'
#' @details
#' The original Cai & Zeng (2004) formula assumes rare events (pD small).
#' This extension (2007) provides better approximations when events
#' are NOT rare (higher pD values).
#'
#' Methods:
#' \itemize{
#'   \item{\code{2004}: Original rare-event approximation}
#'   \item{\code{A1}: Improved estimator for non-rare events}
#'   \item{\code{A2}: Alternative estimator for non-rare events}
#' }
#'
#' @return
#' A numeric value: power (if power=TRUE) or required subcohort size.
#'
#' @references
#' Cai J, Zeng D (2004). Sample size/power calculation for case-cohort studies.
#' Biometrics 60: 1015–1024.
#' DOI: 10.1111/j.0006-341X.2004.00175.x
#'
#' Cai J, Zeng D (2007). Power calculation for case-cohort studies with
#' nonrare events. Biometrics 63: 1288–1295.
#' DOI: 10.1111/j.1541-0420.2007.00838.x
#'
#' @examples
#' # ---- Comparison: Rare vs Non-rare ----
#' # For rare events (pD = 0.01), methods should give similar results
#' ccsize(5000, 0.1, 0.01, 0.5, log(1.5), 0.05)  # Original
#' ccsize07(5000, 0.1, 0.01, 0.5, log(1.5), 0.05, method = "2004")
#' ccsize07(5000, 0.1, 0.01, 0.5, log(1.5), 0.05, method = "A1")
#' ccsize07(5000, 0.1, 0.01, 0.5, log(1.5), 0.05, method = "A2")
#'
#' # ---- Non-rare events (pD = 0.2) ----
#' # Methods diverge when events are more common
#' ccsize07(1000, 0.1, 0.2, 0.5, log(1.25), 0.05, method = "2004")
#' ccsize07(1000, 0.1, 0.2, 0.5, log(1.25), 0.05, method = "A1")
#' ccsize07(1000, 0.1, 0.2, 0.5, log(1.25), 0.05, method = "A2")
#'
#' # ---- Effect of event rate ----
#' pD_vals <- c(0.01, 0.05, 0.1, 0.2, 0.4)
#' results <- data.frame(
#'   pD = pD_vals,
#'   method_2004 = sapply(pD_vals, function(p) 
#'     ccsize07(1000, 0.1, p, 0.5, log(1.5), 0.05, method = "2004")),
#'   method_A1 = sapply(pD_vals, function(p)
#'     ccsize07(1000, 0.1, p, 0.5, log(1.5), 0.05, method = "A1")),
#'   method_A2 = sapply(pD_vals, function(p)
#'     ccsize07(1000, 0.1, p, 0.5, log(1.5), 0.05, method = "A2"))
#' )
#' round(results, 3)
#'
#' # ---- Validation against Table 3 (Cai & Zeng 2007) ----
#' # Row: P(T<τ)=20%, e^θ=1.25, p=0.1, n=1000
#' # Table 3 shows: A1 ≈ 0.163, A2 = 0.173
#' p_A1 <- ccsize07(1000, q = 0.1, pD = 0.2, p1 = 0.1,
#'                  theta = log(1.25), alpha = 0.05, method = "A1")
#' p_A2 <- ccsize07(1000, q = 0.1, pD = 0.2, p1 = 0.1,
#'                  theta = log(1.25), alpha = 0.05, method = "A2")
#' round(c(A1 = p_A1, A2 = p_A2), 3)
#'
#' # ---- Sample size with non-rare events ----
#' ccsize07(1000, 0.1, 0.3, 0.5, log(1.5), 0.05, 
#'          beta = 0.2, power = FALSE, method = "A1")
#'
#' \dontrun{
#' # ---- Compare methods across event rates ----
#' pD_seq <- seq(0.01, 0.5, length.out = 50)
#' power_2004 <- sapply(pD_seq, function(pD) 
#'   ccsize07(1000, 0.1, pD, 0.5, log(1.5), 0.05, method = "2004"))
#' power_A1 <- sapply(pD_seq, function(pD)
#'   ccsize07(1000, 0.1, pD, 0.5, log(1.5), 0.05, method = "A1"))
#'
#' plot(pD_seq, power_2004, type = "l", col = "blue", lwd = 2,
#'      xlab = "Event Proportion (pD)", ylab = "Power",
#'      main = "Power: Rare vs Non-rare Event Methods")
#' lines(pD_seq, power_A1, type = "l", col = "red", lwd = 2)
#' legend("bottomright", legend = c("2004 (rare)", "A1 (non-rare)"),
#'        col = c("blue", "red"), lwd = 2)
#' }
#'
#' @export
ccsize07 <- function(n, q, pD, p1, theta, alpha,
                     beta = 0.2, power = TRUE,
                     method = c("2004", "A1", "A2"),
                     verbose = FALSE)
{
  ## ---- Input validation ----
  if (!is.numeric(n) || length(n) != 1 || n <= 0)
    stop("n must be a positive number")
  if (!is.numeric(q) || length(q) != 1 || q <= 0 || q >= 1)
    stop("q must be in (0,1)")
  if (!is.numeric(pD) || length(pD) != 1 || pD <= 0 || pD >= 1)
    stop("pD must be in (0,1)")
  if (!is.numeric(p1) || length(p1) != 1 || p1 <= 0 || p1 >= 1)
    stop("p1 must be in (0,1)")
  if (!is.numeric(alpha) || length(alpha) != 1 || alpha <= 0 || alpha >= 1)
    stop("alpha must be in (0,1)")
  if (!is.numeric(beta) || length(beta) != 1 || beta <= 0 || beta >= 1)
    stop("beta must be in (0,1)")

  method <- match.arg(method)
  p2 <- 1 - p1
  
  if (power) {
    ## ---- Power calculation ----
    z_alpha <- qnorm(alpha)
    p2 <- 1 - p1
    
    # Variance calculation depends on method
    if (method == "2004") {
      ## Cai & Zeng (2004): full cohort efficiency for rare events
      ## Variance = p1 * p2 * pD
      var <- p1 * p2 * pD
    } else if (method == "A1") {
      ## Cai & Zeng (2007) Method A1: adjusted for non-rare events
      ## Accounts for increased variance when events are not rare
      var <- p1 * p2 * pD / ((1 - pD) * q + pD) / (1 - pD)
    } else {
      ## Cai & Zeng (2007) Method A2: alternative adjustment
      w <- q / (q + (1 - q) * pD)
      var <- p1 * p2 * pD * (1 - pD * q) / ((1 - pD) * q + pD) / (1 - pD)
    }
    
    delta <- sqrt(n * q) * theta * sqrt(var)
    z <- z_alpha + delta

    if (is.nan(z) || is.infinite(z)) {
      warning("Numerical error in power calculation")
      return(NA)
    }

    return(pnorm(z))
  } else {
    ## ---- Sample size calculation ----
    z_alpha <- qnorm(1 - alpha)
    z_beta  <- qnorm(1 - beta)
    p2 <- 1 - p1
    
    # Variance depends on method
    if (method == "2004") {
      var <- p1 * p2 * pD
    } else if (method == "A1") {
      var <- p1 * p2 * pD / ((1 - pD) * q + pD) / (1 - pD)
    } else {
      w <- q / (q + (1 - q) * pD)
      var <- p1 * p2 * pD * (1 - pD * q) / ((1 - pD) * q + pD) / (1 - pD)
    }
    
    z_sum <- z_alpha + z_beta
    B <- z_sum^2 / (theta^2 * var)
    
    if (is.nan(B) || is.infinite(B) || B < 0) {
      warning("Numerical error in sample size calculation")
      return(NA)
    }
    
    ## Cai & Zeng formula for subcohort size
    denom <- n - B * (1 - pD)
    
    if (denom <= 0) {
      if (verbose)
        message("Infeasible configuration: cannot achieve specified power")
      return(NA)
    }
    
    m <- n * B * pD / denom
    return(ceiling(m))
  }
}