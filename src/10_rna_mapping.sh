#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 02:00:00
#SBATCH -J hisatall_rna_mapping
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=/home/nimkup/genomeAnalysis/out/hisatall_%j.out
#SBATCH --error=/home/nimkup/genomeAnalysis/out/hisatall_%j.err
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
OUT_DIR=$WORK_DIR/results/hisat2_results_all

# Create output dir
mkdir -p $OUT_DIR


# Create HISAT2 index if it doesn't exist
if [ ! -e "$REF_DIR/chr3_hisat2_index.1.ht2" ]; then
    echo "Indexing reference genome..."
    hisat2-build -p 4 $REF_GENOME $REF_DIR/chr3_hisat2_index
fi

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Loop over all forward reads
for FWD in $DATA_DIR/*_f1.fq.gz; do
    SAMPLE=$(basename $FWD _f1.fq.gz)
    REV=$DATA_DIR/${SAMPLE}_r2.fq.gz

    if [ -f "$REV" ]; then
        echo "Mapping sample: $SAMPLE"

        # HISAT2 alignment
        hisat2 -p 8 -x $REF_DIR/chr3_hisat2_index \
            -1 $FWD -2 $REV \
            -S $OUT_DIR/${SAMPLE}.sam

        # Convert SAM to sorted BAM
        echo "Converting and sorting: $SAMPLE"
        samtools view -@ 8 -bS $OUT_DIR/${SAMPLE}.sam | \
        samtools sort -@ 8 -m 2G -o $OUT_DIR/${SAMPLE}_sorted.bam
        #-m 2G ( memory flag added as sam conversion takes temporary memory) 
        # Index BAM file
        samtools index $OUT_DIR/${SAMPLE}_sorted.bam

        # Optional: remove the large SAM file to save space
        rm $OUT_DIR/${SAMPLE}.sam
    else
        echo "Skipping $SAMPLE: missing reverse read"
    fi
done
