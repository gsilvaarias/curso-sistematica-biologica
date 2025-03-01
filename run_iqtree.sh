#!/bin/bash

# Directorio base donde están los archivos fasta con los alineamientos
INPUT_DIR="04_alignments/03_trimmed/01_unfiltered_w_refs/01_coding_NUC/02_NT/"
# Directorio base donde quedan los archivos de salida de iqtree
OUTPUT_DIR="05_trees/"

# Verifica si la carpeta de salida existe, si no, la crea
if [[ ! -d "$OUTPUT_DIR" ]]; then
    echo "Creando directorio de salida: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

# Recorre todos los archivos dentro del directorio de alineamientos
for FILE_PATH in "$INPUT_DIR"*.fna; do
    FILE=$(basename "$FILE_PATH")  # Extrae solo el nombre del archivo
    
    echo "Procesando alineamiento en $FILE"
    
    # Ejecuta IQ-TREE en el archivo correspondiente
    ./iqtree2 -s "$FILE_PATH" -B 1000 -pre "$OUTPUT_DIR${FILE%.fna}"  # Quita la extensión .fna para evitar duplicaciones
    
    echo "Análisis completado para $FILE"
done

echo "Todos los análisis han finalizado."
