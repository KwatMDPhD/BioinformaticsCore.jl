module OnePiece

for pa in readdir(@__DIR__, join = true)

    if isdir(pa)

        include(joinpath(basename(pa), "_.jl"))

    end

end

function __init__()

    global TE = OnePiece.Path.make_temporary("OnePiece")

    ENV["LINES"] = 19

    ENV["COLUMNS"] = convert(Int, 1e5)

end

end
