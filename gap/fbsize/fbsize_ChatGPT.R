#' Sample size for family-based linkage and association design
#'
#' @param gamma genotype relative risk assuming multiplicative model.
#' @param p frequency of disease allele.
#' @param alpha Type I error rates for ASP linkage, TDT and ASP-TDT.
#' @param beta Type II error rate.
#' @param debug verbose output.
#' @param error 0=use the correct formula,1=the original paper.
#'
#' @details
#' This function implements Risch and Merikangas (1996) statistics
#' evaluating power for family-based linkage (affected sib pairs, ASP) and
#' association design. They are potentially useful in the prospect of
#' genome-wide association studies.
#'
#' The function calls auxiliary functions sn() and strlen; `sn()`
#' contains the necessary thresholds for power calculation while
#' `strlen()` evaluates length of a string (generic).
#'
#' @export
#' @return
#' The returned value is a list containing:
#' - gamma input gamma.
#' - p input p.
#' - n1 sample size for ASP.
#' - n2 sample size for TDT.
#' - n3 sample size for ASP-TDT.
#' - lambdao lambda o.
#' - lambdas lambda s.
#'
#' @references
#' \insertAllCited{}
#' \insertRef{risch96}{gap}\insertRef{risch97}{gap}\insertRef{scott97}{gap}
#'
#' @seealso [`pbsize`]
#'
#' @examples
#' kp <- c(0.01,0.05,0.10,0.2)
#' models <- matrix(c(
#'     4.0, 0.01,
#'     4.0, 0.10,
#'     4.0, 0.50,
#'     4.0, 0.80,
#'     2.0, 0.01,
#'     2.0, 0.10,
#'     2.0, 0.50,
#'     2.0, 0.80,
#'     1.5, 0.01,
#'     1.5, 0.10,
#'     1.5, 0.50,
#'     1.5, 0.80), ncol=2, byrow=TRUE)
#' outfile <- "fbsize.txt"
#' cat("gamma","p","Y","N_asp","P_A","H1","N_tdt","H2","N_asp/tdt","L_o","L_s\n",sep="\t",file=outfile)
#' for(i in 1:dim(models)[1])
#' {
#'   g <- models[i,1]
#'   p <- models[i,2]
#'   n <- fbsize(g,p)
#'   cat(n$gamma,n$p,n$y,n$n1,n$pA,n$h1,n$n2,n$h2,n$n3,n$lambdao,n$lambdas,
#'       sep="\t",file=outfile,append=TRUE)
#'   cat("\n",file=outfile,append=TRUE)
#' }
#' table1 <- read.table(outfile,header=TRUE,sep="\t")
#' nc <- c(4,7,9)
#' table1[,nc] <- ceiling(table1[,nc])
#' dc <- c(3,5,6,8,10,11)
#' table1[,dc] <- round(table1[,dc],2)
#' unlink(outfile)
#'
#' # Alzheimer's disease
#' g <- 4.5
#' p <- 0.15
#' cat("\nAlzheimer's:\n\n")
#' fbsize(g,p)
#'
#' @author Jing Hua Zhao
#' @note extracted from rm.c.
#' @keywords misc

fbsize <- function (gamma,p,alpha=c(1e-4,1e-8,1e-8),beta=0.2,debug=0,error=0)
{
  ## -----------------------------
  ## Minimal input validation (safe add-on)
  ## -----------------------------
  if (!is.finite(gamma) || !is.finite(p) ||
      any(!is.finite(alpha)) || !is.finite(beta)) stop("invalid input")

  if (gamma <= 0) stop("invalid gamma")
  if (p <= 0 || p >= 1) stop("invalid p")
  if (any(alpha <= 0 | alpha >= 1)) stop("invalid alpha")
  if (beta <= 0 || beta >= 1) stop("invalid beta")

  sn <- function (all,alpha,beta,op)
  {
    m <- all[1]
    v <- all[2]

    if (!is.finite(m) || !is.finite(v) || v < 0) {
      warning("fbsize: unstable sn() inputs")
      return(NA_real_)
    }

    z1beta <- qnorm(beta)
    zalpha <- -qnorm(alpha)

    s <- ((zalpha - sqrt(v) * z1beta) / m)^2 / 2

    if (!is.finite(s) || s <= 0) {
      warning("fbsize: unstable intermediate calculation in sn()")
      return(NA_real_)
    }

    if (op == 3) s <- s / 2
    s
  }

  q <- 1 - p

  denom_gp <- p * gamma + q
  if (!is.finite(denom_gp) || abs(denom_gp) < .Machine$double.eps) {
    warning("fbsize: numerical instability in p*gamma+q")
    return(list(gamma=gamma,p=p,n1=NA,n2=NA,n3=NA))
  }

  k <- denom_gp^2

  va <- 2*p*q*((gamma-1)*denom_gp)^2
  vd <- (p*q*(gamma-1)^2)^2

  w <- p*q*(gamma-1)^2/k
  if (!is.finite(w) || w < 0) {
    warning("fbsize: unstable w")
    return(list(gamma=gamma,p=p,n1=NA,n2=NA,n3=NA))
  }

  y <- (1+w)/(2+w)

  lambdas <- (1+0.5*w)^2
  lambdao <- 1+w

  h <- h1 <- p*q*(gamma+1)/denom_gp
  pA <- gamma/(gamma+1)

  ## ASP
  nl.m <- 0
  nl.v <- 1
  aa.m <- 2*y-1
  if (error==1) aa.v <- 0 else aa.v <- 4*y*(1-y)
  aa <- c(aa.m,aa.v)
  n1 <- sn(aa,alpha[1],beta,1)

  ## TDT
  aa.m <- sqrt(h)*(gamma-1)/(gamma+1)
  aa.v <- 1-h*((gamma-1)/(gamma+1))^2
  aa <- c(aa.m,aa.v)
  n2 <- sn(aa,alpha[2],beta,2)

  ## ASP-TDT
  h <- h2 <- p*q*(gamma+1)^2/(2*(p*gamma+q)^2+p*q*(gamma-1)^2)
  aa.m <- sqrt(h)*(gamma-1)/(gamma+1)
  aa.v <- 1-h*((gamma-1)/(gamma+1))^2
  aa <- c(aa.m,aa.v)
  n3 <- sn(aa,alpha[3],beta,3)

  if (debug==1)
  {
    cat("K=",k,"VA=",va,"VD=",vd,"\n")
    cat("n1=",ceiling(n1),"n2=",ceiling(n2),"n3=",ceiling(n3),"\n")
  }

  list(gamma=gamma,p=p,y=y,n1=n1,pA=pA,h1=h1,n2=n2,h2=h2,n3=n3,
       lambdao=lambdao,lambdas=lambdas)
}
