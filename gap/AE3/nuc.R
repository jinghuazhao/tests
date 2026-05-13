############################################################
# 0. SETUP
############################################################
library(nlme)

set.seed(123)

############################################################
# 1. TRUE PARAMETERS (change for experiments)
############################################################
true_par <- list(
  VA = 0.40,
  VC = 0.20,
  VD = 0.15,
  VE = 0.25
)

############################################################
# 2. FAMILY DATA SIMULATOR (parents + 2 siblings)
############################################################
simulate_family_data <- function(n_fam=1000, pars=true_par)
{
  VA <- pars$VA; VC <- pars$VC; VD <- pars$VD; VE <- pars$VE
  
  out <- vector("list", n_fam)

  for(f in 1:n_fam)
  {
    ## latent family components
    Cfam <- rnorm(1,0,sqrt(VC))
    
    ## parental additive effects
    Af <- rnorm(1,0,sqrt(VA))
    Am <- rnorm(1,0,sqrt(VA))
    
    ## offspring additive via Mendelian sampling
    Mendel1 <- rnorm(1,0,sqrt(0.5*VA))
    Mendel2 <- rnorm(1,0,sqrt(0.5*VA))
    
    A_sib1 <- 0.5*(Af+Am) + Mendel1
    A_sib2 <- 0.5*(Af+Am) + Mendel2
    
    ## dominance (siblings share 1/4 variance)
    D_shared <- rnorm(1,0,sqrt(0.25*VD))
    D_sib1 <- D_shared + rnorm(1,0,sqrt(0.75*VD))
    D_sib2 <- D_shared + rnorm(1,0,sqrt(0.75*VD))
    
    ## unique environment
    Ef <- rnorm(1,0,sqrt(VE))
    Em <- rnorm(1,0,sqrt(VE))
    E1 <- rnorm(1,0,sqrt(VE))
    E2 <- rnorm(1,0,sqrt(VE))
    
    ## phenotypes
    y_father <- Af + Cfam + Ef
    y_mother <- Am + Cfam + Em
    y_sib1   <- A_sib1 + D_sib1 + Cfam + E1
    y_sib2   <- A_sib2 + D_sib2 + Cfam + E2
    
    out[[f]] <- data.frame(
      famid=f,
      role=c("father","mother","sib1","sib2"),
      y=c(y_father,y_mother,y_sib1,y_sib2)
    )
  }
  
  dat <- do.call(rbind,out)
  rownames(dat) <- NULL
  
  ## coefficients for mixed model
  dat$Acoef <- ifelse(dat$role %in% c("sib1","sib2"),1,0.5)
  dat$Ccoef <- 1
  dat$Dcoef <- ifelse(dat$role %in% c("sib1","sib2"),1,0)
  
  dat$indid <- 1:nrow(dat)   # individual ID
  
  return(dat)
}

############################################################
# 3. MODEL FITTER (AE / ACE / ADE / ACDE)
############################################################
fit_family_model <- function(dat, model="ACDE")
{
  if(model=="AE")
  {
    rand <- list(
      famid=pdDiag(~Acoef-1),
      indid=pdDiag(~1)
    )
  }
  
  if(model=="ACE")
  {
    rand <- list(
      famid=pdBlocked(list(
        pdDiag(~Acoef-1),
        pdDiag(~Ccoef-1)
      )),
      indid=pdDiag(~1)
    )
  }
  
  if(model=="ADE")
  {
    rand <- list(
      famid=pdDiag(~Acoef-1),
      sibship=pdDiag(~Dcoef-1),
      indid=pdDiag(~1)
    )
    dat$sibship <- dat$famid
  }
  
  if(model=="ACDE")
  {
    rand <- list(
      famid=pdBlocked(list(
        pdDiag(~Acoef-1),
        pdDiag(~Ccoef-1)
      )),
      sibship=pdDiag(~Dcoef-1),
      indid=pdDiag(~1)
    )
    dat$sibship <- dat$famid
  }
  
  lme(
    y~1,
    random=rand,
    data=dat,
    method="REML",
    control=lmeControl(opt="optim",msMaxIter=200)
  )
}

############################################################
# 4. EXTRACT VARIANCE COMPONENTS
############################################################
extract_variance_components <- function(fit)
{
  vc <- VarCorr(fit)
  print(vc)
}

############################################################
# 5. MODEL COMPARISON
############################################################
compare_models <- function(dat)
{
  cat("\nFitting AE...\n");   mAE  <- fit_family_model(dat,"AE")
  cat("Fitting ACE...\n");  mACE <- fit_family_model(dat,"ACE")
  cat("Fitting ADE...\n");  mADE <- fit_family_model(dat,"ADE")
  cat("Fitting ACDE...\n"); mACDE<- fit_family_model(dat,"ACDE")
  
  cat("\nMODEL COMPARISON\n")
  print(anova(mAE,mACE,mADE,mACDE))
  
  return(list(AE=mAE,ACE=mACE,ADE=mADE,ACDE=mACDE))
}

############################################################
# 6. POWER STUDY (OPTIONAL LONG RUN)
############################################################
power_study <- function(n_sim=50,n_fam=1000)
{
  detectC <- detectD <- 0
  
  for(i in 1:n_sim)
  {
    cat("Sim",i,"\n")
    dat <- simulate_family_data(n_fam)
    
    mAE <- fit_family_model(dat,"AE")
    mACE<- fit_family_model(dat,"ACE")
    mADE<- fit_family_model(dat,"ADE")
    
    if(anova(mAE,mACE)$`p-value`[2] < .05) detectC <- detectC+1
    if(anova(mAE,mADE)$`p-value`[2] < .05) detectD <- detectD+1
  }
  
  cat("\nPower C:",detectC/n_sim,"\n")
  cat("Power D:",detectD/n_sim,"\n")
}

############################################################
# 7. DEMO RUN (FAST)
############################################################
data <- simulate_family_data(n_fam=500)

fit <- fit_family_model(data,"ACDE")
summary(fit)

extract_variance_components(fit)

compare_models(data)

# Long run for publication figure:
# power_study(n_sim=100, n_fam=3000)
