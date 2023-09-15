#!/bin/bash
#SBATCH --job-name="03_coverage_parse"
#SBATCH --output=03_coverage_parse.out
#SBATCH --error=03_coverage_parse.err
#SBATCH -A p31629
#SBATCH -p short
#SBATCH -t 04:00:00
#SBATCH -N 1
#SBATCH -n 12
#SBATCH --mem=20G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

cd /projects/b1052/mckenna/cando_meta/results/coverage

module load samtools/1.10.1

samtools view -h -o output.sam output.bam

/home/mmf8608/programs/bbmap_39.01/pileup.sh -Xmx20g -t=12 \
in=output.sam out=depth.txt twocolumn=t

tail -n +2 depth.txt > depth_clean.txt