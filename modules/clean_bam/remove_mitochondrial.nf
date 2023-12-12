process RemoveMitochondrial {

  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.bam_dir}", mode: "copy", pattern: "*_cleaned.bam"

  input:
  tuple val(sample_id), path(bam)

  output:
  tuple val(sample_id), path("${sample_id}_cleaned.bam"), emit: clean_bam

  """
  # Remove reads mapping to the mitochondrial genome
  samtools view \
  --threads \$SLURM_CPUS_ON_NODE \
  -o ${sample_id}_cleaned.bam \
  -e 'rname != "${params.mitochondrial_chr_name}"' \
  ${bam}
  """

}