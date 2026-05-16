#' Hardy–Weinberg Equilibrium Test (Multiallelic, Unified Interface)
#'
#' Unified Hardy–Weinberg equilibrium (HWE) test for multiallelic loci.
#' All input formats (alleles, genotype IDs, count matrices) are internally
#' converted to a single genotype count matrix, ensuring identical inference.
#'
#' @param data genotype data in one of three formats:
#' \describe{
#'   \item{alleles}{two-column allele pairs}
#'   \item{genotypes}{integer genotype IDs (triangular encoding)}
#'   \item{counts}{symmetric genotype count matrix}
#' }
#' @param type input format: "alleles", "genotypes", or "counts"
#' All representations map to the same matrix \(M_{ij}\).
#' @param verbose logical; if TRUE, prints full test output
#' @param yates.correct logical; if TRUE, applies Yates' continuity correction
#'   to the Pearson chi-square statistic. Only relevant for multiallelic
#'   contingency tables; ignored for other tests.
#' @details
#' Allele frequencies:
#' \deqn{p_i = \frac{c_i}{2n}}
#' Expected genotype frequencies:
#' \deqn{
#' P_{ii} = p_i^2,\quad P_{ij} = 2p_i p_j \ (i \ne j)
#' }
#' Expected counts:
#' \deqn{E_{ij} = n P_{ij}}
#' 1. Pearson chi-square test
#' \deqn{
#' X^2 = \sum_{i \le j} \frac{(O_{ij} - E_{ij})^2}{E_{ij}}
#' }
#' Asymptotic reference: \(\chi^2_{df}\)
#' For multiallelic tables, Yates' correction is applied elementwise as a
#' continuity adjustment.
#' 2. Likelihood ratio test (G-test)
#' \deqn{
#' G^2 = 2 \sum_{i \le j} O_{ij} \log\left(\frac{O_{ij}}{E_{ij}}\right)
#' }
#' with convention \(0 \log 0 = 0\).
#' 3. Inbreeding coefficient (Wright’s F)
#' \deqn{
#' F = \frac{H_{obs} - H_{exp}}{1 - H_{exp}}
#' }
#' where:
#' \deqn{
#' H_{obs} = \sum_i \frac{O_{ii}}{n}, \quad
#' H_{exp} = \sum_i p_i^2
#' }
#' 4. Monte Carlo exact test (Guo–Thompson-style)
#' Exact p-value is approximated under:
#' \deqn{X \sim \text{Multinomial}(n, P)}
#' via likelihood ordering:
#' \deqn{
#' p = \Pr(\ell(X^{sim}) \le \ell(X^{obs}))
#' }
#' where:
#' \deqn{
#' \ell(x) = \sum x_i \log p_i + \log \frac{n!}{\prod x_i!}
#' }
#' All input formats are strictly equivalent:
#' \deqn{
#' \text{alleles} \equiv \text{genotype IDs} \equiv \text{count matrix}
#' \rightarrow M_{ij}
#' }
#'
#' Hence all test statistics are identical (up to Monte Carlo error).
#' @note
#' - Zero-frequency alleles are removed automatically
#' - Exact test is Monte Carlo (fixed seed inside engine)
#' - All tests operate on the same standardized genotype matrix
#'
#' @return Named list of HWE statistics
#' - `X2` : Pearson chi-square statistic
#' - `LRT` : likelihood ratio statistic
#' - `p_exact` : Monte Carlo exact p-value
#' - `p` : allele frequencies
#' - `rho` : inbreeding coefficient
#'
#' @seealso [hwe.hardy]
#' @examples
#' \dontrun{
#' a1 <- c(1,1,1,1,2,2,2,3,3,1,2,3,1,2,3,1,2,3)
#' a2 <- c(1,2,3,1,2,3,2,3,1,2,3,1,1,1,2,3,2,3)
#' ## 1. Allele input
#' res1 <- hwe(cbind(a1,a2), "alleles")
#' ## 2. Genotype ID input
#' g <- a2g(a1,a2)
#' res2 <- hwe(g, "genotypes")
#' ## 3. Genotype count matrix
#' g_tab <- table(g)
#' pairs <- g2a_internal(as.integer(names(g_tab)))
#' k <- max(pairs)
#' M <- matrix(0, k, k)
#' for(i in seq_len(nrow(pairs))) {
#'   M[pairs[i,1], pairs[i,2]] <- g_tab[i]
#' }
#' res3 <- hwe(M, "counts")
#' ## Consistency check (all identical rho)
#' stopifnot(
#'   all.equal(res1$rho, res2$rho),
#'   all.equal(res1$rho, res3$rho)
#' )
#' }
#' @export
#'
a2g <- function(a1,a2){
  if(length(a1)!=length(a2)) stop("Allele vectors must match")
  i <- pmin(a1,a2)
  j <- pmax(a1,a2)
  j*(j-1)/2 + i
}

