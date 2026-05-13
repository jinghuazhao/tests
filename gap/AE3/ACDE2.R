| familyid | sibshipid | role   | y |
| -------- | --------- | ------ | - |
| 1        | NA        | mother | … |
| 1        | NA        | father | … |
| 1        | 1         | child  | … |
| 1        | 1         | child  | … |
| 1        | 1         | child  | … |
| 2        | NA        | mother | … |
| 2        | 2         | child  | … |
| 3        | NA        | father | … |
| 3        | 3         | child  | … |
| 3        | 3         | child  | … |


build_coefficients <- function(dat)
{
  dat$Acoef <- ifelse(dat$role=="child",1,0.5)
  dat$Ccoef <- 1
  dat$Dcoef <- ifelse(dat$role=="child",1,0)
  dat$indid <- seq_len(nrow(dat))
  dat
}

library(nlme)

family_model <- function(formula, data,
                         type=c("AE","ACE","ADE","ACDE"))
{
  type <- match.arg(type)
  dat <- build_coefficients(data)

  rand <- switch(type,

    AE = list(
      familyid = pdDiag(~Acoef-1),
      indid    = pdDiag(~1)
    ),

    ACE = list(
      familyid = pdDiag(~Acoef + Ccoef -1),
      indid    = pdDiag(~1)
    ),

    ADE = list(
      familyid  = pdDiag(~Acoef-1),
      sibshipid = pdDiag(~Dcoef-1),
      indid     = pdDiag(~1)
    ),

    ACDE = list(
      familyid  = pdDiag(~Acoef + Ccoef -1),
      sibshipid = pdDiag(~Dcoef-1),
      indid     = pdDiag(~1)
    )
  )

  lme(formula,
      random = rand,
      data   = dat,
      method = "REML",
      na.action = na.exclude,
      control=lmeControl(opt="optim"))
}

simulate_irregular_families <- function(Nfam=400,
                                        VA=.4, VC=.2, VD=.2, VE=.2)
{
  fams <- list()

  for(f in 1:Nfam)
  {
    nchild <- sample(1:4,1)       # variable sibship size
    has_mom <- rbinom(1,1,.9)
    has_dad <- rbinom(1,1,.9)

    A_fam <- rnorm(1,0,sqrt(VA))
    C_fam <- rnorm(1,0,sqrt(VC))
    D_sib <- rnorm(1,0,sqrt(VD))

    rows <- list()

    if(has_mom==1)
      rows[[length(rows)+1]] <-
        data.frame(familyid=f,sibshipid=NA,role="mother",
                   y=0.5*A_fam+C_fam+rnorm(1,0,sqrt(VE)))

    if(has_dad==1)
      rows[[length(rows)+1]] <-
        data.frame(familyid=f,sibshipid=NA,role="father",
                   y=0.5*A_fam+C_fam+rnorm(1,0,sqrt(VE)))

    for(k in 1:nchild)
      rows[[length(rows)+1]] <-
        data.frame(familyid=f,sibshipid=f,role="child",
                   y=A_fam+C_fam+D_sib+rnorm(1,0,sqrt(VE)))

    fams[[f]] <- do.call(rbind,rows)
  }

  do.call(rbind,fams)
}

dat <- simulate_irregular_families()
fit_ACDE <- family_model(y~1, dat, "ACDE")
fit_ADE  <- family_model(y~1, dat, "ADE")
fit_ACE  <- family_model(y~1, dat, "ACE")
fit_AE   <- family_model(y~1, dat, "AE")

anova(fit_AE, fit_ACE, fit_ADE, fit_ACDE)

extract_ACDE <- function(fit)
{
  vc <- VarCorr(fit)
  v <- as.numeric(vc[,1])
  names(v) <- rownames(vc)

  VA <- v["Acoef"]
  VC <- v["Ccoef"]
  VD <- v["Dcoef"]
  VE <- v["Residual"]

  VP <- sum(VA,VC,VD,VE)

  data.frame(
    VA, VC, VD, VE,
    h2 = VA/VP,
    c2 = VC/VP,
    d2 = VD/VP,
    e2 = VE/VP
  )
}

