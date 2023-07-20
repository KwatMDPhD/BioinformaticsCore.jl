module Plot

using ColorSchemes: ColorScheme, bwr, plasma

using Colors: Colorant, hex

using DataFrames: DataFrame

using JSON: json

using Printf: @sprintf

using BioLab

const _CO = "continuous"

const _CA = "categorical"

const _BI = "binary"

const _MO = "monotonous"

function make_color_scheme(he_, ca, no)

    ColorScheme([parse(Colorant{Float64}, he) for he in he_], ca, no)

end

const COBWR = ColorScheme(bwr.colors, _CO, "Blue White Red")

const COPLA = ColorScheme(plasma.colors, _CO, "PLAsma")

const COPL3 = make_color_scheme(
    (
        "#0508b8",
        "#1910d8",
        "#3c19f0",
        "#6b1cfb",
        "#981cfd",
        "#bf1cfd",
        "#dd2bfd",
        "#f246fe",
        "#fc67fd",
        "#fe88fc",
        "#fea5fd",
        "#febefe",
        "#fec3fe",
    ),
    _CO,
    "PLotly3",
)

const COASP = make_color_scheme(
    ("#00936e", "#a4e2b4", "#e0f5e5", "#ffffff", "#fff8d1", "#ffec9f", "#ffd96a"),
    _CO,
    "ASPen",
)

const COPLO = make_color_scheme(
    (
        "#636efa",
        "#ef553b",
        "#00cc96",
        "#ab63fa",
        "#ffa15a",
        "#19d3f3",
        "#ff6692",
        "#b6e880",
        "#ff97ff",
        "#fecb52",
    ),
    _CA,
    "PLOtly",
)

const COGUA = make_color_scheme(("#20d9ba", "#9017e6", "#4e40d8", "#ff1968"), _CA, "GUArdiome")

const COBIN = make_color_scheme(("#006442", "#ffb61e"), _BI, "BINary")

const COHUM = make_color_scheme(("#4b3c39", "#ffddca"), _BI, "HUMan")

const COSTA = make_color_scheme(("#8c1515", "#175e54"), _BI, "STAnford")

const COMON = make_color_scheme(("#fbb92d",), _MO, "MONotonous")

function _make_hex(rg)

    he = lowercase(hex(rg))

    "#$he"

end

function fractionate(co)

    collect(zip(0:(1 / (length(co) - 1)):1, _make_hex(rg) for rg in co))

end

function pick_color_scheme(nu_::AbstractArray{Int})

    n = length(unique(nu_))

    if n <= 1

        COMON

    elseif n <= 2

        COBIN

    else

        COPLO

    end

end

function pick_color_scheme(::AbstractArray{Float64})

    COBWR

end

function color(nu::Real, co)

    _make_hex(co[nu])

end

function color(nu_, co = pick_color_scheme(nu_))

    color.(nu_, (co,))

end

function plot(ht, data, layout = Dict{String, Any}(); config = Dict{String, Any}(), ke_ar...)

    id = "Plotly"

    daj = json(data)

    laj = json(BioLab.Dict.merge(Dict("hovermode" => "closest"), layout))

    coj = json(BioLab.Dict.merge(Dict("displaylogo" => false), config))

    BioLab.HTML.make(
        ht,
        id,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        """Plotly.newPlot("$id", $daj, $laj, $coj)""";
        ke_ar...,
    )

end

function _set_x(y_)

    [collect(eachindex(y)) for y in y_]

end

function _set_text(y_)

    fill(Vector{String}(), length(y_))

end

function _set_name(y_)

    ["Name $id" for id in eachindex(y_)]

end

function _set_color(y_)

    color(eachindex(y_))

end

function _set_opacity(y_)

    fill(0.8, length(y_))

end

function make_colorbar(z, x)

    tickvals = BioLab.NumberArray.range(skipmissing(z), 10)

    Dict(
        "x" => x,
        "thicknessmode" => "fraction",
        "thickness" => 0.024,
        "len" => 0.5,
        "tickvmode" => "array",
        "tickvals" => tickvals,
        "ticktext" => [@sprintf("%.3g", ti) for ti in tickvals],
        "ticks" => "outside",
        "tickfont" => Dict("size" => 10),
    )

end

const AXIS = Dict("automargin" => true, "showgrid" => false)

const SPIKE = Dict(
    "showspikes" => true,
    "spikemode" => "across",
    "spikesnap" => "cursor",
    "spikedash" => "solid",
    "spikethickness" => 1,
    "spikecolor" => "#561649",
)

