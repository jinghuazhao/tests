options(width = 120)
## GIANT BMI meta-analysis
## https://portals.broadinstitute.org/collaboration/
## giant/images/c/c8/Meta-analysis_Locke_et_al%2BUKBiobank_2018_UPDATED.txt.gz
gz <- gzfile("Meta-analysis_Locke_et_al+UKBiobank_2018_UPDATED.txt.gz")
BMI <- within(read.delim(gz, as.is = TRUE), {Z <- BETA / SE})
summary(BMI$P)
cat("P == 0:", sum(BMI$P == 0, na.rm = TRUE), "\n")
library(Rmpfr)
idx0 <- which(BMI$P == 0)
if (length(idx0) > 0) {
  BMI$log10P <- -log10(BMI$P)
  BMI$log10P[idx0] <- sapply(BMI$Z[idx0], function(z) {
      p <- 2 * pnorm(mpfr(abs(z), 1000), lower.tail = FALSE)
      -log10(asNumeric(p))
    }
} else {
  BMI$log10P <- -log10(BMI$P)
}
cat("Maximum -log10(P):", max(BMI$log10P, na.rm = TRUE), "\n")
cat("Variants with -log10(P) > 200:",sum(BMI$log10P > 200, na.rm = TRUE),"\n")
png("BMI_truncated.png", width = 9, height = 6, units = "in", res = 300)
par(oma = c(0,0,0,0), mar = c(5,6.5,1,1))
mhtplot.trunc(
  BMI,
  chr = "CHR",
  bp = "POS",
  log10p = "log10P",
  snp = "SNP",
  suggestiveline = FALSE,
  genomewideline = -log10(5e-8),
  highlight = c("rs1421085","rs1558902","rs17817449","rs8050136","rs9939609"),
  annotatelog10P = 250,
  annotateTop = FALSE,
  trunc.yaxis = TRUE,
  y.brk1 = 160,
  y.brk2 = 240,
  y.ax.space = 20,
  cex = 0.5,
  cex.axis = 1.2,
  cex.text = 0.8,
  cex.mtext = 1.2,
  col = c("blue4", "skyblue")
)
title("BMI GWAS truncated Manhattan plot")
dev.off()
