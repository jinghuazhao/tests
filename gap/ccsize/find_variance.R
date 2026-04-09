# Find correct variance formula by trying multiple structures
# Target: match expected power values from Table 3

source("ccsize04.md")
source("ccsize07.md")

library(MASS)

# Power calculation function
calc_power <- function(var, n, q, theta, alpha) {
  z_alpha <- qnorm(alpha)
  delta <- sqrt(n * q) * theta * sqrt(var)
  return(pnorm(z_alpha + delta))
}

# Test parameters from Table 3
test_cases <- list(
  list(pD=0.20, HR=1.00, p1=0.1, n=1000, exp=0.050),
  list(pD=0.20, HR=1.25, p1=0.1, n=1000, exp=0.163),
  list(pD=0.20, HR=1.50, p1=0.2, n=1000, exp=0.384),
  list(pD=0.40, HR=1.25, p1=0.1, n=1000, exp=0.207),
  list(pD=0.40, HR=1.50, p1=0.2, n=1000, exp=0.564)
)

alpha <- 0.05
q <- 0.1

# For each test case, find required var
cat("Required variance for each test case:\n")
for (tc in test_cases) {
  pD <- tc$pD
  HR <- tc$HR
  p1 <- tc$p1
  n <- tc$n
  exp_pow <- tc$exp
  theta <- log(HR)
  
  z_alpha <- qnorm(alpha)
  z_exp <- qnorm(exp_pow)
  
  # z_exp = z_alpha + sqrt(n*q)*theta*sqrt(var)
  # sqrt(var) = (z_exp - z_alpha) / (sqrt(n*q)*theta)
  if (abs(theta) < 1e-10) {
    req_var <- pD * p1 * (1-p1)  # Null case: should be p1*p2*pD
  } else {
    sqrt_var <- (z_exp - z_alpha) / (sqrt(n * q) * theta)
    req_var <- sqrt_var^2
  }
  
  p2 <- 1 - p1
  base_var <- p1 * p2 * pD
  
  cat(sprintf("pD=%.2f HR=%.2f p1=%.1f | exp=%.3f | req_var=%.6f | base_var=%.6f | ratio=%.4f\n",
              pD, HR, p1, exp_pow, req_var, base_var, req_var/base_var))
}

cat("\n\n=== Testing variance formula candidates ===\n\n")

# Common variance formula structures:
# V0 = p1*p2*pD (base)
# Try different denominators/multipliers

vformulas <- list(
  "V0_base" = function(p1, p2, pD, q) p1 * p2 * pD,
  "V1_1_pD" = function(p1, p2, pD, q) p1 * p2 * pD / (1 - pD),
  "V2_1_pD_q" = function(p1, p2, pD, q) p1 * p2 * pD / ((1-pD) * q + pD),
  "V3_complex" = function(p1, p2, pD, q) p1 * p2 * pD / ((1-pD) * q + pD) / (1 - pD),
  "V4_alt1" = function(p1, p2, pD, q) p1 * p2 * pD * (1 - pD * q) / ((1-pD) * q + pD) / (1 - pD),
  "V5_alt2" = function(p1, p2, pD, q) p1 * p2 * pD / ((1-pD) + pD/q),
  "V6_1_q" = function(p1, p2, pD, q) p1 * p2 * pD / ((1-pD)/q + pD),
  "V7_exp" = function(p1, p2, pD, q) p1 * p2 * pD / (1 - pD * (1-q))
)

# Test each formula
cat("Testing variance formulas:\n\n")
for (vname in names(vformulas)) {
  vfn <- vformulas[[vname]]
  total_err <- 0
  cat(vname, ":\n")
  
  for (tc in test_cases) {
    pD <- tc$pD
    HR <- tc$HR
    p1 <- tc$p1
    p2 <- 1 - p1
    n <- tc$n
    exp_pow <- tc$exp
    theta <- log(HR)
    
    var <- vfn(p1, p2, pD, q)
    pow <- calc_power(var, n, q, theta, alpha)
    err <- abs(pow - exp_pow)
    total_err <- total_err + err
    
    cat(sprintf("  pD=%.2f HR=%.2f p1=%.1f | var=%.6f | pow=%.4f | exp=%.4f | err=%.4f\n",
                pD, HR, p1, var, pow, exp_pow, err))
  }
  cat(sprintf("  TOTAL ERROR: %.6f\n\n", total_err))
}
