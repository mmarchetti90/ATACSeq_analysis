process CreateConsensus {

  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${params.consensus_dir}", mode: "copy", pattern: "consensus_peaks.bed"

  input:
  path peaks

  output:
  path "consensus_peaks.bed", emit: consensus_peaks

  """
  # Create a consensus bed file for peaks
  cat *Peak | cut -f1-3 | sort -k1,1 -k2,2n | bedtools merge -i - > consensus_peaks.bed
  """

}