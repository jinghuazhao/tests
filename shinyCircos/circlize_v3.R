# ========================================
# circlize version 0.4.6
# 
# CRAN page:      https://cran.r-project.org/package=circlize
# Github page:    https://github.com/jokergoo/circlize
# Documentation:  http://jokergoo.github.io/circlize_book/book/
# Reference:      Gu, Z. circlize implements and enhances circular visualization in R. Bioinformatics 2014.
# ========================================

# import packages
library("colortools")
library("RColorBrewer")
library("circlize")
# library("cartography")
# library("paletteer")
library("ggplot2")
library("colorspace")

# folder
setwd("C:\\Users\\vujkovic\\Box\\MVP_T2D_maki\\circos")

# 21 shades of blue
# display.brewer.pal(n = 11, name = 'PRGn')
# brewer.pal(n = 11, name = "RdBu")
# sequential(brewer.pal(n = 11, name = "RdBu")[7], 10)[2]
palette(c("black", 
          brewer.pal(n = 11, name = "PRGn")[2], 
          brewer.pal(n = 11, name = "Spectral")[2],
          brewer.pal(n = 11, name = "Spectral")[10],
          brewer.pal(n = 11, name = "PRGn")[10]))

#          [3], "black", brewer.pal(n = 11, name = "RdBu")[9]))
# red for pancrease
# black for adipose
# blue for skeletal muscle
# palette("default") # reset the palette to the default color

# palettes_d_names
# paletteer_d(package = "dutchmasters", palette = "view_of_Delft", n = 10)
# paletteer_d(package = "rcartocolor", palette = "Mint", n = 7)
# paletteer_dynamic("cartography", "green.pal", 5)
#
# DATA: Gene annotation (add chromoxom X)
#
# lead.trans = read.table("..//primary_gwas//TRANS//T2D.META.TRANS.leadSNP.formatted.table.txt", T, stringsAsFactors = F)
# lead.trans$chr = paste0("chr", lead.trans$CHR)
# genes = lead.trans[,c("CHR", "BP", "BP", "NOVEL", "GENE")]
# names(genes) = c("chr", "start", "end", "novel", "value")
# genes$chr = paste0("chr", genes$chr)
# genes = genes [which(genes$value != "-"), ]
# genes = genes [which(substr(genes$value, 1, 2) != "RP"), ]
# genes = genes [which(substr(genes$value, 1, 3) != "AC0"), ]
# genes = genes [which(substr(genes$value, 1, 3) != "AC1"), ]
# genes = genes [which(substr(genes$value, 1, 3) != "AP0"), ]
# genes = genes [which(substr(genes$value, 1, 3) != "CTA"), ]
# genes = genes [which(substr(genes$value, 1, 4) != "LINC"), ]
# genes = genes [which(substr(genes$value, 1, 4) != "CTC-"), ]
# genes = genes [which(substr(genes$value, 1, 4) != "CTD-"), ]
# genes = genes [which(substr(genes$value, 1, 4) != "CTB-"), ]
# genes = genes [which(substr(genes$value, 1, 3) != "RNU"), ]

