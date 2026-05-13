#' Fit AE, ACE and ADE biometric models to nuclear family trio data
#'
#' Fits additive genetic (A), shared environmental (C) and dominance (D)
#' variance component models for nuclear family trio data (mother–father–child)
#' using linear mixed models from the `nlme` package.
#'
#' The function automatically fits and compares the AE, ACE and ADE models,
#' extracts variance components, computes heritability estimates, and performs
#' likelihood ratio tests.
#'
#' @details
#' This implementation applies the general covariance–mixed model equivalence
#' described by Rabe-Hesketh, Skrondal & Gjessing (2008) to the specific case
#' of nuclear family trio data. The function constructs the required design
#' matrices to reproduce pedigree covariance structures using standard
#' mixed-effects software.
#'
#' For nuclear family trios:
#' * AE, ACE and ADE models are identifiable.
#' * Shared environment (C) and dominance (D) cannot be estimated simultaneously.
#'
#' Additive genetic coefficients are constructed as:
#' \deqn{A = 0.5\,mother + 0.5\,father + 1\,child}
#'
#' @param formula Fixed-effects model formula (as in \code{lme}).
#' @param data Data frame in long trio format containing:
#' \describe{
#'   \item{familyid}{Family identifier}
#'   \item{var1}{Mother indicator (0/1)}
#'   \item{var2}{Father indicator (0/1)}
#'   \item{var3}{Child indicator (0/1)}
#' }
#' @param method Estimation method: `"ML"` (default) or `"REML"`.
#'
#' @return A list containing:
#' \describe{
#'   \item{AE, ACE, ADE}{Fitted \code{lme} model objects}
#'   \item{fit_stats}{Table of logLik, AIC and BIC}
#'   \item{variance_components}{Variance components and proportions}
#'   \item{LR}{Likelihood ratio tests}
#' }
#'
#' @examples
#' \dontrun{
#' library(gap.datasets)
#' data(mfblong)
#'
#' model <- bwt ~ male + first + midage + highage + birthyr
#' res <- fit_trio_models(model, mfblong)
#' }
#'
#' @references
#' Rabe-Hesketh S, Skrondal A, Gjessing HK (2008).
#' Biometrical modelling of twin and family data using standard mixed model software.
#' Biometrics 64:280–288.
#'
#' The present implementation applies the general mixed-model equivalence
#' established in this paper to nuclear family trio data.
#'
#' @export
#'
fit_trio_models <- function(formula, data, method="ML")
{
  require(nlme)

  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Ccoef <- 1
  data$Dcoef <- 1
  data$indid <- 1:nrow(data)

  ctrl <- lmeControl(opt="optim")

  message("Fitting AE model...")
  AE <- lme(
    formula,
    random=list(familyid=pdDiag(~Acoef-1)),
    data=data, method=method, control=ctrl)

  message("Fitting ACE model...")
  ACE <- lme(
    formula,
    random=list(familyid=pdDiag(~Acoef+Ccoef-1)),
    data=data, method=method, control=ctrl)

  message("Fitting ADE model...")
  ADE <- lme(
    formula,
    random=list(
      familyid=pdDiag(~Acoef-1),
      indid=pdDiag(~Dcoef-1)),
    data=data, method=method, control=ctrl)

  getVC <- function(fit,type){
    pars <- attr(fit$apVar,"Pars")
    vE <- exp(2*pars[1])
    vA <- exp(2*pars[2])
    vC <- if(type=="ACE") exp(2*pars[3]) else 0
    vD <- if(type=="ADE") exp(2*pars[3]) else 0
    vP <- vA+vC+vD+vE
    c(A=vA,C=vC,D=vD,E=vE,h2=vA/vP,c2=vC/vP,d2=vD/vP,VP=vP)
  }

  vcAE  <- getVC(AE,"AE")
  vcACE <- getVC(ACE,"ACE")
  vcADE <- getVC(ADE,"ADE")

  stats <- rbind(
    AE  = c(logLik=logLik(AE),AIC=AIC(AE),BIC=BIC(AE)),
    ACE = c(logLik=logLik(ACE),AIC=AIC(ACE),BIC=BIC(ACE)),
    ADE = c(logLik=logLik(ADE),AIC=AIC(ADE),BIC=BIC(ADE))
  )

  vc_table <- rbind(AE=vcAE,ACE=vcACE,ADE=vcADE)

  LR_AE_ACE <- anova(AE,ACE)
  LR_AE_ADE <- anova(AE,ADE)

  invisible(list(
    AE=AE, ACE=ACE, ADE=ADE,
    fit_stats=stats,
    variance_components=vc_table,
    LR=list(AE_vs_ACE=LR_AE_ACE,
            AE_vs_ADE=LR_AE_ADE)))
}
