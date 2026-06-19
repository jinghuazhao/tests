#!/usr/bin/bash

module load ceuadmin/R
R --no-save < MCQs.R
pandoc MCQs.md -o MCQs.docx