# 
# # add chrX to this
# genes = rbind(genes, 
#               c('chrX', 19497290,  19497290,  1, 'MAP3K15'),
#               c('chrX', 67255974,  67255974,  1, 'AR'),
#               c('chrX', 135859359, 135859359, 1, 'ARHGEF6'),
#               c('chrX', 20009166,  20009166,  1, 'MAP7D2'),
#               c('chrX', 31851610,  31851610,  1, 'DMD'),
#               c('chrX', 66316809,  66316809,  1, 'EDA2R'),
#               c('chrX', 153882606, 153882606, 0, 'DUSP9'),
#               c('chrX', 132597984, 132597984, 1, 'GPC3'),
#               c('chrX', 117955250, 117955250, 0, 'IL13RA1'),
#               c('chrX', 109888390, 109888390, 1, 'RGAG1'),
#               c('chrX', 56902211,  56902211,  0, 'SPIN2A'),
#               c('chrX', 124390172, 124390172, 1, 'TENM1')
# )
# genes$start = as.numeric(genes$start)
# genes$end   = as.numeric(genes$end)
# genes$novel = as.numeric(genes$novel)
# 
# 
# #
# # MIDDLE PLOT
# # 
lead.trans = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D//primary_gwas//TRANS//T2D.META.TRANS.leadSNP.formatted.table.txt", T, stringsAsFactors = F)
lead.all = lead.trans[,c("LeadSNP", "EUR.BETA", "EUR.EAF", "AFR.BETA", "AFR.EAF", "AMR.BETA", "AMR.EAF", "EAS.BETA", "EAS.EAF")]
lead.all$EUR.EAF  = ifelse(lead.all$EUR.EAF > 0.5,  1 - lead.all$EUR.EAF,  lead.all$EUR.EAF)
lead.all$AFR.EAF  = ifelse(lead.all$AFR.EAF > 0.5,  1 - lead.all$AFR.EAF,  lead.all$AFR.EAF)
lead.all$AMR.EAF  = ifelse(lead.all$AMR.EAF > 0.5,  1 - lead.all$AMR.EAF,  lead.all$AMR.EAF)
lead.all$EAS.EAF  = ifelse(lead.all$EAS.EAF > 0.5,  1 - lead.all$EAS.EAF,  lead.all$EAS.EAF)

lead.all$EUR.BETA = abs(lead.all$EUR.BETA)
lead.all$AMR.BETA = abs(lead.all$AMR.BETA)

lead.all$AFR.BETA = -1*abs(lead.all$AFR.BETA)
lead.all$EAS.BETA = -1*abs(lead.all$EAS.BETA)

lead.all$AMR.EAF = -1*abs(lead.all$AMR.EAF)
lead.all$EAS.EAF = -1*abs(lead.all$EAS.EAF)

lead.all =  data.frame(POP   = c(rep("whites", nrow(lead.all)), rep("blacks", nrow(lead.all)), rep("hispanics", nrow(lead.all)), rep("asians", nrow(lead.all))),
                       EAF   = c(lead.all$EUR.EAF,  lead.all$AFR.EAF, lead.all$AMR.EAF,lead.all$EAS.EAF),
                       BETA  = c(lead.all$EUR.BETA, lead.all$AFR.BETA, lead.all$AMR.BETA,lead.all$EAS.BETA),
                       stringsAsFactors = F)
lead.all = subset(lead.all, is.na(lead.all$EAF) == F)

setEPS()
postscript(file = "middlex.eps", width = 2, height = 2, horizontal = FALSE, paper = "special", colormodel="rgb")
# pdf("InnerPlot_v1.pdf", width = 2.3, height = 2.3)
# #svg("InnerPlot_v1.svg", width = 2.3, height = 2.3, pointsize = 12, bg = "transparent")
ggplot(lead.all, aes(x = EAF, y = BETA, col = as.factor(POP), shape = as.factor(POP))) +
  geom_point(size = 0.4) +
  scale_shape_manual(values = c(6, 6, 2, 2)) +
  scale_colour_manual(values = sequential_hcl(9, palette = "SunsetDark")[7:4]) +
  theme_bw() +
  geom_text(data = data.frame(EAF = seq(-0.5, 0.5, by = 0.1), BETA = c(rep(0.07, 6), rep(0,5)), POP = as.factor(rep("blacks", 11))),
            label = c(0.5, 0.4, 0.3, 0.2, 0.1, "", 0.1, 0.2 ,0.3, 0.4, 0.5),
            vjust = 1.5,
            col = "grey20",
            cex = 1.5) +
  geom_text(data = data.frame(EAF = c(rep(-0.02, 5), rep(0.02, 4)), BETA=seq(-0.8, 0.8, by = 0.2), POP = as.factor(rep("blacks", 9))),
            label = c(0.8, 0.6, 0.4, 0.2, 0, 0.2 ,0.4, 0.6, 0.8),
            vjust = 1.5,
            col = "grey20",
            cex = 1.5) +
  theme( panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         panel.border = element_blank(),
         panel.background = element_blank(),
         axis.text.x  = element_blank(),
         axis.ticks.x = element_blank(),
         axis.title.x = element_blank(),
         axis.text.y  = element_blank(),
         axis.ticks.y = element_blank(),
         axis.title.y = element_blank()) +
  geom_vline(xintercept = 0, col = "grey20", cex = 0.2) +
  geom_hline(yintercept = 0, col = "grey20", cex = 0.2) +
  theme(legend.position = "none") +
  annotate("text", x =  0.3,  y =  0.3, label = "whites",    col = "grey20", cex = 1.5) +
  annotate("text", x = -0.3,  y =  0.3, label = "hispanics", col = "grey20", cex = 1.5) +
  annotate("text", x =  0.3,  y = -0.3, label = "blacks",    col = "grey20", cex = 1.5) +
  annotate("text", x = -0.3,  y = -0.3, label = "asians",    col = "grey20", cex = 1.5) +
  annotate("text", x = -0.02, y =  0.75, label = "abs(Beta)", col = "grey20", cex = 1.5, angle = 90) +
  annotate("text", x =  0.02, y = -0.60, label = "abs(Beta)", col = "grey20", cex = 1.5, angle = 90) +
  annotate("text", x = -0.5,  y = -0.05, label = "MAF",       col = "grey20", cex = 1.5) +
  annotate("text", x =  0.5,  y =  0.05, label = "MAF",       col = "grey20", cex = 1.5)
