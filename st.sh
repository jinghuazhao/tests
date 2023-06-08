#!/usr/bin/bash

for f in $(ls)
do
   git add ${f}
   git commit -m '${f}'
done
git push

