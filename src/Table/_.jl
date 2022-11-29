module Table

using CodecZlib: GzipDecompressor, transcode

using CSV: read as CSV_read, write as CSV_write

using DataFrames: DataFrame

using Mmap: mmap

using XLSX: readtable

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