dev.off()

#
# DATA: Trans-ethnic meta-analysis
#
#trans        = read.table("..//..//TRANS//T2D.META.TRANS.XTRA.COJO.ma", F, stringsAsFactors = F)
# 
#trans        = trans[,c("V1", "V7", "V9", "V10")] # isquare and hetp are added
#names(trans) = c("SNP", "P", "I2", "hetP")
#save(trans, file = "trans.RData")
load("trans.RData")

# chrX
trans.x = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D\\chrX\\TRANS\\T2D.META.META.chrX.ALT.1.TBL", T, stringsAsFactors = F)
trans.x = trans.x[ , c("MarkerName", "P.value", "HetISq", "HetPVal")]
names(trans.x) = c("SNP", "P", "I2", "hetP")
trans.x$SNP = paste0("chr", trans.x$SNP)
trans.x = subset(trans.x, trans.x$P < 0.001)

# cut the dataset
trans        = subset(trans, trans$P < 0.001)
trans        = subset(trans, substr(trans$SNP, 1, 4) != "chrX")
trans        = rbind(trans, trans.x)

# get chr-bp
tmp           = as.data.frame(do.call(rbind, strsplit(trans$SNP, '\\:')),  stringsAsFactors = F)
colnames(tmp) = c("chr", "start")
tmp$start     = as.numeric(tmp$start)
tmp$end       = tmp$start + 1

# Trans-ethnic P-values
trans.p           = cbind(tmp, trans$P)
names(trans.p)[4] = "value"
trans.p$value     = ifelse(trans.p$value == 0,     1.0e-300, trans.p$value)
trans.p$cutval    = ifelse(trans.p$value < 1.0e-30, 1.0e-30, trans.p$value)
trans.p$logp      = -log10(trans.p$cutval)
trans.p           = trans.p[ ,c(1:3, 6)]
names(trans.p)[4] = "value1"

#
# TRACK: Heterogeneity Cochrane I-sqaure value
# 
lead.trans = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D\\primary_gwas\\TRANS\\T2D.META.TRANS.leadSNP.formatted.table.txt", T, stringsAsFactors = F)
lead.trans = lead.trans[,c("CHR", "BP", "BP", "NOVEL", "GENE")]
lead.trans$CHR = paste0("chr", lead.trans$CHR)
lead.trans = rbind(lead.trans, 
                   c('chrX', 19497290,  19497290,  1, 'MAP3K15'),
                   c('chrX', 67255974,  67255974,  1, 'AR'),
                   c('chrX', 135859359, 135859359, 1, 'ARHGEF6'),
                   c('chrX', 20009166,  20009166,  1, 'MAP7D2'),
                   c('chrX', 31851610,  31851610,  1, 'DMD'),
                   c('chrX', 66316809,  66316809,  1, 'EDA2R'),
                   c('chrX', 153882606, 153882606, 0, 'DUSP9'),
                   c('chrX', 132597984, 132597984, 1, 'GPC3'),
                   c('chrX', 117955250, 117955250, 0, 'IL13RA1'),
                   c('chrX', 109888390, 109888390, 1, 'RGAG1'),
                   c('chrX', 56902211,  56902211,  0, 'SPIN2A'),
                   c('chrX', 124390172, 124390172, 1, 'TENM1')
)
names(lead.trans) = c("chr", "start", "end", "novel", "gene")
lead.trans$start = as.numeric(lead.trans$start)
lead.trans$end   = as.numeric(lead.trans$end)
lead.trans$novel = as.numeric(lead.trans$novel)

