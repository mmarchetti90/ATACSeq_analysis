# ATACSeq analysis
## General dockerized Nextflow ATACSeq pipeline for bulk paired-end experiments

/// --------------------------------------- //

### RUN COMMAND:

nextflow run [OPTIONS] --sample_reads_list_path "/path/to/sample/reads/list" main.nf

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
    	(Default, 1)

/// --------------------------------------- ///

### DEPENDENCIES:

Nextflow 20.10+

bedtools 2.31.1+

bwa 0.7.17+

homer 4.11+

macs2 2.2.9.1+

picard 2.27.5+

samtools 1.18+

subread 2.0.6+

trim-galore 0.6.10+ &

	Cutadapt
	FastQC

Python 3.9.7+ &

	numpy
	pandas

/// --------------------------------------- ///
