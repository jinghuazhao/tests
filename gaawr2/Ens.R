library(EnsDb.Hsapiens.v75)
library(ensembldb)
EnsDb.Hsapiens.v75
all_genes <- genes(EnsDb.Hsapiens.v75)
mcols(all_genes)
table(mcols(all_genes)$gene_biotype) |> data.frame()
