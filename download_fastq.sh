#!/bin/bash

# Verifica si el archivo accesiones.txt existe
if [[ ! -f "accesiones.txt" ]]; then
    echo "Error: No se encontró accesiones.txt"
    exit 1
fi

# Crear un directorio para los archivos descargados
mkdir -p fastq_downloads
cd fastq_downloads

# Leer accesiones.txt línea por línea
while IFS=$'\t' read -r ACC NEW_NAME; do
    echo "Descargando $ACC y renombrándolo como $NEW_NAME"

# Descargar archivos FASTQ con fastq-dump
fastq-dump --split-files --gzip "$ACC"

# Verificar si los archivos se descargaron correctamente
if [[ -f "${ACC}_1.fastq.gz" && -f "${ACC}_2.fastq.gz" ]]; then
        # Renombrar los archivos según accesiones.txt
        mv "${ACC}_1.fastq.gz" "${NEW_NAME}_R1.fq.gz"
        mv "${ACC}_2.fastq.gz" "${NEW_NAME}_R2.fq.gz"
        echo "Archivos renombrados: ${NEW_NAME}_R1.fq.gz y ${NEW_NAME}_R2.fq.gz"
else
        echo "Advertencia: No se encontraron archivos para $ACC"
fi
done < ../accesiones.txt  # Leer el archivo desde el directorio padre

echo "Descarga y renombrado completados."

