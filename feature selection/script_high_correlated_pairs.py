# ----------------------------- #
# ----------- SCRIPT ---------- #
# --- HIGH CORRELATED PAIRS --- #
# ----------------------------- #
#
# @autor: Sergio Martí
# @date: 30/11/22 - 01/12/22
#
# Parámetros:
# - Matriz de correlación: archivo .feather, dirección absoluta
# - Lista de variables: archivo .feather, dirección absoluta
# - Directorio de salida: dirección absoluta
#
# - Límite/threshold para la correlación
#
# Funcionamiento:
# Genera un directorio de salida, donde se guardan listas de parejas de variables altamente correlacionadas como ".csv"
#

# --- LIBRERÍAS --- #
import sys
import re
import numpy as np
import pandas as pd
import pyarrow.feather as pa
from tabulate import tabulate

# --- CONSTANTES --- #
MAX_DIM = 10000
NUM_CHUNKS = 10
DF_HEADER = ["Var 1", "Var 2", "corr"]


# --- FUNCIONES --- #
def is_feather_file(file_path):
    """
    Comprueba si un archivo es un archivo .feather
    :param file_path: la dirección y nombre del archivo
    :return: true/false si es un archivo .feather o no
    """
    return re.match("/*\\.feather", file_path)


def get_evenly_divided_values(value_to_be_distributed, times):
    """
    Esta función sirve para obtener el tamaño de los chunks
    :param value_to_be_distributed: el valor a dividir en partes iguales
    :param times: el número de veces que se quiere dividir
    :return: una lista con las partes iguales
    """
    return [value_to_be_distributed // times + int(x < value_to_be_distributed % times) for x in range(times)]


def obtain_high_correlated_pairs(mat, t, feature_names, s_row, e_row, s_col, e_col):
    """
    Esta función devuelve una lista de pares correlacionados. Esta pensada para trabajar con submatrices dentro de una
    matriz muy grande
    :param mat: matriz de correlación
    :param t: threshold/limite para filtrar las parejas según su correlación
    :param feature_names: lista con los nombres de las variables
    :param s_row: start row, primera fila a partir de la que trabajar
    :param e_row: end row, última fila con la que trabajar
    :param s_col: start column, primera columna a partir de la que trabajar
    :param e_col: end column, última columna con la que trabajar
    :return: una lista de listas, con los pares correlacionados. "gen 1", "gen2", "correlación"
    """
    pair_list = list()
    pair_count = 0

    for i_row in range(e_row - s_row):
        for i_col in range(e_col - s_col):
            real_col = (i_col + s_col)
            real_row = (i_row + s_row)
            c = mat[real_row, real_col]
            if real_row != real_col and c != 0 and c * c >= t * t:
                e = list()
                e.append(feature_names[real_row])
                e.append(feature_names[real_col])
                e.append(c)
                pair_count += 1

                pair_list.append(e)

    return pair_list, pair_count


def process_big_matrix(mat, n_chunks):
    """
    Procesar una matriz muy grande
    :param mat: la matriz de correlación
    :param n_chunks: el número de trozos de filas y columnas a dividir la matriz
    :return el número de parejas encontradasc
    """
    count = 0

    n_chunks_x = n_chunks
    n_chunks_y = n_chunks
    print(f"Se dividirá:\n- Las filas en {n_chunks_x} \"trozos\"\n- Las columnas en {n_chunks_y} \"trozos\"")

    row_slices = get_evenly_divided_values(n_rows, n_chunks_x)
    col_slices = get_evenly_divided_values(n_cols, n_chunks_y)
    print(f"Tamaño \"trozos\" filas {row_slices}\nTamaño \"trozos\" columnas {col_slices}")

    for x_chunk in range(n_chunks_x):
        for y_chunk in range(n_chunks_y):
            if x_chunk <= y_chunk:  # triangulo superior, diagonal incluido
                rows_by_chunk = row_slices[x_chunk]
                cols_by_chunk = col_slices[y_chunk]

                offset_rows = x_chunk * rows_by_chunk
                offset_cols = y_chunk * cols_by_chunk

                s_row = offset_rows
                e_row = offset_rows + rows_by_chunk

                s_col = offset_cols
                e_col = offset_cols + cols_by_chunk

                m = mat[s_row:e_row, s_col:e_col]

                if x_chunk == y_chunk:  # diagonal
                    m = np.triu(m)

                print(f"Sub-Matriz: {x_chunk}x {y_chunk}y")

                biglist, num_entries = obtain_high_correlated_pairs(
                    m,
                    threshold,
                    gene_names,
                    s_row,
                    e_row,
                    s_col,
                    e_col)
                count += num_entries

                df = pd.DataFrame(biglist, columns=DF_HEADER)
                df = df.sort_values(DF_HEADER[-1], ascending=False)

                print(f"Pares: {num_entries}")
                print(tabulate(df.head()))

                print("Guardando información")
                df.to_csv(output_dir + '\\' + f"high_correlated_pairs_{x_chunk}x_{y_chunk}y.csv")
                print("# " + '-~' * 25 + " #")

    return count


def process_matrix(mat):
    """
    Procesar una matrix pequeña
    :param mat: la matriz
    :return: el número de parejas encontradas
    """
    count = 0

    mat = np.triu(mat)

    biglist, num_entries = obtain_high_correlated_pairs(
        mat,
        threshold,
        gene_names,
        0,
        mat.shape[0],
        0,
        mat.shape[1])
    count += num_entries

    df = pd.DataFrame(biglist, columns=DF_HEADER)
    df = df.sort_values(DF_HEADER[-1], ascending=False)

    print(f"Pares: {num_entries}")
    print(tabulate(df.head()))

    print("Guardando información")
    df.to_csv(output_dir + '\\' + f"high_correlated_pairs.csv")
    print("# " + '-~' * 25 + " #")

    return count


# --- CÓDIGO --- #
if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("El número de parámetros es incorrecto")
    else:
        # --- ADQUIRIR DATOS --- #
        mat_cor = None
        if is_feather_file(sys.argv[0]):
            mat_cor = pa.read_feather(sys.argv[0])
            mat_cor = mat_cor.to_numpy()
        else:
            print(f"El archivo {sys.argv[0]} no tiene la extensión .feather")

        gene_names = None
        if is_feather_file(sys.argv[1]):
            gene_names = pa.read_feather(sys.argv[1])
            gene_names = gene_names["lHighVarGenes"].tolist()
        else:
            print(f"El archivo {sys.argv[1]} no tiene la extensión .feather")

        output_dir = None
        if isinstance(sys.argv[2], str):
            output_dir = sys.argv[2]
        else:
            print(f"La ubicación {sys.argv[2]} no es correcta")

        threshold = None
        try:
            if int(sys.argv[3]) <= 1:
                threshold = int(sys.argv[3])
            else:
                print(f"El valor del threshold ({int(sys.argv[3])}) debe de estar entre 0 y 1")
        except ValueError:
            print(f"El parámetro {sys.argv[3]} no es número")

        if None not in (mat_cor, gene_names, output_dir, threshold):
            n_rows, n_cols = mat_cor.shape
            print(f"Matriz de dimensiones: {n_rows} filas por {n_cols} columnas")
            num_pairs = 0
            if n_rows >= MAX_DIM and n_cols >= MAX_DIM:
                print("Dimensiones de la matriz demasiado grandes")
                num_pairs = process_big_matrix(mat_cor, NUM_CHUNKS)
            else:
                num_pairs = process_matrix(mat_cor)

            print(f"Número de parejas de variables detectadas: {num_pairs}")
            print(f"Se pueden eliminar {np.sqrt(num_pairs)} variables")
