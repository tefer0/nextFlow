#!/usr/bin/env nexflow

// input_ch = Channel.fromPath("data/11.bim")

params.data = "data"
input_ch = Channel.fromPath("${params.data}/*.bim")
// inp_ch = Channel.fromPath("${params.data}/*.bim")

// data = ["Hello", "World"]
// input_ch = Channel.fromList(params.data)

process getIndex {
    input:
    file input from input_ch

    output:
    file "${input.baseName}.ids" into id_ch
    file "$input" into orig_ch
  
    script:
    "cut -f 2 $input | sort > ${input.baseName}.ids"
}

process getDups {
    input:
    file input from id_ch
  
    output:
    file "${input.baseName}.dups" into dups_ch
  
    script:
    out = "${input.baseName}.dups"

    """
    uniq -d $input > $out
    touch ignore
    """
}

process removeDups {
    publishDir "output", pattern: "${badids.baseName}_clean.bim", overwrite:true, mode:'copy'
    input:
    file badids from dups_ch
    file orig from orig_ch
    
    output:
    file "${badids.baseName}_clean.bim" into cleaned_ch
    
    script:
    "grep -v -f $badids $orig > ${badids.baseName}_clean.bim "
}

