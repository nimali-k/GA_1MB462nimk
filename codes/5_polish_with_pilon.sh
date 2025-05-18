#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 06:00:00
#SBATCH -J polish_with_pilon
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/pilon_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/pilon_%j.err
#SBATCH --mem=16G

# Exit script on any error
set -e

# Load required modules
module load bioinfo-tools bwa/0.7.18 samtools/1.20 Pilon/1.24


#input and output directories and files

export assembly_file=/home/nimkup/genomeAnalysis/results/out_nano_assembly/assembly.fasta
export IN_BAM=/home/nimkup/genomeAnalysis/results/polishing/samtools_out/aligned.bam
export OUTPUT_PILON=/home/nimkup/genomeAnalysis/results/polishing/polished_assembly

# Index the BAM file (required by Pilon)
samtools index $IN_BAM

# Run Pilon
java -Xmx16G -jar $PILON_HOME/pilon.jar \
  --genome $assembly_file \
  --frags $IN_BAM \
  --output $OUTPUT_PILON \
  --threads 8 \
  --changes
