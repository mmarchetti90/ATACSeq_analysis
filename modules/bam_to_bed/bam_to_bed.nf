process BamToBed {
  
  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.bed_dir}", mode: "copy", pattern: "*_coverage.bed"

  input:
  tuple val(sample_id), path(bam)

  output:
  tuple val(sample_id), path("${sample_id}_coverage.bed"), emit: bed

  """
  # Extract mapping stats
  samtools flagstat \
  --threads \$SLURM_CPUS_ON_NODE \
  ${bam} > ${sample_id}_mapping.log

  # Calculate factor for normalization to 1e6 reads
  scale_factor=\$(grep '[0-9] mapped (' ${sample_id}_mapping.log | awk '{ print 1000000/\$1 }')
  
  # Convert bam to bed coverage file
  bedtools genomecov \
  -ibam ${bam} \
  -bg \
  -scale \${scale_factor} > ${sample_id}_coverage.bed
  """

}