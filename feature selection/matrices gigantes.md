# Matrices de correlación gigantes

## El problema

La matriz de correlación resultante al trabajar con 32.714 características tendría 1.070.205.796 elementos, que al estar codificados como valores de coma flotante de doble precision (64 bits o 8 bytes), ocupa 8,6GB en memoría (RAM). Este tamaño de la matriz vuelve inviable realizar cualquier trabajo. [link](https://stackoverflow.com/questions/1053928/very-large-matrices-using-python-and-numpy)

## Optimización rápida y sencilla en R

Sin embargo, no es del todo posible trabajar con matrices de este tamaño. Es necesario una máquina potente (al menos 32GB de RAM) y usar tipos de coma flotante de precisión simple (32bits o 4 bytes). Esto reduce el tamaño del objeto a la mitad (4.3GB).

La librería "float" introduce una función "fl()", la cual, transforma los datos guardados como *float* 64bits de doble precisión (también llamados *double*) a *float* 32bits de precisión simple (también llamados *float* a secas).

La diferencia de precisión es que los *float* tienen 7 cifras decimales y los *double* tienen 15 cifras. Para el trabajo que se requiere en este caso, 7 cifras son más que suficientes.

## Optimización teórica

### "Binarizar" la matriz de correlación

Una optimización para reducir más el tamaño en memoria de la matriz, sería binarizar el contenido. La correlación toma valores entre -1 y 1. Si toma valor 0, no hay relación, 1 hay una relación directamente proporcional y -1 una relación inversamente proporcional. [link](https://www.tutorialspoint.com/how-to-convert-a-matrix-to-binary-matrix-in-r)

Si se aplica una transformación a los datos de la matriz, con la cual, se "binarizan" los valores decimales y se convierten en 0, 1 y -1, se puede ahorrar mucha más memoría. Además, existen librerías que estan pensadas con proposito: permiten mantener en memoria matrices muy grandes siempre que sean binarias, ya que los trozos de la matriz que sean 0, directamente no se almacenan. [link 1](https://docs.scipy.org/doc/scipy/reference/sparse.html) [link 2](https://docs.h5py.org/en/stable/faq.html#what-s-the-difference-between-h5py-and-pytables) [link](https://en.wikipedia.org/wiki/Sparse_matrix)

Estas librerías utilizan un truco, ya que almacenan solamente la posición "fila"/"columna" de los elementos de la matriz con valor 1. Esto reduce drásticamente la información, ya que de esta forma no se tienen que guardar todos los elementos de la matriz.

Conociendo este funcionamiento, se podría eliminar la mitad de la matriz de correlación ya que contiene datos repetidos (de la diagonal hacia abajo, incluida la diagonal). Esto reduciría a más de la mitad su tamaño.

Al ser una matriz ahora "binaria", no se debe de confundir con matrices de atributos binarios. Esta explicación es un "truco" para trabajar con matrices de correlación de variables continuas. En las matrices de atributos binarios no se puede aplicar la correlación, ya que las variables no son continuas. En esos casos, se deben de aplicar índices de similitud, como el índice de Jacard. [link](https://stackoverflow.com/questions/45459411/how-to-calculate-correlation-matrix-between-binary-variables-in-r)

### Optimizar el tipo de dato

#### La posición

La posición, dos valores enteros, se pueden almacenar como dos valores *int* (32bits o 4 bytes). Sin embargo, el tipo *int* se puede substituir por *short*, más liviano (16bits o 2 bytes). 

*int* y *short* están pensados para almacenar números negativos. Dado que los índices de una matriz núnca serán negativos (tomando como referencia que el primer elemento tiene índices 0,0), se pueden usar sus versiones sin signo: *uint32_t* (de 0 a 4.294.967.295) y *uint16_t* (de 0 a 65.535). No ocupan menos espacio en memoria pero sí toman un rango de valores mayor al encontrase dentro del conjunto de enteros positivos, permitiendo más filas y más columnas.

Hilando muy fino, y solamente aplicable en casos donde las dimensiones de la matriz sean inferiores a 32.768 por 32.768 (nuestro caso: 32.714 por 32.714), se podría utilizar un solo entero tipo *uint16_t* para guardar la posición fila y columna. Esto reduciría a la mitad la parte de la posición.

También se podrían utilizar tipos extraños como *uint24_t* (si existe ese tipo, pero es poco probable). [link](https://docs.oracle.com/cd/E19253-01/819-6957/chp-typeopexpr-2/index.html)

#### El valor

El valor (-1, 0 o 1), se puede almacenar también como un entero *int*, o con el tipo más reducido *char* (8 bits o 1 byte). Aunque, con medio y un cuarto de byte bastaría (2 bits: uno para el signo y el otro para 0 o 1).

#### La estructura

Para cada dato, se debería de almacenar una estructura con: 2 enteros y 1 entero pequeño. En C++ existe un tipo de estructura llamada "*union*" que reserva espacio para almacenar al elemento más grande, que sería la estructura ideal para este caso. [link](https://en.cppreference.com/w/cpp/language/union)

### Ejemplo teorico

Aplicando esta teoría, tendríamos: almacenando 1.070.205.796 elementos codificados en 32 bits, corresponderían con 4.28GB. Si se aplica una binarización con un *threshold* de 0,5 (> 0,5 = 1; <= 0.5 = 0; lo mismo con -1) supondría una reducción variable, ya que depende de los datos de la matriz. Suponiendo un caso poco favorable de una reducción del 20%. Teniendo en cuenta que no se guarda la mitad de la matriz, y que se utiliza dos *uint16_t* más un *char* para cada elemento, ocuparía en memoria un poco más de 0.54GB o 535MB (reducción >80%). Suponiendo el mismo caso desfavorable pero usando la excepción de usar solo un *uint16_t* y 2 bits para cada valor, ocuparía en memoria 0.24GB o 241MB (reducción ~95%). Es decir, se ocuparía la 20 parte de la memoria.

### Optimización por bloques

Otra optimización posible, es generar grupos: partir la matriz en sub-matrices de n*n elementos (siempre que n < ncol y n < nrow) y aplicar la media aritmética. El resultado sería el elemento que ocuparía la posición (i,j) de la sub-matriz en la matriz grande. Esto reduciría la matriz original dividiendo el número de columnas y el número de filas entre "n" (reducción cuadrática).

Esta vía es útil por ejemplo, para representar gráficamente la matriz. Una matriz de 100.000 filas por 100.000 columnas en la que cada elemento se representase como un pixel correspondería a un gráfico de 0,1Mpx. Para poder visualizar un mapa de calor mejor, este tipo de aproximación puede ser útil.

### Partir la matriz en sub-matrices

Sin embargo, para matrices monstruosamente gigantes; por ejemplo, miles de millones de filas por miles de millones de filas; no habría más remedio que partir la matriz en submatrices y trabajar con ellas. De momento, no existe ordenador en la tierra con millones de terabytes de memoría RAM. Quizás en un futuro.