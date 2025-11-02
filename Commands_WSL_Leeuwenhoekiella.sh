## Programs and commands used in WSL UBUNTU
# FASTPLONG
fastplong -cut_front -cut_mean_quality 30 -l (50/80) --length_limit (90000/95000)
# MultiQC
conda activate MultiQC
multiqc --title "" --filename "" --dirs --dirsdepth x --force
#seqkit
seqkit rmdup -s -o merged_dedup.faa merged_raw.faa
# CD-HIT
cd-hit -i merged_dedup.faa -o curatedRef.faa -c 0.95 -n 5 -d 0 -T 2 -M 0