# I-square of 25 percent (departure from homogeneity)
trans.heti = cbind(tmp, trans$I2)
names(trans.heti)[4] = "value"
trans.heti = merge(lead.trans[,c("chr", "start")], trans.heti, by.x = c("chr", "start"), by.y = c("chr", "start"))
# add chrX data to lead.trans

#
# TRACK: Heterogeneity Cochrane P-values
# 

# 9.0E-05 [p=0.05/558]
trans.hetp = cbind(tmp, trans$hetP)
names(trans.hetp)[4] = "value"
trans.hetp = merge(lead.trans[,c("chr", "start")], trans.hetp, by.x = c("chr", "start"), by.y = c("chr", "start"))
trans.hetp$value = -log10(trans.hetp$value)

# hard-coding
# manually add the European-specific and African American specific dots to TRANS
# Then incoporate extra rule for color based on exact p-value

# African American specific
trans.y = rbind(trans.p, 
                c('chr12', 38710523, 38710523, -log10(0.00000001463)), 
                c('chr12', 57968738, 57968738, -log10(0.0000000177)), 
                c('chr12', 88338461, 88338461, -log10(0.00000003734)))
trans.y$value1 = as.numeric(trans.y$value1)
trans.y$start = as.numeric(trans.y$start)
trans.y$end = as.numeric(trans.y$end)

wtf.afr = trans.y[(nrow(trans.y)-2):nrow(trans.y), c("chr", "start", "end", "value1")]  

# European-specific
trans.y = rbind(trans.y, 
                c('chr1', 147121000, 147121000, -log10(0.00000004791)),
                c('chr3', 3649850, 3649850, -log10(0.000000009255)),
                c('chr3', 36870230, 36870230, -log10(0.00000001525)),
                c('chr3', 89986280, 89986280, -log10(0.000000006694)),
                c('chr3', 128579324, 128579324, -log10(0.000000001872)),
                c('chr4', 91243865, 91243865, -log10(0.0000000123)),
                c('chr6', 41012405, 41012405, -log10(0.00000004805)),
                c('chr7', 1872921, 1872921, -log10(0.0000000007915)),
                c('chr7', 2760750, 2760750, -log10(0.00000001462)),
                c('chr8', 4186731, 4186731, -log10(0.00000002477)),
                c('chr9', 126586563, 126586563, -log10(0.000000001635)),
                c('chr10', 73835274, 73835274, -log10(0.00000004824)),
                c('chr11', 74625997, 74625997, -log10(0.00000004464)),
                c('chr13', 28245127, 28245127, -log10(0.00000002874)),
                c('chr15', 36392562, 36392562, -log10(0.00000004256)),
                c('chr15', 60938816, 60938816, -log10(0.00000001113)),
                c('chr15', 67260238, 67260238, -log10(0.000000003223)),
                c('chr17', 75386909, 75386909, -log10(0.000000003576)),
                c('chr17', 77895311, 77895311, -log10(0.00000001563)),
                c('chr18', 13271367, 13271367, -log10(0.000000002418)),
                c('chr21', 47767295, 47767295, -log10(0.000000001606)))
trans.y$value1 = as.numeric(trans.y$value1)
trans.y$start = as.numeric(trans.y$start)
trans.y$end = as.numeric(trans.y$end)

wtf.eur       = trans.y[(nrow(trans.y)-20):nrow(trans.y), c("chr", "start", "end", "value1")]  

