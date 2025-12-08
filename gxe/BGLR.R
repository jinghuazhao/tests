############################################################
# BGLR: Liability threshold model with GRM + G×E (WORKING)
############################################################

library(BGLR)

set.seed(123)

# ---- Simulate data ----
N <- 300
M <- 50

Z <- matrix(rnorm(N*M), N, M)
G <- tcrossprod(Z) / M
diag(G) <- diag(G) + 1e-6

E <- scale(rnorm(N))[,1]
D <- diag(E)

# Simulate genetic effects
sg0 <- 0.6
sg1 <- 0.4

Cmat <- chol(G)

g0 <- as.vector(sg0 * Cmat %*% rnorm(N))
g1 <- as.vector(sg1 * Cmat %*% rnorm(N))

# Liability
L <- -1 + 0.3*E + g0 + E*g1 + rnorm(N)

# Binary phenotype
y <- as.numeric(L > 0)

# ---- Kernels ----
K0 <- G
K1 <- D %*% G %*% D

# ---- ETA list (MODEL INSIDE ETA!) ----
ETA <- list(
  list(K = K0, model = "RKHS"),
  list(K = K1, model = "RKHS")
)

# ---- Fit liability model ----
fit <- BGLR(
  y = y,
  ETA = ETA,
  response_type = "ordinal",   # <- this triggers liability threshold
  nIter = 5000,
  burnIn = 2000,
  thin = 5,
  verbose = TRUE
)

# Variance components
varG0 <- fit$ETA[[1]]$varU
varG1 <- fit$ETA[[2]]$varU
varE  <- fit$varE

# Posterior means
VG <- varG0 + varG1
h2 <- VG / (VG + varE)

summary(h2)

h2_E <- function(Eval) {
  VG <- varG0 + (Eval^2) * varG1
  VG / (VG + varE)
}

Egrid <- seq(min(E), max(E), length.out = 50)

h2_mat <- sapply(Egrid, h2_E)
apply(h2_mat, 2, mean)

plot(fit$ETA[[1]]$varU, type="l")
