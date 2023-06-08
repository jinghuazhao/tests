To hold modified version which removes interleaved labels

See <https://github.com/jrs95/gassocplot2/issues/4>

```
diff --git a/R/figures.R b/R/figures.R
index 567a8ab..16161a1 100644
--- a/R/figures.R
+++ b/R/figures.R
@@ -324,14 +324,14 @@ plot_assoc_combined <- function(recombination.plot, gene.plot, marker.plot, titl
   if(ngenes<=5){g$heights[panels[2]] <- unit(0.5,"null")}
   if(ngenes>5 & ngenes<=10){g$heights[panels[2]] <- unit(1.2,"null")}
   if(ngenes>10){g$heights[panels[2]] <- unit(2,"null")}
-  if(!is.null(subtitle)){
+  if((subtitle=="")){
     gt1 <- textGrob(subtitle,gp=gpar(fontsize=16))
-    g <- gtable_add_rows(g, heights = grobHeight(gt1)*2.5, pos = 0)
+#   g <- gtable_add_rows(g, heights = grobHeight(gt1)*2.5, pos = 0)
     g <- gtable_add_grob(g, gt1, 1, 1, 1, ncol(g))
   }
-  if(!is.null(title)){
+  if((title=="")){
     gt <- textGrob(title,gp=gpar(fontsize=20, fontface="italic"))
-    g <- gtable_add_rows(g, heights = grobHeight(gt)*1.5, pos = 0)
+#   g <- gtable_add_rows(g, heights = grobHeight(gt)*1.5, pos = 0)
     g <- gtable_add_grob(g, gt, 1, 1, 1, ncol(g))
   }
   g <- gtable_add_padding(g, unit(0.3, "cm"))
@@ -540,9 +540,9 @@ plot_regional_assoc <- function(recombination.plot, marker.plot, title){
   g <- gtable_add_cols(g, g1$widths[g1$layout[ia, ]$l], length(g$widths) - 1)
   g <- gtable_add_grob(g, list(textGrob("Recomb. Rate", rot = -90, gp = gpar(col="black", fontsize=14))), pp$t, length(g$widths) - 1, pp$b)
   gt <- textGrob(title,gp=gpar(fontsize=16, fontface="italic"))
-  g <- gtable_add_rows(g, heights = grobHeight(gt)*1.5, pos = 0)
+# g <- gtable_add_rows(g, heights = grobHeight(gt)*1.5, pos = 0)
   g <- gtable_add_grob(g, gt, 1, 1, 1, ncol(g))
-  g <- gtable_add_padding(g, unit(0.3, "cm"))
+# g <- gtable_add_padding(g, unit(0.3, "cm"))
   return(g)
 }
 
@@ -597,9 +597,9 @@ plot_regional_gene_assoc <- function(recombination.plot, marker.plot, gene.plot,
   if(ngenes>5 & ngenes<=10){g$heights[panels[2]] <- unit(1.8,"null")}
   if(ngenes>10){g$heights[panels[2]] <- unit(2.5,"null")}
   gt <- textGrob(title,gp=gpar(fontsize=16, fontface="italic"))
-  g <- gtable_add_rows(g, heights = grobHeight(gt)*1.5, pos = 0)
+# g <- gtable_add_rows(g, heights = grobHeight(gt)*1.5, pos = 0)
   g <- gtable_add_grob(g, gt, 1, 1, 1, ncol(g))
-  g <- gtable_add_padding(g, unit(0.3, "cm"))
+# g <- gtable_add_padding(g, unit(0.3, "cm"))
   return(g)
 }
 
@@ -716,6 +716,7 @@ stack_assoc_plot <- function(markers, z, corr=NULL, corr.top=NULL, traits, ylab=
     if(i==length(traits)){g <- plot_regional_gene_assoc(recombination.plot, marker.plot, gene.plot, traits[i], ngenes)}
     if(i<length(traits)){
       g1 <- plot_regional_assoc(recombination.plot, marker.plot, traits[i])
+      g1$heights <- unit(2, "null")
       g <- gtable:::rbind_gtable(g1, g, "last")
       panels <- g$layout$t[grep("panel", g$layout$name)]
       g$heights[panels[1]] <- unit(3,"null") 
```
