#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 16
#SBATCH -t 48:00:00
#SBATCH -J canu
#SBATCH --mail-type=ALL
##SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/canu_%j.out


# Load modules
module load bioinfo-tools
module load canu/2.2

# Define directories and parameters
WORKDIR=/domus/h1/nimkup/genomeAnalysis
DATADIR=$WORKDIR/project_data/reads
ASSEMBLY_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/canu_temp/results
OUT_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/canu_temp
mkdir -p $OUT_DIR
mkdir -p $ASSEMBLY_DIR

cd $OUT_DIR

PREFIX=nj_chr3
GENOME_SIZE=60m

echo 'Starting canu assembly'
# Run Canu for Nanopore reads
canu \
  -p $PREFIX \
  -d $ASSEMBLY_DIR \
  -genomeSize=$GENOME_SIZE \
  -nanopore $DATADIR/chr3_clean_nanopore.fq.gz \
  useGrid=false
