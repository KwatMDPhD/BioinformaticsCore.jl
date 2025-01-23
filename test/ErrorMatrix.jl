using Test: @test

using Omics

# ---- #

const ER = Omics.ErrorMatrix.make()

const LA_ = [1, 1, 2, 2]

const PR_ = [0, 0.4, 0.6, 1]

# 8.041 ns (0 allocations: 0 bytes)
# 6.000 ns (0 allocations: 0 bytes)
# 8.042 ns (0 allocations: 0 bytes)
# 8.042 ns (0 allocations: 0 bytes)
# 6.000 ns (0 allocations: 0 bytes)
# 6.000 ns (0 allocations: 0 bytes)
for (th, re) in (
    (
        0.0,
        [
            0 2
            0 2
        ],
    ),
    (
        0.4,
        [
            1 1
            0 2
        ],
    ),
    (
        0.5,
        [
            2 0
            0 2
        ],
    ),
    (
        0.6,
        [
            2 0
            0 2
        ],
    ),
    (
        0.7,
        [
            2 0
            1 1
        ],
    ),
    (
        1.0,
        [
            2 0
            1 1
        ],
    ),
)

    fill!(ER, 0)

    Omics.ErrorMatrix.fil!(ER, LA_, PR_, th)

    @test ER == re

    #@btime Omics.ErrorMatrix.fil!(ER, LA_, PR_, $th)

end

# ---- #

const EO = [
    1 3
    2 4
]

Omics.ErrorMatrix.plot("", EO, Omics.ErrorMatrix.summarize(EO)...)
