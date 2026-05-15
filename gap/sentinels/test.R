## =========================================================
## Sentinel test using OPG positive control (gap.datasets)
## =========================================================

source("sentinels.R")
source("ext.R")
log10p <- gap::log10p

require(gap.datasets)
require(reshape)

data(OPG)

## rename columns to match sentinels() defaults
p <- reshape::rename(OPGtbl, c(Chromosome="Chrom", Position="End"))

chrs <- with(p, unique(Chrom))

## ---------------------------------------------------------
## Run sentinel finder (Effect + SE mode)
## ---------------------------------------------------------
for(chr in chrs)
{
  ps <- subset(p[c("Chrom","End","MarkerName","Effect","StdErr")], Chrom==chr)
  row.names(ps) <- 1:nrow(ps)
  sentinels(ps, "OPG", 1)
}

## ---------------------------------------------------------
## Check the known sentinel SNPs
## ---------------------------------------------------------
subset(OPGrsid, MarkerName=="chr8:120081031_C_T")
subset(OPGrsid, MarkerName=="chr17:26694861_A_G")

## ---------------------------------------------------------
## Run sentinel finder using METAL LOGPVALUE mode
## ---------------------------------------------------------
p <- within(p, { logp <- log(P.value) })

for(chr in chrs)
{
  ps <- subset(p[c("Chrom","End","MarkerName","logp")], Chrom==chr)
  row.names(ps) <- 1:nrow(ps)
  sentinels(ps, "OPG", 1, log_p="logp")
}

## ---------------------------------------------------------
## Variance explained (heritability proxy)
## ---------------------------------------------------------
tbl <- within(OPGtbl, chi2n <- (Effect/StdErr)^2/N)

s  <- with(tbl, aggregate(chi2n, list(prot), sum))
names(s) <- c("prot","h2")

sd <- with(tbl, aggregate(chi2n, list(prot), sd))
names(sd) <- c("p1","sd")

m  <- with(tbl, aggregate(chi2n, list(prot), length))
names(m) <- c("p2","m")

h2 <- cbind(s,sd,m)

ord <- with(h2, order(h2))
print(h2[ord, c("prot","h2","sd","m")], row.names=FALSE)

## optional outputs from original example
write.csv(tbl,file="INF1.csv",quote=FALSE,row.names=FALSE)
