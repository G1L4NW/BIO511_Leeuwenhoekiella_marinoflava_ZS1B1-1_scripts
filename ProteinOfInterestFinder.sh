#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J find_proteins_of_interest
#SBATCH -p vera  
#SBATCH -N 1 -c 1
#SBATCH -t 0:01:00
#SBATCH --output=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/Alvin/find_proteins_of_interest_%j.out
#SBATCH --error=/cephyr/NOBACKUP/groups/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/logs/Alvin/find_proteins_of_interest_%j.err

# Set paths
RESULTS_PATH="/cephyr/users/hiddew/Vera/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/results/annotation/proteins_of_interest"
GENOMIC_ANNOTATION="/cephyr/users/hiddew/Vera/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/results/annotation/prokka_curated_Hidde/assembly_curated_2.ffn" # The annotated ZS1B1-1 genome for input
PatternsOfInterest="/cephyr/users/hiddew/Vera/n2bin_gu/students/Hidde/leeuwenhoekiela_marinara/script/PatternsOfInterest2.txt" # Gene name patterns of interest. Put your keywords into this text-file 

# Creating file for proteins with interesting names
cat > ${RESULTS_PATH}/ProteinsOfInterest.txt << 'EOF'
Protein names matching pattern of interest:

EOF

# Creating tab-separated file for summary of different annotation features
cat > ${RESULTS_PATH}/AnnotationSummary.tsv << 'EOF'
Annotation_feature  Number_of_feature
EOF

# Checking whether any annotations in the .ffn-file have names containing a pattern of interest, which are found in the "PatternsOfInterest". If so, 
# add its name to the file "ProteinsOfInterest.txt".
while IFS= read -r pattern; do
    NumberOfFeature=0
    NumberOfFeature=$(grep -c "${pattern}" $GENOMIC_ANNOTATION)

    # Checking for prevalence of proteins of interest
    if [[ $pattern != "tRNA-...(...)$" ]] && [[ $pattern != "rRNA" ]] && [[ $pattern != "23S rRNA" ]] && [[ $pattern != "16S rRNA" ]]; then
        echo "'${pattern}': ${NumberOfFeature} hits in annotated ZS1B1-1 genome" >> ${RESULTS_PATH}/ProteinsOfInterest.txt
        grep -i "${pattern}" $GENOMIC_ANNOTATION >> ${RESULTS_PATH}/ProteinsOfInterest.txt
        echo "" >> ${RESULTS_PATH}/ProteinsOfInterest.txt
    fi

    # Checking how many instances of common annotation patterns are found in the .ffn-file.
    if [[ $pattern == "tRNA-...(...)$" ]] || [[ $pattern == "rRNA" ]] || [[ $pattern == "23S rRNA" ]] || [[ $pattern == "16S rRNA" ]] || [[ $pattern == "hypothetical protein" ]] || [[ $pattern == "putative protein" ]]; then
        if [[ $pattern == "tRNA-...(...)$" ]]; then
            echo -e "tRNA\t${NumberOfFeature}" >> ${RESULTS_PATH}/AnnotationSummary.tsv
        else
            echo -e "${pattern}\t${NumberOfFeature}" >> ${RESULTS_PATH}/AnnotationSummary.tsv
        fi
    fi
done < $PatternsOfInterest

echo -e "Coding domain sequences\t$(grep -c "^>" ${GENOMIC_ANNOTATION})"  >> ${RESULTS_PATH}/AnnotationSummary.tsv