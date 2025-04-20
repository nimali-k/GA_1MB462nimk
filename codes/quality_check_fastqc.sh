#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 00:30:00
#SBATCH -J fastqc3_trimmed_1904
#SBATCH --mail-type=ALL
#SBATCH --mail-user nimali-madushika.kularatne.3390@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools FastQC/0.11.9

#input directory
 	INPUT_DIR=/home/nimkup/GA_1MB462nimk/codes/trim_result

#creating a directory for saving the trimmed reads output
	mkdir /home/nimkup/GA_1MB462nimk/codes/trim_result/trimmed_reads_quality

#output directory
	OUTPUT_DIR=/home/nimkup/GA_1MB462nimk/codes/trim_result/trimmed_reads_quality

#set java options to increase heap size
#export FASTQC_JAVA_OPTIONS="-Xmx4G" # set java heap size to 4 GB


for file in "$INPUT_DIR"/*.fastq "$INPUT_DIR"/*.fastq.gz
do
    # Check if file exists to avoid issues if no files match pattern
    if [[ -f "$file" ]]; then
        echo "Running FastQC on $file"
        fastqc -t 4 -o "$OUTPUT_DIR" "$file"
    fi
done 

echo "FastQC analysis complete. Results saved in $OUTPUT_DIR."



#do
        #fastqc -t 4 -o /home/nimkup/GA_1MB462nimk/fastqc_long /home/nimkup/GA_1MB462nimk/project_data/reads/chr3_illumina_R2.fastq.gz

#done

