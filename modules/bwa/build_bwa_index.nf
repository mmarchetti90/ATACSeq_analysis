process GenerateBwaIndex {

  label 'contained'

  input:
  path genome_fasta

  output:
  path "*.{amb,ann,bwt,pac,sa}", emit: bwa_index

  script:
  """
  # Build BWA index
  bwa index ${genome_fasta}
  """

}