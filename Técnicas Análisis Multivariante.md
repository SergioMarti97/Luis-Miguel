# Introducci�n, t�cnicas de an�lisis multivariante

El an�lisis multivariante (es decir, m�s de una variable) se utiliza en situaciones en las que se quieren estudiar: 
- Diversas variables conjuntamente.
- Las relaciones entre distintos grupos.

Incluye varias t�cnicas estad�sticas, las cuales se pueden dividir en 3 grupos:

1) **Ajuste de modelos estad�sticos**

Determina un modelo estad�stico que se ajuste a una colecci�n de datos observada.

2) **Reducci�n de datos**

Reducir el n�mero de dimensiones para deshacerse de la informaci�n redundante y/o no relevante. Conocido como el "infierno de la Dimensionalidad". Podemos diferenciar dos grupos de t�cnicas: 

2.1) *Composici�n*

Transforma las variables observadas en otras no observadas. Estas variables no observadas, tambi�n llamadas Componentes Principales (PC), son resultado de una combinaci�n de las variables observadas u originales.

2.1.1) Transformaci�n L�neal

Las Componentes Principales (PC) resultan de la combinaci�n l�neal de las Variables Originales

2.1.1.1) An�lisis de Componentes Principales (PCA)

2.1.2) Transformaci�n No-l�neal

Las Componentes Principales (PC) resultan de un algoritmo de reducci�n de la dimensionalidad no l�neal. 

2.1.2.1) Uniform Manifold Approximation and Projection (UMAP)

Se utiliza mucho en estudios de Single-Cell.

2.1.2.2) t-distributed Stochastic Neighbor Embedding (tSNE)

2.2) *Selecci�n*

@see: https://towardsdatascience.com/feature-selection-and-dimensionality-reduction-f488d1a035de

Selecciona las variables observadas u originales m�s importantes, deshaciendose de las menos relevantes.

2.2.1) Filtros
- Missing values/Valores incompletos
- Baja varianza
- Car�cter�sticas altamente correlacionadas
- Eliminaci�n recursiva de caracter�sticas: Random Forest

2.2.2) Selecci�n
- Selecci�n de caracter�sticas univariantes
- 

3) **Clasificaci�n**

Agrupa y ordena los individuos

3.1) Supervisado

- Naive Bayes: @see https://medium.com/datos-y-ciencia/algoritmos-naive-bayes-fudamentos-e-implementaci%C3%B3n-4bcb24b307f

3.2) No supervisado

---

3.1) An�lisis de conglomerados

* Medidas de asociaci�n/C�lculo de distancias:

3.1.1) T�cnicas jer�rquicas -> Clusttering jer�rquico

3.1.1.1) Aglomerativo

3.1.1.2) Disociativo

3.1.2) T�cnicas divisivas/de partici�n -> K-means