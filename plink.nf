#!/usr/bin/env nextflow

nextflow.enable.dsl=1

params.dir = "data/pops/"
dir = params.dir
params.pops = ["YRI","CEU","BEB"]

Channel.from(params.pops)
    .map { pop ->
        [ file("$dir/${pop}.bed"), file("$dir/${pop}.bim"), file("$dir/${pop}.fam")]
    }
    .set { plink_data }
    
// plink_data.subscribe { println "$it" }

process getFreq {
    input:
    set file(bed), file(bim), file(fam) from plink_data
    
    output:
    file "${bed.baseName}.frq" into result
    
    script:
    inp = "${bed.baseName}"

    """
    plink --bfile $inp \
        --freq \
        --out ${bed.baseName}
    """
}

// /home/tefero/eanbit-RT22/nextFlow/plink --bfile $inp \