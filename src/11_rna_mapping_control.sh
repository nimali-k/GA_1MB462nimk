#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 02:00:00
#SBATCH -J hisat2_rna_mapping
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/hisat_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/hisat_%j.err
#SBATCH --mem=16G

# Load module
module load bioinfo-tools HISAT2/2.2.1 samtools

# Define input and output
WORK_DIR=/domus/h1/nimkup/genomeAnalysis
DATA_DIR=$WORK_DIR/project_data/reads
REF_DIR=$WORK_DIR/results/repeat_masker_results
REF_GENOME=$REF_DIR/polished_assembly.fasta.masked
INDEX_PREFIX=$REF_DIR/chr3_hisat2_index
FWD=$DATA_DIR/Control_1_f1.fq.gz
REV=$DATA_DIR/Control_1_r2.fq.gz

# Set custom temp directory
export TMPDIR=/proj/uppmax2025-3-3/nobackup/work/nimali/tmp_hisat2
mkdir -p $TMPDIR

OUT_DIR=$WORK_DIR/results/hisat2_results_forControl
# Create output dir
mkdir -p $OUT_DIR


# Build HISAT2 index (only if it doesn't already exist)
if [ ! -e "${INDEX_PREFIX}.1.ht2" ]; then
    echo "Building HISAT2 index..."
    hisat2-build -p 8 $REF_GENOME $INDEX_PREFIX
fi


#Run hiSAT2 mapping for Control samples
for ID in 1 2 3; do
    FWD=$DATA_DIR/Control_${ID}_f1.fq.gz
    REV=$DATA_DIR/Control_${ID}_r2.fq.gz
    SAMPLE=Control_${ID}

    echo "Processing $SAMPLE..."

    hisat2 -p 16 -x $INDEX_PREFIX \
        -1 $FWD -2 $REV \
    | samtools view -@ 8 -bS - \
    | samtools sort -@ 8 -T $TMPDIR/${SAMPLE} -o $OUT_DIR/${SAMPLE}_sorted.bam

    samtools index $OUT_DIR/${SAMPLE}_sorted.bam
done

echo "Finished HISAT2 mapping for Control samples."






















echo "Finished HISAT2 mapping for Control samples."
