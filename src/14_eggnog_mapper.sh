#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 02:00:00
#SBATCH -J eggnog
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/eggnog_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/eggnog_%j.err
#SBATCH --mem=16G 

# Load module
module load bioinfo-tools
module load eggNOG-mapper/2.1.9

# Define input and output
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
DATA_DIR=$WORK_DIR/project_data/reads
REF_DIR=$WORK_DIR/results/repeat_masker_results
REF_GENOME=$REF_DIR/polished_assembly.fasta.masked
OUT_DIR=$WORK_DIR/results/eggnog_results2

mkdir -p $OUT_DIR

#protein file from the agat cleanup process 
PROTEIN_FILE="$WORK_DIR/results/agat_results2/tmp_agat/braker_standardized.aa"

emapper.py -i "$PROTEIN_FILE" \
	--itype proteins \
	-m diamond \
	--cpu 16 \
	--go_evidence experimental \
	--output n.japonicum \
	--output_dir "$OUT_DIR" \
	--decorate_gff "$WORK_DIR/results/agat_results2/tmp_agat/braker_standardized.gff3" \
	--decorate_gff_ID_field ID \
	--excel
