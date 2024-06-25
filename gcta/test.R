# 26-10-2015 MRC-Epid JHZ

library(gap)
phen <- read.table("test.phen",as.is=TRUE,col.names=c("id","id1","y"),header=FALSE)
cvar <- read.table("test.covar",as.is=TRUE,col.names=c("id","id1","sex"),header=FALSE)
test <- merge(phen,cvar,by=c("id","id1"),sort=FALSE)
t <- ReadGRMBin("test",TRUE)
with(t,{
  G <<- GRM
  GE <<- with(test,outer(sex-1,sex-1)*G)
  WriteGRMBin("test_G",grm,N,id)
  WriteGRMBin("test_GE",GE[upper.tri(GE,TRUE)],N,id)
})

library(regress)
N <- dim(G)[1]
d <- diag(0.5,N)
r <- regress(y~1,~G,data=test)
with(r,h2G(sigma,sigma.cov))
s <- regress(y~1,~GE,data=test)
with(s,h2G(sigma,sigma.cov))
sr <- regress(y~sex,~G+GE,data=test)
with(sr,h2GE(sigma,sigma.cov))

library(coxme)
l <- lmekin(y~sex+(1|id),varlist=list(G+d,GE+d),data=test,method="REML")
l
testGRM <- ReadGRM("test")
sum(G-testGRM$GRM)
save(r,sr,l,file="test.rda")

q('no')

p <- ReadGRMPLINK("plink")
with(p, {
  id <- phen[,c("id","id1")]
  N <- 3925
  M <- rep(1000,N*(N+1)/2)
  WriteGRM("gap",id,M,PIHAT)
})

lds_seg = read.table("test.mrsq.ld",header=T,colClasses=c("character",rep("numeric",7)))
quartiles=summary(lds_seg$mean_lds)

lb1 = which(lds_seg$ldscore_region <= quartiles[2])
lb2 = which(lds_seg$ldscore_region > quartiles[2] & lds_seg$ldscore_region <= quartiles[3])
lb3 = which(lds_seg$ldscore_region > quartiles[3] & lds_seg$ldscore_region <= quartiles[5])
lb4 = which(lds_seg$ldscore_region > quartiles[5])

lb1_snp = lds_seg$SNP[lb1]
lb2_snp = lds_seg$SNP[lb2]
lb3_snp = lds_seg$SNP[lb3]
lb4_snp = lds_seg$SNP[lb4]

write.table(lb1_snp, "snp_group1.txt", row.names=F, quote=F, col.names=F)
write.table(lb2_snp, "snp_group2.txt", row.names=F, quote=F, col.names=F)
write.table(lb3_snp, "snp_group3.txt", row.names=F, quote=F, col.names=F)
write.table(lb4_snp, "snp_group4.txt", row.names=F, quote=F, col.names=F)
