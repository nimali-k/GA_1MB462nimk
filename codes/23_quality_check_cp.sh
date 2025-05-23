#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 04:00:00
#SBATCH -J cpassembly_quality_check
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/qccheck_cpassembly_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/qccheck_cpassembly_%j.err
#SBATCH --mem=16G


# Load modules
module load bioinfo-tools
module load quast/5.0.2

#input and output directories
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
DATA_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/GetOrganelle/chloroplast_genome

OUT_DIR=$DATA_DIR/cp_quality_check
mkdir -p $OUT_DIR

cd $OUT_DIR

quast.py -t 8 $DATA_DIR/embplant_pt.K105.scaffolds.graph1.1.path_sequence.fasta
