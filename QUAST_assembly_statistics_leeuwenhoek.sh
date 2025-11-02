#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J quast_analysis
#SBATCH -p vera
#SBATCH -N 1 -c 4
#SBATCH -t 01:00:00
#SBATCH --output=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/quast/quast_%j.out
#SBATCH --error=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/quast/quast_%j.err

# Load or use containerized QUAST
CONTAINER_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/quast.sif"

# Set paths - ADJUST THESE TO YOUR ACTUAL PATHS
DATA_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/results/flye"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/results"
OUTPUT_DIR="${RESULTS_PATH}/quast"

# Set the path to the assemblies
ASSEMBLIES_DIR="${RESULTS_PATH}/flye"

# Bind paths for container
export SINGULARITY_BINDPATH="${ASSEMBLIES_DIR}:/assemblies,${OUTPUT_DIR}:/output"

# Create output directory
mkdir -p ${OUTPUT_DIR}

# Run QUAST on both assemblies
singularity exec ${CONTAINER_PATH} quast.py \
    -o ${OUTPUT_DIR} \
    --threads 4 \
    --plots-format png \
    --labels "Polished" \
    ${ASSEMBLIES_DIR}/assembly.fasta

echo "QUAST analysis completed"