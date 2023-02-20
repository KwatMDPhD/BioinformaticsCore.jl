module Network

using JSON3: write

using ..BioLab

function position!(ke_va_, id_kec_vac::AbstractDict)

    for ke_va in ke_va_

        po = "position"

        ke_va[po] = id_kec_vac[ke_va["data"]["id"]][po]

    end

    return nothing

end

function position!(ke_va_, js)

    return position!(
        ke_va_,
        Dict(
            pop!(kec_vac["data"], "id") => kec_vac for
            kec_vac in BioLab.Dict.read(js)["elements"]["nodes"]
        ),
    )

end

function plot(el_, st_, la; ht = "", he = 800, wr = "", sc = 1.0, bg = "#fdfdfd")

    di = "BioLab.Network.plot.$(BioLab.Time.stamp())"

    if isempty(ht)

        pr = @__MODULE__

    else

        pr = splitext(basename(ht))[1]

    end

    if isempty(wr)

        re = ""

    else

        if wr == "json"

            bl = """new Blob([JSON.stringify(cy.json(), null, 2)], {type: "application/json"})"""

        elseif wr == "png"

            bl = """cy.png({"full": true, "scale": $sc, "bg": "$bg"})"""

        else

            error()

        end

        re = """cy.ready(function() {saveAs($bl, "$pr.$wr");});"""

    end

    return BioLab.HTML.write(
        di,
        (
            "http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js",
            "https://cdn.rawgit.com/eligrey/FileSaver.js/master/dist/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.1/cytoscape.min.js",
        ),
        """
        var cy = cytoscape({
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
        ht,
        he,
    )

end

end