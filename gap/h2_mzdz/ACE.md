# Statistical Note

Falconer's equations are simple descriptive estimators. They are not equivalent to full structural equation modeling (SEM) ACE models implemented in packages such as:

* OpenMx
* umx
* lavaan

For publication-grade inference, SEM approaches are generally preferred because they:

* enforce variance constraints
* estimate uncertainty more rigorously
* support covariates
* handle multivariate models
* allow likelihood-based model comparison
* support ADE/ACE/AE/CE model selection
