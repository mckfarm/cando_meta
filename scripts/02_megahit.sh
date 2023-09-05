#!/bin/bash
#SBATCH --job-name="02_megahit"
#SBATCH --output=02_megahit.out
#SBATCH --error=02_megahit.err
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 24:00:00
#SBATCH -N 1
#SBATCH --mem=0
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

module purge all
module load mamba
source activate /projects/b1052/mckenna/envs/megahit

cd /projects/b1052/mckenna/cando_meta/results

megahit -1 CAN_1_R1.fastq.gz,CAN_2_R1.fastq.gz,CAN_3_R1.fastq.gz \
-2 -1 CAN_1_R2.fastq.gz,CAN_2_R2.fastq.gz,CAN_3_R2.fastq.gz \
-o megahit