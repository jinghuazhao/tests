#!/usr/bin/bash

module load ceuadmin/R
R --no-save < MCQs.R
module load ceuadmin/pandoc/3.6.2
pandoc MCQs.md -o MCQs.docx --metadata title=""

# pandoc 2.18 has duplicated titles but normal with --metadata title=""
# pandoc 3.6.2 may or may not take the option.
