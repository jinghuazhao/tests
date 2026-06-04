
suppressMessages(library(Biobase))
data(sample.ExpressionSet, package = "Biobase")
exampleSet <- sample.ExpressionSet
set.seed(1)
probs <- runif(nrow(exampleSet))
Biobase::fData(exampleSet)$lod.max <- vapply(seq_len(nrow(exampleSet)), function(i)
           quantile(Biobase::exprs(exampleSet)[i, ], probs = probs[i], na.rm = TRUE),
           numeric(1))
source("ext.R")
lod <- get.prop.below.LLOD(exampleSet)
fd <- Biobase::fData(lod)
fd <- fd[order(fd$pc.belowLOD.new, decreasing = TRUE), ]
knitr::kable(head(lod))
plot(fd$pc.belowLOD.new, main = "Random quantile cut off", ylab = "% below LOD")

source("es.R")
LOD <- get.prop.below.LLOD(exampleSet)
x <- dplyr::arrange(fData(LOD),desc(pc.belowLOD.new))
knitr::kable(head(LOD))
plot(x[,2], main="Random quantile cut off", ylab="<lod%")

fData(lod)-fData(LOD)
