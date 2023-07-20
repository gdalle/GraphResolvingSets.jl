function maximally_distant(g, i, j, d)
    for k in neighbors(g, i)
        if d[k, j] > d[i, j]
            return false
        end
    end
    return true
end

function strong_resolving_graph(g::AbstractGraph)
    if is_directed(g)
        throw(
            ArgumentError("Strong metric dimension is only defined for undirected graphs.")
        )
    end
    d = johnson_shortest_paths(g).dists
    srg = SimpleGraph(nv(g))
    for i in 1:nv(g), j in 1:(i - 1)
        if maximally_distant(g, i, j, d) && maximally_distant(g, j, i, d)
            add_edge!(srg, i, j)
        end
    end
    return srg
end

function vertex_cover_ilp(g::AbstractGraph; fractional=false)
    model = Model(HiGHS.Optimizer; add_bridges=false)
    set_silent(model)
    @variable(model, 0 <= x[k=1:nv(g)] <= 1, binary = !fractional)
    @objective(model, Min, sum(x))

    for e in edges(g)
        i, j = src(e), dst(e)
        @constraint(model, x[i] + x[j] >= 1)
    end

    optimize!(model)
    @assert termination_status(model) == OPTIMAL
    return model
end

function smallest_strongly_resolving_set(g::AbstractGraph; kwargs...)
    srg = strong_resolving_graph(g)
    model = vertex_cover_ilp(srg; kwargs...)
    x = value.(model[:x])
    SR = filter(i -> x[i] > 0, eachindex(x))
    return SR
end

function strong_metric_dimension(g::AbstractGraph; kwargs...)
    srg = strong_resolving_graph(g)
    model = vertex_cover_ilp(srg; kwargs...)
    return objective_value(model)
end
