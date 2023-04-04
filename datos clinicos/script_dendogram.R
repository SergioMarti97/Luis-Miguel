library(tidyverse)
library(ggdendro)
library(dendextend)

dend_expr <- as.dendrogram(hcSurvival)

tree_labels <- dendro_data(dend_expr, type = "rectangle")

tree_labels$labels <- cbind(tree_labels$labels, cluster = fSurvival)

tree_labels$labels$label <- paste0(tree_labels$labels$label, ": ", round(lSurvival, 2), "w")

fSurvival[order(as.numeric(names(fSurvival)))]

ggplot() +
  geom_segment(data = segment(tree_labels), aes(x=x, y=y, xend=xend, yend=yend))+
  geom_segment(data = tree_labels$segments %>%
                 filter(yend == 0) %>%
                 left_join(tree_labels$labels, by = "x"), aes(x=x, y=y.x, xend=xend, yend=yend, color = cluster)) +
  geom_text(data = label(tree_labels), aes(x=x, y=y, label=label, colour = cluster, hjust=0), size=2) +
  coord_flip() +
  scale_y_reverse(expand=c(0.2, 0)) +
  #scale_colour_brewer(palette = "Dark2") + 
  theme_dendro() #+
  #ggtitle("Mayo Cohort: Hierarchical Clustering of Patients Colored by Diagnosis")