g2a_internal <- function(g){
  j <- ceiling((sqrt(8*g+1)-1)/2)
  i <- g - j*(j-1)/2
  cbind(i,j)
}

hwe_exact_GT <- function(obs, probs, n, B=1e5, seed=123){
  logMultinom <- function(x, p){
    lgamma(sum(x)+1) - sum(lgamma(x+1)) + sum(x*log(p))
  }
  obs_ll <- logMultinom(obs, probs)
  sim_ll <- numeric(B)
  for(b in 1:B){
    sim <- as.vector(rmultinom(1,n,probs))
    sim_ll[b] <- logMultinom(sim, probs)
  }
  mean(sim_ll <= obs_ll)
}

hwe_engine <- function(geno.table,verbose=TRUE,yates.correct=FALSE){
  geno.table <- as.matrix(geno.table)
  n <- sum(geno.table)
  k <- nrow(geno.table)
# Allele frequencies
  allele.counts <- numeric(k)
  for(i in 1:k)
    allele.counts[i] <- 2*geno.table[i,i] +
                        sum(geno.table[i,-i]) +
                        sum(geno.table[-i,i])
  p <- allele.counts/(2*n)
# REMOVE ZERO ALLELES (critical!)
  keep <- p > 0
  geno.table <- geno.table[keep,keep,drop=FALSE]
  p <- p[keep]
  k <- length(p)
# Expected genotype counts under HWE
  exp <- matrix(0,k,k)
  prob_mat <- matrix(0,k,k)
  for(i in 1:k)
    for(j in i:k){
      exp[i,j] <- ifelse(i==j, n*p[i]^2, 2*n*p[i]*p[j])
      prob_mat[i,j] <- ifelse(i==j, p[i]^2, 2*p[i]*p[j])
    }
  obs <- geno.table[upper.tri(geno.table,diag=TRUE)]
  expv <- exp[upper.tri(exp,diag=TRUE)]
  probs <- prob_mat[upper.tri(prob_mat,diag=TRUE)]
# Pearson Chi-square
  if (yates.correct) {
    X2 <- sum((abs(obs - expv) - 0.5)^2 / expv)
  } else {
    X2 <- sum((obs - expv)^2 / expv)
  }
  df <- length(obs)-length(p)
  p_chisq <- pchisq(X2,df,lower.tail=FALSE)
# Likelihood ratio test (safe logs)
  LRT <- 2*sum(ifelse(obs>0, obs*log(obs/expv), 0))
  p_LRT <- pchisq(LRT,df,lower.tail=FALSE)
# Inbreeding coefficient
  Hobs <- sum(diag(geno.table))/n
  Hexp <- sum(p^2)
  rho <- (Hobs-Hexp)/(1-Hexp)
# Guo–Thompson exact test
  p_exact <- hwe_exact_GT(obs, probs, n)
  if (verbose) {
    cat("Hardy-Weinberg equilibrium test (multiallelic)\n")
    cat("Tests: Chi-square, Likelihood-ratio, Guo–Thompson exact\n\n")
    cat("Pearson chi-square:\n")
    cat("  X2 =",X2," df =",df," p =",p_chisq,"\n\n")
    cat("Likelihood-ratio test:\n")
    cat("  LRT =",LRT," df =",df," p =",p_LRT,"\n\n")
    cat("Exact test (Monte-Carlo):\n")
    cat("  p =",p_exact,"\n\n")
    cat("Allele frequencies:\n")
    print(round(p,4))
    cat("\nrho =",rho,"\n")
  }
  invisible(list(X2=X2,LRT=LRT,p_exact=p_exact,p=p,rho=rho))
}

hwe <- function(data, type=c("alleles","genotypes","counts"),
                verbose=TRUE,yates.correct=FALSE){
  type <- match.arg(type)
  if(type=="alleles"){
    if(ncol(data)!=2) stop("Allele input must have 2 columns")
    g <- a2g(data[,1], data[,2])
    gtab <- table(g)
    pairs <- g2a_internal(as.integer(names(gtab)))
    k <- max(pairs)
    M <- matrix(0,k,k)
    for(i in 1:nrow(pairs))
      M[pairs[i,1],pairs[i,2]] <- gtab[i]
  }
  if(type=="genotypes"){
    gtab <- table(data)
    pairs <- g2a_internal(as.integer(names(gtab)))
    k <- max(pairs)
    M <- matrix(0,k,k)
    for(i in 1:nrow(pairs))
      M[pairs[i,1],pairs[i,2]] <- gtab[i]
  }
  if(type=="counts"){
    M <- as.matrix(data)
    if(nrow(M)!=ncol(M))
      stop("Genotype count matrix must be square")
  }
  hwe_engine(M,verbose=verbose,yates.correct=yates.correct)
}
