#!/bin/bash
#SBATCH --job-name="02_megahit"
#SBATCH --output=02_megahit.out
#SBATCH --error=02_megahit.err
#SBATCH -A p31629
#SBATCH -p genhimem
#SBATCH -t 05:00:00
#SBATCH -N 1
#SBATCH -n 12
#SBATCH --mem=150Gb
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

module purge all
module load mamba
source activate /projects/b1052/mckenna/envs/megahit

cd /projects/b1052/mckenna/cando_meta/results/clean_reads

megahit -1 CAN_1_R1.fastq,CAN_2_R1.fastq,CAN_3_R1.fastq \
-2 CAN_1_R2.fastq,CAN_2_R2.fastq,CAN_3_R2.fastq \
-o /projects/b1052/mckenna/cando_meta/results/megahit \
-t 12 --k-min 31 --continue -m 150000000000