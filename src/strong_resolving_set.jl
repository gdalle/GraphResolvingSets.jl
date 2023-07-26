function check_strong_resolving_set(
    R, g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g)
)
    for i in 1:nv(g), j in 1:(i - 1)
        strongly_resolved = false
        for r in R
            if (d[r, j] ≈ d[r, i] + d[i, j]) ||  # i in the middle
                (d[r, i] ≈ d[r, j] + d[j, i])  # j in the middle
                strongly_resolved = true
            end
        end
        if !strongly_resolved
            return false
        end
    end
    return true
end

function maximally_distant(g, i, j, d)
    for k in neighbors(g, i)
        if d[k, j] > d[i, j]
            return false
        end
    end
    return true
end

function strong_resolving_graph(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g)
)
    if is_directed(g)
        throw(
            ArgumentError("Strong metric dimension is only defined for undirected graphs.")
        )
    end
    srg = SimpleGraph(nv(g))
    for i in 1:nv(g), j in 1:(i - 1)
        if maximally_distant(g, i, j, d) && maximally_distant(g, j, i, d)
            add_edge!(srg, i, j)
        end
    end
    return srg
end

function minimum_vertex_cover_ilp(g::AbstractGraph; fractional=false)
    model = Model(HiGHS.Optimizer; add_bridges=false)
    set_silent(model)
    @variable(model, 0 <= x[r=1:nv(g)] <= 1, binary = !fractional)
    @objective(model, Min, sum(x))

    for e in edges(g)
        i, j = src(e), dst(e)
        @constraint(model, x[i] + x[j] >= 1)
    end

    optimize!(model)
    @assert termination_status(model) == OPTIMAL
    return model
end

function smallest_strong_resolving_set_ilp(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g); kwargs...
)
    srg = strong_resolving_graph(g, d)
    return minimum_vertex_cover_ilp(srg; kwargs...)
end

function smallest_strong_resolving_set(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g); kwargs...
)
    model = smallest_strong_resolving_set_ilp(g, d; kwargs...)
    x = value.(model[:x])
    SR = filter(r -> x[r] > eps(), eachindex(x))
    return sort(SR)
end

function strong_metric_dimension(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g); kwargs...
)
    model = smallest_strong_resolving_set_ilp(g, d; kwargs...)
    return objective_value(model)
end
