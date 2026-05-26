INF <- Sys.getenv("INF")
suppressMessages(library(dplyr))
d <- file.path(INF,"mr","gsmr","trait")
inf1 <- select(gap.datasets::inf1,prot,target.short)
gsmr_efo <- read.delim(file.path(INF,"mr","gsmr","gsmr-efo.txt")) %>%
            left_join(inf1,by=c('protein'='target.short')) %>%
            mutate(file_gwas=paste(prot,id,"rsid.txt",sep="-"),
                   bfile=file.path(INF,"INTERVAL","per_chr",
                                   paste0("interval.imputed.olink.chr_",chr)),
                   proxy=NA,p_proxy=NA,rsq=NA)
proxies <- qtl_lookup(d,gsmr_efo,plink_bin="/rds/user/jhz22/hpc-work/bin/plink",
                      xlsx=file.path(INF,"mr","gsmr","r2_INTERVAL.xlsx")) %>%
           select(protein,id,Disease,fdr,pqtl,p,qtl,p_qtl,proxy,p_proxy,rsq)
write.table(proxies,file=file.path(INF,"mr","gsmr","r2_INTERVAL.tsv"),
            row.names=FALSE,quote=FALSE,sep="\t")
