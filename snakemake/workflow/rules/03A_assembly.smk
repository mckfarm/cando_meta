rule megahit_assembly:
    input: 
        r1_clean = get_trimmed_r1,
        r2_clean = get_trimmed_r2
    output:
        "results/megahit/{sample}/final.contigs.fa"
    params: 
        out_dir = "results/megahit/{sample}"
    conda: "../envs/megahit.yaml"
    threads: 20
    resources:
        mem="200g",
        account="b1042",
        partition="genomics-himem",
        time="24:00:00"
    shell:
        """
        megahit -1 {input.r1_clean} -2 {input.r2_clean} \
        -o {params.out_dir}_tmp \
        -t {threads} \
        --continue -m 200 --presets meta-large

        mv {params.out_dir}_tmp/* {params.out_dir}
        rmdir {params.out_dir}_tmp

        """

rule quast_assembly:
    input:
        "results/megahit/{sample}/final.contigs.fa"
    output:
        "results/quast/{sample}/report.html"
    params:
        out_dir = "results/quast/{sample}/"
    threads: 2
    resources:
        mem="5G",
        time="00:30:00"
    shell:
        """
        module load quast/5.2.0

        quast.py -o {params.out_dir} --threads {threads} -L {input}
        """


rule index_contigs:
    input:
         "results/megahit/{sample}/final.contigs.fa"
    output:
        "results/coverage/{sample}/{sample}.1.bt2"
    params:
        index_name = "results/coverage/{sample}/{sample}"
    threads: 10
    resources:
        mem="40G",
        time="10:00:00"
    shell:
        """
        module load bowtie2/2.4.5
        module load samtools/1.10.1

        bowtie2-build {input} {params.index_name}
        """

rule map_contigs:
    input:
        r1_clean = get_trimmed_r1,
        r2_clean = get_trimmed_r2,
        index = "results/coverage/{sample}/{sample}.1.bt2"
    output:
        sorted_bam = "results/coverage/{sample}/{sample}.sorted.bam",
        flagstat = "results/coverage/{sample}/{sample}.flagstat.tsv",
        bam_index = "results/coverage/{sample}/{sample}.sorted.bam.bai"
    params:
        index_name = "results/coverage/{sample}/{sample}"
    threads: 10
    resources:
        mem="40G",
        time="10:00:00"
    shell:
        """
        module load bowtie2/2.4.5
        module load samtools/1.10.1

        bowtie2 -p {threads} -x {params.index_name} --very-sensitive-local -1 {input.r1_clean} -2 {input.r2_clean}| \
        samtools view -bS -@ {threads}| \
        samtools sort -@ {threads} -o {output.sorted_bam}

        samtools index {output.sorted_bam}

        samtools flagstat -@ {threads} -O tsv {output.sorted_bam} > {output.flagstat}
        """