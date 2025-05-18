#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 06:00:00
#SBATCH -J repeatmasker
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/repeatmasker_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/repeatmasker_%j.err
#SBATCH --mem=16G

# Exit script on any error
set -e

# Load required modules
module load bioinfo-tools
module load RepeatMasker/4.1.5

#input and output directories and files
export WORK_DIR=/home/nimkup/genomeAnalysis
export OUT_DIR=$WORK_DIR/results/repeat_masker_results
export LIB="$WORK_DIR/results/repeat_masker/niphotrichum_japonicum-families.fa"

export ASSEMBLY="$WORK_DIR/results/polishing/polished_assembly.fasta"

# Create output directory if it doesn't exist
#mkdir -p $OUT_DIR

# Run RepeatMasker
RepeatMasker\
	-lib $LIB \
	-xsmall \
	-pa 8 \
	-html \
	-gff \
	-dir $OUT_DIR \
	$ASSEMBLY


