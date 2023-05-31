# 9-2-2020 JHZ

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
