process RemoveDuplicates {

  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.bam_dir}", mode: "copy", pattern: "*_dedup.bam"
  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.reports_dir}/${params.deduplication_subdir}", mode: "copy", pattern: "*_dedup_metrics.txt"

  input:
  each path(genome_fasta)
  tuple val(sample_id), path(bam)

  output:
  tuple val(sample_id), path("${sample_id}_dedup.bam"), emit: dedup_bam
  path "${sample_id}_dedup_metrics.txt", emit: dedup_metrics

  """
  # Mark and remove duplicate reads
  picard \
  MarkDuplicates \
  --REMOVE_DUPLICATES true \
  --ASSUME_SORT_ORDER coordinate \
  --INPUT ${bam} \
  --OUTPUT ${sample_id}_dedup.bam \
  --REFERENCE_SEQUENCE ${genome_fasta} \
  --METRICS_FILE ${sample_id}_dedup_metrics.txt
  """

}