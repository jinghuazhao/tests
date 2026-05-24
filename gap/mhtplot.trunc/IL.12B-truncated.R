load("~/tests/gap/mhtplot.trunc/IL.12B-truncated.rda")
source("gap/R/mhtplot.trunc.R")
hl <- c("BHLHE40", "LPP", "IL12B", "MHC", "SH2B3;TRAFD1", "FLT3", "RAD51B", "TRAF3")
dat <- IL.12B_truncated
dat <- dat[order(dat$Chromosome, dat$Position), ]
Cairo::CairoPNG("IL-12B_mhtplot.trunc.png", width = 9, height = 6, units = "in", dpi = 300)
screen_like <- TRUE
cex.scale <- if (screen_like) 0.85 else 1
space.scale <- if (screen_like) 0.85 else 1
par(mar = c(5, 6.5, 1, 1),cex = cex.scale)
d <- mhtplot.trunc(
  dat,
  chr = "Chromosome",
  bp = "Position",
  log10p = "log10P",
  snp = "MarkerName",
  highlight = hl,
  suggestiveline = FALSE,
  genomewideline = -log10(5e-8),
  annotateTop = FALSE,
  annotatelog10P = Inf,
  y.brk1 = 115,
  y.brk2 = 300,
  trunc.yaxis = TRUE,
  cex.axis = 1.1 * cex.scale,
  cex = 0.75 * cex.scale,
  cex.text = 0.85 * cex.scale,
  y.ax.space = 35 * space.scale,
  col = c("blue4", "skyblue")
)
hl.df <- d[d$SNP %in% hl, ]
hl.df <- hl.df[order(hl.df$log10P, decreasing = TRUE), ]
base.space <- 0.9 * space.scale
hl.df$offset <- (seq_len(nrow(hl.df)) - 1) * base.space
if (all(c("FLT3", "TRAF3") %in% hl.df$SNP)) {
  i1 <- which(hl.df$SNP == "FLT3")
  i2 <- which(hl.df$SNP == "TRAF3")
  hl.df$offset[i2] <- hl.df$offset[i1] + 2.2 * base.space
}
text(x = hl.df$pos, y = hl.df$log10P + hl.df$offset,
  labels = hl.df$SNP, cex = 0.85 * cex.scale, font = 3, pos = 3)
dev.off()
