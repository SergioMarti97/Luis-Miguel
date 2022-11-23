# Función modificada de PCA del paquete DESeq2
#
# @author: Sergio Martí
# @date: 21/11/22
# @see https://www.biostars.org/p/243695/

## Modified plotPCA from DESeq2 package. Shows the Names of the Samples (the first col of SampleTable), and uses ggrepel pkg to plot them conveniently.
# @SA 10.02.2017

# Librerías necesarias
library(genefilter)
library(ggplot2)
library(ggrepel)

# Función
myPlotPCA <- function (object, intgroup = "condition", ntop = 500, returnData = FALSE) {
  
  object = vsdata
  ntop = 500
  intgroup = "Grade"
  
  # Extracción de PCs
  rv <- rowVars(assay(object))
  select <- order(rv, decreasing = TRUE)[seq_len(min(ntop, length(rv)))]
  pca <- prcomp(t(assay(object)[select, ]))
  percentVar <- pca$sdev^2/sum(pca$sdev^2)
  
  if (!all(intgroup %in% names(colData(object)))) {
    stop("the argument 'intgroup' should specify columns of colData(dds)")
  }
  
  intgroup.df <- as.data.frame(colData(object)[, intgroup, drop = FALSE])
  
  group <- if (length(intgroup) > 1) {
    factor(apply(intgroup.df, 1, paste, collapse = " : "))
  } else {
    colData(object)[[intgroup]]
  }
  
  # Generación de un dataframe con las PCs
  d <- data.frame(
    PC1 = pca$x[, 1], 
    PC2 = pca$x[, 2], 
    PC3 = pca$x[, 3],
    PC4 = pca$x[, 4], 
    group = group, 
    intgroup.df, 
    name = colData(dds)[,1])
  
  # Devolvemos el dataframe si es necesario
  if (returnData) {
    attr(d, "percentVar") <- percentVar[1:4]
    return(d)
  }
  
  # Gráfico
  ggplot(data = pcaData2, aes_string(x = "PC3", y = "PC4", color = "group", label = "name")) + 
    geom_point(size = 3) + 
    xlab(paste0("PC3: ", round(percentVar[3] * 100), "% variance")) + 
    ylab(paste0("PC4: ", round(percentVar[4] * 100), "% variance")) + 
    coord_fixed() + 
    geom_text_repel(size=3)
  
}
