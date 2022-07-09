#!/usr/bin/env nextflow

inp_channel = Channel.fromFilePairs("../data/*dat", size: -1) {
    f -> "${f.baseName[0..3]}" + "-" + "${f.baseName[9..10]}"
        }

process pasteData {
    input:
    set val(key), file(data) from inp_channel

    output:
    file "${key}.res" into concat_ch 

    script:
    "paste * > ${key}.res "
}

process concatData {
    publishDir "output", overwrite:true, mode:'move'
    
    input:
    file("*") from concat_ch.toList()

    output:
    file("combined.dat") into output_ch

    script:
    "cat * > combined.dat"
}

output_ch.subscribe { print "$it\n" }


