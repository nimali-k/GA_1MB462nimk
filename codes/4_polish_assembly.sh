#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 06:00:00
#SBATCH -J pilon_polish
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se 
#SBATCH --output=/home/nimkup/genomeAnalysis/out/pilon_polish_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/pilon_polish_%j.err
#SBATCH --mem=16G

# Exit script on any error
set -e

# Load required modules
module load bioinfo-tools bwa/0.7.18 samtools/1.20 Pilon/1.24 

#input and output directories and files  

export assembly_file=/home/nimkup/genomeAnalysis/results/out_nano_assembly/assembly.fasta
export IN_FORWARD=/home/nimkup/genomeAnalysis/project_data/reads/chr3_illumina_R1.fastq.gz
export IN_REVERSE=/home/nimkup/genomeAnalysis/project_data/reads/chr3_illumina_R2.fastq.gz
export OUTPUT_POLISHING=/home/nimkup/genomeAnalysis/results/polishing/samtools_out/aligned.bam

bwa index $assembly_file

bwa mem -t 8 $assembly_file $IN_FORWARD $IN_REVERSE| samtools sort -@ 8 -T temp_sort -o $OUTPUT_POLISHING 


