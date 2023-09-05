#!/bin/bash
#SBATCH --job-name="01_fastp_CAN3"
#SBATCH --output=01_fastp_CAN3.out
#SBATCH --error=01_fastp_CAN3.err
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 10:00:00
#SBATCH -N 1
#SBATCH --mem=10G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

module purge all
module load mamba
source activate /projects/b1052/mckenna/envs/fastp

cd /projects/b1052/mckenna/cando_meta

fastp -i ./raw_reads/CAN_3_S10_R1_001.fastq.gz \
 -I ./raw_reads/CAN_3_S10_R2_001.fastq.gz \
 --out1 ./results/clean_reads/CAN_3_R1.fastq.gz \
 --out2 ./results/clean_reads/CAN_3_R2.fastq.gz \
 --detect_adapter_for_pe --dedup --length_required 50 \
 -h ./results/clean_reads/CAN_3.html \
 -V --thread 1