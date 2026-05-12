family_model <- function(model, data, type=c("AE","ACE","ADE","ACDE"))
{
  require(nlme)
  type <- match.arg(type)

  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Ccoef <- 1
  data$Dcoef <- data$var3      # only siblings/children
  data$indid <- 1:nrow(data)

  if(type=="AE")
    rand <- list(familyid = pdDiag(~ Acoef - 1))

  if(type=="ACE")
    rand <- list(familyid = pdDiag(~ Acoef + Ccoef - 1))

  if(type=="ADE")
    rand <- list(
      familyid = pdDiag(~ Acoef - 1),
      sibshipid = pdDiag(~ Dcoef - 1)
    )

  if(type=="ACDE")
    rand <- list(
      familyid  = pdDiag(~ Acoef + Ccoef - 1),
      sibshipid = pdDiag(~ Dcoef - 1)
    )

  fit <- lme(model, random=rand, data=data, method="ML",
             control=lmeControl(opt="optim"))

  pars <- attr(fit$apVar,"Pars")

  varE <- exp(2*pars[1])
  varA <- exp(2*pars[2])
  varC <- if(type %in% c("ACE","ACDE")) exp(2*pars[3]) else 0
  varD <- if(type %in% c("ADE","ACDE")) exp(2*pars[length(pars)]) else 0

  varP <- varA + varC + varD + varE

  list(
    fit = fit,
    var = c(A=varA,C=varC,D=varD,E=varE),
    h2  = varA/varP,
    c2  = varC/varP,
    d2  = varD/varP
  )
}

compare_family_models <- function(model,data)
{
  AE   <- family_model(model,data,"AE")
  ACE  <- family_model(model,data,"ACE")
  ADE  <- family_model(model,data,"ADE")
  ACDE <- family_model(model,data,"ACDE")

  tab <- anova(AE$fit, ACE$fit, ADE$fit, ACDE$fit)

  list(AE=AE, ACE=ACE, ADE=ADE, ACDE=ACDE, anova=tab)
}
