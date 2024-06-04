rule metabat_depth:
    input: 
        contigs = "results/megahit/{sample}/final.contigs.fa",
        sorted_bam = "results/coverage/{sample}/{sample}.sorted.bam"
    output:
        depth = "results/coverage/{sample}/{sample}.depth.txt"
    conda:
        "../envs/metabat.yaml"
    resources:
        mem="20g",
        time="10:00:00",
    threads: 4
    shell:
        """
        jgi_summarize_bam_contig_depths \
        --referenceFasta {input.contigs} {input.sorted_bam} \
        --outputDepth {output.depth}
        """

rule metabat_bin:
    input: 
        contigs = "results/megahit/{sample}/final.contigs.fa",
        depth = "results/coverage/{sample}/{sample}.depth.txt"
    output:
        directory("results/metabat/{sample}")
    params:
        "results/metabat/{sample}/{sample}"
    conda:
        "../envs/metabat.yaml"
    resources:
        mem="20g",
        time="05:00:00"
    threads: 1
    shell:
        """
        metabat2 -t {threads} \
        --inFile {input.contigs} --outFile {params} --abdFile {input.depth} \
        --unbinned --verbose
        """

rule gtdbtk:
    input:
        "results/metabat/{sample}"
    output:
        directory("results/gtdbtk/{sample}")
    params:
        "results/gtdbtk/{sample}/mash_db"
    conda: 
        "../envs/gtdbtk.yaml"
    threads: 8
    resources:
        mem="100G",
        time="24:00:00"
    shell:
        """
        gtdbtk classify_wf --genome_dir {input} --out_dir {output} \
        --mash_db {params} --extension fa \
        --pplacer_cpus {threads} --cpus {threads}
        """


rule checkm_metabat:
    input:
        "results/metabat/{sample}"
    output:
        "results/metabat_checkm/{sample}/{sample}_checkm_output.txt"
    params: 
        checkm_dir = "results/metabat_checkm/{sample}"
    threads: 6
    resources:
        mem="50G",
        time="03:00:00"
    shell:
        """
        module load checkm/1.0.7
        checkm lineage_wf \
        --threads {threads} \
        --extension 'fa' \
        --file {output} \
        --tab_table \
        {input} {params.checkm_dir}
        """

checkpoint bin_filter:
    input:
        "results/metabat_checkm/{sample}/{sample}_checkm_output.txt",
        "results/metabat/{sample}"
    output:
        directory("results/metabat_filt/{sample}/")
    script:
        "../scripts/checkm_filter.py"

def get_filtered_bins(wildcards):
    checkpoint_output = checkpoints.bin_filter.get(**wildcards).output[0]
    bin = glob_wildcards(os.path.join(checkpoint_output, "{bin}.fa")).bin
    return expand(f"{checkpoint_output}/{{bin}}.fa", bin=bin)

rule prokka:
    input:
        get_filtered_bins
    output:
        "results/prokka/{sample}/{bin}/{bin}.tsv"
    params:  
        outdir = "results/prokka/{sample}/{bin}",
        prefix = "{bin}"
    conda: 
        "../envs/prokka.yaml"
    threads: 4
    resources:
        mem="30G",
        time="05:00:00"
    shell:
        """
        prokka {input} --outdir {params.outdir} --prefix {params.prefix} --metagenome --force --cpus {threads}
        """