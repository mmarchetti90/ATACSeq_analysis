process AnnotatePeaks {

  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${params.consensus_dir}", mode: "copy", pattern: "consensus_annotated_peaks.{txt,gtf}"

  input:
  path genome_fasta
  path genome_annotation
  path peaks

  output:
  path "consensus_annotated_peaks.txt", emit: annotated_peaks
  path "consensus_annotated_peaks.gtf", emit: annotated_peaks_gtf

  """
  # Annotate peaks with Home
  annotatePeaks.pl \
  ${peaks} \
  ${genome_fasta} \
  ${params.homer_options} \
  -gtf ${genome_annotation} \
  -cpu \$SLURM_CPUS_ON_NODE > consensus_annotated_peaks.txt

  # Prepare Gtf file for featureCounts
  awk -v FS='\t' -v OFS='\t' 'NR > 1 { printf "%s\tHomer\tAtacPeak\t%s\t%s\t.\t%s\t.\tpeak_id \\"%s\\"; gene_id \\"%s\\"; gene_name \\"%s\\";\\n",\$2,\$3,\$4,\$5,\$1,\$12,\$16 }' consensus_annotated_peaks.txt > consensus_annotated_peaks.gtf
  """

}