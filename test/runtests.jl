using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

for mo in (
    "Clustering",
    "Color",
    "Density",
    "Dic",
    "Distance",
    "Entropy",
    "ErrorMatrix",
    "Evidence",
    "Extreme",
    "GeneralizedLinearModel",
    "Grid",
    "HTM",
    "Information",
    "Match",
    "MutualInformation",
    "Normalization",
    "Palette",
    "Path",
    "Plot",
    "Probability",
    "ROC",
    "Significance",
    "Simulation",
    "Strin",
    "Table",
    "Target",
    "XSample",
)

    @info "🎬 Running $mo"

    run(`julia --project $mo.jl`)

end

# ---- #

xs = rand(1000);

@btime pushfirst!(xs, 0.0);

@btime vcat(0.0, xs);
