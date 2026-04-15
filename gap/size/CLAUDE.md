# Genetic Power / Sample Size Package (gap-style implementation)

This project implements classical genetic epidemiology sample size calculations for:

- Population-based association studies (`pbsize`)
- Family-based linkage/association studies (`fbsize`)

All methods are derived from:
- Scott et al. (1997)
- Rosner & associates (2000)
- Armitage et al. (2005)
- Risch & Merikangas (1996, 1997)

References are managed via `REFERENCES.bib` and inserted using `roxygen2 + Rd macros`.

---

# GENERAL RULES (CRITICAL)

## Determinism & Execution Policy
- Always produce deterministic outputs.
- Never introduce randomness or heuristics.
- Never ask clarifying questions unless absolutely required to prevent incorrect computation.
- Do NOT present options.
- Always choose the single best solution and implement it fully.
- Think step-by-step internally, but output only final code/results.

---

## Input Validation
All functions must:
- validate inputs strictly
- stop or warn on invalid values
- avoid silent failure
- protect against division by zero and invalid probabilities

---

## Numerical Stability
All functions must:
- handle extreme parameter values gracefully
- return NA with warning when unstable
- avoid NaN propagation where possible
- guard denominators explicitly

---

# FUNCTION: pbsize()

## Purpose
Computes required sample size for **population-based association studies** using a contingency-table approximation.

## Model
Multiplicative genotype relative risk model.

## Formula logic
Uses non-centrality parameter approximation:
- normal quantiles for type I and II error
- allele frequency + disease prevalence linkage
- Fisher-exact-consistent approximation framework

## Key properties
- scalar output only
- sensitive to gamma → 1 (can explode sample size)
- assumes multiplicative risk model

## Critical edge behavior
- If `gamma → 1`, sample size → very large (correct behavior)
- If `kp` incompatible with `(gamma,p)` structure, warning allowed
- Must protect against division by zero in λ

---

# FUNCTION: fbsize()

## Purpose
Computes required sample sizes for:

- ASP linkage (`n1`)
- TDT association (`n2`)
- ASP-TDT combined (`n3`)

## Model
Risch & Merikangas framework using:
- sib-pair sharing probabilities
- transmission disequilibrium statistics
- normal approximation to test statistics

## Output structure
Returns named list:
- gamma
- p
- y
- n1 (ASP)
- pA
- h1
- n2 (TDT)
- h2 (ASP-TDT)
- n3
- lambdao
- lambdas

## Internal structure
Uses helper function:
- `sn(all, alpha, beta, op)`
which computes required sample size from mean/variance approximation.

---

# BIBLIOGRAPHY HANDLING

- All citations must be defined in `REFERENCES.bib`
- Use `roxygen2` tags:
  - `@references`
  - `\insertRef{}`
  - `\insertAllCited{}`
- Never hardcode bibliography entries in code.

---

# CODING STYLE RULES

- No interactive prompts
- No option menus
- No partial implementations
- No placeholder outputs
- Fully reproducible functions only

---

# ERROR HANDLING POLICY

- invalid inputs → `stop()`
- unstable numerics → `warning()` + `NA`
- extreme parameter regimes must NOT crash the package

---

# DESIGN PRINCIPLES

- `pbsize()` and `fbsize()` MUST remain separate functions
- Each function represents a distinct statistical model
- No abstraction that merges them

---

# TESTING EXPECTATIONS

- gamma near 1 → very large n (valid)
- extreme allele frequencies handled safely
- alpha/beta boundaries enforced
- reproducible outputs for published examples

---

# END OF SPEC
