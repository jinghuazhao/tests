options(width = 200)
rm(list = ls())

# Liftover function
liftover <- function(chr_start_end_snpid) {
  HPC_WORK <- Sys.getenv("HPC_WORK")
  f <- file.path(HPC_WORK, "bin", "hg19ToHg38.over.chain")
  chain <- rtracklayer::import.chain(f)
  
  require(GenomicRanges)
  
  gr <- with(chr_start_end_snpid, {
    GRanges(seqnames = chr, 
            ranges = IRanges(start, end), 
            snpid = snpid)  # Include snpid as metadata
  })
  
  seqlevelsStyle(gr) <- "UCSC"
  
  gr38 <- rtracklayer::liftOver(gr, chain)
  
  # Check if liftover was successful
  if (all(is.na(gr38$seqnames))) {
    warning("Liftover failed for some SNPs.")
  }
  
  return(gr38)
}

# Example usage
# You can pass a data frame with columns chr, start, end, snpid to the liftover function
chr_start_end_snpid <- data.frame(
  chr = c("chr1", "chr2", "chr3"),
  start = c(67092164, 133429360, 134204565),
  end = c(67208778, 134275097, 134280377),
  snpid = c("1:66999043-67208778", "2:133429360-134275097", "3:134204565-134280377")
)

ld38 <- liftover(chr_start_end_snpid)

# Display the lifted-over data
print(ld38)
