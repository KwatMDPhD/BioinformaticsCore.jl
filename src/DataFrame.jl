module DataFrame

using DataFrames: DataFrames, insertcols!

using OrderedCollections: OrderedDict

using StatsBase: countmap, mean

using ..BioLab

function make(an__)

    BioLab.Array.error_size(an__)

    co_ = an__[1]

    return DataFrames.DataFrame([[an_[id] for an_ in an__[2:end]] for id in eachindex(co_)], co_)

end

function make(ro, ro_, co_, _x_co_x_an)

    return insertcols!(DataFrames.DataFrame(_x_co_x_an, co_), 1, ro => ro_)

end

function separate(ro_x_co_x_an)

    co_ = names(ro_x_co_x_an)

    return co_[1], ro_x_co_x_an[:, 1]::Vector{String}, co_[2:end], Matrix(ro_x_co_x_an[!, 2:end])

end

function print_unique(ro_x_co_x_an; di = 2)

    ro_, co_, _x_co_x_an = separate(ro_x_co_x_an)[2:end]

    if di == 1

        na_ = ro_

        ea = eachrow

    elseif di == 2

        na_ = co_

        ea = eachcol

    else

        error()

    end

    for (na, an_) in zip(na_, ea(_x_co_x_an))

        println("🔦 $na")

        BioLab.Dict.print(sort(countmap(an_); byvalue = true); so = false)

    end

    return nothing

end

function collapse(ro_x_co_x_nu; fu = mean, pr = true)

    if pr

        println("📐 Before $(size(ro_x_co_x_nu))")

    end

    ro_id_ = OrderedDict{String, Vector{Int}}()

    ro, ro_, co_, ma::Matrix{Float64} = BioLab.DataFrame.separate(ro_x_co_x_nu)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, Int[]), id)

    end

    n = length(ro_id_)

    roc_ = Vector{String}(undef, n)

    mac = Matrix{Float64}(undef, (n, length(co_)))

    for (id, (ro, id_)) in enumerate(ro_id_)

        roc_[id] = ro

        if length(id_) == 1

            nu_ = ma[id_[1], :]

        else

            nu_ = [fu(nu_) for nu_ in eachcol(ma[id_, :])]

        end

        mac[id, :] = nu_

    end

    roc_x_co_x_nuc = BioLab.DataFrame.make(ro, roc_, co_, mac)

    if pr

        println("📐 After $(size(roc_x_co_x_nuc))")

    end

    return roc_x_co_x_nuc

end

function map_to(ro_x_co_x_st, ho, fr_, to; de = "")

    fr_to = Dict{String, String}()

    for (fr_, to) in zip(
        eachrow(ro_x_co_x_st[!, fr_]),
        ro_x_co_x_st[!, findfirst(co == to for co in names(ro_x_co_x_st))],
    )

        if ismissing(to)

            continue

        end

        ho(fr_to, to, to)

        for fr in fr_

            if ismissing(fr)

                continue

            end

            if isempty(de)

                fr2_ = [fr]

            else

                fr2_ = split(fr, de)

            end

            # TODO: Check if `fr` collision matters.
            for fr in fr2_

                ho(fr_to, fr, to)

            end

        end

    end

    return fr_to

end

end
