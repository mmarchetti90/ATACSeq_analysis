FROM continuumio/miniconda3:latest

### UPDATING CONDA ------------------------- ###

RUN conda update -y conda

### INSTALLING PIPELINE PACKAGES ----------- ###

# Adding bioconda to the list of channels
RUN conda config --add channels bioconda

# Adding conda-forge to the list of channels
RUN conda config --add channels conda-forge

# Installing mamba
RUN conda install -y mamba

# Installing software
RUN mamba install -y \
    bedtools=2.31.1 \
    bwa=0.7.17 \
    homer=4.11 \
    macs2=2.2.9.1 \
    numpy \
    pandas \
    picard=2.27.5 \
    samtools=1.18 \
    subread=2.0.6 \
    trim-galore=0.6.10 && \
    conda clean -afty

### SETTING WORKING ENVIRONMENT ------------ ###

# Set workdir to /home/
WORKDIR /home/

# Launch bash automatically
CMD ["/bin/bash"]
