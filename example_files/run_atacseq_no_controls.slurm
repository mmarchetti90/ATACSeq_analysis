#!/bin/bash
#SBATCH --nodes=1
#SBATCH --account=ucgd-rw
#SBATCH --partition=ucgd-rw
#SBATCH -o atac-out-%j
#SBATCH -e atac-err-%j

# Loading modules
module load singularity/4.1.1 jdk/11

# Running Nextflow
nextflow run main.nf \
-profile no_ctrls \
--sample_reads_list_path /path/to/samples_reads_list.tsv \
--genome_fasta_path /path/to/reference/fasta \
--genome_annotation_path /path/to/reference/gtf
