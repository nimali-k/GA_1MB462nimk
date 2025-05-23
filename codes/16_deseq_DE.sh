#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 02:00:00
#SBATCH -J deseq
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/deseq_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/deseq_%j.err
#SBATCH --mem=16G

# Load the appropriate modules
module load bioinfo-tools
module load   R/4.4.2

# Define paths
WORK_DIR=/home/nimkup/genomeAnalysis/results/feature_count/feature_count_all
OUT_DIR=$WORK_DIR/results/deseq
mkdir -p $OUT_DIR

cd $WORK_DIR

# Run the DESeq2 R script
#echo "Looking for expression level and sorting genes"

#Rscript extract_sorted_gene_expression.R

#script to extract mostly and least expressed genes 
#Rscript get_extreme_expression_genes.R
Rscript /domus/h1/nimkup/genomeAnalysis/codes/deseq2_rscript.R

