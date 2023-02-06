function _sum_1_absolute_and_0_count(sc_, bi_)

    sut = 0.0

    suf = 0.0

    @inbounds @fastmath @simd for id in 1:length(sc_)

        if bi_[id]

            sc = sc_[id]

            if sc < 0.0

                sc = -sc

            end

            sut += sc

        else

            suf += 1.0

        end

    end

    sut, suf

end

function _xxx(sc_, bi_)

    su = 0.0

    sub = 0.0

    n = length(sc_)

    @inbounds @fastmath @simd for id in 1:n

        sc = sc_[id]

        if sc < 0.0

            sc = -sc

        end

        su += sc

        if bi_[id]

            sub += sc

        end

    end

    su, sub, n

end
