#!/bin/bash
#SBATCH --job-name=dorado_basecall
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --ntasks=1
#SBATCH --mem=128GB
#SBATCH --time=48:00:00
#SBATCH --output=dorado.%J.log

set -euo pipefail

BASE_DIR="$(pwd)"
SAMPLE_NAME="$(basename "$BASE_DIR")"

# Update these as needed for your environment
MODEL="${MODEL:-dna_r10.4.1_e8.2_400bps_sup@v5.2.0}"
DORADO="${DORADO:-dorado}"

TMP_DIR="$BASE_DIR/temp_fastq_runs"
MERGED_FASTQ="$BASE_DIR/${SAMPLE_NAME}.fastq"

mkdir -p "$TMP_DIR"

echo "Starting Dorado basecalling in: $BASE_DIR"
echo "Temporary FASTQs: $TMP_DIR"
echo "Final merged FASTQ: $MERGED_FASTQ"
echo "Running on host: $(hostname)"
echo "Job ID: ${SLURM_JOB_ID:-not_set}"
echo "Start time: $(date)"
nvidia-smi || true

for RUN_DIR in "$BASE_DIR"/*; do
    [ -d "$RUN_DIR" ] || continue

    POD5_DIR="$RUN_DIR/pod5"
    RUN_NAME="$(basename "$RUN_DIR")"
    OUT_FILE="$TMP_DIR/${RUN_NAME}.fastq"

    if [ ! -d "$POD5_DIR" ]; then
        echo "Skipping $RUN_DIR (no pod5 directory found)"
        continue
    fi

    echo "Processing: $POD5_DIR"

    "$DORADO" basecaller \
        --device cuda:0 \
        -r \
        --emit-fastq \
        "$MODEL" \
        "$POD5_DIR" > "$OUT_FILE"

    echo "Finished: $RUN_NAME"
done

echo "Merging FASTQs into: $MERGED_FASTQ"
cat "$TMP_DIR"/*.fastq > "$MERGED_FASTQ"

echo "Cleaning up temporary FASTQs..."
rm -rf "$TMP_DIR"

echo "All runs complete."
echo "End time: $(date)"