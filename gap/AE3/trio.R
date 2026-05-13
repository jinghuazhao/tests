library(nlme)

fit_trio_models <- function(formula, data, method="ML")
{
  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Ccoef <- 1
  data$Dcoef <- 1
  data$indid <- 1:nrow(data)

  ctrl <- lmeControl(opt="optim")

  cat("\nFitting AE model...\n")
  AE <- lme(
    formula,
    random = list(
      familyid = pdDiag(~ Acoef - 1)
    ),
    data=data, method=method, control=ctrl
  )

  cat("Fitting ACE model...\n")
  ACE <- lme(
    formula,
    random = list(
      familyid = pdDiag(~ Acoef + Ccoef - 1)
    ),
    data=data, method=method, control=ctrl
  )

  cat("Fitting ADE model...\n")
  ADE <- lme(
    formula,
    random = list(
      familyid = pdDiag(~ Acoef - 1),
      indid    = pdDiag(~ Dcoef - 1)
    ),
    data=data, method=method, control=ctrl
  )

  getVC <- function(fit, type)
  {
    pars <- attr(fit$apVar,"Pars")
    vE <- exp(2*pars[1])
    vA <- exp(2*pars[2])
    vC <- if(type=="ACE") exp(2*pars[3]) else 0
    vD <- if(type=="ADE") exp(2*pars[3]) else 0
    vP <- vA+vC+vD+vE

    c(A=vA, C=vC, D=vD, E=vE,
      h2=vA/vP, c2=vC/vP, d2=vD/vP, VP=vP)
  }

  vcAE  <- getVC(AE,"AE")
  vcACE <- getVC(ACE,"ACE")
  vcADE <- getVC(ADE,"ADE")

  model_stats <- function(fit)
    c(logLik=logLik(fit),
      AIC=AIC(fit),
      BIC=BIC(fit))

  stats <- rbind(
    AE  = model_stats(AE),
    ACE = model_stats(ACE),
    ADE = model_stats(ADE)
  )

  vc_table <- rbind(
    AE  = vcAE,
    ACE = vcACE,
    ADE = vcADE
  )

  LR_AE_ACE <- anova(AE,ACE)
  LR_AE_ADE <- anova(AE,ADE)

  cat("\n=============================\n")
  cat("MODEL FIT STATISTICS\n")
  print(stats)

  cat("\n=============================\n")
  cat("VARIANCE COMPONENTS\n")
  print(round(vc_table,3))

  cat("\n=============================\n")
  cat("LIKELIHOOD RATIO TESTS\n")
  cat("\nAE vs ACE (shared environment):\n")
  print(LR_AE_ACE)

  cat("\nAE vs ADE (dominance):\n")
  print(LR_AE_ADE)

  invisible(list(
    AE=AE, ACE=ACE, ADE=ADE,
    fit_stats=stats,
    variance_components=vc_table,
    LR=list(AE_vs_ACE=LR_AE_ACE,
            AE_vs_ADE=LR_AE_ADE)
  ))
}

library(gap.datasets)
data(mfblong)

model <- bwt ~ male + first + midage + highage + birthyr

results <- fit_trio_models(model, mfblong)
