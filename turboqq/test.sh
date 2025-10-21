# 21-10-2025 JHZ

R --no-save <<END
  require(gap.datasets)
  test <- mhtdata[c("chr","pos","p")]
  write.table(test,file="test.txt",row.names=FALSE,quote=FALSE)
END

R --slave --vanilla --args \
  input_data_path=test.txt \
  output_data_rootname=test_qq \
  plot_title="gap.datasets example" < turboqq.r
}

wget https://portals.broadinstitute.org/collaboration/giant/images/0/0f/Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz
gunzip -c ~/work/Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz | \
awk 'NR>1{print $1,$2,$9,$7,$8}' | \
sort -k1,1n -k2,2n | \
gzip -f > ~/work/yengo.txt.gz
module load ceuadmin/R
R --no-save -q <<END
   png('yengo_qq.png', height = 1800, width = 1800, pointsize = 12, res = 450)
   par(mar = c(4, 4, 3, 1))
   input_data_path <- 'yengo.txt.gz'
   plot_title <- 'Locke_et_al+UKB'
   yengo <- read.table("yengo.txt.gz")
   gap::qqunif(yengo[1:3],pch=21,col="skyblue",bg="skyblue")
 # pQTLtools::turboqq(input_data_path, plot_title)
   dev.off()
END
R --slave --vanilla --args \
  input_data_path=yengo.txt.gz \
  output_data_rootname=giant_qq \
  plot_title="Locke_et_al+UKB" < ~/cambridge-ceu/turboqq/turboqq.r
}
