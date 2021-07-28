# 13-10-2019 JHZ

tbl <- read.delim("tbl",as.is=TRUE)
all <- read.delim("all",as.is=TRUE)
rsid <- read.delim("rsid",as.is=TRUE)
save(tbl,all,rsid,file="anca.rda",version=2)

library(gap)
load("anca.rda")
METAL_forestplot(tbl,all,rsid,width=8.75,height=5)
