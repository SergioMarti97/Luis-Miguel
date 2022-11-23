# Introducción, técnicas de análisis multivariante

El análisis multivariante (es decir, más de una variable) se utiliza en situaciones en las que se quieren estudiar: 
- Diversas variables conjuntamente.
- Las relaciones entre distintos grupos.

Incluye varias técnicas estadísticas, las cuales se pueden dividir en 3 grupos:

1) **Ajuste de modelos estadísticos**

Determina un modelo estadístico que se ajuste a una colección de datos observada.

2) **Reducción de datos**

Reducir el número de dimensiones para deshacerse de la información redundante y/o no relevante. Conocido como el "infierno de la Dimensionalidad". Podemos diferenciar dos grupos de técnicas: 

2.1) *Composición*

Transforma las variables observadas en otras no observadas. Estas variables no observadas, también llamadas Componentes Principales (PC), son resultado de una combinación de las variables observadas u originales.

2.1.1) Transformación Líneal

Las Componentes Principales (PC) resultan de la combinación líneal de las Variables Originales

2.1.1.1) Análisis de Componentes Principales (PCA)

2.1.2) Transformación No-líneal

Las Componentes Principales (PC) resultan de un algoritmo de reducción de la dimensionalidad no líneal. 

2.1.2.1) Uniform Manifold Approximation and Projection (UMAP)

Se utiliza mucho en estudios de Single-Cell.

2.1.2.2) t-distributed Stochastic Neighbor Embedding (tSNE)

2.2) *Selección*

@see: https://towardsdatascience.com/feature-selection-and-dimensionality-reduction-f488d1a035de

Selecciona las variables observadas u originales más importantes, deshaciendose de las menos relevantes.

2.2.1) Filtros
- Missing values/Valores incompletos
- Baja varianza
- Carácterísticas altamente correlacionadas
- Eliminación recursiva de características: Random Forest

2.2.2) Selección
- Selección de características univariantes
- 

3) **Clasificación**

Agrupa y ordena los individuos

3.1) Supervisado

- Naive Bayes: @see https://medium.com/datos-y-ciencia/algoritmos-naive-bayes-fudamentos-e-implementaci%C3%B3n-4bcb24b307f

3.2) No supervisado

---

3.1) Análisis de conglomerados

* Medidas de asociación/Cálculo de distancias:

3.1.1) Técnicas jerárquicas -> Clusttering jerárquico

3.1.1.1) Aglomerativo

3.1.1.2) Disociativo

3.1.2) Técnicas divisivas/de partición -> K-means