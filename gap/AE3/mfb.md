# Biometrical Modelling of Nuclear Family Trio Data (AE / ACE / ADE)
Using nlme (No OpenMx)

Author: Adapted from Rabe-Hesketh, Skrondal & Gjessing (2008)

---

# Contents

1. Introduction  
2. Quantitative Genetic Theory  
3. Mixed Model Representation  
4. Estimation Strategy  
5. AE model implementation  
6. ACE model implementation  
7. ADE model implementation  
8. Simulation-based confidence intervals  
9. Example analysis using mfblong  
10. Interpreting results  

---

# 1. Introduction

We extend the AE3 implementation to fit AE, ACE and ADE variance-component models
for nuclear family trio data (mother, father, child) using **nlme::lme only**.

Phenotype vector (long format):

Each family contributes three rows:
- mother
- father
- child

This allows us to encode genetic covariance via random effects.

---

# 2. Quantitative Genetic Theory

Phenotype model:

y = Xβ + g_A + g_D + c + e

Variance components:

Var(y) = σ_A² + σ_D² + σ_C² + σ_E²

Definitions:

σ_A²  additive genetic variance  
σ_D²  dominance genetic variance  
σ_C²  shared environmental variance  
σ_E²  residual environmental variance  

Total phenotypic variance:

σ_P² = σ_A² + σ_D² + σ_C² + σ_E²

---

## Expected covariances in nuclear families

Relationship | Additive | Dominance | Shared Env
---|---|---|---
Parent–child | ½σ_A² | 0 | σ_C²
Father–mother | 0 | 0 | σ_C²
Sibling pair | ½σ_A² | ¼σ_D² | σ_C²

These expectations drive the random-effect design matrices.

---

# 3. Mixed Model Representation

We fit:

y = Xβ + Z_A u_A + Z_D u_D + Z_C u_C + e

with:

u_A ~ N(0, σ_A² I)  
u_D ~ N(0, σ_D² I)  
u_C ~ N(0, σ_C² I)  
e   ~ N(0, σ_E² I)

nlme estimates log standard deviations:

θ = (ln σ_E, ln σ_A, ln σ_C, ln σ_D)

We convert back using:

σ² = exp(2θ)

---

# 4. Heritability Definitions

Narrow sense heritability:

h² = σ_A² / σ_P²

Broad sense heritability:

H² = (σ_A² + σ_D²) / σ_P²

Shared environment proportion:

c² = σ_C² / σ_P²

Dominance proportion:

d² = σ_D² / σ_P²

---

# 5. Helper: Delta Method for Ratios

For h² = σ_A² / (σ_A² + σ_E²):

Let:

A = exp(2θ_A)  
E = exp(2θ_E)

h² = A / (A + E)

Gradient:

∂h²/∂θ_A = 2AE / (A+E)²  
∂h²/∂θ_E = −2AE / (A+E)²

SE computed via:

Var(h²) ≈ gᵀ Σ g

where Σ is covariance of log-variance estimates.

---

# 6. AE MODEL FUNCTION

```r
AE_family <- function(model, random, data, seed=1, n.sim=50000)
{
  require(nlme); require(MASS)

  fit <- lme(model, random=random, data=data, method="ML")

  pars <- attr(fit$apVar,"Pars")
  vcov <- fit$apVar

  lnE <- pars[1]
  lnA <- pars[2]

  varE <- exp(2*lnE)
  varA <- exp(2*lnA)

  h2 <- varA/(varA+varE)

  set.seed(seed)
  samp <- exp(2*MASS::mvrnorm(n.sim, pars[1:2], vcov[1:2,1:2]))
  h2.sim <- samp[,2]/rowSums(samp)

  list(fit=fit, h2=h2, CI=quantile(h2.sim,c(.025,.975)))
}
```

---

# 7. ACE MODEL FUNCTION

Random effects needed:

- family additive genetic effect
- family shared environment

```r
ACE_family <- function(model, data)
{
  require(nlme)

  fit <- lme(
    model,
    random=list(
      familyid=pdIdent(~A_effect-1),
      familyid=pdIdent(~C_effect-1)
    ),
    data=data,
    method="ML"
  )

  pars <- attr(fit$apVar,"Pars")

  varE <- exp(2*pars[1])
  varA <- exp(2*pars[2])
  varC <- exp(2*pars[3])

  varP <- varA+varC+varE

  h2 <- varA/varP
  c2 <- varC/varP

  list(fit=fit,h2=h2,c2=c2)
}
```

---

# 8. ADE MODEL FUNCTION

Dominance random effect added.

```r
ADE_family <- function(model,data)
{
  require(nlme)

  fit <- lme(
    model,
    random=list(
      familyid=pdIdent(~A_effect-1),
      familyid=pdIdent(~D_effect-1)
    ),
    data=data,
    method="ML"
  )

  pars <- attr(fit$apVar,"Pars")

  varE <- exp(2*pars[1])
  varA <- exp(2*pars[2])
  varD <- exp(2*pars[3])

  varP <- varA+varD+varE

  h2 <- varA/varP
  d2 <- varD/varP
  H2 <- (varA+varD)/varP

  list(fit=fit,h2=h2,d2=d2,H2=H2)
}
```

---

# 9. Example Using mfblong

```r
library(gap.datasets)
data(mfblong)

model <- bwt ~ male + first + midage + highage + birthyr

AEres  <- AE_family(model,
           list(familyid=pdIdent(~var1+var2+var3-1)),
           mfblong)

ACEres <- ACE_family(model, mfblong)
ADEres <- ADE_family(model, mfblong)
```

---

# 10. Model Comparison

Use likelihood ratio tests:

```r
anova(AEres$fit, ACEres$fit)
anova(AEres$fit, ADEres$fit)
```

Decision rules:

If ACE improves fit → shared environment important  
If ADE improves fit → dominance important  
Otherwise AE sufficient  

---

# 11. Interpretation Template

Report:

Total variance components  
Heritability estimates  
Confidence intervals  
Likelihood comparisons  

Example write-up:

"The ACE model estimated h² = 0.38 and c² = 0.22.
Likelihood ratio tests suggested shared environmental effects
significantly improved model fit compared with AE."
