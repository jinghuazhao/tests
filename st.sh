#!/usr/bin/bash

for f in $(ls) .gitignore
do
   git add ${f}
   git commit -m "${f}"
done
git push

