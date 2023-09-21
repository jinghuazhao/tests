#!/usr/bin/bash

export phenoname=IL.12B
cat <(echo chromosome position nearest_gene_name cistrans) \
    <(grep -w ${phenoname} ${INF}/work/INF1.METAL | sort -k4,4n -k5,5n | awk '{print $4,$5,$3,$21}') | \
Rscript -e 'IL.12B <- read.table("stdin",header=TRUE);
            IL.12B["nearest_gene_name"] <- c("BHLHE40","LPP","IL12B","MHC","SH2B3;TRAFD1","FLT3","RAD51B","TRAF3");
            write.table(IL.12B,quote=FALSE,row.names=FALSE)' \
    > ${phenoname}.annotate
gunzip -c ${INF}/METAL/${phenoname}-1.tbl.gz | \
awk '{if (NR==1) print "chromsome","position","log_pvalue","beta","se"; else print $1,$2,-$12,$10,$11}' | \
gzip -f > ${phenoname}.txt.gz

R --slave --vanilla --args \
  input_data_path=${phenoname}.txt.gz \
  output_data_rootname=IL.12B \
  custom_peak_annotation_file_path=${phenoname}.annotate \
  reference_file_path=turboman_hg19_reference_data.rda \
  pvalue_sign=5e-10 \
  plot_title="${phenoname} example" < turboman.r

# 21-9-2023 JHZ
