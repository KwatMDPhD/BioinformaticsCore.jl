include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "Collection")

# ---- #

for an_ in (
    (),
    (1, 1),
    [1, 1],
    [1, 2, 2],
    [1 1; 2 2],
    [1 2; 1 2],
    [1 2; 3 1],
    [nothing, nothing],
    [missing, missing],
    [NaN, NaN],
    [Inf, Inf],
    [0.5, 1 / 2, 1 // 2],
    ['a', 'b', 'b'],
)

    @test @is_error BioLab.Collection.error_duplicate(an_)

end

# ---- #

for an_ in (
    (1, 2),
    [],
    [1, 2],
    [1, 2, 3],
    [1 2; 3 4],
    [nothing, missing, NaN, -Inf, Inf, -0.0, 0.0],
    [1.0, 2],
    ['a', 'b', 'c'],
    ['a', 'b', 'c', "c"],
)

    @test !@is_error BioLab.Collection.error_duplicate(an_)

end

# ---- #

for an_ in (
    (),
    (1, 1),
    [1, 1],
    [1, 1, 1],
    [1 1],
    [1 1; 1 1],
    [nothing, nothing],
    [missing, missing],
    [NaN, NaN],
    [-Inf, -Inf],
    [Inf, Inf],
    ['a', 'a'],
    ["a", "a"],
)

    @test @is_error BioLab.Collection.error_no_change(an_)

end

# ---- #

for an_ in (
    (1, 2),
    [],
    [1, 2],
    [1, 2, 3],
    [1 2],
    [1 1; 1 2],
    [1.0, 2],
    [nothing, missing],
    [nothing, NaN],
    [missing, NaN],
    [-Inf, Inf],
    [-0.0, 0.0],
    ['a', 'b'],
    ['a', "a"],
)

    @test !@is_error BioLab.Collection.error_no_change(an_)

end

# ---- #

@test BioLab.Collection.index(("Aa", "Ii", "Uu", "Ee", "Oo")) == (
    Dict("Aa" => 1, "Ii" => 2, "Uu" => 3, "Ee" => 4, "Oo" => 5),
    Dict(1 => "Aa", 2 => "Ii", 3 => "Uu", 4 => "Ee", 5 => "Oo"),
)

# ---- #

# TODO: Try with Tuple.
an_ = ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

an1_ = ['1', '2', 'K']

@test BioLab.Collection.is_in(an_, an1_) ==
      [false, true, false, false, false, false, false, false, false, false, false, false, true]

@test BioLab.Collection.is_in(Dict('A' => 1, '2' => 2, '3' => 3, 'Q' => 4, 'K' => 5), an1_) ==
      [false, true, false, false, true]

@test BioLab.Collection.is_in(Dict('A' => 5, '2' => 4, '3' => 3, 'Q' => 2, 'K' => 1), an1_) ==
      [true, false, false, true, false]

@test BioLab.Collection.is_in(an_, an1_) ==
      BioLab.Collection.is_in(an_, Set(an1_)) ==
      BioLab.Collection.is_in(Dict(ca => id for (id, ca) in enumerate(an_)), an1_)

# ---- #

fe_ = reverse!(BioLab.Table.read(joinpath(DA, "gene_x_statistic_x_number.tsv"))[!, 1])

fe1_ = BioLab.GMT.read(joinpath(DA, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

# 454.167 μs (2 allocations: 19.67 KiB)
#@btime BioLab.Collection.is_in($fe_, $(Set(fe1_)));

# 740.875 μs (2 allocations: 19.67 KiB)
#@btime BioLab.Collection.is_in($fe_, $fe1_);

# 616.616 ns (2 allocations: 19.67 KiB)
# 929.688 ns (2 allocations: 19.67 KiB)
#@btime BioLab.Collection.is_in($(Dict(fe => id for (id, fe) in enumerate(fe_))), $fe1_);