df.eur = iris[NULL, NULL]
for(i in 1:nrow(wtf.eur)) {
    tmp = subset(trans.y, (trans.y$chr == wtf.eur$chr[i]) & (trans.y$start > (wtf.eur$start[i] - 500000)) & (trans.y$start < (wtf.eur$start[i] + 3500000)) & (trans.y$value1 <= wtf.eur$value1[1]))
    df.eur = rbind(df.eur, tmp)
}
df.eur$value2 = 1

df.afr = iris[NULL, NULL]
for(i in 1:nrow(wtf.afr)) {
  tmp = subset(trans.y, (trans.y$chr == wtf.afr$chr[i]) & (trans.y$start > (wtf.afr$start[i] - 500000)) & (trans.y$start < (wtf.afr$start[i] + 3500000)) & (trans.y$value1 <= wtf.afr$value1[1]))
  df.afr = rbind(df.afr, tmp)
}
df.afr$value3 = 1

trans.y = merge(trans.y, df.afr, by = c("chr", "start", "end", "value1"), all.x = T)
trans.y = merge(trans.y, df.eur, by = c("chr", "start", "end", "value1"), all.x = T)
trans.y$value2 = ifelse(is.na(trans.y$value2) == T, 0, trans.y$value2)
trans.y$value3 = ifelse(is.na(trans.y$value3) == T, 0, trans.y$value3)

trans.y$value4 = as.factor(trans.y$value2 + trans.y$value3 + 1)

#
# DATA: PrediXcan results
#
linker = read.table("ensembl_build_37_original_import_space_g_first.txt", T, stringsAsFactors = F)
names(linker)[1:5] = c("gene_name", "gene","chr", "start", "end")
linker$chr = paste0("chr", linker$chr)

Pancreas = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Pancreas_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Muscle_Skeletal = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Muscle_Skeletal_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Adipose_Subcutaneous  = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Adipose_Subcutaneous_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Adipose_Visceral_Omentum= read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Adipose_Visceral_Omentum_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Cerebellum = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Cerebellum_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Frontal_Cortex_BA9 = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Frontal_Cortex_BA9_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Cerebellar_Hemisphere = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Hypothalamus_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Hypothalamus = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Amygdala_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Amygdala = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Cerebellum_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Anterior_cingulate_cortex_BA24 = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Anterior_cingulate_cortex_BA24_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Nucleus_accumbens_basal_ganglia = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Nucleus_accumbens_basal_ganglia_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Caudate_basal_ganglia = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Caudate_basal_ganglia_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Putamen_basal_ganglia = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Putamen_basal_ganglia_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Hippocampus = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Hippocampus_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Brain_Cortex = read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Brain_Cerebellum_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Artery_Tibial= read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Artery_Tibial_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Artery_Aorta= read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Artery_Aorta_imputed_.csv", T, sep = ",", stringsAsFactors = F)
Artery_Coronary= read.table("C:\\Users\\vujkovic\\Box\\MVP_T2D_tWAS\\GPGE_Results_02282019\\S_PrediXcan_output\\metaxcanInput-gtex_v7_Artery_Coronary_imputed_.csv", T, sep = ",", stringsAsFactors = F)

Pancreas$tissue = "pancreas"
Muscle_Skeletal$tissue = "skeletal_muscle"
Adipose_Subcutaneous$tissue  = "adipose"
Adipose_Visceral_Omentum$tissue = "adipose"
Brain_Cerebellum$tissue = "brain"
Brain_Frontal_Cortex_BA9$tissue = "brain"
Brain_Cerebellar_Hemisphere$tissue = "brain"
Brain_Hypothalamus$tissue = "brain"
Brain_Amygdala$tissue = "brain"
Brain_Anterior_cingulate_cortex_BA24$tissue = "brain"
Brain_Nucleus_accumbens_basal_ganglia$tissue = "brain"
Brain_Caudate_basal_ganglia$tissue = "brain"
Brain_Putamen_basal_ganglia$tissue = "brain"
Brain_Hippocampus$tissue = "brain"
Brain_Cortex$tissue = "brain"
Artery_Tibial$tissue = "artery"
Artery_Aorta$tissue = "artery"
Artery_Coronary$tissue = "artery"

