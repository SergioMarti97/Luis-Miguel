
# Cargar countData como un dataframe
mCountData <- readRDS("./countData.RDS")
dfCountData <- as.data.frame(countData)
View(dfCountData)

# Cargar el dataframe de countData que se llevará a python
dfCountDataFeather <- read_feather("countData.feather")

# Cargar las varianzas obtenidas con skylearn en python
dfVarCountData <- read_feather("./t-SNE/variances.feather")
View(dfVarCountData)
table(dfVarCountData$var)

# Escalar los datos yo mismo
mTemp <- t(mCountData)
dfCountDataT <- as.data.frame(mTemp)

dfTemp <- dfCountDataT[,1:10]
View(dfTemp)

rm(mTemp, dfTemp)

# Escalar los datos con R
dfCountDataScaled <- as.data.frame(scale(dfCountDataT))

dfTemp <- dfCountDataScaled[,1:10]
View(dfTemp)

rm(dfTemp)

# Eliminar variables
rm(mCountData)
rm(dfCountDataT)
rm(dfCountDataScaled)
rm(dfTemp)