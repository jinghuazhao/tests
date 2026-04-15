# CLAUDE.md

IMPORTANT:
- Ask questions ONLY if required to avoid incorrect assumptions. Otherwise proceed without asking.
- Do NOT present options
- Choose the best solution and implement it fully
- Think step-by-step internally but output only final code
- Be deterministic and consistent

## Project Overview

R implementation for population-based association study sample size calculations.

Core function:
- pbsize() — sample size calculation for population-based case-control genetic association studies

Statistical framework:
- Scott et al. (1997): contingency table association model for genetic studies
- Rosner (2000): biostatistical foundations for inference and design
- Armitage (2005): distributional and statistical test theory for contingency tables

Supporting files:
- pbsize.R — implementation of pbsize()
- REFERENCES.bib — authoritative bibliography for all derivations and statistical grounding

Goals:
- Numerical correctness
- Reproducibility (match documented examples and published derivations)
- Numerical stability
- Strict consistency with REFERENCES.bib and pbsize.R
- Single unified implementation (pbsize only)

---

## Execution Strategy (MANDATORY)

For every task:

1. Validate inputs strictly
2. Compute model quantities using Scott et al. (1997) framework
3. Derive genotype and disease model quantities under multiplicative model
4. Compute non-centrality parameter (λ)
5. Compute sample size using asymptotic normal approximation
6. Apply numerical stability safeguards
7. Validate outputs
8. Return final code only

Do NOT skip steps.

---

## Working with Code

Source R files:

```r
source("pbsize.R")