eqtl = rbind(Pancreas, Muscle_Skeletal, Adipose_Subcutaneous, Adipose_Visceral_Omentum, Brain_Cerebellum, Brain_Frontal_Cortex_BA9, Brain_Hypothalamus, Brain_Amygdala, Brain_Anterior_cingulate_cortex_BA24,
             Brain_Nucleus_accumbens_basal_ganglia, Brain_Caudate_basal_ganglia, Brain_Putamen_basal_ganglia, Brain_Hippocampus, Brain_Cortex, Artery_Tibial, Artery_Aorta, Artery_Coronary)
eqtl$tissue_gene = paste0(eqtl$tissue, "_", eqtl$gene_name)
maki = aggregate(pvalue ~ tissue_gene, eqtl, function(x) min(x))
eqtl = merge(eqtl, maki, by = c("pvalue", "tissue_gene"))
eqtl = unique(eqtl)
head(eqtl)
#pancreas = subset(pancreas, pancreas$pvalue < 0.1)
eqtl = merge(linker[,c("gene", "chr", "start", "end")], eqtl[,c("gene", "pvalue", "tissue", "gene_name")], by = "gene")
eqtl$gene = NULL
names(eqtl)[4] = "value1"
names(eqtl)[5] = "value2"
names(eqtl)[6] = "value3"
eqtl$value1 = -log10(eqtl$value1)
eqtl$value1 = ifelse(eqtl$value1 > 20, 20, eqtl$value1)
eqtl$start  = round((eqtl$start + eqtl$end)/2, 0)
eqtl$end    = eqtl$start 
eqtl$value4 = 20 - eqtl$value1

library(tidyr)
genes = unique(eqtl[which(eqtl$value1 > 6) , c(1:3, 5:6)])
data_wide <- spread(genes, value2, value3)
data_wide$gene_name       = ifelse(is.na(data_wide$pancreas) == F, data_wide$pancreas, 
                                   ifelse(is.na(data_wide$skeletal_muscle) == F, data_wide$skeletal_muscle, 
                                          ifelse(is.na(data_wide$adipose) == F, data_wide$adipose, 
                                                 ifelse(is.na(data_wide$artery) == F, data_wide$artery, data_wide$brain))))
# data_wide$gene_name  = unique(na.omit(c(data_wide$adipose, data_wide$skeletal_muscle, data_wide$pancreas, data_wide$brain, data_wide$artery)))      
data_wide$adipose          = ifelse(is.na(data_wide$adipose) == T, 0, 1)
data_wide$pancreas         = ifelse(is.na(data_wide$pancreas) == T, 0, 1)
data_wide$skeletal_muscle  = ifelse(is.na(data_wide$skeletal_muscle) == T, 0, 1)
data_wide$brain            = ifelse(is.na(data_wide$brain) == T, 0, 1)
data_wide$artery           = ifelse(is.na(data_wide$artery) == T, 0, 1)
data_wide$color_code       = ifelse(data_wide$pancreas == 1, 1, 
                                    ifelse(data_wide$skeletal_muscle == 1, 2, 
                                           ifelse(data_wide$adipose == 1, 3, 
                                                  ifelse(data_wide$artery == 1, 4, 5))))
# exclude brain
data_wide = subset(data_wide, data_wide$color_code != 5)
data_wide = data_wide [which(data_wide$gene_name != "-"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 2) != "RP"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 3) != "AC0"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 3) != "AC1"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 3) != "AC2"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 3) != "AP0"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 3) != "CTA"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 4) != "LINC"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 4) != "CTC-"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 4) != "CTD-"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 4) != "CTB-"), ]
data_wide = data_wide [which(substr(data_wide$gene_name, 1, 5) != "XXbac"), ]
data_wide = data_wide[which(substr(data_wide$gene_name, 1, 3) != "RNU"), ]
data_wide = data_wide[which(substr(data_wide$gene_name, 1, 7) != "HLA-DRB"), ]
data_wide = data_wide[which(substr(data_wide$gene_name, 1, 6) != "HLA-DQ"), ]
data_wide = data_wide[which(substr(data_wide$gene_name, 1, 3) != "DNA"), ]
data_wide = data_wide[which(substr(data_wide$gene_name, 1, 3) != "RNA"), ]


