process MergeCounts {

    label 'contained'

    publishDir "${projectDir}/${params.main_results_dir}/${params.consensus_dir}", mode: "copy", pattern: "merged_peaks_counts.tsv"

    input:
    path count_files

    output:
    path "merged_peaks_counts.tsv", emit: merged_counts

    """
    # Main vars
    header_row=1
    file_pattern=_peaks_counts.tsv
    output_header="PeakID\tGeneID\tGeneName\tChr\tStart\tEnd\tStrand\tLength"
    output_file=merged_peaks_counts.tsv
    counts_column=9

    # Extract info: PeakID, gene_id, gene_name, Chr, Start, End, Strand, Length (columns 1, 7, 8, 2, 3, 4, 5, 6)
    echo -e "\${output_header}" > merged_temp.txt
    ls -1 *\${file_pattern} | head -n 1 | xargs awk -v FS='\t' -v OFS='\t' -v header_row=\${header_row} '(NR > header_row) { print \$1, \$7, \$8, \$2, \$3, \$4, \$5, \$6 }' >> merged_temp.txt

    # Add counts
    for file in *\${file_pattern}
    do

        sample_name=\$(basename \${file} | sed "s/\${file_pattern}//g")

        echo \${sample_name} > counts_temp.txt
        awk -v header_row=\${header_row} -v counts_column=\${counts_column} '(NR > header_row) { print \$counts_column }' \${file} >> counts_temp.txt

        paste merged_temp.txt counts_temp.txt > new_merged_temp.txt

        rm counts_temp.txt
        rm merged_temp.txt
        mv new_merged_temp.txt merged_temp.txt

    done

    mv merged_temp.txt \${output_file}
    """

}