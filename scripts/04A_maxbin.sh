#!/bin/bash
#SBATCH --job-name="04A_maxbin"
#SBATCH --output=04A_maxbin.out
#SBATCH --error=04A_maxbin.err
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 12:00:00
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=25G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

cd /projects/b1052/mckenna/cando_meta/results/

perl /projects/b1052/shared/MaxBin-2.2.7/run_MaxBin.pl -thread 4 \
-contig megahit/final.contigs.trim.fa -abund coverage/depth_clean.txt -out maxbin/ \


