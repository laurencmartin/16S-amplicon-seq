#!/usr/bin/env nextflow

containers = ["fastqc", "trim-galore", "matam", "dada2_test"]

base = docker://lcmartin
  

process build_containers {
        label "build_images"

        publishDir "$PWD/containers", mode:"copy", overwrite:"true"

        input:
        each container from containers

        script:
        """
        singularity build  ${container}.sif  ${base}/${container}
        """
}

