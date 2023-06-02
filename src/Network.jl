module Network

using JSON3: write

using ..BioLab

function position!(ke_va_, id_no::AbstractDict)

    for ke_va in ke_va_

        ke_va["position"] = id_no[ke_va["data"]["id"]]["position"]

    end

end

function position!(ke_va_, js)

    position!(
        ke_va_,
        Dict(no["data"]["id"] => no for no in BioLab.Dict.read(js)["elements"]["nodes"]),
    )

end

function plot(
    el_;
    st_ = (),
    la = Dict{String, Any}("name" => "preset"),
    ex = "",
    pns = 1.0,
    pnb = "#fdfdfd",
    ht = "",
    ke_ar...,
)

    di = "BioLab.Network.plot.$(BioLab.Time.stamp())"

    if isempty(ht)

        pr = @__MODULE__

    else

        pr = splitext(basename(ht))[1]

    end

    if isempty(ex)

        re = ""

    else

        if ex == "json"

            bl = "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            bl = "cy.png({\"full\": true, \"scale\": $pns, \"bg\": \"$pnb\"})"

        else

            error()

        end

        re = "cy.ready(function() {saveAs($bl, \"$pr.$ex\");});"

    end

    BioLab.HTML.write(
        di,
        (
            "http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js",
            "https://cdn.rawgit.com/eligrey/FileSaver.js/master/dist/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.25.0/cytoscape.min.js",
        ),
        """var cy = cytoscape({
            container: document.getElementById("$di"),
            elements: $(write(el_)),
            style: $(write(st_)),
            layout: $(write(la)),
        });

        cy.on("mouseover", "node", function(ev) {
            ev.target.addClass("nodehover");
        });

        cy.on("mouseout", "node", function(ev) {
            ev.target.removeClass("nodehover");
        });

        cy.on("mouseover", "edge", function(ev) {
            ev.target.addClass("edgehover");
        });

        cy.on("mouseout", "edge", function(ev) {
            ev.target.removeClass("edgehover");
        });

        $re""";
        ke_ar...,
    )

end

end