# Analyze variance formulas for ccsize07
# Working backwards from Table 3 expected values

source("ccsize04.md")
source("ccsize07.md")

# From Table 3: pD=0.20, HR=1.25, p1=0.1, n=1000, q=0.1, expected A1=0.163
# Back-calculate required variance

power_target <- 0.163
alpha <- 0.05
theta <- log(1.25)
n <- 1000
q <- 0.1
p1 <- 0.1
p2 <- 0.9
pD <- 0.20

# Power = Phi(z_alpha + sqrt(nq) * theta * sqrt(var))
# qnorm(power) = z_alpha + sqrt(nq) * theta * sqrt(var)
# sqrt(var) = (qnorm(power) - z_alpha) / (sqrt(nq) * theta)

z_alpha <- qnorm(alpha)  # One-sided: ~ -1.645
z_power <- qnorm(power_target)

sqrt_var_needed <- (z_power - z_alpha) / (sqrt(n * q) * theta)
var_needed <- sqrt_var_needed^2

cat("Target power:", power_target, "\n")
cat("z_alpha:", round(z_alpha, 4), "\n")
cat("z_power:", round(z_power, 4), "\n")
cat("Required sqrt(var):", round(sqrt_var_needed, 6), "\n")
cat("Required var:", round(var_needed, 6), "\n\n")

# Current code variances:
var_2004 <- p1 * p2 * pD
var_A1_current <- p1 * p2 * pD / ((1 - pD) * q + pD) / (1 - pD)
var_A2_current <- p1 * p2 * pD * (1 - pD * q) / ((1 - pD) * q + pD) / (1 - pD)

cat("Current variances:\n")
cat("  2004:", round(var_2004, 6), "\n")
cat("  A1:  ", round(var_A1_current, 6), "\n")
cat("  A2:  ", round(var_A2_current, 6), "\n\n")

# What ARE the current powers?
pow_2004 <- ccsize07(n, q, pD, p1, theta, alpha, method="2004")
pow_A1 <- ccsize07(n, q, pD, p1, theta, alpha, method="A1")
pow_A2 <- ccsize07(n, q, pD, p1, theta, alpha, method="A2")

cat("Current computed powers (expected 0.163):\n")
cat("  2004:", round(pow_2004, 4), "\n")
cat("  A1:  ", round(pow_A1, 4), "\n")
cat("  A2:  ", round(pow_A2, 4), "\n\n")

# Let's try TWO-SIDED test (alpha/2)
cat("=== TRYING TWO-SIDED TEST (alpha/2) ===\n\n")
z_alpha_2sided <- qnorm(alpha/2)  # ~ -1.96
sqrt_var_needed_2sided <- (z_power - z_alpha_2sided) / (sqrt(n * q) * theta)
var_needed_2sided <- sqrt_var_needed_2sided^2

cat("Two-sided z_alpha:", round(z_alpha_2sided, 4), "\n")
cat("Required var:", round(var_needed_2sided, 6), "\n\n")

# Maybe the formula has different structure
# Check if it's V = p1*p2*pD / ((1-pD)*q + pD)  WITHOUT the /(1-pD)
var_A1_alt <- p1 * p2 * pD / ((1 - pD) * q + pD)
var_A2_alt <- p1 * p2 * pD * (1 - pD * q) / ((1 - pD) * q + pD)

cat("Alternative variances (without /(1-pD)):\n")
cat("  A1 alt:", round(var_A1_alt, 6), "\n")
cat("  A2 alt:", round(var_A2_alt, 6), "\n\n")

# Compute power with alternative variances
power_from_var <- function(var, z_alpha, n, q, theta) {
  delta <- sqrt(n * q) * theta * sqrt(var)
  return(pnorm(z_alpha + delta))
}

cat("Powers with alternative variances:\n")
cat("  A1 alt:", round(power_from_var(var_A1_alt, z_alpha, n, q, theta), 4), "\n")
cat("  A2 alt:", round(power_from_var(var_A2_alt, z_alpha, n, q, theta), 4), "\n\n")

# Check another data point: pD=0.40, HR=1.50, p1=0.2, n=1000, expected A1=0.564
cat("=== Second test case: pD=0.40, HR=1.50, p1=0.2 ===\n")
pD2 <- 0.40
theta2 <- log(1.50)
p1_2 <- 0.2
p2_2 <- 0.8
target2 <- 0.564

z_power2 <- qnorm(target2)
sqrt_var2 <- (z_power2 - z_alpha) / (sqrt(n * q) * theta2)
var2_needed <- sqrt_var2^2

var2_A1_current <- p1_2 * p2_2 * pD2 / ((1 - pD2) * q + pD2) / (1 - pD2)
var2_A1_alt <- p1_2 * p2_2 * pD2 / ((1 - pD2) * q + pD2)

cat("Target power:", target2, "\n")
cat("Required var:", round(var2_needed, 6), "\n")
cat("Current A1 var (with /(1-pD)):", round(var2_A1_current, 6), "\n")
cat("A1 var without /(1-pD):", round(var2_A1_alt, 6), "\n\n")

cat("Powers:\n")
cat("  Current A1:", round(ccsize07(n, q, pD2, p1_2, theta2, alpha, method="A1"), 4), " (expected 0.564)\n")
cat("  A1 without /(1-pD):", round(power_from_var(var2_A1_alt, z_alpha, n, q, theta2), 4), "\n")
