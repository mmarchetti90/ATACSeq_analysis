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
  # Add/replace read groups for MarkDuplicates
  picard AddOrReplaceReadGroups \
  --INPUT ${bam} \
  --OUTPUT temp_rdup.bam \
  --RGID 1 \
  --RGLB library1 \
  --RGPU unit1 \
  --RGPL ILLUMINA \
  --RGSM ${sample_id}

  # Mark and remove duplicate reads
  picard \
  MarkDuplicates \
  --REMOVE_DUPLICATES true \
  --ASSUME_SORT_ORDER coordinate \
  --INPUT temp_rdup.bam \
  --OUTPUT ${sample_id}_dedup.bam \
  --REFERENCE_SEQUENCE ${genome_fasta} \
  --METRICS_FILE ${sample_id}_dedup_metrics.txt
  """

}