#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
Pipeline to analyze ATAC-Seq samples
*/

// ----------------Workflow---------------- //

include { ATAC_NOCTRLS } from './workflows/atac_no_controls.nf'
include { ATAC_WITHCTRLS } from './workflows/atac_with_controls.nf'

workflow {

  // WORKFLOW SELECTION ------------------- //

  if ("$workflow.profile" == "standard") {
    
    ATAC_NOCTRLS()

  }
  else if ("$workflow.profile" == "no_ctrls") {
    
    ATAC_NOCTRLS()

  }
  else if ("$workflow.profile" == "with_ctrls") {
    
    ATAC_WITHCTRLS()

  } else {

    println "ERROR: Unrecognized profile!"
    println "Please chose one of: standard, single, merged"

  }

}