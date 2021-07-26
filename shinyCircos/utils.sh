#!/usr/bin/bash

for prefix in e p
do
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTLs.csv > ${prefix}QTLs.txt
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTL_labels.csv > ${prefix}QTL_labels.txt
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTL_colors.csv > ${prefix}QTL_colors.txt
done
