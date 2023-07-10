
options(width=200)
suppressMessages(library(openxlsx))

xlsx <- file.path("../../work","mainfigure.xlsx")
sheet1 <- read.xlsx(xlsx,sheet=1,colNames=TRUE,skipEmptyRows=TRUE)

suppressMessages(library("circlize"))
suppressMessages(library(dplyr))

QTLs <- rename(sheet1,start=TSS_start) %>%
        mutate(end=start+1) %>%
        arrange(chr,start,end) %>%
        mutate(chr=paste0("chr",chr),log10p=-log10(pval)) %>%
        mutate(log10p=if_else(log10p>30,30,log10p)) %>%
        select(chr,start,end,log10p,label,druggability_category)
QTL_labels <- filter(QTLs,!is.na(druggability_category)) %>%
              mutate(druggability_category=druggability_category+1)
QTL_labels
with(QTL_labels,table(druggability_category))

setEPS()
postscript(file = "circlize.ps", width = 7.08, height = 7.08, horizontal = FALSE, paper = "special", colormodel="rgb")
circos.clear()
circos.par("start.degree" = 90, gap.degree = c(rep(c(0.7), 21), 8), track.margin = c(0.005, 0.005), cell.padding = c(0.001, 0.01, 0.01, 0.001))
circos.initializeWithIdeogram(plotType = NULL, species = "hg19",  chromosome.index = paste0("chr", 1:22))
circos.genomicLabels(QTL_labels, labels=QTL_labels[[5]], side = "outside",
                     cex = 0.7, line_lwd = 0.7, padding=0.5,
                     labels_height=min(c(cm_h(0.5), max(strwidth(QTL_labels, cex = 0.4, font = par("font"))))),
                     connection_height = convert_height(6, "mm"),
                     line_col = QTL_labels[[6]],
                     col = QTL_labels[[6]])
circos.track(ylim = c(0, 1),
             panel.fun = function(x, y) {
               chr  = gsub("chr", CELL_META$sector.index, replace = "")
               xlim = CELL_META$xlim
               ylim = CELL_META$ylim
               circos.rect(xlim[1], 0, xlim[2], 1, col = "white", cex = 0.2, lwd = 0.5 )
               circos.text(mean(xlim), mean(ylim), chr, cex = 0.4, col = "black", facing = "inside", niceFacing = TRUE)
             },
             track.height = 0.03,  bg.border = NA)
circos.track(ylim=c(0,1), track.height=0.05, bg.border=NA, panel.fun=function(x, y) {
             chr=gsub("chr", CELL_META$sector.index, replace="")
             xlim=CELL_META$xlim
             ylim=CELL_META$ylim
             circos.genomicAxis(h="top", direction="inside", labels.cex=0.25, major.at=seq(0,1e10,5e7))})
circos.genomicTrackPlotRegion(QTLs, numeric.column = 4,
                              panel.fun = function(region, value,  ...)
                              circos.genomicPoints(region, value, pch = 16, col = "magenta", cex = 0.3),
                              track.height = 0.55, bg.border = NA, bg.col = "white", ylim = c(0, 30))
circos.yaxis(side = "left", at = c(0, 10, 20, 30), labels = c(0, 10, 20, 30), 
             sector.index = get.all.sector.index()[1], labels.cex = 0.3, lwd = 0.3,
             tick.length = 0.5*(convert_x(1, "mm",
             get.cell.meta.data("sector.index"),
             get.cell.meta.data("track.index"))))
circos.genomicText(data.frame(start=1,end=1),sector.index=get.all.sector.index()[1],
                   labels = "-log10(P)",
                   h = "bottom",
                   cex = 0.4,
                   y = 20,
                   adj = c(0.2, 1.5),
                   facing = "clockwise")
#circos.genomicTrackPlotRegion(QTLs, panel.fun = function(region, value,  ...)
#                              circos.genomicPoints(region, value, pch = 19, col = "red", cex = 0.3),
#                              track.height = 0.2, bg.border = NA, bg.col = "#A6E1F4", ylim = c(-30, 0))
#circos.yaxis(side = "left", at = c(-30,-15,0), labels = c(-30,-15,0), sector.index = get.all.sector.index()[1], labels.cex = 0.3, lwd = 0.3)
#circos.genomicLabels(QTL_labels, labels.column = 5, side = "outside", cex = 0.4, line_lwd = 0.8,
#                     connection_height = convert_height(1, "mm"),
#                     line_col = as.numeric(factor(QTL_labels[[6]])), col = as.numeric(factor(QTL_labels[[6]])), facing = "reverse.clockwise")
# title("A circos plot of druggability")
dev.off()
system("convert -density 600 circlize.ps circlize.pdf")
system("convert -density 300 circlize.ps circlize.png")
# https://www.rapidtables.com/web/color/RGB_Color.html
