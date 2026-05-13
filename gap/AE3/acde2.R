#' Fit biometric mixed models to nuclear family data (trios or siblings)
#'
#' Automatically detects whether the dataset contains only trios or
#' nuclear families with multiple offspring and fits the appropriate
#' biometric models using linear mixed models from `nlme`.
#'
#' Models fitted:
#' * Trio data → AE, ACE, ADE
#' * Sibling data → AE, ACE, ADE, ACDE
#'
#' @details
#' The function applies the covariance–mixed model equivalence of
#' Rabe-Hesketh, Skrondal & Gjessing (2008) to nuclear family data.
#'
#' Additive genetic coefficients are constructed as:
#' \deqn{A = 0.5\,mother + 0.5\,father + 1\,child}
#'
#' Dominance effects are fitted at the sibship level and become
#' identifiable only when siblings are present.
#'
#' Required columns in `data`:
#' \describe{
#'   \item{familyid}{Family identifier}
#'   \item{var1}{Mother indicator}
#'   \item{var2}{Father indicator}
#'   \item{var3}{Child indicator}
#' }
#'
#' Optional (needed for ACDE):
#' \describe{
#'   \item{sibid}{Sibling group identifier. If absent, it will be created.}
#' }
#'
#' @param formula Fixed-effects model formula.
#' @param data Long-format nuclear family dataset.
#' @param method "ML" (default) or "REML".
#'
#' @return List with fitted models, variance components,
#' model fit statistics and likelihood ratio tests.
#'
#' @references
#' Rabe-Hesketh S, Skrondal A, Gjessing HK (2008).
#' Biometrical modelling of twin and family data using standard mixed model software.
#' Biometrics 64:280–288.
#'
#' @export
#'
fit_nuclear_models <- function(formula, data, method="ML")
{
  require(nlme)
  ctrl <- lmeControl(opt="optim")

  ## --- Detect whether siblings exist ---
  child_count <- tapply(data$var3, data$familyid, sum)
  has_siblings <- any(child_count > 1)

  message(if(has_siblings) "Sibling data detected → fitting ACDE"
          else "Trio data detected → fitting AE/ACE/ADE")

  ## --- Construct design variables ---
  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Ccoef <- 1
  data$Dcoef <- 1
  data$indid <- 1:nrow(data)

  ## Create sibship id if missing
  if(is.null(data$sibid))
  {
    data$sibid <- data$familyid
    data$sibid[data$var3==0] <- paste0(data$familyid[data$var3==0],
                                       "_", data$indid[data$var3==0])
  }

  ## --- Fit models ---
  fits <- list()

  fits$AE <- lme(formula,
                 random=list(familyid=pdDiag(~Acoef-1)),
                 data=data, method=method, control=ctrl)

  fits$ACE <- lme(formula,
                  random=list(familyid=pdDiag(~Acoef+Ccoef-1)),
                  data=data, method=method, control=ctrl)

  fits$ADE <- lme(formula,
                  random=list(familyid=pdDiag(~Acoef-1),
                              indid=pdDiag(~Dcoef-1)),
                  data=data, method=method, control=ctrl)

  if(has_siblings)
    fits$ACDE <- lme(formula,
                     random=list(familyid=pdDiag(~Acoef+Ccoef-1),
                                 sibid=pdDiag(~Dcoef-1)),
                     data=data, method=method, control=ctrl)

  ## --- Extract variance components ---
  get_varcomp <- function(fit, model)
  {
    pars <- attr(fit$apVar,"Pars")
    vE <- exp(2*pars[1])
    vA <- exp(2*pars[2])

    vC <- vD <- 0
    if(model %in% c("ACE","ACDE")) vC <- exp(2*pars[3])
    if(model=="ADE")  vD <- exp(2*pars[3])
    if(model=="ACDE") vD <- exp(2*pars[4])

    vP <- vA+vC+vD+vE

    c(A=vA,C=vC,D=vD,E=vE,
      h2=vA/vP,c2=vC/vP,d2=vD/vP)
  }

  varcomp <- mapply(get_varcomp, fits, names(fits), SIMPLIFY=FALSE)

  ## --- Fit statistics ---
  fit_stats <- do.call(rbind,
    lapply(fits, function(f)
      c(logLik=logLik(f), AIC=AIC(f), BIC=BIC(f))))

  ## --- Likelihood ratio tests ---
  LR <- NULL
  if(has_siblings)
    LR <- anova(fits$AE, fits$ACE, fits$ADE, fits$ACDE)
  else
    LR <- anova(fits$AE, fits$ACE, fits$ADE)

  list(
    models=fits,
    variance_components=varcomp,
    fit_stats=fit_stats,
    LR_tests=LR
  )
}

library(gap.datasets)
data(mfblong)

model <- bwt ~ male + first + midage + highage + birthyr
res <- fit_nuclear_models(model, mfblong)

res$fit_stats
res$variance_components
res$LR_tests
