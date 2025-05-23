#!/bin/bash -l 
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 04:00:00
#SBATCH -J cpassembly
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/cpassembly_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/cpassembly_%j.err
#SBATCH --mem=16G


# Load modules
module load bioinfo-tools
module load GetOrganelle/1.7.7.0

#input and output directories
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
DATA_DIR=$WORK_DIR/results/trim_result2

OUT_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/GetOrganelle

mkdir -p $OUT_DIR

get_organelle_from_reads.py -1 /domus/h1/nimkup/genomeAnalysis/results/trim_result2/ch3_R1.trimmed_forward_paired.fastq.gz -2 /domus/h1/nimkup/genomeAnalysis/results/trim_result2/ch3_R2.trimmed_reverse_paired.fastq.gz -k 21,45,65,85,105 -t 8 -o "$OUT_DIR"/chloroplast_genome \
-R 20 -F embplant_pt
