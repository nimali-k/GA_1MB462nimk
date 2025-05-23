#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 04:00:00
#SBATCH -J juicer_hic
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/scaffold/juicer_hic_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/scaffold/juicer_hic_%j.err
#SBATCH --mem=16G


# Load modules
module load bioinfo-tools
module load samtools
module load Juicer_tools/1.22.01

#export Juicer path
#export PATH=/sw/mf/rackham/bioinfo-tools/pipelines/Juicer/2.0

#input and output directories
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
YAHS=/proj/uppmax2025-3-3/Genome_Analysis/yahs
INPUT_DIR=/proj/uppmax2025-3-3/nobackup/work/nimali/hic-tmp/scaffolding
OUT_DIR=$INPUT_DIR/juicer

mkdir -p $OUT_DIR

cd $INPUT_DIR

#generate Hi-C contact matrix
#(java -jar -Xmx32G $YAHS/juicer_tools_1.22.01.jar pre alignments_sorted.txt out.hic.part genome.chrom.sizes) && (mv out.hic.part out.hic)
#java -jar $YAHS/juicer_tools_1.22.01.jar pre yahs.out.bin out.hic genome.chrom.sizes
java -jar juicer_tools.jar pre duplicate_marked.bam out.hic $INPUT_DIR/genome.chrom.sizes
