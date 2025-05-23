#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 06:00:00
#SBATCH -J repeatmodeler
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/repeatmodeler_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/repeatmodeler_%j.err
#SBATCH --mem=16G

# Exit script on any error
set -e

# Load required modules
module load bioinfo-tools
module load RepeatModeler/2.0.4

#input and output directories and files
export WORK_DIR=/home/nimkup/genomeAnalysis
export JOB_DIR=$WORK_DIR/results/repeat_masker
export ASSEMBLY=$WORK_DIR/results/polishing/polished_assembly.fasta


mkdir -p $JOB_DIR
cd $JOB_DIR

#build the database for niphotricum_japanicum 
BuildDatabase -name niphotrichum_japonicum $ASSEMBLY

#create the library 
RepeatModeler -database niphotrichum_japonicum -threads 8 -LTRStruct 



