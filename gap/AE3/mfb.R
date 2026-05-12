#' Fit biometric AE/ACE/ADE models to nuclear family trio data
#'
#' This file implements linear mixed model versions of classical
#' biometric models using the `nlme` package. The implementation
#' follows the covariance equivalence approach of
#' Rabe-Hesketh, Skrondal & Gjessing (2008).
#'
#' The data must be in long format with one row per individual
#' and the following variables:
#'
#' * `familyid` : nuclear family identifier
#' * `var1` : indicator for mother (1/0)
#' * `var2` : indicator for father (1/0)
#' * `var3` : indicator for child (1/0)
#'
#' The package `gap.datasets` provides the example dataset `mfblong`.
#'
NULL


#' Prepare trio genetic design variables
#'
#' Constructs additive genetic and familial design coefficients
#' used as random‐effect regressors in the mixed model.
#'
#' @param data Data frame in mfblong format.
#'
#' @return Data frame with added columns:
#' \describe{
#'   \item{Acoef}{Additive genetic coefficient}
#'   \item{Fcoef}{Familial coefficient (C or D)}
#' }
#'
#' @details
#' Additive genetic transmission:
#' \deqn{A = 0.5\,Mother + 0.5\,Father + 1\,Child}
#'
#' The familial component represents either shared environment (C)
#' or dominance genetics (D) depending on model choice.
#'
#' @export
prepare_trio_design <- function(data)
{
  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Fcoef <- 1
  data
}



#' Fit a biometric mixed model
#'
#' Fits AE, ACE or ADE models using maximum likelihood.
#'
#' @param model Fixed effects formula.
#' @param data Trio dataset (mfblong format).
#' @param type Model type: `"AE"`, `"ACE"`, or `"ADE"`.
#'
#' @return A list containing:
#' \describe{
#'   \item{fit}{`nlme::lme` model object}
#'   \item{var}{Variance components (A,C,D,E)}
#'   \item{h2}{Narrow-sense heritability}
#'   \item{c2}{Shared environment proportion}
#'   \item{d2}{Dominance proportion}
#'   \item{H2}{Broad-sense heritability}
#' }
#'
#' @examples
#' library(gap.datasets)
#' data(mfblong)
#' model <- bwt ~ male + first + midage + highage + birthyr
#' fit <- biometric_model(model, mfblong, "ACE")
#' fit$h2
#'
#' @export
biometric_model <- function(model, data, type=c("AE","ACE","ADE"))
{
  require(nlme)
  type <- match.arg(type)

  data <- prepare_trio_design(data)

  if(type=="AE")
    rand <- list(familyid = pdDiag(~ Acoef - 1))

  if(type %in% c("ACE","ADE"))
    rand <- list(familyid = pdDiag(~ Acoef + Fcoef - 1))

  fit <- lme(model, random=rand, data=data, method="ML",
             control=lmeControl(opt="optim"))

  pars <- attr(fit$apVar,"Pars")

  varE <- exp(2*pars[1])
  varA <- exp(2*pars[2])
  varF <- if(type!="AE") exp(2*pars[3]) else 0

  varC <- if(type=="ACE") varF else 0
  varD <- if(type=="ADE") varF else 0

  varP <- varA + varC + varD + varE

  list(
    fit = fit,
    var = c(A=varA, C=varC, D=varD, E=varE),
    h2  = varA/varP,
    c2  = varC/varP,
    d2  = varD/varP,
    H2  = (varA+varD)/varP
  )
}



#' Compare AE, ACE and ADE models
#'
#' Fits all three biometric models and performs likelihood comparison.
#'
#' @param model Fixed effects formula.
#' @param data Trio dataset.
#'
#' @return List containing fitted models and ANOVA comparison table.
#'
#' @examples
#' library(gap.datasets)
#' data(mfblong)
#'
#' model <- bwt ~ male + first + midage + highage + birthyr
#' res <- compare_biometric_models(model, mfblong)
#'
#' res$anova
#' res$ACE$h2
#'
#' @export
compare_biometric_models <- function(model, data)
{
  AE  <- biometric_model(model,data,"AE")
  ACE <- biometric_model(model,data,"ACE")
  ADE <- biometric_model(model,data,"ADE")

  tab <- anova(AE$fit, ACE$fit, ADE$fit)

  list(AE=AE, ACE=ACE, ADE=ADE, anova=tab)
}



#' Tidy summary table of biometric results
#'
#' Converts model outputs into a publication-ready table.
#'
#' @param res Output from `compare_biometric_models()`
#'
#' @return Data frame summarising variance decomposition.
#' @export
tidy_biometric_summary <- function(res)
{
  rbind(
    AE  = c(res$AE$var,  h2=res$AE$h2,  c2=res$AE$c2,  d2=res$AE$d2),
    ACE = c(res$ACE$var, h2=res$ACE$h2, c2=res$ACE$c2, d2=res$ACE$d2),
    ADE = c(res$ADE$var, h2=res$ADE$h2, c2=res$ADE$c2, d2=res$ADE$d2)
  )
}

#' Fit and summarise biometric trio models
#'
#' High-level convenience function that fits AE, ACE and ADE models,
#' performs likelihood comparison and returns a compact summary table
#' ready for reporting in publications.
#'
#' @param model Fixed effects formula.
#' @param data Trio dataset in mfblong format.
#' @param digits Number of digits for rounding output table.
#'
#' @return A list containing:
#' \describe{
#'   \item{fits}{List of fitted AE, ACE, ADE model objects}
#'   \item{anova}{Likelihood comparison table}
#'   \item{summary}{Compact variance decomposition table}
#'   \item{latex}{LaTeX table code}
#' }
#'
#' @examples
#' library(gap.datasets)
#' data(mfblong)
#'
#' model <- bwt ~ male + first + midage + highage + birthyr
#' out <- fit_biometric_trio(model, mfblong)
#'
#' out$summary
#' cat(out$latex)
#'
#' @export
fit_biometric_trio <- function(model, data, digits=3)
{
  res <- compare_biometric_models(model, data)

  tab <- tidy_biometric_summary(res)

  tab <- round(tab, digits)

  ## build latex table automatically
  latex <- paste0(
"\\begin{table}[ht]
\\centering
\\caption{Biometric variance decomposition}
\\begin{tabular}{lrrrrrr}
\\toprule
Model & A & C & D & E & $h^2$ & $c^2$/$d^2$ \\\\
\\midrule\n",
sprintf("AE  & %.3f & %.3f & %.3f & %.3f & %.3f & -- \\\\\n",
        tab["AE","A"],tab["AE","C"],tab["AE","D"],tab["AE","E"],tab["AE","h2"]),
sprintf("ACE & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f \\\\\n",
        tab["ACE","A"],tab["ACE","C"],tab["ACE","D"],tab["ACE","E"],
        tab["ACE","h2"],tab["ACE","c2"]),
sprintf("ADE & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f \\\\\n",
        tab["ADE","A"],tab["ADE","C"],tab["ADE","D"],tab["ADE","E"],
        tab["ADE","h2"],tab["ADE","d2"]),
"\\bottomrule
\\end{tabular}
\\end{table}"
)

  list(
    fits    = res,
    anova   = res$anova,
    summary = tab,
    latex   = latex
  )
}
