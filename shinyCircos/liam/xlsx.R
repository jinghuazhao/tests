library(openxlsx)

xlsx <- dir(".","xlsx$")
for (filespec in setdiff(xlsx,c("eQTL_results.xlsx","pQTL_results.xlsx")))
{
  f <- gsub(".xlsx","",filespec)
  sheet1 <- read.xlsx(filespec,sheet=1,colNames=TRUE,skipEmptyRows=TRUE)
  write.csv(sheet1,file=paste0(f,".csv"),quote=FALSE,row.names=FALSE)
}

