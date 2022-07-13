#!/usr/bin/env nextflow

scripts = params.scripts
in_data = "$PWD/results"
samples = "/users/lcmartin/matam/samples.txt"

process run_merge_files {
    label 'merge_files'

    publishDir "$PWD/results/final_tables", mode:"copy", overwrite:"true"

    input:
    path scripts
    path in_data

    output:
    file("*") into merge_ch

    script:
    """
    bash scripts/phyloseq.sh -t $in_data/tax_tables -a $in_data/asvs -s $samples

    """
}
