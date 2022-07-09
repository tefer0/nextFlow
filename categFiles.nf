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
    
    """
    plink --bed $bed \
        --bim $bim \
        --fam $fam \
        --freq \
        --out ${bed.baseName}
    """
}

// commands = Channel.fromFilePairs("/usr/bin/*", size:-1) { it.baseName[0] }

// commands.subscribe { k = it[0];
//     n = it[1].size();
//     println "There are $n files starting with $k";
//     }

// Channel
//     .fromFilePairs ("${params.dir}/*.{bed,fam,bim}", size:3, flat : true)
//     .ifEmpty { error "No matching plink files" }
//     .set { plink_data }

// plink_data.subscribe { println "$it" }

// Channel
//     .fromFilePairs("${params.dir}/{YRI,BEB,CEU}.{bed,bim,fam}",size:3) {
//         file -> file.baseName 
//     }
//     .filter { key, files -> key in params.pops }
//     .set { plink_data }

// process checkData {
//     input:
//     set pop, file(pl_files) from plink_data
    
//     output:
//     file "${pop}.frq" into result
    
//     script:
//     "plink --bfile $pop --freq  --out $pop"
// }