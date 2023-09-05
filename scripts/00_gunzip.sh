#!/bin/bash
#SBATCH --job-name="00_gunzip"
#SBATCH --output=00_gunzip.out
#SBATCH --error=00_gunzip.err
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 05:00:00
#SBATCH -N 1
#SBATCH --mem=1G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu


cd /projects/b1052/mckenna/cando_meta/results/clean_reads


gunzip -k CAN_1_R1.fastq.gz
gunzip -k CAN_1_R2.fastq.gz

# gunzip -k CAN_2_R1.fastq.gz
# gunzip -k CAN_2_R2.fastq.gz

gunzip -k CAN_3_R1.fastq.gz
gunzip -k CAN_3_R2.fastq.gz
