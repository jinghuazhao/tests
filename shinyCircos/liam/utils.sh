#!/usr/bin/bash

if [ ! -d circos ]; then mkdir circos; fi

function ep()
{
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
}

export circos=${HPC_WORK}/circos-0.69-9/tests
export tests=${HOME}/tests
function by_group()
{
  for category in approved_drugs_ clinical_phase_ not_druggable_ preclinical_ predicted_druggable_
  do
    echo ${category}circos
    for ep in e p
    do
      export prefix=${category}${ep}
      sed '1d;s/chr/hs/;s/,/ /g' ${prefix}qtl_results.csv | awk '{print $1,$2,$2,$3}' > ${circos}/${prefix}QTLs.txt
      awk -v FS="," '$4!="NA" && $5!="NA"' ${prefix}qtl_results.csv | \
      awk -v FS="," '{
         colors[1]="vdred"
         colors[2]="vdblue"
         colors[3]="vdgreen"
         colors[4]="vdorange"
         colors[5]="vdpurple"
         sub(/chr/,"hs",$1)
         if (ENVIRON["prefix"]=="e") label=$4; else label=$4 "----"
         if (NR>1) print $1,$2,$2,label,"color=" colors[$5]
      }' | \
      sort -k1,1 > ${circos}/${prefix}QTL_labels.txt
    done
    sed -i 's/-//' ${circos}/${category}pQTLs.txt
    sed "s/eQTLs.txt/${category}eQTLs.txt/;s/pQTLs.txt/${category}pQTLs.txt/" ${tests}/work/circos/circos.conf > ${circos}/${category}circos.conf
    sed -i "s/eQTL_labels.txt/${category}eQTL_labels.txt/;s/pQTL_labels.txt/${category}pQTL_labels.txt/" ${circos}/${category}circos.conf
    cd ${circos}
    ../bin/circos -conf ${circos}/${category}circos.conf -debug_group summary,timer > ${category}circos.out
    mv circos.png ${category}circos.png
    mv circos.svg ${category}circos.svg
    cd -
  done
}

by_group
