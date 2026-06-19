The MCQs is based on the HSTalks presentation in connection with <https://cran.r-project.org/package=gaawr2>

E. Environment

L. R language

A. Association analysis

N. Annotation

These questions progress from modern R workflow concepts to genetic association analysis, genetic models, and annotation, matching the 
structure and emphasis of the vignette.

# Questions

## Question 1

Which of the following is NOT a primary rationale for using R as a bioinformatics and data analysis environment?

A. It provides integrated facilities for data handling, including customized genomic, transcriptomic, RNA-Seq, and proteomic data.

B. It offers comprehensive statistical modeling capabilities, including GLM, GLMM, and GAM.

C. It provides extensive graphics capabilities and visualization controls comparable to or exceeding many other software environments.

D. It is designed exclusively for biological data analysis and cannot interface with languages such as C++, Java, or Python.

Answer: D

Explanation:
R is not limited to biological data analysis. It can interface with several programming languages, including C/C++, Fortran, Java, JavaScript, and Python. Its strengths include data handling, statistical modeling, graphics, cross-platform compatibility, and access to extensive package ecosystems such as Bioconductor.

---

## Question 2

What is the purpose of the following command?

use_github_action("pkgdown",
                  save_as = "R-CMD-check.yaml")

A. Creates a local web server using plumber.

B. Sets up a GitHub Action workflow for automated package checking and website deployment.

C. Builds the package tarball.

D. Creates a GitHub repository.

Answer: B

---

## Question 3

Which statement about R CMD check is correct?

A. It installs a package from GitHub.

B. It generates package documentation.

C. It performs quality checks on a package and can be run with --as-cran for CRAN-like validation.

D. It creates a package skeleton.

Answer: C

---

## Question 4

Which of the following statements is NOT true regarding genetic association studies?

A. A significant deviation from Hardy–Weinberg Equilibrium (HWE) in control samples may indicate genotyping errors.

B. A haplotype refers to a combination of alleles at multiple loci that are inherited together on the same chromosome.

C. Genome-Wide Association Studies (GWAS) typically test millions of SNPs across the genome for association with a trait.

D. Single-SNP association analysis directly identifies the causal variant responsible for a disease.

Answer: D

Explanation:
Single-SNP association analysis identifies variants statistically associated with a trait, but the associated SNP is often only in linkage disequilibrium with the true causal variant. Additional fine-mapping and functional studies are usually required to identify the causal variant.

---

## Question 5

Which R feature highlighted in the vignette allows chaining operations together in a readable workflow?

A. :: scope operator
B. |> native pipe operator
C. $ extraction operator
D. @ slot operator

Answer: B. |> native pipe operator

Explanation: The vignette highlights the native pipe operator (|>) and the magrittr pipe (%>%) as important modern features for constructing chained data-analysis workflows.

---

## Question 6

What is the primary purpose of the command below?

create_package("gaawr2")

A. Install the package from GitHub

B. Create a package skeleton with the required directory structure

C. Build a pkgdown website

D. Generate Rd documentation files

Answer: B

---

## Question 7

Which command is used to create a source package archive from an R package directory?

A. R CMD INSTALL gaawr2

B. R CMD build gaawr2

C. R CMD check gaawr2

D. devtools::document()

Answer: B

Explanation: R CMD build gaawr2 creates a compressed source package such as gaawr2_0.0.1.tar.gz.

---

## Question 8

Which of the following is NOT an advantage of a GitHub repository?

A. Version control and change tracking.

B. Hosting project documentation and web pages.

C. Automatic conversion of R code into machine code.

D. Collaboration and code sharing.

Answer: C

---

## Question 9

MCQ 6

Which command is specifically intended to create a pkgdown website suitable for GitHub Pages?

A. build_articles()

B. build_site_github_pages()

C. build_news()

D. R CMD INSTALL

Answer: B

---

## Question 10

Which Bioconductor package listed in the vignette is specifically intended for genome annotation resources?

A. HardyWeinberg
B. GMMAT
C. EnsDb.Hsapiens.v75
D. SNPassoc

Answer: C. EnsDb.Hsapiens.v75

Explanation: The package list includes EnsDb.Hsapiens.v75 and ensembldb, which provide Ensembl-based gene and transcript annotation resources used in genetic annotation workflows.

---

