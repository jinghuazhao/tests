IMPORTANT:
- Do NOT ask questions
- Do NOT present options
- Choose the best solution and implement it fully
- Think step-by-step internally but output only final code
- Be deterministic and consistent

# CLAUDE.md

## Project Overview

R implementations for power and sample size calculations in case-cohort studies:

- ccsize() — Cai & Zeng (2004), rare events (pD < 0.05)
- ccsize07() — Cai & Zeng (2007), non-rare events (pD ≥ 0.05)

Goals:
- Numerical correctness
- Reproducibility (match published tables)
- Numerical stability
- Unified implementation (ccsize() handles all regimes)

---

## Execution Strategy (MANDATORY)

For every task:

1. Validate inputs strictly
2. Determine method based on pD
3. Use correct formulas from existing implementation
4. Apply numerical stability improvements
5. Validate outputs
6. Return final code only

Do NOT skip steps.

---

## Working with Code

Source R files:

```r
source("ccsize04.md")
source("ccsize07.md")
```

- Prefer modifying existing code
- Do not rewrite unless necessary

---

## Method Selection

- pD < 0.05 → use 2004 method
- pD ≥ 0.05 → use 2007 A1 method
- Never apply 2004 method to large pD

---

## Input Validation (STRICT)

All functions must enforce:

- n > 0
- 0 < q < 1
- 0 < pD < 1
- 0 < p1 < 1
- 0 < alpha < 1
- 0 < beta < 1

Invalid input → stop("invalid input")

---

## Numerical Stability (CRITICAL)

- Prefer log-scale computations
- Avoid subtracting nearly equal numbers
- Avoid division by small values
- Guard all denominators
- Ensure log arguments > 0

Check:
- is.nan
- is.infinite
- negative variance

On failure:
- warning("numerical issue")
- return NA_real_

---

## R Implementation Rules

- Use explicit numeric types
- No partial argument matching
- Use log(hr) internally
- Prefer vectorized operations
- Preallocate outputs

---

## Output Constraints

- Sample size must be positive and finite
- Otherwise return NA_real_

- Power must be within [0,1]

---

## Testing (MANDATORY)

Must reproduce:
- table1.md
- table3.md

Relative error < 1%

Test:
- small pD
- large pD
- extreme hazard ratios
- large n

---

## Debugging

- Use message() only
- verbose = FALSE optional
- No debug output in final results

---

## Anti-Patterns (FORBIDDEN)

- Negative sample sizes
- Silent coercion
- Ignoring warnings
- Hardcoded constants without explanation
- Unstable arithmetic when stable alternatives exist

---

## Final Instruction

Output only:

- Clean
- Validated
- Numerically stable
- Reproducible

R code only. No explanations.
