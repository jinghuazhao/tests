options(width=2000)

# shinyCircos: https://venyao.xyz/shinyCircos/ (https://yimingyu.shinyapps.io/shinycircos/)

# Chromosome data: TSS_start has 0 start/hg38/autosomes, so we use as follows.
cat("chr,start,end\n",file="hg38.csv")
for(i in 1:22) cat(paste0("chr",xy(i)),1,paste0(gap::hg19[i],"\n"),sep=",",file="hg38.csv",append=TRUE)
HOME <- Sys.getenv("HOME")
data_prep <- function(prefix)
# QTLs, their labels and colors; chr:pos duplicates were dropped except those with the smallest p values (reasonable?)
{
  file <- file.path(HOME,"R","work",paste0(prefix,"QTL_results.xlsx"))
  xlsx <- read.xlsx(file,sheet=1,colNames=TRUE,skipEmptyRows=TRUE)
  QTLs <- xlsx %>%
          mutate(start=TSS_start,end=TSS_start+1,value=-log10(pval), color=letters[druggability_category]) %>%
          filter(!is.na(start+value)) %>%
          distinct() %>%
          group_by(chr,start,label) %>%
          slice_min(value) %>%
          select(chr,start,end,value,label,color)
  if(prefix=="p") QTLs <- within(QTLs,{value <- -value})
  annotated <- filter(QTLs, label!="")
  write.csv(xlsx,file=paste0(prefix,"QTL_xlsx.csv"),row.names=FALSE,quote=FALSE)
  write.csv(QTLs[c("chr","start","end","value")],file=paste0(prefix,"QTLs.csv"),row.names=FALSE,quote=FALSE)
  write.csv(select(annotated,-value,-color),file=paste0(prefix,"QTL_labels.csv"),row.names=FALSE,quote=FALSE)
  write.csv(select(annotated,-value,-label),file=paste0(prefix,"QTL_colors.csv"),row.names=FALSE,quote=FALSE)
  invisible(list(file=file,xlsx=xlsx,QTLs=QTLs,annotated=annotated))
}
require(openxlsx)
require(dplyr)
p <- data_prep("p")
e <- data_prep("e")
