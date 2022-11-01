function make(di, sr_, sc, ht = "")

    if isempty(ht)

        ht = joinpath(OnePiece.TE, "$(OnePiece.Time.stamp()).html")

    end

    li_ = vcat(
        "<!doctype html>",
        "<div id=\"$di\" style=\"display: block; height: 1000px; width: 90%; margin: auto; background: #f8f8f8\"></div>",
        ["<script src=\"$sr\"></script>" for sr in sr_],
        "<script>",
        "$sc",
        "</script>",
    )

    jo = join(li_, "\n")

    open(ht, "w") do io

        write(io, jo)

    end

    println("Wrote $ht.")

    display(Base.HTML(jo))

end
