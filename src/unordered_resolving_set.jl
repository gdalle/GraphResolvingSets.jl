function check_unordered_resolving_set(
    R, g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g)
)
    d_iR = d[1, R]
    d_jR = d[1, R]
    for i in 1:nv(g), j in 1:(i - 1)
        for (k, r) in enumerate(R)
            d_iR[k] = d[i, r]
            d_jR[k] = d[j, r]
        end
        sort!(d_iR)
        sort!(d_jR)
        if recursive_isapprox(d_iR, d_jR)
            return false
        end
    end
    return true
end

function smallest_unordered_resolving_set(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g); must_contain=nothing
)
    for R in powerset(1:nv(g))
        if must_contain !== nothing && must_contain ∉ R
            continue
        end
        if check_unordered_resolving_set(R, g, d)
            return R
        end
    end
    return nothing
end

function unordered_metric_dimension(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g)
)
    R = smallest_unordered_resolving_set(g, d)
    if R !== nothing
        return length(R)
    else
        return nothing
    end
end

function equivariant_unordered_resolving_set(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g);
)
    umd = unordered_metric_dimension(g, d)
    if umd === nothing
        return nothing
    end
    R_equiv = Int[]
    for r in 1:nv(g)
        R = smallest_unordered_resolving_set(g, d; must_contain=r)
        if R !== nothing && length(R) == umd
            push!(R_equiv, r)
        end
    end
    return R_equiv
end
