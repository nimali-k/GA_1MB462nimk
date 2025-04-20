#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 00:20:00
#SBATCH -J fastqc_20250707
#SBATCH --mail-type=ALL
#SBATCH --mail-user nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools/FastQC/0.11.9

#input directory 
#export INPUT_DIR=/home/nimkup/GA_1MB462nimk/project_data/reads/ 

#output directory 
#export OUTPUT_DIR=/home/nimkup/GA_1MB462nimk/fastqc_long

#set java options to increase heap size 
#export FASTQC_JAVA_OPTIONS="-Xmx4G" # set java heap size to 4 GB

#for i in {};
#do
	fastqc -t 4 -o /home/nimkup/GA_1MB462nimk/fastqc_long /home/nimkup/GA_1MB462nimk/project_data/reads/chr3_illumina_R2.fastq.gz

#done 
