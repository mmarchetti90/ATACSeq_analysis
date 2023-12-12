process CountPeaks {
  
  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.reports_dir}/${params.counts_subdir}", mode: "copy", pattern: "*.AlignmentSummary.tsv"
  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.counts_dir}", mode: "copy", pattern: "*_peaks_counts.tsv"

  input:
  each path(annotation)
  tuple val(sample_id), path(bam)

  output:
  path "${sample_id}_peaks_counts.tsv", emit: peaks_counts
  path "${sample_id}.AlignmentSummary.tsv", emit: peaks_counts_report

  """
  # Counting peaks with Subread featureCounts for paired-end reads
  featureCounts \
  -T \$SLURM_CPUS_ON_NODE \
  -p \
  -B \
  -t AtacPeak \
  -g peak_id \
  --extraAttributes gene_id,gene_name \
  -s ${params.strandedness} \
  -a ${annotation} \
  -F GTF \
  -o temp.tsv \
  ${bam}

  # Removing first line of count file (it contains the command used to run featureCounts)
  sed "1d" temp.tsv > ${sample_id}_peaks_counts.tsv

  # Renaming summary from featureCounts
  mv temp.tsv.summary ${sample_id}.AlignmentSummary.tsv
  """

}