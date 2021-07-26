#!/usr/bin/bash

if [ ! -d circos ]; then mkdir circos; fi

for prefix in e p
do
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTLs.csv > circos/${prefix}QTLs.txt
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTL_labels.csv > circos/${prefix}QTL_labels.txt
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTL_colors.csv > circos/${prefix}QTL_colors.txt
done
