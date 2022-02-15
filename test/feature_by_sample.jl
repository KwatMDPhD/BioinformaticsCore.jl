TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

n_ro = 5

n_co = 4

n_ze = convert(Int64, n_co / 2)

n_on = n_co - n_ze

bi_ = convert(BitVector, [zeros(n_ze); ones(n_on)])

ve = [10^(id - 1) for id in 1:n_co]

ma = convert(Matrix, reshape(1:(n_ro * n_co), (n_ro, n_co)))

OnePiece.feature_by_sample.compare_with_target(bi_, ma, "signal_to_noise_ratio")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end