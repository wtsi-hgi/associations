/*
========================================================================================
    VALIDATE INPUTS
========================================================================================
*/

/*
========================================================================================
    CONFIG FILES
========================================================================================
*/

ch_multiqc_config        = file("$projectDir/assets/multiqc_config.yaml", checkIfExists: true)
ch_multiqc_custom_config = params.multiqc_config ? Channel.fromPath(params.multiqc_config) : Channel.empty()

/*
========================================================================================
    IMPORT LOCAL MODULES/SUBWORKFLOWS
========================================================================================
*/



/*
========================================================================================
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
========================================================================================
*/



/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

// Info required for completion email and summary
def multiqc_report = []

workflow ASSOCIATIONS {

    // first create a channel for each of the chromosomes.
    input_channel = Channel.fromPath(params.input_tsv, followLinks: true, checkIfExists: true)
    channel_input_data_table
        .splitCsv(header: true, sep: params.input_tables_column_delimiter).map{row->tuple(row.vcf,row.chr )}
	.set{vcf_chr}
    vcf_chr.view()
    // then convert the chromosome to the gds file.

    // extract the tar chromosome notation files
    // tar -xzvf /lustre/scratch119/realdata/mdt2/projects/interval_wgs/analysis/data/FAVOR/chr20.tar.gz -C ./

    // Run the 3 codes to create aGDS files - these are the outputs.
}

/*
========================================================================================
    COMPLETION EMAIL AND SUMMARY
========================================================================================
*/

workflow.onComplete {
    if (params.email || params.email_on_fail) {
        NfcoreTemplate.email(workflow, params, summary_params, projectDir, log, multiqc_report)
    }
    NfcoreTemplate.summary(workflow, params, log)
}

/*
========================================================================================
    THE END
========================================================================================
*/
