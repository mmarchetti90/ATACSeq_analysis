# ATACSeq analysis
## General dockerized Nextflow ATACSeq pipeline for bulk paired-end experiments

/// --------------------------------------- //

### OVERVIEW:

* Reads trimming (TrimGalore!)

* Aligment (BWA)

* Deduplication (Picard)

* Removal of Mitochondrial reads (samtools)

* Peak calling (MACS3)

* Peak annotation (HOMER)

* Peak consensus across samples (bedtools merge)

* Peak counting (featureCounts)

/// --------------------------------------- //

### RUN COMMAND:

nextflow run [OPTIONS] --sample_reads_list_path "/path/to/sample/reads/list" main.nf

/// --------------------------------------- //

### OPTIONS: (See config file for more)

-profile

		If not specified or equal to "standard" or "no_ctrls", the samples are processed by calling
		peaks without controls.

		If equal to "with_ctrls", both samples and controls must be specified for MACS2 peak
		calling.

--sample_reads_list_path

		Path to tsv file manifest of samples, with columns SampleID, Mate1, and Mate2.

--control_reads_list_path

		Path to tsv file manifest of controls, with columns SampleID, Mate1, and Mate2.
		Sample IDs must match those in the manifest of samples, but with the addition of the suffix
		"_CONTROL" (e.g. SAMPLE1_CONTROL for the control of SAMPLE1)
		Must be specified if profile = "with_ctrls"

--trimgalore_params

		Parameters for TrimGalore as a single line of text.

--genome_size

		MACS2 genome size

--macs2_options

		Parameters for MACS2 as a single line of text.

--homer_options

		Parameters for Homer as a single line of text.

--strandedness

		featureCounts strandedness.
    	Possible values: 0 = unstranded, 1 = stranded, 2 = reversestrand.
    	(Default, 0)

/// --------------------------------------- ///

### DEPENDENCIES:

Nextflow 24.10.2+

bedtools 2.31.1+

bwa 0.7.18+

homer 5.1+

macs2 3.0.2+

picard 3.3.0+

samtools 1.21+

Singularity 4.1.1+

subread 2.0.8+

trim-galore 0.6.10+ &

	Cutadapt
	FastQC

Python 3.9.7+ &

	numpy
	pandas

/// --------------------------------------- ///

### NOTES:

* Can be used for other chromatin analysis techniques (e.g. ChIP-Seq, Cut&Tag, etc) by modifying MACS3 options.