const ANNOTATION = Dict(
    "yref" => "paper",
    "xref" => "paper",
    "yanchor" => "middle",
    "xanchor" => "center",
    "showarrow" => false,
)

function plot_scatter(
    ht,
    y_,
    x_ = _set_x(y_);
    text_ = _set_text(y_),
    name_ = _set_name(y_),
    mode_ = [ifelse(length(y) < 10^3, "markers+lines", "lines") for y in y_],
    marker_color_ = _set_color(y_),
    opacity_ = _set_opacity(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        # TODO: Check if mapping using a variable of the parent scope slows the performance.
        [
            Dict(
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "text" => text_[id],
                "mode" => mode_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => opacity_[id]),
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge(Dict("yaxis" => AXIS, "xaxis" => AXIS), layout);
        ke_ar...,
    )

end

function plot_bar(
    ht,
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_color_ = _set_color(y_),
    opacity_ = _set_opacity(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        [
            Dict(
                "type" => "bar",
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => opacity_[id]),
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge(Dict("yaxis" => AXIS, "xaxis" => AXIS), layout);
        ke_ar...,
    )

end

function plot_histogram(
    ht,
    x_,
    text_ = _set_text(x_);
    rug_marker_size = ifelse(all(length(x) < 100000 for x in x_), 16, 0),
    name_ = _set_name(x_),
    marker_color_ = _set_color(x_),
    opacity_ = _set_opacity(x_),
    histnorm = "",
    xbins_size = 0,
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n = length(x_)

    if 0 < rug_marker_size

        fr = min(n * 0.08, 0.5)

    else

        fr = 0

    end

    if isempty(histnorm)

        yaxis2_title_text = "Count"

    else

        yaxis2_title_text = titlecase(histnorm)

    end

    layout = BioLab.Dict.merge(
        Dict(
            "yaxis" => BioLab.Dict.merge(
                AXIS,
                Dict(
                    "domain" => (0, fr),
                    "zeroline" => false,
                    "dtick" => 1,
                    "showticklabels" => false,
                ),
            ),
            "yaxis2" => BioLab.Dict.merge(
                AXIS,
                Dict("domain" => (fr, 1), "title" => Dict("text" => yaxis2_title_text)),
            ),
            "xaxis" => BioLab.Dict.merge(AXIS, Dict("anchor" => "y")),
        ),
        layout,
    )

    data = Vector{Dict{String, Any}}()

    showlegend = 1 < length(x_)

    for id in 1:n

        marker = Dict("color" => marker_color_[id], "opacity" => opacity_[id])

        le = Dict(
            "showlegend" => showlegend,
            "legendgroup" => id,
            "name" => name_[id],
            "x" => x_[id],
            "marker" => marker,
        )

        push!(
            data,
            BioLab.Dict.merge(
                le,
                Dict(
                    "yaxis" => "y2",
                    "type" => "histogram",
                    "histnorm" => histnorm,
                    "xbins" => Dict("size" => xbins_size),
                ),
            ),
        )

        if 0 < rug_marker_size

            push!(
                data,
                BioLab.Dict.merge(
                    le,
                    Dict(
                        "showlegend" => false,
                        "y" => fill(id, length(x_[id])),
                        "text" => text_[id],
                        "mode" => "markers",
                        "marker" => BioLab.Dict.merge(
                            marker,
                            Dict("symbol" => "line-ns-open", "size" => rug_marker_size),
                        ),
                        "hoverinfo" => "x+text",
                    ),
                ),
            )

        end

    end

    plot(ht, data, layout; ke_ar...)

end

function plot_heat_map(
    ht,
    z::AbstractMatrix,
    y = ["$id *" for id in 1:size(z, 1)],
    x = ["* $id" for id in 1:size(z, 2)];
    text = z,
    nar = "Row",
    nac = "Column",
    colorscale = fractionate(COBWR),
    grr_ = Vector{Int}(),
    grc_ = Vector{Int}(),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n_ro, n_co = size(z)

    domain1 = (0, 0.95)

    axis2 = BioLab.Dict.merge(AXIS, Dict("domain" => (0.96, 1), "tickvals" => ()))

    layout = BioLab.Dict.merge(
        Dict(
            "yaxis" => BioLab.Dict.merge(
                AXIS,
                Dict(
                    "domain" => domain1,
                    "autorange" => "reversed",
                    "title" => Dict("text" => "$nar (n=$n_ro)"),
                ),
            ),
            "xaxis" => BioLab.Dict.merge(
                AXIS,
                Dict("domain" => domain1, "title" => Dict("text" => "$nac (n=$n_co)")),
            ),
            "yaxis2" => BioLab.Dict.merge(axis2, Dict("autorange" => "reversed")),
            "xaxis2" => axis2,
        ),
        layout,
    )

    data = Vector{Dict{String, Any}}()

    # TODO: Cluster within a group.

    colorbarx = 1

    if !isempty(grr_)

        colorbarx += 0.04

        if eltype(grr_) <: AbstractString

            gr_id = BioLab.Collection.index(unique(grr_))[1]

            grr_ = [gr_id[gr] for gr in grr_]

        end

        so_ = sortperm(grr_)

        grr_ = grr_[so_]

        y = y[so_]

        z = z[so_, :]

    end

    if !isempty(grc_)

        # TODO: Test.
        if eltype(grc_) <: AbstractString

            gr_id = BioLab.Collection.index(unique(grc_))[1]

            grc_ = [gr_id[gr] for gr in grc_]

        end

        so_ = sortperm(grc_)

        grc_ = grc_[so_]

        x = x[so_]

        z = z[:, so_]

    end

    push!(
        data,
        Dict(
            "type" => "heatmap",
            "z" => collect(eachrow(z)),
            "y" => y,
            "x" => x,
            "text" => collect(eachrow(text)),
            "hoverinfo" => "y+x+z+text",
            "colorscale" => colorscale,
            "colorbar" => make_colorbar(z, colorbarx),
        ),
    )

    if !isempty(grr_)

        push!(
            data,
            Dict(
                "type" => "heatmap",
                "xaxis" => "x2",
                "z" => [[grr] for grr in grr_],
                "hoverinfo" => "y+z",
                "colorscale" => fractionate(COPLO),
                "colorbar" => make_colorbar(z, colorbarx += 0.06),
            ),
        )

    end

    if !isempty(grc_)

        push!(
            data,
            Dict(
                "type" => "heatmap",
                "yaxis" => "y2",
                "z" => [grc_],
                "hoverinfo" => "x+z",
                "colorscale" => fractionate(COPLO),
                "colorbar" => make_colorbar(z, colorbarx += 0.06),
            ),
        )

    end

    plot(ht, data, layout; ke_ar...)

end

function plot_heat_map(ht, da; ke_ar...)

    nar, ro_, co_, ro_x_co_x_nu = BioLab.DataFrame.separate(da)

    plot_heat_map(ht, ro_x_co_x_nu, ro_, co_; nar, ke_ar...)

end

function plot_radar(
    ht,
    theta_,
    r_;
    radialaxis_range = (0, maximum(vcat(r_...))),
    name_ = _set_name(theta_),
    line_color_ = _set_color(theta_),
    fillcolor_ = line_color_,
    opacity_ = _set_opacity(theta_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    costa = "#b83a4b"

    cofai = "#ebf6f7"

    plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "name" => name_[id],
                "theta" => vcat(theta_[id], theta_[id][1]),
                "r" => vcat(r_[id], r_[id][1]),
                "opacity" => opacity_[id],
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 1,
                    "color" => line_color_[id],
                ),
                "marker" => Dict("size" => 4, "color" => line_color_[id]),
                "fill" => "toself",
                "fillcolor" => fillcolor_[id],
            ) for id in eachindex(theta_)
        ],
        BioLab.Dict.merge(
            Dict(
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "ticks" => "",
                        "tickfont" =>
                            Dict("size" => 32, "family" => "Optima", "color" => "#23191e"),
                        "linewidth" => 4,
                        "linecolor" => costa,
                        "gridwidth" => 2,
                        "gridcolor" => cofai,
                    ),
                    "radialaxis" => Dict(
                        "range" => radialaxis_range,
                        "nticks" => 10,
                        "tickcolor" => costa,
                        "tickangle" => 90,
                        "tickfont" => Dict(
                            "size" => 12,
                            "family" => "Monospace",
                            "color" => "#1f4788",
                        ),
                        "linewidth" => 0.8,
                        "linecolor" => costa,
                        "gridwidth" => 1.2,
                        "gridcolor" => cofai,
                    ),
                ),
                "title" => Dict(
                    "x" => 0.01,
                    "font" => Dict(
                        "size" => 48,
                        "family" => "Times New Roman",
                        "color" => "#27221f",
                    ),
                ),
            ),
            layout,
        );
        ke_ar...,
    )

end

function animate(gi, pn_)

    BioLab.Path.warn_overwrite(gi)

    BioLab.Path.error_extension_difference(gi, "gif")

    run(`convert -delay 32 -loop 0 $pn_ $gi`)

    BioLab.Path.open(gi)

end

end
