#!/usr/bin/bash

if [ ! -d circos ]; then mkdir circos; fi

for prefix in e p
do
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTLs.csv > circos/${prefix}QTLs.txt
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTL_labels.csv > circos/${prefix}QTL_labels.txt
  sed '1d;s/chr/hs/;s/,/ /g' ${prefix}QTL_colors.csv > circos/${prefix}QTL_colors.txt
  (
    grep -v NA ${prefix}QTL_xlsx.csv | cut -d, -f4,5 | sed '1d;s/,/ /' | \
    while read gene category
    do
       case ${category} in
         5) color=red;;
         4) color=blue;;
         3) color=green;;
         2) color=yellow;;
         1) color=purple;;
         *) echo "nonexistent";;
       esac
       echo "<rule>"
       echo "condition = var(value) eq \"${gene}\""
       echo "color     = ${color}"
       echo "</rule>"
    done
  ) > circos/${prefix}rule.textcolor.conf
done

sed -i 's/-//' circos/pQTLs.txt
