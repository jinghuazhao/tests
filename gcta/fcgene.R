# 12-8-2014 MRC-Epid JHZ

frq <- read.table("test_snp.frq",header=TRUE,as.is=TRUE,row.names=NULL)
raw <- read.table("test_dose.raw",header=TRUE,as.is=TRUE,row.names=NULL)
names(raw) <- c(names(raw)[1:6],frq[,2])

library(foreign)
write.dta(raw,file="test.dta")
