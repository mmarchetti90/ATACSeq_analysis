
// ----------------Workflow---------------- //

include { TrimFastQ } from '../modules/trimgalore/trimgalore.nf'
include { MapReads } from '../modules/bwa/map_reads_bwa.nf'
include { RemoveDuplicates } from '../modules/clean_bam/remove_duplicates.nf'
include { RemoveMitochondrial } from '../modules/clean_bam/remove_mitochondrial.nf'

workflow PREPROCESS {

  take:
  raw_reads
  genome_fasta
  bwa_index

  main:
  // TRIMGALORE --------------------------- //

  // Trimming adapters
  TrimFastQ(raw_reads)

  // MAPPING ------------------------------ //

  MapReads(genome_fasta, bwa_index, TrimFastQ.out.trimmed_fastq_files)

  // CLEAN BAMS --------------------------- //

  // Marking and removing duplicates with Picard
  RemoveDuplicates(genome_fasta, MapReads.out.mapped_bam)

  // Remove mitochondrial sequences
  RemoveMitochondrial(RemoveDuplicates.out.dedup_bam)

  emit:
  trimming_reports = TrimFastQ.out.trimming_reports
  fastqc_reports = TrimFastQ.out.fastqc_reports
  mapping_reports = MapReads.out.mapping_reports
  dedup_metrics = RemoveDuplicates.out.dedup_metrics
  clean_bam = RemoveMitochondrial.out.clean_bam

}