# Analyze Table 3 data and find correct variance formulas
# Working backwards from expected values

source("ccsize04.md")

alpha <- 0.05
z_alpha <- qnorm(alpha)  # One-sided

# Table 3 test cases from the A1 method
# Format: (pD, HR, p1, n, expected_power)
test_cases <- list(
  list(pD=0.20, HR=1.25, p1=0.1, n=1000, expected=0.163),
  list(pD=0.20, HR=1.50, p1=0.2, n=1000, expected=0.384),
  list(pD=0.40, HR=1.25, p1=0.1, n=1000, expected=0.207),
  list(pD=0.40, HR=1.50, p1=0.2, n=1000, expected=0.564)
)

q <- 0.1  # Default sampling fraction

cat("Working backwards to find variance:\n\n")
for (tc in test_cases) {
  pD <- tc$pD
  HR <- tc$HR
  p1 <- tc$p1
  n <- tc$n
  expected <- tc$expected
  
  theta <- log(HR)
  p2 <- 1 - p1
  
  # From power formula: Phi(z_alpha + sqrt(n*q)*theta*sqrt(var)) = expected
  # So: z_alpha + sqrt(n*q)*theta*sqrt(var) = qnorm(expected)
  # And: sqrt(var) = (qnorm(expected) - z_alpha) / (sqrt(n*q)*theta)
  
  if (abs(theta) > 1e-10) {
    sqrt_var <- (qnorm(expected) - z_alpha) / (sqrt(n * q) * theta)
    var_needed <- sqrt_var^2
    
    # Base variance (2004 method)
    base_var <- p1 * p2 * pD
    
    cat(sprintf("pD=%.2f HR=%.2f p1=%.1f | exp=%.3f | var_needed=%.6f | base_var=%.6f | ratio=%.4f\n",
                pD, HR, p1, expected, var_needed, base_var, var_needed/base_var))
  }
}

# Now test various variance formulas to see which matches
cat("\n\nTesting different variance formulas:\n\n")

vformulas <- list(
  "V0_base" = function(p1, p2, pD, q) p1 * p2 * pD,
  "V1_1/(1-pD)" = function(p1, p2, pD, q) p1 * p2 * pD / (1 - pD),
  "V2_1/((1-pD)*q)" = function(p1, p2, pD, q) p1 * p2 * pD / ((1-pD) * q),
  "V3_pD/((1-pD)*q + pD)" = function(p1, p2, pD, q) p1 * p2 * pD / ((1-pD) * q + pD),
  "V4_complex" = function(p1, p2, pD, q) p1 * p2 * pD / ((1-pD) * q + pD) / (1-pD),
  "V5_alt" = function(p1, p2, pD, q) p1 * p2 * pD * (1-pD*q) / ((1-pD) * q + pD) / (1-pD),
  "V6_pD/(q*(1-pD) + pD*(1-q))" = function(p1, p2, pD, q) p1 * p2 * pD / (q*(1-pD) + pD*(1-q))
)

calc_power <- function(var, n, q, theta, alpha) {
  z_alpha <- qnorm(alpha)
  delta <- sqrt(n * q) * theta * sqrt(var)
  return(pnorm(z_alpha + delta))
}

for (tc in test_cases) {
  pD <- tc$pD
  HR <- tc$HR  
  p1 <- tc$p1
  n <- tc$n
  expected <- tc$expected
  theta <- log(HR)
  p2 <- 1 - p1
  
  cat(sprintf("\npD=%.2f HR=%.2f p1=%.1f | expected=%.3f\n", pD, HR, p1, expected))
  cat("-" , rep("-", 60), "\n", sep="")
  
  for (vname in names(vformulas)) {
    vfn <- vformulas[[vname]]
    var <- vfn(p1, p2, pD, q)
    pow <- calc_power(var, n, q, theta, alpha)
    error <- abs(pow - expected) * 100
    cat(sprintf("%-30s | var=%.6f | pow=%.4f | err=%.2f%%\n", 
                vname, var, pow, error))
  }
}
