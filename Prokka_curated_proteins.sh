#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J prokka_curated
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=8
#SBATCH -t 01:00:00
#SBATCH --output=/cephyr/users/hiddew/Vera/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/prokka/prokka_curated_%j.out # output log, adjust path to where you want to save logs
#SBATCH --error=/cephyr/users/hiddew/Vera/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/prokka/prokka_curated_%j.err # error log, adjust path to where you want to save logs

# Set paths - ADJUST THESE TO YOUR ACTUAL PATHS
CONTAINER_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/prokka.sif"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/results/annotation/prokka_curated_Hidde"
ASSEMBLIES_DIR="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/results/flye"
CURATED_PROTEINS="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/data/references/CuratedRef_Hidde.faa"
OUTPUT_DIR="${RESULTS_PATH}/annotation/"

# Bind paths for container
export SINGULARITY_BINDPATH="${ASSEMBLIES_DIR}:/assemblies,${RESULTS_PATH}:/results,${CURATED_PROTEINS}:/CuratedRef.faa"

# Create output directories
mkdir -p ${OUTPUT_DIR}

# Input assembly
ASSEMBLY="/assemblies/assembly.fasta"

# Set a prefix variable for naming outputs
PREFIX="$(basename ${ASSEMBLY} .fasta)_curated_3"

# Run Prokka (curated)
singularity exec ${CONTAINER_PATH} prokka \
  --cpus 8 \
  --force \
  --outdir /results \
  --prefix ${PREFIX} \
  --locustag Leeuwenhoekiella_Marinoflava \
  --genus Leeuwenhoekiella \
  --species Marinoflava \
  --proteins /CuratedRef.faa \
  ${ASSEMBLY}

echo "Curated Prokka annotation completed"