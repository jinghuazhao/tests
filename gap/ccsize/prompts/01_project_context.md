R implementations for power and sample size calculations in case-cohort studies:

- ccsize() — Cai & Zeng (2004), rare events (pD < 0.05)
- ccsize07() — Cai & Zeng (2007), non-rare events (pD ≥ 0.05)

Goals:
- Numerical correctness
- Reproducibility (match published tables)
- Numerical stability
- Unified implementation (ccsize() handles all regimes)
