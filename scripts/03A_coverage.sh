#!/bin/bash
#SBATCH --job-name="03_coverage"
#SBATCH --output=03_coverage.out
#SBATCH --error=03_coverage.err
#SBATCH -A p31629
#SBATCH -p genhimem
#SBATCH -t 12:00:00
#SBATCH -N 1
#SBATCH -n 12
#SBATCH --mem=150G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

cd /projects/b1052/mckenna/cando_meta/results/

module load samtools/1.10.1

# /home/mmf8608/programs/bbmap_39.01/reformat.sh \
# in=megahit/final.contigs.fa out=megahit/final.contigs.trim.fa \
# minlength=1000

/home/mmf8608/programs/bbmap_39.01/bbwrap.sh -Xmx150g -t=12 \
ref=megahit/final.contigs.trim.fa path=coverage/ \
in=clean_reads/CAN_1_R1_cn.fastq,clean_reads/CAN_2_R1.fastq,clean_reads/CAN_3_R1.fastq \
in2=clean_reads/CAN_1_R2_cn.fastq,clean_reads/CAN_2_R2.fastq,clean_reads/CAN_3_R2.fastq \
kfilter=22 subfilter=15 maxindel=80 \
out=coverage/output.bam bamscript=coverage/bs.sh ; sh coverage/bs.sh