#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 00:30:00
#SBATCH -J trimming_20250410
#SBATCH --mail-type=ALL
#SBATCH --mail-user nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools trimmomatic/0.39

#P-paired
#UP-unpaired

export IN_FORWARD=/home/nimkup/GA_1MB462nimk/project_data/reads/chr3_illumina_R1.fastq.gz 
export IN_REVERSE=/home/nimkup/GA_1MB462nimk/project_data/reads/chr3_illumina_R2.fastq.gz
export OUT_FORWARD_P=/home/nimkup/GA_1MB462nimk/codes/trim_result/ch3_R1.trimmed_forward_paired.fastq.gz
export OUT_FORWARD_UP=/home/nimkup/GA_1MB462nimk/codes/trim_result/ch3_R1.trimmed_forward_unpaired.fastq.gz
export OUT_REVERSE_P=/home/nimkup/GA_1MB462nimk/codes/trim_result/ch3_R1.trimmed_reverse_paired.fastq.gz
export OUT_REVERSE_UP=/home/nimkup/GA_1MB462nimk/codes/trim_result/ch3_R1.trimmed_reverse_unpaired.fastq.gz


# Run Trimmomatic

trimmomatic PE -threads 4 $IN_FORWARD $IN_REVERSE \
$OUT_FORWARD_P $OUT_FORWARD_UP \
$OUT_REVERSE_P $OUT_REVERSE_UP \
ILLUMINACLIP:$TRIMMOMATIC_ADAPTERS/TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36

