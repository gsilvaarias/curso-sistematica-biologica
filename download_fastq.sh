#!/bin/bash
# Descarga paralela de accesiones con fasterq-dump

set -euo pipefail

if [[ ! -f "accesiones.txt" ]]; then
    echo "Error: No se encontró accesiones.txt"
    exit 1
fi

mkdir -p 00_raw_reads

# --- Configuración de paralelismo ---
TOTAL_CPUS=$(nproc)
JOBS=4
THREADS_PER_JOB=$(( TOTAL_CPUS / JOBS ))
[[ $THREADS_PER_JOB -lt 1 ]] && THREADS_PER_JOB=1

export THREADS_PER_JOB

procesar_accesion() {
    local ACC="$1"
    local NEW_NAME="$2"
    local OUTDIR="00_raw_reads"

    # --- Saltar si ya existen los archivos finales ---
    if [[ -f "${OUTDIR}/${NEW_NAME}_R1.fq.gz" && -f "${OUTDIR}/${NEW_NAME}_R2.fq.gz" ]]; then
        echo "[$ACC] Ya existen ${NEW_NAME}_R1.fq.gz y ${NEW_NAME}_R2.fq.gz, saltando..."
        return 0
    fi

    echo "[$ACC] Descargando -> $NEW_NAME (threads: $THREADS_PER_JOB)"

    fasterq-dump "$ACC" \
        --split-files \
        --threads "$THREADS_PER_JOB" \
        --outdir "$OUTDIR" \
        --temp "$OUTDIR" \
        --skip-technical

    if [[ -f "${OUTDIR}/${ACC}_1.fastq" && -f "${OUTDIR}/${ACC}_2.fastq" ]]; then
        pigz -p "$THREADS_PER_JOB" "${OUTDIR}/${ACC}_1.fastq" "${OUTDIR}/${ACC}_2.fastq"
        mv "${OUTDIR}/${ACC}_1.fastq.gz" "${OUTDIR}/${NEW_NAME}_R1.fq.gz"
        mv "${OUTDIR}/${ACC}_2.fastq.gz" "${OUTDIR}/${NEW_NAME}_R2.fq.gz"
        echo "[$ACC] OK -> ${NEW_NAME}_R1.fq.gz / ${NEW_NAME}_R2.fq.gz"
    else
        echo "[$ACC] ADVERTENCIA: no se generaron ambos archivos" >&2
    fi
}
export -f procesar_accesion

parallel --colsep '\t' -j "$JOBS" procesar_accesion {1} {2} :::: accesiones.txt

echo "Descarga y renombrado completados."
