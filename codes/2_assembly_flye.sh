#!/bin/bash -l 
#SBATCH -A uppmax2025-3-3 
#SBATCH -M snowy 
#SBATCH -p core 
#SBATCH -n 16  
#SBATCH -t 16:00:00 
#SBATCH -J assembly_20250405 
#SBATCH --mail-type=ALL 
#SBATCH --mail-user nimali-madushika.kularatne.3390@student.uu.se 
#SBATCH --output=%x.%j.out 

# Load modules 
module load bioinfo-tools Flye/2.9.5

# Your commands 
#ln -s /proj/uppmax2025-3-3/Genome_Analysis/4_Zhou_2023/reads/chr3_clean_nanopore.fq.gz
#ll -a 

flye --nano-raw /home/nimkup/genomeAnalysis/project_data/reads/chr3_clean_nanopore.fq.gz \
 --out-dir /home/nimkup/genomeAnalysis/out_nano_assembly --threads 16