extract_ACDE(fit_ACDE)
fit_ACDE <- family_model(
  y ~ age + sex + PC1 + PC2,
  data = dat,
  type = "ACDE"
)

stack_traits <- function(dat, traits)
{
  long <- reshape(
    dat,
    varying = traits,
    v.names = "y",
    timevar = "trait",
    times = traits,
    direction = "long"
  )

  long$trait <- factor(long$trait)
  long
}

build_coefficients_multi <- function(dat)
{
  dat$Acoef <- ifelse(dat$role=="child",1,0.5)
  dat$Ccoef <- 1
  dat$Dcoef <- ifelse(dat$role=="child",1,0)
  dat$indid <- seq_len(nrow(dat))
  dat
}

library(nlme)

family_model_multi <- function(formula, data, type="ACDE")
{
  dat <- build_coefficients_multi(data)

  rand <- list(
    familyid  = pdBlocked(list(
      pdSymm(~ trait*Acoef -1),
      pdSymm(~ trait*Ccoef -1)
    )),
    sibshipid = pdSymm(~ trait*Dcoef -1),
    indid     = pdSymm(~ trait -1)
  )

  lme(formula,
      random = rand,
      data   = dat,
      method = "REML",
      na.action = na.exclude,
      control=lmeControl(opt="optim"))
}

fit_multi <- family_model_multi(
  y ~ trait + trait:age + trait:sex,
  data = longdata
)

simulate_two_traits <- function(Nfam=300)
{
  VA <- matrix(c(.4,.2,.2,.3),2)
  VC <- matrix(c(.2,.1,.1,.2),2)
  VD <- matrix(c(.2,.05,.05,.2),2)
  VE <- matrix(c(.2,.05,.05,.3),2)

  fams <- list()

  for(f in 1:Nfam)
  {
    nchild <- sample(1:3,1)

    Afam <- MASS::mvrnorm(1,c(0,0),VA)
    Cfam <- MASS::mvrnorm(1,c(0,0),VC)
    Dsib <- MASS::mvrnorm(1,c(0,0),VD)

    add_person <- function(role)
    {
      Acoef <- ifelse(role=="child",1,.5)
      Dcoef <- ifelse(role=="child",1,0)

      y <- Acoef*Afam + Cfam + Dcoef*Dsib +
           MASS::mvrnorm(1,c(0,0),VE)

      data.frame(familyid=f,sibshipid=f,role=role,
                 BMI=y[1],BP=y[2],
                 age=rnorm(1,50,10),
                 sex=rbinom(1,1,.5))
    }

    fams[[f]] <- rbind(
      add_person("mother"),
      add_person("father"),
      do.call(rbind,lapply(1:nchild,function(x)add_person("child")))
    )
  }

  do.call(rbind,fams)
}

dat <- simulate_two_traits()
longdata <- stack_traits(dat, c("BMI","BP"))

vc <- VarCorr(fit_multi)

# pull A covariance block manually
# then compute:
rg <- CovA12 / sqrt(VA1 * VA2)

extract_ACDE_matrices <- function(fit, traits)
{
  vc <- VarCorr(fit)
  vc <- as.data.frame(vc)

  # grab all variances/covariances in order
  vals <- as.numeric(vc$Variance[!is.na(vc$Variance)])

  p <- length(traits)
  block_size <- p*(p+1)/2

  # split into blocks
  A_vals <- vals[1:block_size]
  C_vals <- vals[(block_size+1):(2*block_size)]
  D_vals <- vals[(2*block_size+1):(3*block_size)]
  E_vals <- vals[(3*block_size+1):(4*block_size)]

  make_matrix <- function(x)
  {
    M <- matrix(0,p,p)
    M[lower.tri(M,diag=TRUE)] <- x
    M[upper.tri(M)] <- t(M)[upper.tri(M)]
    M
  }

  list(
    A = make_matrix(A_vals),
    C = make_matrix(C_vals),
    D = make_matrix(D_vals),
    E = make_matrix(E_vals)
  )
}

