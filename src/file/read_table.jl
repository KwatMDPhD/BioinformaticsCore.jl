using CSV: read, File
using DataFrames: DataFrame
using Mmap: mmap


function read_table(pa::String)::DataFrame

    return DataFrame(File(pa))

end

export read_table
