rule all:
    input:
        "rel606.annot",
        "rel606.quast"

rule link_data:
    input:
        "/home/ctbrown/data/ggg201b/{filename}.fastq.gz"
    output:
        "{filename,[A-Za-z0-9_]+}.fastq.gz"
    shell:
        "ln -fs {input} {output}"

rule assemble_data:
    input:
        r1 = "SRR2584857_1.fastq.gz",
        r2 = "SRR2584857_2.fastq.gz"
    output:
        directory("rel606.megahit.out")
    threads: 8
    params:
        ram="5e9",
    shell:
        """megahit -1 {input.r1} -2 {input.r2} -o {output} -f -t {threads} \
               -m {params.ram}"""

rule copy_genome_contigs:
    input:
        "rel606.megahit.out"
    output:
        "rel606.contigs.fa"
    shell:
        "cp {input}/final.contigs.fa {output}"

rule annotate_contigs:
    input:
        "{prefix}.contigs.fa"
    output:
        directory("{prefix}.annot")
    threads: 8
    shell:
        # note: a bug in prokka+megahit means we have to force success.
        # that's what "|| :" does.
        "prokka --outdir {output} --prefix {wildcards.prefix} {input} --cpus {threads} || :"

rule quast_eval:
    input:
        "{prefix}.contigs.fa"
    conda: "env-quast.yml"
    output:
        directory("{prefix}.quast")
    shell: "quast {input} -o {output}"
