#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J flye_polished
#SBATCH -p vera  
#SBATCH -N 1 --cpus-per-task=12
#SBATCH -t 02:30:00
#SBATCH --output=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/flye/flye_polished_%j.out
#SBATCH --error=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/flye/flye_polished_%j.err

# Set paths - ADJUST THESE TO YOUR ACTUAL PATHS
DATA_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/data/fastq"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/results/flye"
SINGULARITY_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/flye.sif"

# Set bind paths for Singularity
export SINGULARITY_BINDPATH="${DATA_PATH}:/data,${RESULTS_PATH}:/results"

# Set sample and output paths
ONT_READS="${DATA_PATH}/*.fastq.gz"
OUTPUT_DIR="${RESULTS_PATH}"

# Create output directories
mkdir -p ${OUTPUT_DIR}

# Run Flye assembly with basic settings
singularity exec ${SINGULARITY_PATH} flye --nano-raw /data/ZS1B1-1_cat_fastplong.fastq.gz \
     --out-dir /results \
     --threads 12 \
     --iterations 5

echo "Polished ONT assembly completed"