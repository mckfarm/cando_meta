rule metabat_depth_coassembly:
    input: 
        contigs = "results/megahit_coassembly/final.contigs.fa",
        sorted_bam = "results/coverage_coassembly/{sample}/{sample}.sorted.bam"
    output:
        depth = "results/coverage_coassembly/{sample}/{sample}.depth.txt"
    conda:
        "../envs/metabat.yaml"
    resources:
        mem="30g",
        time="05:00:00",
    threads: 4
    shell:
        """
        jgi_summarize_bam_contig_depths \
        --referenceFasta {input.contigs} {input.sorted_bam} \
        --outputDepth {output.depth}
        """

rule metabat_bin_coassembly:
    input: 
        contigs = "results/megahit_coassembly/final.contigs.fa",
        depth = "results/coverage_coassembly/{sample}/{sample}.depth.txt"
    output:
        directory("results/metabat_coassembly/{sample}")
    params:
        "results/metabat_coassembly/{sample}/{sample}"
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

rule gtdbtk_coassembly:
    input:
        "results/metabat_coassembly/{sample}"
    output:
        directory("results/gtdbtk_coassembly/{sample}")
    params:
        "results/gtdbtk_coassembly/{sample}/mash_db"
    conda: 
        "../envs/gtdbtk.yaml"
    threads: 20
    resources:
        mem="100G",
        time="14:00:00"
    shell:
        """
        gtdbtk classify_wf --genome_dir {input} --out_dir {output} \
        --mash_db {params} --extension fa \
        --pplacer_cpus {threads} --cpus {threads}
        """

rule checkm_metabat_coassembly:
    input:
        "results/metabat_coassembly/{sample}"
    output:
        "results/metabat_checkm_coassembly/{sample}/{sample}_checkm_output.txt"
    params: 
        checkm_dir = "results/metabat_checkm_coassembly/{sample}"
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

checkpoint bin_filter_coassembly:
    input:
        "results/metabat_checkm_coassembly/{sample}/{sample}_checkm_output.txt",
        "results/metabat_coassembly/{sample}"
    output:
        directory("results/metabat_filt_coassembly/{sample}/")
    script:
        "../scripts/checkm_filter.py"

rule prokka_coassembly:
    input:
        "results/metabat_filt_coassembly/{sample}/{bin}.fa"
    output:
        "results/prokka_coassembly/{sample}/{bin}/{bin}.tsv"
    params:  
        outdir = "results/prokka_coassembly/{sample}/{bin}",
        prefix = "{bin}"
    conda: 
        "../envs/prokka.yaml"
    threads: 4
    resources:
        mem="30G",
        time="01:00:00"
    shell:
        """
        prokka {input} --outdir {params.outdir} --prefix {params.prefix} --metagenome --force --cpus {threads}
        """

def get_prokka_output_coassembly(wildcards):
    checkpoint_output = checkpoints.bin_filter_coassembly.get(**wildcards).output[0]
    return expand("results/prokka_coassembly/{sample}/{bin}/{bin}.tsv", sample = wildcards.sample, bin = glob_wildcards(os.path.join(checkpoint_output, "{bin}.fa")).bin)

rule aggregate_prokka_coassembly:
    input:
        get_prokka_output_coassembly
    output:
        "results/prokka_coassembly/{sample}/aggregate.txt"
    shell:
        """
        touch {output}
        """