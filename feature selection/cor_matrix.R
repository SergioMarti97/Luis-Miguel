# --- CÓDIGO MATRIZ DE CORRELACIÓN --- #

# --- LIBRERIAS --- #

# Instalar, si no lo está, la librería float
if (!require("float", quietly = TRUE)) {
  install.packages("float")
}

# Instalar, si no lo está, la librería memuse
if(!require("memuse", quietly = TRUE)) {
  install.packages("memuse")
}

# --- ADQUISICIÓN DE LO DATOS --- #
# Modificar aquí para lo que se quiera
df <- readRDS("./feature selection/serialized objects/dfCountData500HighestVar.RDS")
sOutputDir <- "./feature selection/serialized objects"
sOutputFile <- "mCor500HighestVar.RDS"

# --- MEMORIA --- #
# Comprobar que hay suficiente memoria disponible

gc()

memoryAvailable <- memuse::Sys.meminfo()
memoryAvailable <- memoryAvailable[["freeram"]]
memoryAvailable <- slot(memoryAvailable, "size")

memoryNeded <- memuse::howbig(ncol(df) * ncol(df), unit = "gib", type = "float")
memoryNeded <- slot(memoryNeded, "size")

if (memoryNeded < memoryAvailable) {
  
  rm(memoryAvailable, memoryNeded)
  
  # Aplicamos la función "cor()" para obtener la matriz de correlaciones
  mCorLight <- float::fl(cor(df))
  
  # Borramos el dataframe con el que se ha generado la matriz
  rm(df)
  
  # La matriz generada es muy grande y pesada, guardar directamente
  saveRDS(mCorLight, file.path(sOutputDir, sOutputFile))
  
  # Eliminar el objeto
  rm(mCorLight)
  
  # Eliminar memoria sin uso
  gc()
  
} else {
  sprintf("No hay suficiente memoria RAM para guardar la matriz. Ocupará: %.3f", memoryNeded)
}
