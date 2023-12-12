process MapReads {
  
  label 'contained'

  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.bam_dir}", mode: "copy", pattern: "*_mapped_sorted.bam"
  publishDir "${projectDir}/${params.main_results_dir}/${sample_id}/${params.reports_dir}/${params.alignment_subdir}", mode: "copy", pattern: "*_mapping.log"

  input:
  each path(genome_fasta)
  path(bwa_index)
  tuple val(sample_id), path(read1), path(read2)

  output:
  tuple val(sample_id), path("${sample_id}_mapped_sorted.bam"), emit: mapped_bam
  path "${sample_id}_mapping.log", emit: mapping_reports

  """
  # Map with BWA
  bwa mem \
  -t \$SLURM_CPUS_ON_NODE \
  ${genome_fasta} \
  ${read1} ${read2} > ${sample_id}_mapped.sam

  # Sort and convert to bam
  samtools sort \
  --threads \$SLURM_CPUS_ON_NODE \
  -o ${sample_id}_mapped_sorted.bam \
  ${sample_id}_mapped.sam

  # Extract mapping stats
  samtools flagstat \
  --threads \$SLURM_CPUS_ON_NODE \
  ${sample_id}_mapped_sorted.bam > ${sample_id}_mapping.log
  """

}