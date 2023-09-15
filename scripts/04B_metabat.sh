#!/bin/bash
#SBATCH --job-name="04B_metabat"
#SBATCH --output=04B_metabat.out
#SBATCH --error=04B_metabat.err
#SBATCH -A p31629
#SBATCH -p genhimem
#SBATCH -t 05:00:00
#SBATCH -N 1
#SBATCH -n 12
#SBATCH --mem=150Gb
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu

