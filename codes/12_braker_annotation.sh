#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 05:00:00
#SBATCH -J braker_annotation2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/braker_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/brake_%j.err
#SBATCH --mem=16G

# Load module  
module load bioinfo-tools  samtools
module load braker/2.1.6 
module load augustus
module load GeneMark/4.68-es
module load bamtools

# Export environment for BRAKER and AUGUSTUS
#source $AUGUSTUS_CONFIG_COPY
#mv ~/augustus_config /proj/uppmax2025-3-3/nobackup/work/nimali/

# Export AUGUSTUS config
export AUGUSTUS_CONFIG_PATH=/proj/uppmax2025-3-3/nobackup/work/nimali/augustus_config	
export AUGUSTUS_BIN_PATH=$(dirname $(which augustus))
export AUGUSTUS_SCRIPTS_PATH=$(dirname $(which autoAug.pl))
export GENEMARK_PATH=$GENEMARK_PATH/gmes

#

# Define input and output
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
DATA_DIR=$WORK_DIR/project_data/reads
REF_DIR=$WORK_DIR/results/repeat_masker_results
REF_GENOME=$REF_DIR/polished_assembly.fasta.masked

# BAM merging
BAM_DIR=$WORK_DIR/results/hisat2_results_forControl
MERGED_BAM=/proj/uppmax2025-3-3/nobackup/work/nimali/tmp_hisat2/merged_control.bam
PROT=$WORK_DIR/project_data/reads/embryophyte_proteomes.faa
OUT_DIR=$WORK_DIR/results/braker_annotation_results2
TMP_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/tmp_braker2_20250905

mkdir -p $OUT_DIR
mkdir -p $TMP_DIR
export TMPDIR=$TMP_DIR 

# Merge BAM files if merged file doesn't exist
cd $BAM_DIR
if [ ! -f "$MERGED_BAM" ]; then
    echo "Merging control BAM files..."
    samtools merge -f -@ 8 $MERGED_BAM Control_1_sorted.bam Control_2_sorted.bam Control_3_sorted.bam
    samtools index $MERGED_BAM
fi 

# Run BRAKER in ETP mode 
braker.pl \
	--etpmode \
	--genome=$REF_GENOME \
	--prot_seq=$PROT \
	--bam=$MERGED_BAM \
	--softmasking \
	--cores=16 \
	--workingdir=/proj/uppmax2025-3-3/nobackup/work/nimali/braker_etp_run \
	--species=plant_species_etp \
	--gff3 \
	--AUGUSTUS_CONFIG_PATH=/proj/uppmax2025-3-3/nobackup/work/nimali/augustus_config \
	#--codingseq \          # Explicitly request coding sequences
	#--aaout \             # Explicitly request protein sequences
	#--makehub             # (Optional) Creates additional output organization
	#--useexisting \ removed as braker is running for the first time

