rule get_cds:
    input:
         "results/megahit/{sample}/final.contigs.fa"
    output:
        protein = "results/pyrodigal/{sample}/cds_proteins.faa",
        nucl = "results/pyrodigal/{sample}/cds_nucl.fa",
        gff = "results/pyrodigal/{sample}/cds.gff"
    threads: 6
    conda: "../envs/pyrodigal.yaml"
    resources:
        mem="80G",
        time="05:00:00"
    shell:
        """
        pyrodigal -i {input} -a {output.protein} -d {output.nucl} -f gff -o {output.gff} -p meta --jobs {threads}
        """

rule diamond_denit:
    input:
         "results/pyrodigal/{sample}/cds_proteins.faa"
    output:
        "results/diamond_contigs/{sample}/uniref90_denit.tsv"
    params:
        db_loc = "/projects/b1052/mckenna/resources/diamond/denit_uniprotkb"
    threads: 10
    conda: "../envs/diamond.yaml"
    resources:
        mem="50G",
        time="02:00:00"
    shell:
        """
        diamond blastp -d {params.db_loc} -q {input} -o {output} \
        --very-sensitive --iterate --verbose --threads {threads} --max-target-seqs 1
        """


rule pileup_stats:
    input:
        "results/coverage/{sample}/{sample}.sorted.bam"
    output:
        pileup = "results/pileup/{sample}/{sample}.pileup.txt",
        rpkm = "results/pileup/{sample}/{sample}.rpkm.txt",
        basecov = "results/pileup/{sample}/{sample}.basecov.txt"
    threads: 4
    resources:
        mem="50G",
        time="01:00:00"
    shell:
        """
        module load bowtie2/2.4.5
        module load samtools/1.10.1
        module load sambamba/0.8.2

        /home/mmf8608/programs/bbmap_39.01/pileup.sh -Xmx50g \
        in={input} out={output.pileup} rpkm={output.rpkm} basecov={output.basecov}
        """

rule pileup_summary:
    input:
        flagstat = "results/coverage/{sample}/{sample}.flagstat.tsv",
        depth = "results/coverage/{sample}/{sample}.depth.txt"
    output:
        flagstat = "results/pileup/{sample}/{sample}.flagstat.tsv",
        depth = "results/pileup/{sample}/{sample}.depth.txt"
    shell:
        """
        cp {input.flagstat} {output.flagstat}
        cp {input.depth} {output.depth}
        """
