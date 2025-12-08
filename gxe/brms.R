############################################################
## Liability Threshold Model with GRM + G×E (brms)
## Fully revised working script
############################################################

rm(list = ls())
set.seed(123)

library(brms)
library(posterior)

############################################################
# 1) SIMULATE DATA + GRM
############################################################

N <- 300
M <- 50

# Random GRM
Z <- matrix(rnorm(N * M), N, M)
G <- tcrossprod(Z) / M

# Force positive definite
diag(G) <- diag(G) + 1e-6

# Cholesky
Cmat <- chol(G)

# Environment variable
E <- scale(rnorm(N))[,1]

# True genetic parameters
sg0_true <- 0.6
sg1_true <- 0.4
rho_true <- 0.3

# Latent genetic effects
z0 <- rnorm(N)
z1 <- rnorm(N)

g0 <- as.vector(sg0_true * Cmat %*% z0)
g1 <- as.vector(sg1_true * Cmat %*% (rho_true * z0 + sqrt(1 - rho_true^2) * z1))

# Fixed effects
beta0 <- -1
betaE <-  0.3

# Latent liability
L <- beta0 + betaE*E + g0 + E*g1 + rnorm(N)

# Binary trait
y <- as.numeric(L > 0)

# Build dataset
dat <- data.frame(
  id = factor(1:N),
  y  = y,
  E  = E
)

cat("Sample prevalence:", mean(y), "\n")

# Name GRM rows/cols for brms
rownames(G) <- colnames(G) <- levels(dat$id)

############################################################
# 2) FIT MODEL
############################################################

fit <- brm(
  bf(y ~ E + (1 + E | gr(id, cov = G))),
  data   = dat,
  data2  = list(G = G),
  family = bernoulli(link = "probit"),
  chains = 4,
  cores  = 4,
  iter   = 2000,
  warmup = 1000,
  control = list(adapt_delta = 0.95)
)

print(summary(fit))

############################################################
# 3) EXTRACT POSTERIOR DRAWS (ROBUST TO NAMING)
############################################################

post <- as_draws_df(fit)

# Automatically find parameter names
sd_int_name <- grep("^sd_.*Intercept", colnames(post), value = TRUE)[1]
sd_E_name   <- grep("^sd_.*__E$",       colnames(post), value = TRUE)[1]
cor_name    <- grep("^cor_.*Intercept__E", colnames(post), value = TRUE)[1]

cat("Using parameter names:\n")
print(sd_int_name)
print(sd_E_name)
print(cor_name)

# Extract posterior samples
sg0 <- post[[sd_int_name]]
sg1 <- post[[sd_E_name]]
rho <- post[[cor_name]]

# Sanity checks
print(summary(sg0))
print(summary(sg1))
print(summary(rho))

############################################################
# 4) COMPUTE ENVIRONMENT-SPECIFIC h² (LIABILITY SCALE)
############################################################

VR <- 1   # probit residual variance

h2_fun <- function(Eval) {
  VG <- sg0^2 + 2 * Eval * sg0 * sg1 * rho + (Eval^2) * sg1^2
  VG / (VG + VR)
}

Egrid <- seq(min(E), max(E), length.out = 50)

h2_mat <- as.matrix(sapply(Egrid, h2_fun))

h2_mean <- colMeans(h2_mat)
h2_lo   <- apply(h2_mat, 2, quantile, 0.025)
h2_hi   <- apply(h2_mat, 2, quantile, 0.975)

############################################################
# 5) PLOT HERITABILITY CURVE
############################################################

plot(Egrid, h2_mean, type="l", lwd=2, ylim=c(0,1),
     xlab="Environment (E)",
     ylab="Heritability (liability scale)",
     main="Environment-specific heritability")
lines(Egrid, h2_lo, lty=2)
lines(Egrid, h2_hi, lty=2)

############################################################
# 6) BASIC DIAGNOSTICS
############################################################

plot(fit)
pp_check(fit)

rhats <- rhat(fit)
print(summary(rhats))

############################################################
# 7) SUMMARY OUTPUT
############################################################

cat("\nPosterior summaries:\n")
cat("Mean sd_g0:", mean(sg0), "\n")
cat("Mean sd_g1:", mean(sg1), "\n")
cat("Mean genetic correlation:", mean(rho), "\n")
cat("Mean h2 at E=0:", mean(h2_fun(0)), "\n")

############################################################
# END
############################################################
