#!/bin/bash
#SBATCH --job-name="03_coverage"
#SBATCH --output=03_coverage.out
#SBATCH --error=03_coverage.err
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 12:00:00
#SBATCH -N 1
#SBATCH --mem=10G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

cd /projects/b1052/mckenna/cando_meta/results/


/home/mmf8608/programs/bbmap_39.01/bbwrap.sh \
ref=megahit/final.contigs.fa \
in=clean_reads/CAN_1_R1_cn.fastq,clean_reads/CAN_2_R1.fastq,clean_reads/CAN_3_R1.fastq \
in2=clean_reads/CAN_1_R2_cn.fastq,clean_reads/CAN_2_R2.fastq,clean_reads/CAN_3_R2.fastq \
out=coverage/aln.sam.gz \
kfilter=22 subfilter=15 maxindel=80