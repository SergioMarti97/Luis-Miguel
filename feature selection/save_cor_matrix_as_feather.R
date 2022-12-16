# --- ADQUISICIÓN DE LO DATOS --- #
# Modificar aquí para lo que se quiera
sOutputDir <- "./feature selection/feather"
sOutputFile <- "mCor500HighestVar.feather"
mCor <- readRDS("./feature selection/serialized objects/mCor500HighestVar.RDS")

gc()

feather::write_feather(as.data.frame(mCor), file.path(sOutputDir, sOutputFile))

rm(mCor)
gc()