derive_genetic_results <- function(mats)
{
  A <- mats$A
  C <- mats$C
  D <- mats$D
  E <- mats$E

  P <- A + C + D + E   # phenotypic covariance

  # heritabilities per trait
  h2 <- diag(A) / diag(P)
  c2 <- diag(C) / diag(P)
  d2 <- diag(D) / diag(P)
  e2 <- diag(E) / diag(P)

  # correlation helper
  cor_from_cov <- function(M)
  {
    D <- sqrt(diag(M))
    M / outer(D,D)
  }

  list(
    Sigma_A = A,
    Sigma_C = C,
    Sigma_D = D,
    Sigma_E = E,
    Sigma_P = P,

    h2 = h2,
    c2 = c2,
    d2 = d2,
    e2 = e2,

    rG = cor_from_cov(A),
    rC = cor_from_cov(C),
    rD = cor_from_cov(D),
    rE = cor_from_cov(E),
    rP = cor_from_cov(P)
  )
}

summarise_ACDE <- function(fit, traits)
{
  mats <- extract_ACDE_matrices(fit, traits)
  derive_genetic_results(mats)
}

results <- summarise_ACDE(fit_multi, c("BMI","BP"))

###

family_model_ACDE <- function(formula, data)
{
  require(nlme)

  # --- Construct coefficients describing genetic sharing ---
  # var1 = parent-offspring indicator (0/1)
  # var2 = grandparent indicator (0/1)
  # var3 = sibling indicator (0/1)

  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Ccoef <- 1
  data$Dcoef <- data$var3

  # unique individual id (required by nlme)
  data$indid <- 1:nrow(data)

  # --- Random effects structure ---
  rand <- list(
    familyid  = pdDiag(~ Acoef + Ccoef - 1),  # A and C at family level
    sibshipid = pdDiag(~ Dcoef - 1)           # D at sibship level
  )

  fit <- lme(
    fixed   = formula,
    random  = rand,
    data    = data,
    method  = "ML",
    control = lmeControl(opt = "optim")
  )

  return(fit)
}

extract_vc_ACDE <- function(fit)
{
  vc <- VarCorr(fit)

  # Extract variance components
  sigma_A <- as.numeric(vc["Acoef","Variance"])
  sigma_C <- as.numeric(vc["Ccoef","Variance"])
  sigma_D <- as.numeric(vc["Dcoef","Variance"])
  sigma_E <- as.numeric(vc["Residual","Variance"])

  total <- sigma_A + sigma_C + sigma_D + sigma_E

  out <- data.frame(
    Component = c("A","C","D","E"),
    Variance  = c(sigma_A, sigma_C, sigma_D, sigma_E),
    Proportion = c(sigma_A, sigma_C, sigma_D, sigma_E)/total
  )

  return(out)
}

set.seed(123)

n_fam  <- 200
n_sib  <- 2          # two siblings per family
N      <- n_fam * n_sib

familyid  <- rep(1:n_fam, each=n_sib)
sibshipid <- familyid

# Relationship indicators
var1 <- 0                  # parent-offspring not used here
var2 <- 0
var3 <- rep(1, N)          # siblings

# True variance components
VA <- 0.4
VC <- 0.2
VD <- 0.2
VE <- 0.2

# Random effects
A_fam <- rnorm(n_fam, 0, sqrt(VA))
C_fam <- rnorm(n_fam, 0, sqrt(VC))
D_sib <- rnorm(n_fam, 0, sqrt(VD))
E     <- rnorm(N, 0, sqrt(VE))

# Phenotype
y <- A_fam[familyid] + C_fam[familyid] + D_sib[sibshipid] + E

dat <- data.frame(
  y, familyid, sibshipid,
  var1, var2, var3
)

fit <- family_model_ACDE(y ~ 1, dat)

summary(fit)
extract_vc_ACDE(fit)

###

