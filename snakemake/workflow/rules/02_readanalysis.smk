### trim reads with fastp ###
rule kraken:
    input:
        r1 = get_trimmed_r1,
        r2 = get_trimmed_r2
    output:
        "results/kraken/{sample}/{sample}_kraken.txt"
    threads: 10
    resources:
        mem="100g",
        time="00:20:00"
    shell: 
        """
        module load kraken/2

        kraken2 --db /projects/b1052/mckenna/resources/kraken2_db --threads {threads} \
        --paired --gzip-compressed {input.r1} {input.r2} --report {output}
        """