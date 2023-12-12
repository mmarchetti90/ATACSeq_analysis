
// ----------------Workflow---------------- //

include { PREPROCESS } from '../subworkflows/preprocess.nf'
include { GenerateBwaIndex } from '../modules/bwa/build_bwa_index.nf'
include { CallPeaks } from '../modules/macs2/call_peaks_no_ctrl.nf'
include { AnnotatePeaks } from '../modules/homer/annotate_peaks.nf'
include { CreateConsensus } from '../modules/consensus/peaks_consensus.nf'
include { CountPeaks } from '../modules/counting/count_peaks.nf'
include { MergeCounts } from '../modules/merge_counts/merge_counts.nf'

workflow ATAC_NOCTRLS {

  main:
  // LOADING RESOURCES -------------------- //

  // Loading reads list file
  Channel
  .fromPath("${params.sample_reads_list_path}")
  .splitCsv(header: true, sep: '\t')
  .map{row -> tuple(row.SampleID, file(row.Mate1), file(row.Mate2))}
  .set{ raw_reads }

  // Channel for genome reference fasta
  Channel
  .fromPath("${params.genome_fasta_path}")
  .set{ genome_fasta }

  // Channel for genome annotation
  Channel
  .fromPath("${params.genome_annotation_path}")
  .set{ genome_annotation }

  // Creating channel for existing BWA index, or building de novo
  if (new File("${params.bwa_index_dir_path}/${params.bwa_index_prefix}.amb").exists()) {

    Channel
    .fromPath("${params.bwa_index_dir_path}/${params.bwa_index_prefix}.{amb,ann,bwt,pac,sa}")
    .collect()
    .set{ bwa_index }

  }
  else {

    GenerateBwaIndex(genome_fasta)
    GenerateBwaIndex.out.bwa_index
    .collect()
    .set{ bwa_index }

  }
  
  // PREPROCESSING ------------------------ //

  PREPROCESS(raw_reads, genome_fasta, bwa_index)

  // PEAK CALLING ------------------------- //

  CallPeaks(PREPROCESS.out.clean_bam)

  // PEAKS CONSENSUS ---------------------- //

  CreateConsensus(CallPeaks.out.all_peaks.collect())

  // CONSENSUS PEAKS ANNOTATION ----------- //

  AnnotatePeaks(genome_fasta, genome_annotation, CreateConsensus.out.consensus_peaks)

  // PEAKS COUNTING ----------------------- //

  CountPeaks(AnnotatePeaks.out.annotated_peaks_gtf, PREPROCESS.out.clean_bam)

  // MERGE COUNTS ------------------------- //

  MergeCounts(CountPeaks.out.peaks_counts.collect())
  
}