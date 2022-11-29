# --- script_save_as_feather ---
# 
# @autor: Sergio Martí
# @date: 29/11/22

# --- FUNCIONAMIENTO ---
#
# Pasar por parámetro el nombre del dataframe que encuentre cargado en el
# entorno de R en ese momento y que se quiera guardar. Indicar como segundo
# argumento la dirección (relativa o absoluta) donde se quiere guardar el
# objeto. Si no se índica, se guardará en el directorio de trabajo actual. Se
# puede comprobar el directorio de trabajo actual con "getwd()".

args = commandArgs(trailingOnly = TRUE)

if (length(args) > 0) {
  # Instalamos, si no lo está, la librería arrow
  if (!require(arrow, quietly = TRUE)) {
    install.package(arrow)
  }
  
  # Cargar la librería arrow
  library(arrow)
  
  # El nombre del objeto que se quiere guardar
  sObj <- args[1]
  
  # Añado a cada nombre de objeto, la extensión ".feather"
  sObjName <- paste(c(sObj, "feather"), collapse = ".")
  
  if (length(args) == 2) {
    # Añado la dirección donde se quiere guardar
    sObjName <- paste(c(args[2], sObjName), collapse = "/")
  }
  
  # Guardamos el objeto extensión feather
  feather::write_feather(get(sObj), sObjName)
  
  rm(sObj, sObjName)
  
} else {
  sprintf("Número incorrecto de parámetros")
}

