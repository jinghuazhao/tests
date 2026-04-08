# context.md

This file provides guidance working with code in this repository.

## Project Overview

R implementations for power and sample size calculations in case-cohort studies:
- `ccsize()` — Cai & Zeng (2004) for rare events (pD < 0.05)
- `ccsize07()` — Cai & Zeng (2007) for non-rare events (pD ≥ 0.05)

Goal is numerical correctness and reproducibility against published tables and
possibility to have a unified code for all scenarios, e.g., ccsize() in R.

## Key Files

| File | Purpose |
|------|---------|
| `ccsize04.md` | Rare-event implementation (R roxygen + code) |
| `ccsize07.md` | Non-rare implementation with methods "2004"/"A1"/"A2" |
| `table1.md` | Validation data for Cai & Zeng (2004) |
| `table3.md` | Validation data for Cai & Zeng (2007) |
| `cai04.pdf`, `cai07.pdf` | Original papers for reference |

## Working with .md R Files

Source R code from markdown files (roxygen comments + R code):
```r
source("ccsize04.md")
source("ccsize07.md")
```

## Quick Test

```r
source("ccsize04.md")
source("ccsize07.md")

# Rare event
ccsize(n=10000, q=0.1, pD=0.01, p1=0.5, theta=log(1.2), alpha=0.05, beta=0.2)

# Non-rare event
ccsize07(n=1000, q=0.1, pD=0.2, p1=0.1, theta=log(1.25), alpha=0.05, method="A1")
```

## Method Selection

- `pD < 0.05`: Use `ccsize()` or `ccsize07(method="2004")`
- `pD ≥ 0.05`: Use `ccsize07(method="A1")` (default)
- Never use "2004" for large pD unless explicitly requested

## R Implementation Rules

- Use explicit numeric types; avoid implicit coercion
- Avoid partial argument matching
- Use `log(hr)` internally (not raw HR)
- Prefer vectorized operations over loops
- Preallocate outputs

## Numerical Stability

- Prefer log-scale computations
- Avoid subtracting nearly equal numbers
- Validate domains: probabilities ∈ (0,1), log arguments > 0
- Explicitly check `is.nan`, `is.infinite`, negative variance
- Return `NA` with warning if invalid

## Input Validation (All Functions)

Must enforce: `n > 0`, `0 < q < 1`, `0 < pD < 1`, `0 < p1 < 1`, `alpha ∈ (0,1)`, `beta ∈ (0,1)`

Invalid input → `stop()` with clear message.

## Output Constraints

- Sample size: positive and finite
- If `ssize ≤ 0` → return `NA`
- Power: must be within [0,1]

## Debugging

- Use `message()` (not `print()`)
- Provide optional `verbose=TRUE`
- No debug output in final results

## Testing Protocol

All changes must reproduce `table1.md` and `table3.md` values within relative error < 1%.

Run edge-case tests: small/large pD, extreme HR, large n.

## Reference Example

Expected: n=25000, pD=0.3, p1=0.2, hr=1.3 → sample size ≈ 5099

## Anti-Patterns

- Do not return negative sample sizes
- Do not silently coerce types
- Do not ignore warnings
- Do not hardcode unexplained constants
