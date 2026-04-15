# tests/test_pbsize.R

source("pbsize.R")

rel_error <- function(a, b) {
  abs(a - b) / abs(b)
}

stopifnot_msg <- function(cond, msg) {
  if (!isTRUE(cond)) stop(msg)
}

# -----------------------------
# 1. Alzheimer’s disease example (from documentation)
# -----------------------------
g <- 4.5
p <- 0.15
alpha <- 5e-8
beta <- 0.2

z1alpha <- qnorm(1 - alpha / 2)
z1beta <- qnorm(1 - beta)

q <- 1 - p
pi <- 0.065

k <- pi * (g * p + q)^2

lambda <- pi * p * q * (g - 1)^2 / (1 - k)
n_ref <- (z1alpha + z1beta)^2 / lambda

n_test <- pbsize(kp = k, gamma = g, p = p, alpha = alpha, beta = beta)

stopifnot_msg(
  is.finite(n_test),
  "Alzheimer test returned non-finite result"
)

stopifnot_msg(
  rel_error(n_test, n_ref) < 0.01,
  "Alzheimer test relative error >= 1%"
)

# -----------------------------
# 2. Small kp regime
# -----------------------------
for (kp in c(0.001, 0.005, 0.01)) {
  val <- pbsize(kp = kp, gamma = 2, p = 0.1, alpha = 0.05, beta = 0.2)
  stopifnot_msg(is.finite(val), "small kp failed")
  stopifnot_msg(val > 0, "small kp non-positive")
}

# -----------------------------
# 3. Large kp regime
# -----------------------------
for (kp in c(0.2, 0.3, 0.4)) {
  val <- pbsize(kp = kp, gamma = 2, p = 0.2, alpha = 0.05, beta = 0.2)
  stopifnot_msg(is.finite(val), "large kp failed")
  stopifnot_msg(val > 0, "large kp non-positive")
}

# -----------------------------
# 4. Rare allele limit (p -> 0)
# -----------------------------
for (p in c(0.001, 0.005, 0.01)) {
  val <- pbsize(kp = 0.05, gamma = 2, p = p, alpha = 0.05, beta = 0.2)
  stopifnot_msg(is.finite(val), "rare allele failed")
  stopifnot_msg(val > 0, "rare allele non-positive")
}

# -----------------------------
# 5. Common allele (p -> 0.5)
# -----------------------------
for (p in c(0.3, 0.4, 0.5)) {
  val <- pbsize(kp = 0.05, gamma = 2, p = p, alpha = 0.05, beta = 0.2)
  stopifnot_msg(is.finite(val), "common allele failed")
  stopifnot_msg(val > 0, "common allele non-positive")
}

# -----------------------------
# 6. Extreme gamma values
# -----------------------------
for (g in c(1.1, 1.5, 2, 5)) {
  val <- pbsize(kp = 0.05, gamma = g, p = 0.1, alpha = 0.05, beta = 0.2)
  stopifnot_msg(is.finite(val), "gamma failed")
  stopifnot_msg(val > 0, "gamma non-positive")
}

# -----------------------------
# 7. Extreme alpha / beta
# -----------------------------
grid <- expand.grid(
  alpha = c(1e-2, 1e-4, 1e-6),
  beta  = c(0.1, 0.2, 0.3)
)

for (i in seq_len(nrow(grid))) {
  val <- pbsize(
    kp = 0.05,
    gamma = 2,
    p = 0.1,
    alpha = grid$alpha[i],
    beta = grid$beta[i]
  )
  stopifnot_msg(is.finite(val), "alpha/beta failed")
  stopifnot_msg(val > 0, "alpha/beta non-positive")
}

# -----------------------------
# 8. Boundary checks (should not crash)
# -----------------------------
pbsize(kp = 0.01, gamma = 1.01, p = 0.01, alpha = 0.05, beta = 0.2)

cat("All pbsize tests passed\n")
