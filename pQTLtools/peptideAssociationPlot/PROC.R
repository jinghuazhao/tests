png("PROC.png",height=10,width=10,units="in",res=300)
par(mfrow=c(2,1))
protein <- "PROC"
suffix <- "_dr"
input <- paste0("~/Caprion/analysis/METAL",suffix,"/gz/",protein,suffix,".txt.gz")
annotation <- paste0("~/Caprion/analysis/METAL",suffix,"/vep/",protein,".txt")
reference <- file.path(find.package("pQTLtools"),"turboman",
                                    "turboman_hg19_reference_data.rda")
pvalue_sign <- 5e-8
plot_title <- protein
pQTLtools::turboman(input, annotation, reference, pvalue_sign, plot_title)
load(file.path(find.package("pQTLtools"),"tests","PROC.rda"))
pQTLtools::peptideAssociationPlot(protein,cistrans)
dev.off()
