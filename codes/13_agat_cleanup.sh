#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy 
#SBATCH -n 1
#SBATCH -p core
#SBATCH -c 8
#SBATCH -t 01:00:00
#SBATCH -J agat
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/agat_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/agat_%j.err

# Load module  
module load bioinfo-tools AGAT/1.3.2

# Define input and output
WORK_DIR="/domus/h1/nimkup/genomeAnalysis"
JOB_DIR="/proj/uppmax2025-3-3/nobackup/work/nimali/tmp_agat"
REF_DIR="$WORK_DIR/results/repeat_masker_results"
REF_GENOME="$REF_DIR/polished_assembly.fasta.masked" 

#GFF files for processing 
GFF3_FILE="$WORK_DIR/results/braker_annotation_results2/braker_etp_run2/braker.gff3"
GFF_CLEANED="$JOB_DIR/braker_cleaned.gff3"
GFF_STD_NAME="braker_standardized.gff3"
GFF_STANDARD_PATH="$JOB_DIR/$GFF_STD_NAME"
AGAT_CONFIG="/sw/bioinfo/AGAT/1.3.2/rackham/lib/site_perl/5.32.1/auto/share/dist/AGAT/agat_config.yaml"

#Change to working directory 
cd $JOB_DIR
pwd
echo "$pwd"

mkdir -p $JOB_DIR

#convert GFF into GFF(bioperl) format
agat_convert_sp_gxf2gxf.pl --gff $GFF3_FILE -c $AGAT_CONFIG -o $GFF_CLEANED 

#manage IDS
agat_sp_manage_IDs.pl --gff $GFF_CLEANED -o $GFF_STANDARD_PATH --prefix NJAP --ensembl

#get feature statistics 
agat_sp_statistics.pl --gff $GFF_STANDARD_PATH -o "$JOB_DIR/braker_standardized_statistics.txt"

#Extract protein sequences 
agat_sp_extract_sequences.pl --gff $GFF_STANDARD_PATH \
	--fasta $REF_GENOME -p -o "$JOB_DIR/braker_standardized.aa"

#create symlinks for output files 
OUT_DIR="$WORK_DIR/results/agat_results2"
mkdir -p $OUT_DIR
ln -sf $JOB_DIR/*_standardized.* $OUT_DIR
