#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 04:00:00
#SBATCH -J scaffolding
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/scaffold/scaffold_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/scaffold/scaffold_%j.err
#SBATCH --mem=16G


# Load modules
module load bioinfo-tools
module load samtools
module load Juicer/2.0
module load coreutils

#export Juicer path
export PATH=/sw/mf/rackham/bioinfo-tools/pipelines/Juicer/2.0 

#input and output directories 
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
ASSEMBLY=$WORK_DIR/results/polishing/polished_assembly.fasta
HIC_DATA=/proj/uppmax2025-3-3/Genome_Analysis/yahs
BAM_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/hic-tmp
OUT_DIR=$BAM_DIR/scaffolding

#create the index for polished genome
samtools faidx $OUT_DIR/yahs.out_scaffolds_final.fa

mkdir -p $OUT_DIR

cd $OUT_DIR

#scaffolding 
$HIC_DATA/yahs $ASSEMBLY $BAM_DIR/duplicate_marked.bam

($HIC_DATA/juicer pre $BAM_DIR/duplicate_marked.bam yahs.out_scaffolds_final.agp $OUT_DIR/yahs.out_scaffolds_final.fa.fai | sort -k2,2d -k6,6d -T ./ --parallel=8 -S32G | awk 'NF' > \
alignments_sorted.txt.part) && (mv alignments_sorted.txt.part alignments_sorted.txt)


