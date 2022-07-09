#!/usr/bin/env nexflow

input_ch = Channel.fromPath("data/11.bim")

// params.data = "data/11.bim"
// input_ch = Channel.fromPath(params.data)

// data = ["Hello", "World"]
// input_ch = Channel.fromList(params.data)

process getIndex {
    input:
    file input from input_ch

    output:
    file "ids" into id_ch
    file "11.bim" into orig_ch
  
    script:
    "cut -f 2 $input | sort > ids"
}

process getDups {
    input:
    file input from id_ch
  
    output:
    file "dups" into dups_ch
  
    script:
    """
    uniq -d $input > dups
    touch ignore
    """
}

process removeDups {
    input:
    file badids from dups_ch
    file orig from orig_ch
    
    output:
    file "clean.bim" into output
    
    script:
    "grep -v -f $badids $orig > clean.bim "
}

output.subscribe { print "Done!" }
