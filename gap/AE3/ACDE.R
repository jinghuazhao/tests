family_model <- function(formula, data,
                         type=c("AE","ACE","ADE","ACDE"))
{
  require(nlme)
  type <- match.arg(type)

  dat <- data

  # --- coefficients implied by pedigree ---
  # parent=0.5 transmission, child=1
  dat$Acoef <- ifelse(dat$role=="child",1,0.5)

  # shared family environment
  dat$Ccoef <- 1

  # dominance shared by siblings only
  dat$Dcoef <- ifelse(dat$role=="child",1,0)

  # unique environment (residual)
  dat$indid <- 1:nrow(dat)

  # --- random effects structures ---
  if(type=="AE")
    rand <- list(
      familyid = pdDiag(~Acoef-1),
      indid    = pdDiag(~1)
    )

  if(type=="ACE")
    rand <- list(
      familyid = pdDiag(~Acoef + Ccoef -1),
      indid    = pdDiag(~1)
    )

  if(type=="ADE")
    rand <- list(
      familyid  = pdDiag(~Acoef-1),
      sibshipid = pdDiag(~Dcoef-1),
      indid     = pdDiag(~1)
    )

  if(type=="ACDE")
    rand <- list(
      familyid  = pdDiag(~Acoef + Ccoef -1),
      sibshipid = pdDiag(~Dcoef-1),
      indid     = pdDiag(~1)
    )

  fit <- lme(
    formula,
    random = rand,
    data   = dat,
    method = "REML",
    control=lmeControl(opt="optim")
  )

  return(fit)
}

set.seed(1)

simulate_ACDE <- function(Nfam=500,
                          VA=.4, VC=.2, VD=.2, VE=.2)
{
  fam_list <- list()

  for(f in 1:Nfam)
  {
    # random effects
    A_fam <- rnorm(1,0,sqrt(VA))
    C_fam <- rnorm(1,0,sqrt(VC))
    D_sib <- rnorm(1,0,sqrt(VD))

    roles <- c("father","mother","child","child")
    sibship <- c(NA,NA,f,f)

    y <- numeric(4)

    # parents
    y[1] <- 0.5*A_fam + C_fam + rnorm(1,0,sqrt(VE))
    y[2] <- 0.5*A_fam + C_fam + rnorm(1,0,sqrt(VE))

    # siblings
    y[3] <- A_fam + C_fam + D_sib + rnorm(1,0,sqrt(VE))
    y[4] <- A_fam + C_fam + D_sib + rnorm(1,0,sqrt(VE))

    fam_list[[f]] <- data.frame(
      familyid=f,
      sibshipid=c(NA,NA,f,f),
      role=roles,
      y=y
    )
  }

  do.call(rbind,fam_list)
}

dat <- simulate_ACDE()
fit_ACDE <- family_model(y~1, dat, "ACDE")
summary(fit_ACDE)
VarCorr(fit_ACDE)
get_vc <- function(fit)
{
  vc <- VarCorr(fit)
  vals <- as.numeric(vc[,1])
  names(vals) <- rownames(vc)

  VA <- vals["Acoef"]
  VC <- vals["Ccoef"]
  VD <- vals["Dcoef"]
  VE <- vals["Residual"]

  VP <- VA+VC+VD+VE

  data.frame(
    VA,VC,VD,VE,
    h2 = VA/VP,
    c2 = VC/VP,
    d2 = VD/VP,
    e2 = VE/VP
  )
}

get_vc(fit_ACDE)
fit_AE  <- family_model(y~1, dat, "AE")
fit_ACE <- family_model(y~1, dat, "ACE")
fit_ADE <- family_model(y~1, dat, "ADE")

anova(fit_AE, fit_ACE, fit_ADE, fit_ACDE)
