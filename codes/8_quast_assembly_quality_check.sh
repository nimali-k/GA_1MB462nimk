#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 01:00:00
#SBATCH -J quast_check
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/quast_chr3_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/quast_chr3_%j.err
#SBATCH --mem=4G

# Load module
module load bioinfo-tools quast/5.0.2

# Define input and output
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
ASSEMBLY=$WORK_DIR/results/repeat_masker_results/polished_assembly.fasta.masked
OUTDIR=$WORK_DIR/results/quast_results

# Make output dir if it doesn’t exist
mkdir -p $OUTDIR

# Run QUAST
quast.py -t 4 -o $OUTDIR $ASSEMBLY

