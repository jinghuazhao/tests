#' Fit biometric AE, ACE or ADE mixed models for nuclear family trios
#'
#' Fits classical biometric variance–decomposition models using a
#' linear mixed model formulation implemented with `nlme::lme`.
#' The implementation follows the covariance–equivalence approach of
#' Rabe-Hesketh, Skrondal & Gjessing (2008).
#'
#' The function estimates additive genetic (A), shared familial (C or D),
#' and unique environmental (E) variance components from parent–child
#' trio data.
#'
#' @param model A fixed-effects model formula.
#' @param data A data frame in trio *long format* with one row per individual.
#' Must contain:
#' \describe{
#'   \item{familyid}{Nuclear family identifier}
#'   \item{var1}{Mother indicator (1/0)}
#'   \item{var2}{Father indicator (1/0)}
#'   \item{var3}{Child indicator (1/0)}
#' }
#' @param type Character string specifying the biometric model:
#' `"AE"`, `"ACE"` or `"ADE"`.
#'
#' @details
#' The mixed model uses genetic design regressors:
#'
#' Additive genetic coefficient:
#' \deqn{A = 0.5\,Mother + 0.5\,Father + 1\,Child}
#'
#' The second random effect represents either:
#' \itemize{
#'   \item shared environment (C) in the ACE model, or
#'   \item dominance genetic variance (D) in the ADE model.
#' }
#'
#' With trio data, ACE and ADE models have identical likelihood and
#' cannot be statistically distinguished.
#'
#' @return A list with components:
#' \describe{
#'   \item{fit}{Fitted `nlme::lme` model}
#'   \item{var}{Named vector of variance components (A, C, D, E)}
#'   \item{h2}{Narrow-sense heritability}
#'   \item{c2}{Shared environmental proportion}
#'   \item{d2}{Dominance proportion}
#'   \item{H2}{Broad-sense heritability}
#' }
#'
#' @examples
#' library(gap.datasets)
#' data(mfblong)
#'
#' model <- bwt ~ male + first + midage + highage + birthyr
#'
#' AE  <- acde(model, mfblong, "AE")
#' ACE <- acde(model, mfblong, "ACE")
#' ADE <- acde(model, mfblong, "ADE")
#'
#' ACE$h2
#' tab <- anova(AE$fit, ACE$fit, ADE$fit)
#' res <- list(AE=AE, ACE=ACE, ADE=ADE, anova=tab)
#' tab <- rbind(
#'   AE  = c(res$AE$var,  h2=res$AE$h2,  c2=res$AE$c2,  d2=res$AE$d2),
#'   ACE = c(res$ACE$var, h2=res$ACE$h2, c2=res$ACE$c2, d2=res$ACE$d2),
#'   ADE = c(res$ADE$var, h2=res$ADE$h2, c2=res$ADE$c2, d2=res$ADE$d2)
#' )
#' tab <- round(tab, digits=3)
#' list(
#'   fits    = res,
#'   anova   = res$anova,
#'   summary = tab
#' )
#'
#' @export
#'
acde <- function(model, data, type=c("AE","ACE","ADE"))
{
  require(nlme)
  type <- match.arg(type)

  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Fcoef <- 1

  if(type=="AE")
    rand <- list(familyid = pdDiag(~ Acoef - 1))

  if(type %in% c("ACE","ADE"))
    rand <- list(familyid = pdDiag(~ Acoef + Fcoef - 1))

  fit <- lme(model,
             random = rand,
             data   = data,
             method = "ML",
             control = lmeControl(opt="optim"))

  ## ===== extract SDs from VarCorr text matrix =====
  vc <- VarCorr(fit)
  sd_vals <- as.numeric(vc[,"StdDev"])

  ## nlme ordering:
  ## random effects first, residual last
  varE <- fit$sigma^2            # residual variance
  re_sd <- sd_vals[1:(length(sd_vals)-1)]
  re_var <- re_sd^2

  varA <- re_var[1]
  varF <- if(type!="AE") re_var[2] else 0

  varC <- if(type=="ACE") varF else 0
  varD <- if(type=="ADE") varF else 0

  varA <- as.numeric(varA)
  varC <- as.numeric(varC)
  varD <- as.numeric(varD)
  varE <- as.numeric(varE)

  varP <- varA + varC + varD + varE

  list(
    fit = fit,
    var = c(A=varA, C=varC, D=varD, E=varE),
    h2  = varA/varP,
    c2  = varC/varP,
    d2  = varD/varP,
    H2  = (varA + varD)/varP
  )
}
