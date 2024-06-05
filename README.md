# Metagenomics pipeline for CANDO+P 

This repo contains the Snakemake workflow and analysis scripts for CANDO+P shotgun metagenomic data.  

## Workflow overview
I used a [Snakemake](https://snakemake.github.io) workflow to process the shotgun metagenomic data. The pipeline is fairly standard, consisting of read trimming, assembly, binning, and annotation. Snakemake environment details and programs are listed below. This workflow was executed on the [Quest HighPerformance Computing Cluster](https://www.it.northwestern.edu/departments/it-services-support/research/computing/quest/specs.html). 

### Snakemake environment info:
- mamba 1.4.2
- conda 23.1.0
- snakemake 8.4.12

### Pipeline info: 
- Read trimming: fastp 0.23.4 
- Read-based taxonomy annotation: Kraken2 2.1.2 (using Standard database released 1/12/2024)
- Assembly: MEGAHIT 1.2.9
- Binning: MetaBat2 2.15
- Taxonomy: GTDB-TK 2.3.2 (using Release 214)
- CDS and functional annotation: prokka 1.14.6