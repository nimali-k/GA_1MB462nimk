#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 04:00:00
#SBATCH -J hic_mapping
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/hic_mapping_%j.out
#SBATCH --mem=16G

module load bioinfo-tools
module load bwa/0.7.18
module load samtools
module load picard/3.1.1

# Define paths
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
ASSEMBLY=$WORK_DIR/results/polishing/polished_assembly.fasta
READ1=$WORK_DIR/project_data/reads/chr3_hiC_R1.fastq.gz
READ2=$WORK_DIR/project_data/reads/chr3_hiC_R2.fastq.gz
OUT_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/hic-tmp
mkdir -p $OUT_DIR

cd $OUT_DIR

# Step 1: Index the assembly
bwa index $ASSEMBLY

# Step 2: Align Hi-C reads to the assembly
bwa mem -t 8 $ASSEMBLY $READ1 $READ2 | samtools view -Sb - > hic_unsorted.bam

# Step 3: Sort the BAM file
samtools sort hic_unsorted.bam -o hic_sorted.bam

# Step 4: Mark duplicates
picard MarkDuplicates I=hic_sorted.bam O=duplicate_marked.bam M=dup_metrics.txt REMOVE_DUPLICATES=false CREATE_INDEX=true

