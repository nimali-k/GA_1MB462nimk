#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 02:00:00
#SBATCH -J feature_count2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/featurecount2_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/featurecount2_%j.err
#SBATCH --mem=16G

module load bioinfo-tools
module load subread/2.0.3

# Define paths
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
#Input files
GFF_FILE=$WORK_DIR/results/eggnog_results2/n.japonicum.emapper.decorated.gff
BAM_PATH=/proj/uppmax2025-3-3/nobackup/work/nimali/bam_files
BAM_FILES=${BAM_PATH}/*.bam
OUT_DIR=$WORK_DIR/results/feature_count/feature_count_all
mkdir -p $OUT_DIR

cd $WORK_DIR

featureCounts -p --countReadPairs \
  -T 4 \
  -a "$GFF_FILE" -t gene -g ID \
  -o "${OUT_DIR}/counts.txt" \
  $BAM_FILES
