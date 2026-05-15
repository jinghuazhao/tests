#' Sentinel identification from GWAS summary statistics
#'
#' Identify sentinel variants from genome-wide significant GWAS signals
#' using a distance-based flanking algorithm.
#'
#' @description
#' This function accepts GWAS summary statistics and identifies sentinel
#' variants in a region-based manner using a flanking window approach.
#' Extremely small P-values are handled by computing \eqn{-log10(P)} from
#' effect sizes and standard errors, or by using supplied log P values.
#'
#' The algorithm processes signals for a phenotype on a chromosome and
#' classifies sentinel variants into three types.
#'
#' @details
#' For a given phenotype and chromosome, the algorithm proceeds as follows:
#'
#' **Step 1**  
#' For a collection of genome-wide significant variants, compute the region
#' width from the minimum and maximum chromosomal positions.
#' If the width is smaller than the flanking distance, the variant with the
#' smallest P value is recorded as a *Type I sentinel*.
#'
#' **Step 2**  
#' Otherwise, generate a flanking window from the top variant.  
#' If no downstream variants exist within the flanking window, the candidate
#' is recorded as a *Type II sentinel*, and the search continues from the
#' next variant.
#'
#' **Step 3**  
#' If downstream variants exist, compare their significance to the candidate:
#' * If the candidate remains the most significant, record a *Type III sentinel*
#'   and continue after the downstream window.
#' * Otherwise, update the candidate and continue searching.
#'
#' Typical interpretation:
#' * Type I: variants in strong LD (cis region)
#' * Type II: two independent trans signals on a chromosome
#' * Type III: multiple independent trans signals
#'
#' Input data should already be filtered to genome-wide significant variants.
#'
#' @param p Data frame containing GWAS summary statistics.
#' @param pid Phenotype identifier printed in the output.
#' @param st Starting row index for recursion (normally 1).
#' @param debug Logical; print intermediate calculations.
#' @param flanking Flanking window size in base pairs (default 1 Mb).
#' @param chr Column name for chromosome.
#' @param pos Column name for genomic position.
#' @param b Column name for effect size.
#' @param se Column name for standard error.
#' @param log_p Optional column containing log10(P) (e.g. METAL LOGPVALUE).
#' @param snp Column name for variant identifier.
#' @param sep Output field delimiter.
#'
#' @return
#' The function prints sentinel variants to the console.
#' Columns printed are:
#' phenotype, SNP, region start, region end, region width,
#' \eqn{-log10(P)}, row index, sentinel type.
#'
#' @section Input requirements:
#' * Data must contain genome-wide significant variants.
#' * Data are automatically sorted by chromosome and position.
#' * If `log_p` is supplied, it must contain **log10(P)**.
#'
#' @section Downstream analysis: variance explained (h2 proxy)
#'
#' Sentinel discovery is typically followed by estimation of the variance
#' explained by genome-wide significant variants. A simple proxy can be
#' computed from GWAS summary statistics as:
#'
#' \deqn{ \chi^2/N = (Effect/StdErr)^2 / N }
#'
#' where *N* is the sample size. Summing this quantity across variants for
#' each phenotype provides an estimate of variance explained (h2 proxy).
#'
#' Example workflow:
#' \dontrun{
#' tbl <- within(OPGtbl, chi2n <- (Effect/StdErr)^2/N)
#'
#' s  <- with(tbl, aggregate(chi2n, list(prot), sum))
#' names(s) <- c("prot","h2")
#'
#' sd <- with(tbl, aggregate(chi2n, list(prot), sd))
#' names(sd) <- c("prot","sd")
#'
#' m  <- with(tbl, aggregate(chi2n, list(prot), length))
#' names(m) <- c("prot","m")
#'
#' h2 <- cbind(s, sd["sd"], m["m"])
#' }
#'
#' @examples
#' \dontrun{
#' require(gap.datasets)
#' data(OPG)
#' p <- reshape::rename(OPGtbl, c(Chromosome="Chrom", Position="End"))
#' chrs <- unique(p$Chrom)
#'
#' for(chr in chrs) {
#'   ps <- subset(p[c("Chrom","End","MarkerName","Effect","StdErr")], Chrom==chr)
#'   row.names(ps) <- 1:nrow(ps)
#'   sentinels(ps, "OPG", 1)
#' }
#' }
#'
#' @keywords utilities
#' @export
#'
sentinels <- function(p,pid,st,debug=FALSE,flanking=1e+6,
                      chr="Chrom",pos="End",b="Effect",se="StdErr",
                      log_p=NULL,snp="MarkerName",sep=",")
{
  nr <- nrow(p)
  if (st > nr) return(invisible(NULL))
  p <- p[order(p[[chr]], p[[pos]]), ]
  row.names(p) <- 1:nrow(p)
  u <- p[st:nr,]
  z <- within(u,{
    d <- c(0,diff(u[[pos]]))
    s <- cumsum(d)
    if (is.null(log_p))
      log10p <- -log10p(u[[b]]/u[[se]])   # gap::log10p()
    else
      log10p <- -u[[log_p]]               # METAL gives log10(P)
  })
  if (debug) print(z[c(chr,pos,"d","s",snp,"log10p")])
  if ((max(z[[pos]]) - min(z[[pos]])) <= flanking)
  {
    l <- head(z[[pos]],1)
    u_pos <- tail(z[[pos]],1)
    log10p1 <- max(z$log10p)
    x <- z[z$log10p==log10p1,]
    r1 <- as.numeric(row.names(x)[1])
    m  <- tail(x[[pos]],1)
    n  <- tail(x[[snp]],1)
    cat(pid,n,l,u_pos,u_pos-l,log10p1,r1,"I\n",sep=sep)
    return(invisible(NULL))
  }
  sblk <- z[z$s <= flanking,]
  l <- head(sblk[[pos]],1)
  u_pos <- tail(sblk[[pos]],1)
  log10p1 <- max(sblk$log10p)
  x <- sblk[sblk$log10p==log10p1,]
  r1 <- as.numeric(tail(row.names(x),1))
  m  <- tail(x[[pos]],1)
  n  <- tail(x[[snp]],1)
  t <- z[z[[pos]] > m & z[[pos]] <= m + flanking,]
  if (nrow(t)==0)
  {
    cat(pid,n,l,u_pos,u_pos-l,log10p1,r1,"II\n",sep=sep)
    message(paste0("No variants +1 MB downstream so move to next block (",pid,")"))
    sentinels(p,pid,r1+1,debug,flanking,chr,pos,b,se,log_p,snp,sep)
    return(invisible(NULL))
  }
  log10p2 <- max(t$log10p)
  y <- t[t$log10p==log10p2,]
  u2 <- tail(t[[pos]],1)
  r2 <- as.numeric(tail(row.names(t),1))
  if (log10p1 > log10p2)
  {
    cat(pid,n,l,u2,u2-l,log10p1,r1,"III\n",sep=sep)
    if (r2 < nr)
      sentinels(p,pid,r2+1,debug,flanking,chr,pos,b,se,log_p,snp,sep)
  }
  else
  {
    r2 <- as.numeric(tail(row.names(y),1))
    if (r2 < nr)
      sentinels(p,pid,r2,debug,flanking,chr,pos,b,se,log_p,snp,sep)
  }
}
