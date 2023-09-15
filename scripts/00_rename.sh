#!/bin/bash
#SBATCH --job-name="00_rename"
#SBATCH --output=00_rename.out
#SBATCH --error=00_rename.err
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH --mem=1G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

cd /projects/b1052/mckenna/cando_meta/results/clean_reads

# /home/mmf8608/programs/bbmap_39.01/rename.sh in=CAN_1_R1.fastq in2=CAN_1_R2.fastq \
# out=CAN_1_R1_cn.fastq out2=CAN_1_R2_cn.fastq prefix=CAN1

# /home/mmf8608/programs/bbmap_39.01/rename.sh in=CAN_2_R1.fastq in2=CAN_2_R2.fastq \
# out=CAN_2_R1_cn.fastq out2=CAN_2_R2_cn.fastq prefix=CAN2

# /home/mmf8608/programs/bbmap_39.01/rename.sh in=CAN_3_R1.fastq in2=CAN_3_R2.fastq \
# out=CAN_3_R1_cn.fastq out2=CAN_3_R2_cn.fastq prefix=CAN1

/home/mmf8608/programs/bbmap_39.01/reformat.sh in=CAN_1_R1_cn.fastq out=CAN_1_R1_cn.fasta
/home/mmf8608/programs/bbmap_39.01/reformat.sh in=CAN_1_R2_cn.fastq out=CAN_1_R2_cn.fasta

/home/mmf8608/programs/bbmap_39.01/reformat.sh in=CAN_2_R1_cn.fastq out=CAN_2_R1_cn.fasta
/home/mmf8608/programs/bbmap_39.01/reformat.sh in=CAN_2_R2_cn.fastq out=CAN_2_R2_cn.fasta

/home/mmf8608/programs/bbmap_39.01/reformat.sh in=CAN_3_R1_cn.fastq out=CAN_3_R1_cn.fasta
/home/mmf8608/programs/bbmap_39.01/reformat.sh in=CAN_3_R2_cn.fastq out=CAN_3_R2_cn.fasta