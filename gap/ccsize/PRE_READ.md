# Pre-Read: Case-Cohort Power & Sample Size Package

## What This Is

R implementations of Cai & Zeng (2004, 2007) for power and sample size calculations in **case-cohort studies**.

**Core question:** How many subjects do you need in a cohort study when you're only genotyping a random subcohort (not everyone)?

---

## The Two Functions

### `ccsize()` — Rare Events (pD < 0.05)
- Based on Cai & Zeng (2004)
- Original asymptotic theory
- Validated against **Table 1** (5000 simulations)

### `ccsize07()` — Non-Rare Events (pD ≥ 0.05)
- Based on Cai & Zeng (2007)
- Three methods: `"2004"`, `"A1"`, `"A2"`
- Validated against **Table 3** (empirical powers)

---

## Key Parameters

| Symbol | Meaning |
|--------|---------|
| `n` | Total cohort size |
| `q` | Subcohort sampling fraction |
| `pD` | Event proportion in full cohort |
| `p1` | Proportion in exposure group 1 |
| `θ = log(HR)` | Log-hazard ratio |
| `α` | Type I error |
| `β` | Type II error (1 − power) |

---

## Method Selection Guide

```
pD < 0.05  →  ccsize()   or   ccsize07(method="2004")
pD ≥ 0.05  →  ccsize07(method="A1")   ← default
```

**A1 vs A2:** A1 generally preferred; A2 is an alternative with slightly different bias-variance trade-off.

---

## Validation Status

| Table | Source | Status |
|-------|--------|--------|
| Table 1 | Cai & Zeng (2004) | ✅ Implemented |
| Table 3 | Cai & Zeng (2007) | ✅ Implemented |

Expected relative error: **< 1%**

---

## Example Use Cases

**Power calculation:**
```r
ccsize(n=10000, q=0.1, pD=0.01, p1=0.5, theta=log(1.2), alpha=0.05)
```

**Sample size (given 80% power):**
```r
ccsize(n=10000, q=0.1, pD=0.3, p1=0.2, theta=log(1.3),
       alpha=0.05, beta=0.2, power=FALSE)
# → ~5099
```

---

## Code Quality

- **Log-scale computations** throughout
- Explicit input validation → `stop()` on invalid args
- Handles `NA`/Inf edge cases with warnings
- Vectorized operations, preallocated outputs
- No hardcoded unexplained constants

---

## Open Questions for Discussion

1. Should we add a **unified wrapper** `ccsize()` that auto-selects method based on pD?
2. Do we need ** covariate-adjusted** power formulas?
3. Any interest in **simulation utilities** to generate empirical powers?
