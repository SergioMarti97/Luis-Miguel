# @see: https://medium.com/@saurav12das/correlation-plots-in-r-b392056a2ce

# --- ADQUISICIÓN DE LO DATOS --- #
# Modificar aquí para lo que se quiera
df <- readRDS("./feature selection/serialized objects/dfCountDataHighVar.RDS")

mCor <- cor(df)

library(reshape2)
dfCor <- melt(replace(mCor, lower.tri(mCor, TRUE), NA), na.rm = TRUE)
dfCor <- dfCor[order(dfCor$value, decreasing = TRUE),]

library(ggplot2)

ggplot(dfCor, aes(x = Var1, y = Var2, color = value)) + 
  scale_colour_gradient2() +
  geom_tile() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

