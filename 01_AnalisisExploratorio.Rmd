---
title: "Analisis exploratorio datos Luis Miguel"
author: "Sergio Martí"
date: '2022-10-20'
output: html_document
editor_options: 
  markdown: 
    wrap: sentence
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Analisis exploratorio datos Luis Miguel

## Introducción

Luis Miguel Valor nos facilito un DataSet con datos de secuenciación de Illumina, procedentes de pacientes enfermos con cáncer cerebral de diferentes grados: grado II y grado IV (glioblastoma).

## Apuntes de la charla con Luis Miguel

Hipotesis de Miguel: en glioblastomas de bajo grado, hay una corregulación de genes.
Conforme el tumor se vuelve más agresivo, la corregulación se pierde, siendo esta pérdida el motivo de la agresividad.

Datos sobre el DataSet: - 28 muestras de pacientes enfermos con cáncer cerebral de diferentes grados.
- Muestras secuenciadas hace 2 años mediante Illumina.
- Se desconoce el tratamiento suministrado a los pacientes.
- Se conoce la posición donde se desarrollo el tumor.
- Los datos están full-seq de todo el exosoma.
Por lo tanto, aparecen todos los genes.
no solamente los genes que se poliadeninan en los procesos post-transcripcionales, sino también los demás genes.
Se hizo de esta forma para poder analizar la expresión de la histona H3.

Miguel explico que sería interesante estudiar los siguientes puntos: 1- *Redes de coexpresión*: comprobar si genes que regulan de forma parecida pertenecen a un mismo grupo funcional.
"WGCNA" es un paquete de bioconductor que puede servir para estudiar este aspecto.
2- *Profundiad de Lectura*: medir la profundidad de lectura.
La secuencación se llevo a cabo mediante Illumina (20-30 millones de **reads**).

¿Que es lo que hay que hacer?
- Completar el excel de Luis, con todas las variables.
- Buscar en el **paper** de Luis Miguel, todas las librerias utilizadas.
- Se pueden limpiar los **reads** de los pacientes con glioblastoma grado IV que tengan exceso de lecturas.
- Alinear los archivos fastq para obtener los archivos BAM.
Utilizar otros programas para el alineamiento, como la herramienta SALMON o STAR.
- Hacer un análisis de expresión diferencial, entre el grado II y el grado IV.
No hay un control como tal, de forma que los pacientes con un "**low-grade**" se tomarán de control.
Por lo tanto, mediante este experimento solo se podrán identificar los biomarcadores que conviertan un tumor poco agresivo en uno muy agresivo.
- Replantearse nuevas preguntas una vez analizados los datos.

## Trabajo para Camino

Camino tiene sospecha de que el análisis de Luis Miguel esta sesgado, ya que ha hecho el análisis con el fin de dar robustez a sus hipotesis sobre la histona HighK27.

Por ello, se va a realizar un gráfico de dispersion para los individuos y un Clusttering con todos los individuos presentes en el DataSet, sin tener en cuenta el sesgo de la histona HighK27.
Con el fin de comprobar si realmente el factor de la presencia de esta histona asegura una separabilidad entre los grupos.
Además, se probaran otros factores clínicos de los pacientes, facilitados por Luis Miguel, para estudiar si alguno de ellos tiene efecto sobre el grado del glioblastoma o la supervivencia.

El gráfico de dispersión de los individuos se puede realizar mediante un análisis de componentes principales, o mediante otro método de análisis de las relaciones entre los individuos como UMAP.
Para el Clusttering se va a realizar un Herarquical Clusttering y un Clusttering mediante K-Means.

Además, hay que preguntar a Luis Miguel lo siguiente: - En el data set de los datos clínicos de los pacientes ¿En que unidades está la supervivencia?
- ¿Sería posible conseguir los datos de supervivencia de los pacientes que pone "No-Data" (N.D.)?

# Enlaces consultados

Aquí están los enlaces consultados para realizar el análisis: - Galaxy y fastq: <https://galaxyproject.org/tutorials/ngs/> -
