# --- save_as_feather ---
# 
# @autor: Sergio Martí
# @date: 29/11/22

#
# "Feather" (y más en concreto "arrow") es una librería que permite transferir
# dataframes y objetos entre R y python
#
# Además, Feather es un formato de archivo binario rápido, liviano y fácil de
# usar para almacenar dataframes. Algunos de sus objetivos de diseño son:
#
# - API mínima y liviana: la inserción y extracción de dataframes en la memoria
# debe ser lo más simple posible
#
# - Independiente del lenguaje: los archivos ".feather" son siempre iguales, da
# igual que se hayan guardado desde Python o R. A parte, otros lenguajes también
# pueden leer y escribir archivos Feather.
#
# - Lectura y escritura de alto rendimiento: siempre que sea posible, las
# operaciones con archivos Feather estarán limitadas por el rendimiento del
# disco local.
#
# @see: https://posit.co/blog/feather/
# @see: https://arrow.apache.org/docs/python/feather.html
# @see: https://github.com/wesm/feather
#

# --- FUNCIONAMIENTO ---
#
# Cambiar el valor de la variable "sObj" por el nombre del dataframe que se
# encuentre cargado en el entorno de R en ese momento. Se guardará en el
# directorio de trabajo actual. Se puede comprobar el directorio de trabajo
# actual con "getwd()".

# Instalamos, si no lo está, la librería feather
if (!require("feather", quietly = TRUE)) {
  install.packages("feather")
}

# Instalamos, si no lo está, la librería arrow
if (!require("arrow", quietly = TRUE)) {
  install.packages("arrow")
}

# Cargar la librería arrow
library(arrow)

# El nombre del objeto que se quiere guardar
sObj <- "countData"

# Añado a cada nombre de objeto, la extensión ".feather"
sObjName <- paste(c(sObj, "feather"), collapse = ".")

# Guardamos el objeto extensión feather
write_feather(get(sObj), sObjName)

rm(sObj, sObjName)
