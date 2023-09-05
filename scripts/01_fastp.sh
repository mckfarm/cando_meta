#!/bin/bash
#SBATCH --job-name="01_fastp"
#SBATCH --output=01_fastp.out
#SBATCH --error=01_fastp.err
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 10:00:00
#SBATCH -N 1
#SBATCH --mem=10G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

module load mamba
conda activate /projects/b1052/mckenna/envs/fastp

cd /projects/b1052/mckenna/cando_meta

fastp -i ./raw_reads/CAN_1_S8_R1_001.fastq.gz \
 -I ./raw_reads/CAN_1_S8_R2_001.fastq.gz \
 --out1 ./results/clean_reads/CAN_1_R1.fastq.gz \
 --out2 ./results/clean_reads/CAN_1_R2.fastq.gz \
 --detect_adapter_for_pe --dedup --length_required 50 \
 -h ./results/clean_reads/CAN_1.html \
 -V --thread 1

 fastp -i ./raw_reads/CAN_2_S9_R1_001.fastq.gz \
 -I ./raw_reads/CAN_2_S9_R2_001.fastq.gz \
 --out1 ./results/clean_reads/CAN_2_R1.fastq.gz \
 --out2 ./results/clean_reads/CAN_2_R2.fastq.gz \
 --detect_adapter_for_pe --dedup --length_required 50 \
 -h ./results/clean_reads/CAN_2.html \
 -V --thread 1

 fastp -i ./raw_reads/CAN_3_S10_R1_001.fastq.gz \
 -I ./raw_reads/CAN_3_S10_R2_001.fastq.gz \
 --out1 ./results/clean_reads/CAN_3_R1.fastq.gz \
 --out2 ./results/clean_reads/CAN_3_R2.fastq.gz \
 --detect_adapter_for_pe --dedup --length_required 50 \
 -h ./results/clean_reads/CAN_3.html \
 -V --thread 1