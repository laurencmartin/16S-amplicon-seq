#!/usr/bin/env nextflow

out_dir = params.out_dir

input_ch = Channel.fromFilePairs(params.in_fastq, type:'file')

input_ch.into{data1; data2}

ref_db = params.ref_db

ref_db_dir = new File("${params.ref_db}").getParent()
ref_prefix = new File("${params.ref_db}").getSimpleName()

silva_ch = Channel.fromPath(params.ref_tax_db)

scripts = params.scripts

process run_fastqc {
     label 'fastqc'

     publishDir "$out_dir/fastqc_results", mode: 'copy', overwrite: 'true'     

     input:
     set val(name), file(fastq) from data1

     output:
     set val(name), file("*") into qc_ch

     script:
     """
     fastqc ${fastq[0]} ${fastq[1]}
     """
}


process run_trimgalore {
     label 'trimgalore'
     
     publishDir "$out_dir/trim_results", mode: 'copy', overwrite: 'true'

     input:
     set val(name), file(fastq) from data2

     output:
     set val(name), file("${name}_R1_001_val_1.fq"), file("${name}_R2_001_val_2.fq") into trim_ch

     script:
     """
     trim_galore -q 30 --length 50 --dont_gzip --clip_R1 1 --clip_R2 1 --paired ${fastq[0]} ${fastq[1]} --fastqc

     """
}

process run_concat {
     label 'concatenate'

     input:
     set val(name), file(fastq1), file(fastq2) from trim_ch

     output:
     set val(name), file("${name}_concat.fastq") into concat_ch

     script:
     """
     cat $fastq1 $fastq2 > ${name}_concat.fastq
    
     """
}

process run_matam {
     errorStrategy 'ignore'
     label 'matam'
     time '50h'      
     
     publishDir "$out_dir/matam_assembly", mode: 'copy', overwrite: 'true'

     input:
     set val(name), file(fastq_concat) from concat_ch
     path ref_dir from Channel.value("${ref_db_dir}")     

     output:
     set val(name), path("${name}_output") into matam_ch

     script:
     """
     matam_assembly.py -d ${ref_dir}/${ref_prefix} -i $fastq_concat -o ${name}_output --cpu 32 --max_memory 80000 -v --perform_taxonomic_assignment 
     """
} 

process run_fasta_2_fastq {
     label 'makefastq'

     input:
     set val(name), path("${name}_output") from matam_ch
     path scripts     

     output:
     set val(name), file("${name}_assembly.fastq") into fastq_ch
     set val(name), file("${name}_counts.txt") into counts_ch

     script:
     """
     python3 ${scripts}/fasta_to_fastq.py ${name}_output/final_assembly.fa > ${name}_assembly.fastq
     python3 ${scripts}/read_counts.py ${name}_output/final_assembly.fa > ${name}_counts.txt 

     """
}     

ref_tax_db = params.ref_tax_db

process run_dada2_tax {
     label 'dada2_tax'

     publishDir "$out_dir/tax_tables", mode:"copy", overwrite:"true"

     input:
     set val(name), file(fastq) from fastq_ch
     path scripts

     output:
     set val(name), file("${name}_tax_table.csv") into tax_ch

     script:
     """
     Rscript $scripts/assign_taxonomy.R $fastq $ref_tax_db ${name}_tax_table.csv  
     """
}

tax_ch.into{tax_ch_1; tax_ch_2}

tax_ch_1.join(counts_ch).set{tax_counts_ch}

process run_ASV_table {
    label 'ASV_table'
     
    publishDir "$out_dir/asvs", mode:"copy", overwrite:"true"       

    input:
    set val(name), file(tax_table), file(counts) from tax_counts_ch
    path scripts     

    output:
    set val(name), file("${name}_ASV.csv") into ASV_ch

    script:
    """
    python3 ${scripts}/sequence_table_2.py $tax_table $counts > ${name}_ASV.csv
    """
}

     

