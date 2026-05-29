# Key Improvements Over the Original

## 1. Correct variance approximation

Your original implementation used:

```r
vmz <- 1 / (n1 - 1)
vdz <- 1 / (n2 - 1)
```

The improved version uses the asymptotic variance of Pearson correlations:

```r
Var(r) ≈ (1 - r^2)^2 / (n - 1)
```

which is substantially more accurate.

---

## 2. Proper input validation

The revised function checks:

* variable existence
* correlation bounds
* minimum sample size
* finite correlations
* valid `selV`
* sufficient complete pairs

This prevents many silent failures.

---

## 3. Cleaner handling of raw vs summary input

A dedicated helper function eliminates duplicated code and improves maintainability.

---

## 4. Confidence intervals included

The function optionally returns:

* standard errors
* 95% confidence intervals

which are usually expected in quantitative genetics workflows.

---

## 5. Optional parameter bounding

ACE estimates can become negative or exceed 1 because Falconer estimators are unconstrained.

The `bounds = TRUE` option truncates estimates and confidence intervals to [0,1].

---

## 6. Better reproducibility and API design

Additional arguments:

* `use`
* `ci`
* `bounds`
* `digits`

make the function easier to integrate into packages and analysis pipelines.

---

## 7. Better documentation and package readiness

The revised roxygen documentation is:

* CRAN-ready
* easier to understand
* more statistically explicit
* easier to maintain

---

