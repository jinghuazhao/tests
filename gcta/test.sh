# 13-11-2015 MRC-Epid JHZ

plink --bfile test --recode --out test
fcgene --bfile test --oformat recodeA-dose --out test

gcta64 --bfile test --make-grm-gz --out test --thread-num 20
gcta64 --reml --grm test --pheno test.phen --out test --thread-num 20
gcta64 --pca 3925 --grm-gz test --out test --thread-num 20

gcta64 --bfile test --make-grm-bin --out test
gcta64 --reml --reml-pred-rand --grm-bin test --pheno test.phen --out test2
gcta64 --bfile test --blup-snp test2.indi.blp --pheno test.phen --out test2

plink-1.90beta --noweb --bfile test --make-grm-gz --genome --out plink
gcta64 --reml --grm-gz gap --pheno test.phen --out gap --thread-num 20
gcta64 --pca 3925 --grm-gz gap --out gap --thread-num 20

gcta64 --grm-gz test --make-grm --out test
gcta64 --reml --reml-est-fix --grm test --pheno test.phen --covar test.covar --thread-num 20 --out test3

gcta64 --reml  --reml-est-fix --grm test --pheno test.phen --gxe test.covar --thread-num 20 --out test4
gcta64 --reml --mgrm test.grmlist --reml-est-fix --pheno test.phen --covar test.covar --thread-num 20

gcta64 --reml --grm test_G --pheno test.phen --thread-num 20 --out test5
gcta64 --reml --grm test_GE --pheno test.phen --thread-num 20 --out test6

gcta64 --bfile test --fst --sub-popu test.covar --out test
gcta64 --HEreg --grm test --pheno test.phen --out test
gcta64 --bfile test --ld-score-region 200 --out test

gcta64 --bfile test --extract snp_group1.txt --make-grm --out test_group1
gcta64 --bfile test --extract snp_group2.txt --make-grm --out test_group2
gcta64 --bfile test --extract snp_group3.txt --make-grm --out test_group3
gcta64 --bfile test --extract snp_group4.txt --make-grm --out test_group4
gcta64 --reml --mgrm multi_GRMs.txt --pheno test.phen --out ldms