trans.region = as.data.frame(matrix(c("X", 154930487, 154930488, "22", 51147015, 51147016), ncol = 3, byrow = T), stringsAsFactors = F)
names(trans.region) = c("chr", "start", "end")
trans.region$start  = as.numeric(trans.region$start)
trans.region$end    = as.numeric(trans.region$end)

# 
# CIRCOS PLOT
#
#pdf("TripleTrack_v8.pdf")
setEPS()
postscript(file = "onemoretime.eps", width = 7.08, height = 7.08, horizontal = FALSE, paper = "special", colormodel="rgb")
circos.clear()
circos.par("start.degree" = 90,                        # set circos parameters
           gap.degree = c(rep(c(0.7), 22), 8),         # small gap between chr's, except between X and 1 (big gap of 4)
           track.margin = c(0.005, 0.005),             # remove the spaces between the tracks
           cell.padding = c(0.001, 0.01, 0.01, 0.001))
circos.initializeWithIdeogram(plotType = NULL,         # initialize a genomics template
                              species = "hg19", 
                              chromosome.index = paste0("chr", c(1:22, "X")))
circos.genomicLabels(data_wide,                            # gene names on the outside, colored by novelty (novel vs known)
                     labels.column = 9, 
                     side = "outside", 
                     cex = 0.3, 
                     line_lwd = 0.8,
                     connection_height = convert_height(3, "mm"),
                     line_col = as.numeric(factor(data_wide[[10]])), 
                     col = as.numeric(factor(data_wide[[10]]))) 
circos.track(ylim = c(0, 1),                           # chromosome name in a box
             panel.fun = function(x, y) {
               chr  = gsub("chr", CELL_META$sector.index, replace = "")
               xlim = CELL_META$xlim
               ylim = CELL_META$ylim
               circos.rect(xlim[1], 0, xlim[2], 1, 
                           col = "white", 
                           cex = 0.2, 
                           lwd = 0.5 ) # try to make thinner box outline
               circos.text(mean(xlim), mean(ylim), 
                           chr, 
                           cex = 0.4, 
                           col = "black",
                           facing = "inside", 
                           niceFacing = TRUE)
             }, 
             track.height = 0.03, 
             bg.border = NA)
circos.genomicTrackPlotRegion(trans.y,                  # Results Track 1: Trans-ethnic Manhattan plot
                              panel.fun = function(region, value,  ...) {
                                colx  = ifelse(value[, 2] == 1, "red", 
                                               ifelse(value[,3] == 1, "green", brewer.pal(n = 11, name = "RdBu")[11]))
                                for(h in seq(10, 30, by = 5)) {
                                  circos.lines(CELL_META$cell.xlim, c(h, h), 
                                               lty = 1, 
                                               lwd = 0.5, 
                                               col = "white")
                                }
                                circos.genomicPoints(region, value[, 1], 
                                                     pch = 16, 
                                                     col = colx, 
                                                     cex = 0.2)
                                circos.lines(CELL_META$cell.xlim, c(7.3, 7.3), 
                                             lty = 1, 
                                             col = "red", 
                                             lwd = 0.5)
                              },
                              track.height = 0.2,
                              bg.border = NA,
                              #bg.col = "#D8E7F0FF", 
                              bg.col = "ghostwhite",
                              ylim = c(3, 31)
)
circos.yaxis(side = "left",                             # Y-axis for the P-values on the top (in between chrX and chr1)
             at = c(3, 10, 20, 30),
             labels = c(1, 10, 20, 30),
             sector.index = get.all.sector.index()[1],
             labels.cex = 0.3,
             lwd = 0.3, 
             tick.length = 0.5*(convert_x(1, "mm", get.cell.meta.data("sector.index"), get.cell.meta.data("track.index"))))
