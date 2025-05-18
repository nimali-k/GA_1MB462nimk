#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 02:00:00
#SBATCH -J busco_check_mosses
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/busco_moss%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/busco_moss%j.err
#SBATCH --mem=4G

# Load module
module load bioinfo-tools BUSCO/5.7.1
#module load bioinfo-tools augustus/3.5.0-20231223-33fc04d

# Copy AUGUSTUS config to a writable location
#export AUGUSTUS_CONFIG_PATH=/domus/h1/nimkup/genomeAnalysis/codes/augustus_config

# Fix Augustus permissions
source $AUGUSTUS_CONFIG_COPY

# Define input and output
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
ASSEMBLY=$WORK_DIR/results/repeat_masker_results/polished_assembly.fasta.masked
OUTDIR=$WORK_DIR/results/busco_results_moss
LINEAGE=$BUSCO_LINEAGE_SETS/bryophyta_odb10

# Make output dir if it doesn’t exist
mkdir -p $OUTDIR


echo "Running BUSCO on $ASSEMBLY with lineage $LINEAGE"
echo "Results will be stored in $OUTDIR"
# Run BUSCO 
busco -i $ASSEMBLY \
	-o busco_output \
	--out_path $OUTDIR \
	-l $LINEAGE \
	-m genome \
	-c 8 \
#	--augustus  

