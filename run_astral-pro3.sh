#!/bin/bash

# Directorio donde están los archivos de árboles generados con IQ-TREE
INPUT_DIR="05_trees/"
OUTPUT_DIR="06_species_tree"

# Verifica si la carpeta de salida existe, si no, la crea
if [[ ! -d "$OUTPUT_DIR" ]]; then
    echo "Creando directorio de salida: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

# Archivo donde se concatenarán los árboles génicos
GENE_TREES_FILE="$OUTPUT_DIR/gene_trees.tre"

# Vacía el archivo antes de empezar (si ya existe)
> "$GENE_TREES_FILE"

# Recorre los archivos .treefile en el directorio de IQ-TREE y los concatena
for TREE_FILE in "$INPUT_DIR"*.treefile; do
    if [[ -f "$TREE_FILE" ]]; then
        cat "$TREE_FILE" >> "$GENE_TREES_FILE"
        echo "" >> "$GENE_TREES_FILE"  # Asegura un salto de línea entre árboles
    fi
done

echo "Árboles génicos concatenados en $GENE_TREES_FILE"

# Ejecuta ASTRAL-Pro 3 en C++ para inferir el árbol de especies
./astral-pro3 -i "$GENE_TREES_FILE" -o "$OUTPUT_DIR/species_tree.tre" -a mapping.txt -u 3

echo "Análisis completado. Árbol de especies guardado en $OUTPUT_DIR/species_tree.tre"