circos.genomicText(trans.region[1, c(2,3)],
                   labels = "trans-ethnic meta",
                   h = "bottom", 
                   cex = 0.3, 
                   y = 10,
                   adj = c(0.8, -1),
                   facing = "reverse.clockwise")
circos.genomicTrack(trans.hetp,                         # Results Track 2: Heterogeneity P-value
                    panel.fun = function(region, value, ...) {
                      circos.genomicPoints(region, 40, 
                                           pch = 16, 
                                           col = brewer.pal(n = 11, name = "PRGn")[10], 
                                           cex = value[[1]]/50)
                    },
                    track.height = 0.03,
                    bg.border = NA,
                    bg.col = brewer.pal(n = 11, name = "PRGn")[7])
circos.yaxis(side = "left",                             # add line
             at = 45,
             labels = expression(P[het]),
             labels.cex = 0.3,
             sector.index = get.all.sector.index()[1],
             lwd = 0.3,
             tick = FALSE) 
circos.genomicTrackPlotRegion(eqtl,                   # Results Track 3: PrediXcan analysis in Europeans (Adipose)
                              panel.fun = function(region, value, ...) {
                                colx  = ifelse(value[, 2] == "pancreas", "black", 
                                               ifelse(value[, 2] == "skeletal_muscle", brewer.pal(n = 11, name = "PRGn")[2], 
                                                      ifelse(value[, 2] == "adipose", brewer.pal(n = 11, name = "Spectral")[2],
                                                             brewer.pal(n = 11, name = "Spectral")[10])))
                                for(h in seq(5, 20, by = 5)) {
                                  circos.lines(CELL_META$cell.xlim, c(h, h), 
                                               lty = 1, 
                                               lwd = 0.5,
                                               col = "white")
                                }
                                circos.genomicPoints(region, value[,4], 
                                                     pch = 16, 
                                                     cex = 0.25, 
                                                     col = colx)
                                circos.lines(CELL_META$cell.xlim, c(20-7.3, 20-7.3), 
                                             lty = 1, 
                                             col = "red", 
                                             lwd = 0.5)
                              },
                              track.height = 0.2,
                              bg.border = NA,
                              bg.col = "ghostwhite")
#ylim = c(5, 21), 
#bg.col = brewer.pal(n = 11, name = "PRGn")[5])
circos.yaxis(side = "left",                             # Y-axis for the P-values on the top (in between chrX and chr1)
             at = c(0, 10, 19),
             labels = c(20, 10, 1),
             sector.index = get.all.sector.index()[1],
             labels.cex = 0.3,
             lwd = 0.3, 
             tick.length = 0.5*(convert_x(1, "mm", get.cell.meta.data("sector.index"), get.cell.meta.data("track.index")))
)
circos.genomicText(trans.region[1, c(2,3)],
                   labels = "GTEx S-PrediXcan",
                   h = "bottom", 
                   cex = 0.3, 
                   y = 10,
                   adj = c(.5, 1.5),
                   facing = "reverse.clockwise")
circos.genomicText(trans.region[2, c(2,3)],
                   labels = "pancreas",
                   col = "black",
                   h = "bottom", 
                   cex = 0.3, 
                   y = 10,
                   adj = c(.5, -2.5),
                   facing = "reverse.clockwise")
circos.genomicText(trans.region[2, c(2,3)],
                   labels = "skeletal muscle",
                   col = brewer.pal(n = 11, name = "PRGn")[2],
                   h = "bottom", 
                   cex = 0.3, 
                   y = 10,
                   adj = c(.5, -1.0),
                   facing = "reverse.clockwise")
circos.genomicText(trans.region[2, c(2,3)],
                   labels = "adipose",
                   col = brewer.pal(n = 11, name = "Spectral")[2],
                   h = "bottom", 
                   cex = 0.3, 
                   y = 10,
                   adj = c(.5, 0.5),
                   facing = "reverse.clockwise")
circos.genomicText(trans.region[2, c(2,3)],
                   labels = "artery",
                   col = brewer.pal(n = 11, name = "Spectral")[10],
                   h = "bottom", 
                   cex = 0.3, 
                   y = 10,
                   adj = c(.5, 2),
                   facing = "reverse.clockwise")
dev.off()
