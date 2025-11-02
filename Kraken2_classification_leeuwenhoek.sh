#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J kraken2_job
#SBATCH -p vera
#SBATCH -N 1 -c 12 # Request 1 node with 12 CPUs
#SBATCH -t 01:00:00
#SBATCH --output=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/kraken2/kraken2_%j.out  # Standard output
#SBATCH --error=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/kraken2/kraken2_%j.err   # Standard error

# Set paths - ADJUST THESE TO YOUR ACTUAL PATHS
CONTAINER_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/kraken2.sif"
DB_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/ref_dbs/kraken2db"
DATA_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/data/fastq"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/results/kraken2"

# Bind paths for container
export SINGULARITY_BINDPATH="${DB_PATH}:/db,${DATA_PATH}:/data,${RESULTS_PATH}:/results"

# Create results directory
# mkdir -p ${RESULTS_PATH}

for sample_file in ${DATA_PATH}/ZS1B1-1_cat_tryout_no.fastq.gz; do
    basename_sample=$(basename ${sample_file} .fastq.gz)
    echo "Found data file: ${basename_sample}"
    srun singularity exec ${CONTAINER_PATH} kraken2 \
        --db /db \
        --threads 12 \
        --output /results/${basename_sample}_kraken2_output.txt \
        --report /results/${basename_sample}_kraken2_report.txt \
        --classified-out /results/${basename_sample}_classified#.fastq \
        --unclassified-out /results/${basename_sample}_unclassified#.fastq \
        /data/${basename_sample}.fastq.gz

echo "Completed classification for ${sample_file}"
done

echo "All samples processed successfully"


# # Identify sample
# sample="A210"
# echo "Processing sample: ${sample}"

# # Run Kraken2 classification
# srun singularity exec ${CONTAINER_PATH} kraken2 \
#         --db /db \
#         --threads 8 \
#         --paired \
#         --output /results/${sample}_kraken2_output.txt \
#         --report /results/${sample}_kraken2_report.txt \
#         --classified-out /results/${sample}_classified#.fastq \
#         --unclassified-out /results/${sample}_unclassified#.fastq \
#         /data/${sample}_R1.fastq.gz /data/${sample}_R2.fastq.gz

# echo "Completed classification for ${sample}"

# echo "All samples processed successfully"