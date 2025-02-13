process CallPeaks {

  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.reports_dir}/${params.macs2_subdir}", mode: "copy", pattern: "*.{xls,r,bdg}"
  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.macs2_dir}", mode: "copy", pattern: "*{.narrowPeak,.broadPeak,.gappedPeak,_summits.bed}"

  input:
  tuple val(sample_id), path(bam)

  output:
  tuple val("${sample_id}"), path("*.{narrowPeak,broadPeak}"), emit: macs2_peaks
  path "*.{narrowPeak,broadPeak}", emit: all_peaks
  path "*.gappedPeak", optional: true
  path "*_summits.bed", optional: true
  path "*.xls", optional: true
  path "*_model.r", optional: true
  path "*.{bdg}", optional: true

  """
  # Call peaks with MACS2
  macs2 callpeak \
  --gsize ${params.genome_size} \
  --name ${sample_id} \
  ${params.macs2_options} \
  --treatment ${bam}
  """

}