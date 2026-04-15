# Family-Based Sample Size Module (fbsize.R)

This module implements sample size calculations for family-based genetic association studies using the framework of:

- Risch & Merikangas (1996, 1997)
- Scott et al. (1997)

It evaluates power/sample size for:
- Affected Sib Pair (ASP) linkage analysis
- Transmission Disequilibrium Test (TDT)
- Combined ASP–TDT design

---

# CORE FUNCTION

## fbsize()

### Purpose
Computes required sample sizes for family-based genetic study designs under a multiplicative genotype relative risk model.

---

## Model Assumptions

- Multiplicative genetic risk model
- Hardy–Weinberg equilibrium
- Bi-allelic locus with allele frequency `p`
- Relative risk parameter `gamma`
- Normal approximation to test statistics
- Asymptotic variance approximations for sharing/transmission statistics

---

## Input Parameters

- `gamma`: genotype relative risk (>0, typically ≥1)
- `p`: disease allele frequency (0 < p < 1)
- `alpha`: vector of type I error rates:
  - ASP
  - TDT
  - ASP–TDT
- `beta`: type II error rate (power = 1 - beta)
- `debug`: optional verbose output (do not rely on in production)
- `error`:
  - 0 = corrected formula (default, recommended)
  - 1 = original paper approximation

---

## Output Structure

A named list:

- `gamma`
- `p`
- `y` : ASP parameter
- `n1` : required ASP sample size
- `pA` : allele transmission probability
- `h1` : TDT-related parameter
- `n2` : required TDT sample size
- `h2` : ASP–TDT parameter
- `n3` : required ASP–TDT sample size
- `lambdao` : overall sibling risk component
- `lambdas` : model-based sibling risk

---

# INTERNAL COMPUTATION

## Key Derived Quantities

Let:

- q = 1 - p
- k = (p * gamma + q)^2

### Risk structure:
- w = p q (gamma − 1)^2 / (p gamma + q)^2
- y = (1 + w) / (2 + w)

### Sibling risk measures:
- lambdao = 1 + w
- lambdas = (1 + 0.5 w)^2

---

## Sample Size Core Engine

The internal helper function:

### sn(all, alpha, beta, op)

Uses:
- mean (m)
- variance (v)

and computes:

- normal quantiles:
  - z_alpha = qnorm(1 − alpha)
  - z_beta = qnorm(1 − beta)

- sample size approximation:
  - n = ((z_alpha − sqrt(v) * z_beta) / m)^2 / 2

Adjustment:
- if op == 3 → n = n / 2

---

# NUMERICAL STABILITY RULES

The function MUST:

## Input validation
- gamma > 0
- 0 < p < 1
- 0 < alpha < 1
- 0 < beta < 1

## Stability safeguards
- Guard against:
  - division by zero in (p*gamma + q)
  - negative or zero variance terms
  - non-finite intermediate results

## Failure handling
- invalid inputs → stop()
- unstable intermediate values → warning + NA
- extreme regimes → return NA safely, do not crash

---

# EDGE CASE BEHAVIOR

## gamma → 1
- w → 0
- sample sizes increase appropriately
- behavior is mathematically correct (no correction needed)

## extreme allele frequency (p → 0 or p → 1)
- model becomes unstable
- must trigger warnings or NA where appropriate

---

# DESIGN CONSTRAINTS

- fbsize() MUST remain independent and not merged with pbsize()
- ASP, TDT, ASP–TDT computations must remain explicit
- Do not abstract shared logic across unrelated models
- Maintain Risch & Merikangas structure faithfully

---

# DEBUG MODE

If debug = 1:
- print intermediate parameters:
  - k, va, vd
  - y, h1, h2
  - n1, n2, n3
- output must remain deterministic and reproducible

---

# REFERENCES

All references must be resolved via REFERENCES.bib using:

- Risch & Merikangas (1996, 1997)
- Scott et al. (1997)

Use roxygen2:

- @references
- \insertRef{}
- \insertAllCited{}

No hardcoded citations in code.

---

# IMPLEMENTATION RULES

- No interactive prompts
- No option menus
- No partial results
- No stochastic behavior
- Always return full structured output

---

# END OF SPEC
