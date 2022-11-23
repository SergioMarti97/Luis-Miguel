# Este script ejecuta tximport para generar un dataframe con los datos de la 
# quantificación de los transcritos obtenidos con SALMON
#
# @see: https://bioconductor.org/packages/release/bioc/vignettes/tximport/inst/doc/tximport.html
# @see: https://support.bioconductor.org/p/123134/
#
# @autor: Sergio Martí
# @date: 23/11/22

# -~-~-~-~-~-~-~ #
# --- SCRIPT --- #
# -~-~-~-~-~-~-~ #

# Leer los argumentos
args <- commandArgs(trailingOnly = F)

if (length(args) == 3) {
  
  # ---------------------------------------- #
  # --- ASIGNAR LAS VARIABLES NECESARIAS --- #
  # ---------------------------------------- #
  sPathListQuantFiles <- args[1] # ubicación del archivo con la lista de los archivos quant.sf
  sPathTx2gene <- args[2] # ubicación del archivo tx2gene
  sPathOutput <- args[3] # archivo de salida
  
  # ------------------------------------------------ #
  # --- LEER "tx2gene" Y LISTA DE ARCHIVOS QUANT --- #
  # ------------------------------------------------ #
  
  # Leer la tabla tx2gene
  tx2gene <- read.csv(sPathTx2gene, header = FALSE, sep = "")
  # TODO lFiles
  lFiles <- list.dirs(sPathListQuantFiles, full.names = TRUE)
  
  # ----------------------------------------- #
  # --- INSTALAR PAQUETES DE BIOCONDUCTOR --- #
  # ----------------------------------------- #
  
  # SERÁN NECESARIOS
  # - BiocManager
  # - tximport
  
  # Instalar BiocManager. Solo lo instala si no esta instalado
  if (!require("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  
  # Instalar tximport. Solo lo instala si no esta instalado
  if (!require("tximport", quietly = TRUE)) {
    BiocManager::install("tximport")
  }
  
  # ---------------- #
  # --- IMPORTAR --- #
  # ---------------- #
  
  # Cargar la librería
  library(tximport)
  
  # La función tximport es la encargada de hacer todo el trabajo
  txi <- tximport(lFiles, type = "salmon", tx2gene = tx2gene)
  
  # ------------------------- #
  # --- GUARDAR COMO .rds --- #
  # ------------------------- #
  
  saveRDS(txi, file =  file.path(sPathOutput, "txi.rds"))
  
  # -~-~-~-~-~- #
  # -~- FIN -~- #
  # -~-~-~-~-~- #
  
  # Eliminar los objetos que ya no son necesarios en la sesion de R
  rm(lFiles, tx2gene, txi)
}