family_model <- function(formula, data,
                         type = c("AE","ACE","ADE","ACDE"))
{
  require(nlme)
  type <- match.arg(type)

  # Genetic relationship coefficients
  data$Acoef <- 0.5*data$var1 + 0.5*data$var2 + 1*data$var3
  data$Ccoef <- 1
  data$Dcoef <- data$var3
  data$indid <- 1:nrow(data)

  # Random structures for each model
  if(type=="AE")
    rand <- list(familyid=pdDiag(~Acoef-1))

  if(type=="ACE")
    rand <- list(familyid=pdDiag(~Acoef + Ccoef -1))

  if(type=="ADE")
    rand <- list(
      familyid  = pdDiag(~Acoef -1),
      sibshipid = pdDiag(~Dcoef -1))

  if(type=="ACDE")
    rand <- list(
      familyid  = pdDiag(~Acoef + Ccoef -1),
      sibshipid = pdDiag(~Dcoef -1))

  fit <- lme(
    fixed   = formula,
    random  = rand,
    data    = data,
    method  = "ML",   # ML required for model comparison
    control = lmeControl(opt="optim")
  )

  return(fit)
}

extract_vc <- function(fit)
{
  vc <- VarCorr(fit)
  rows <- rownames(vc)

  getvar <- function(name){
    if(name %in% rows)
      return(as.numeric(vc[name,"Variance"]))
    else
      return(0)
  }

  sigma_A <- getvar("Acoef")
  sigma_C <- getvar("Ccoef")
  sigma_D <- getvar("Dcoef")
  sigma_E <- getvar("Residual")

  total <- sigma_A + sigma_C + sigma_D + sigma_E

  data.frame(
    Component = c("A","C","D","E"),
    Variance  = c(sigma_A, sigma_C, sigma_D, sigma_E),
    Proportion = c(sigma_A, sigma_C, sigma_D, sigma_E)/total
  )
}

fit_all_models <- function(formula, data)
{
  fits <- list(
    AE   = family_model(formula, data, "AE"),
    ACE  = family_model(formula, data, "ACE"),
    ADE  = family_model(formula, data, "ADE"),
    ACDE = family_model(formula, data, "ACDE")
  )
  return(fits)
}

compare_models <- function(fits)
{
  AICtab <- sapply(fits, AIC)

  cat("\nAIC comparison:\n")
  print(sort(AICtab))

  cat("\nLikelihood ratio tests vs ACDE:\n")

  anova(fits$AE,   fits$ACDE)
  anova(fits$ACE,  fits$ACDE)
  anova(fits$ADE,  fits$ACDE)
}

# Fit all models
fits <- fit_all_models(y ~ 1, dat)

# Compare models
compare_models(fits)

# Variance components of best model
extract_vc(fits$ACDE)

fits <- fit_all_models(y ~ sex + age + SES, dat)

test_power_once <- function(n_fam, VA, VC, VD, VE) {
  
  dat <- simulate_ACDE_data(n_fam, VA, VC, VD, VE)
  fits <- fit_all_models(y ~ 1, dat)
  
  # Likelihood ratio tests
  LRT_C <- 2*(logLik(fits$ACE) - logLik(fits$AE))
  LRT_D <- 2*(logLik(fits$ACDE) - logLik(fits$ACE))
  
  pC <- pchisq(LRT_C, df=1, lower.tail=FALSE)
  pD <- pchisq(LRT_D, df=1, lower.tail=FALSE)
  
  c(detect_C = pC < 0.05,
    detect_D = pD < 0.05)
}

estimate_power <- function(n_fam, nsim=200,
                           VA=0.4, VC=0.2, VD=0.2, VE=0.2) {
  
  results <- replicate(nsim,
                       test_power_once(n_fam,VA,VC,VD,VE))
  
  power_C <- mean(results["detect_C",])
  power_D <- mean(results["detect_D",])
  
  c(power_C=power_C, power_D=power_D)
}

sizes <- c(200,400,600,800,1000)

power_results <- sapply(sizes, estimate_power)
t(power_results)
