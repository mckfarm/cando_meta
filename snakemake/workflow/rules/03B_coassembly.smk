rule concat_reads:
    input: 
        r1 = get_all_r1,
        r2 = get_all_r2
    output:
        r1_concat = "results/fastp_out/concat.r1.fastp.fastq.gz",
        r2_concat = "results/fastp_out/concat.r2.fastp.fastq.gz"
    shell:
        """
        cat {input.r1} > {output.r1_concat}
        cat {input.r2} > {output.r2_concat}
        """

rule megahit_coassembly:
    input: 
        r1_concat = "results/fastp_out/concat.r1.fastp.fastq.gz",
        r2_concat = "results/fastp_out/concat.r2.fastp.fastq.gz"
    output:
        "results/megahit_coassembly/final.contigs.fa"
    params: 
        out_dir = "results/megahit_coassembly/"
    conda: "../envs/megahit.yaml"
    threads: 20
    resources:
        mem="200g",
        account="b1042",
        partition="genomics-himem",
        time="24:00:00"
    shell:
        """
        megahit -1 {input.r1_concat} -2 {input.r2_concat} \
        -o {params.out_dir}_tmp \
        -t {threads} \
        --continue -m 150 --presets meta-large

        mv {params.out_dir}_tmp/* {params.out_dir}
        rmdir {params.out_dir}_tmp

        """

rule quast_coassembly:
    input:
        "results/megahit_coassembly/final.contigs.fa"
    output:
        "results/quast_coassembly/report.html"
    params:
        out_dir = "results/quast_coassembly/"
    threads: 2
    resources:
        mem="5G",
        time="01:00:00"
    shell:
        """
        module load quast/5.2.0

        quast.py -o {params.out_dir} --threads {threads} -L {input}
        """

rule index_contigs_coassembly:
    input:
         "results/megahit_coassembly/final.contigs.fa"
    output:
        "results/coverage_coassembly/coassembly.1.bt2"
    params:
        index_name = "results/coverage_coassembly/coassembly"
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

rule map_contigs_coassembly:
    input:
        r1_clean = get_trimmed_r1,
        r2_clean = get_trimmed_r2,
        index = "results/coverage_coassembly/coassembly.1.bt2"
    output:
        sorted_bam = "results/coverage_coassembly/{sample}/{sample}.sorted.bam",
        flagstat = "results/coverage_coassembly/{sample}/{sample}.flagstat.tsv",
        bam_index = "results/coverage_coassembly/{sample}/{sample}.sorted.bam.bai"
    params:
        index_name = "results/coverage_coassembly/coassembly"
    threads: 12
    resources:
        mem="80G",
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