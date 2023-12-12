process TrimFastQ {

  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.reports_dir}/${params.trimming_subdir}", mode: "copy", pattern: "*_trimming_report.txt"
  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.reports_dir}/${params.fastqc_subdir}", mode: "copy", pattern: "*_fastqc.{html,zip}"

  input:
  tuple val(sample_id), path(read1), path(read2)

  output:
  path "*_trimming_report.txt", emit: trimming_reports
  path "*_fastqc.{html,zip}", emit: fastqc_reports
  tuple val("${sample_id}"), path("${sample_id}_val_1.fq.gz"), path("${sample_id}_val_2.fq.gz"), emit: trimmed_fastq_files

  """
  # Trim raw reads
  trim_galore \
  --cores \$SLURM_CPUS_ON_NODE \
  --output_dir . \
  --basename ${sample_id} \
  --gzip \
  --fastqc \
  ${params.trimgalore_params} \
  --paired \
  ${read1} ${read2}
  """

}