
# --- ADQUISICIÓN DE LO DATOS --- #
# Modificar aquí para lo que se quiera
df <- readRDS("./feature selection/serialized objects/dfCountData500HighestVar.RDS")

mCor <- round(cor(df), 3)

if (!require("ggplot2")) {
  install.packages("ggplot2")
}

library(ggplot2)

if (!require("ggcorrplot")) {
  install.packages("ggcorrplot")
}

library(ggcorrplot)

gCor <- ggcorrplot(mCor, 
                   hc.order = TRUE, 
                   type = "upper", 
                   outline.col = "white", 
                   show.legend = FALSE, 
                   tl.cex = 0) + 
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

gCor
