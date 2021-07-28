#!/usr/bin/bash

if [ ! -d circos ]; then mkdir circos; fi

for prefix in e p
do
  export prefix=${prefix}
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTLs.csv > circos/${prefix}QTLs.txt
  awk -v FS="," '$4!="NA" && $5!="NA"' ${prefix}QTL_xlsx.csv | \
  awk -v FS="," '{
     colors[1]="vdred"
     colors[2]="vdblue"
     colors[3]="vdgreen"
     colors[4]="vdorange"
     colors[5]="vdpurple"
     sub(/chr/,"hs",$1)
     if (ENVIRON["prefix"]=="e") label=$4; else label=$4 "----"
     if (NR>1) print $1,$2-1,$2,label,"color=" colors[$5]
  }' | \
  sort -k1,1 > circos/${prefix}QTL_labels.txt
done

sed -i 's/-//' circos/pQTLs.txt
