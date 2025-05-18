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
#SBATCH --output=/home/nimkup/genomeAnalysis/out/scaffold_%j.out
#SBATCH --mem=16G

# Load modules
module load bioinfo-tools
module load samtools
module load Juicer_tools/1.22.01

#input and output directories 
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
ASSEMBLY=$WORK_DIR/results/polishing/polished_assembly.fasta
HIC_DATA=/proj/uppmax2025-3-3/Genome_Analysis/yahs
OUT_DIR=$WORK_DIR/results/scaffolding


#scaffolding 
$HIC_DATA/yahs $ASSEMBLY $OUT_DIR/duplicate_marked.bam

samtools faidx $ASSEMBLY

(juicer pre hic-to-contigs.bin scaffolds_final.agp {$ASSEMBLY}.fai | sort -k2,2d -k6,6d -T ./ --parallel=8 -S32G | awk 'NF' > \
alignments_sorted.txt.part) && (mv alignments_sorted.txt.part alignments_sorted.txt)
