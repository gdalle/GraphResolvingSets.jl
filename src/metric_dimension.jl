function smallest_resolving_set_ilp(g::AbstractGraph; fractional=false)
    if is_directed(g)
        throw(ArgumentError("Metric dimension is only defined for undirected graphs."))
    end

    model = Model(HiGHS.Optimizer; add_bridges=false)
    set_silent(model)
    @variable(model, 0 <= x[k=1:nv(g)] <= 1, binary = !fractional)
    @objective(model, Min, sum(x))

    d = johnson_shortest_paths(g).dists
    for i in 1:nv(g), j in 1:(i - 1)
        possible_resolvers = AffExpr(0.0)
        for k in 1:nv(g)
            if !(d[i, k] ≈ d[j, k])
                add_to_expression!(possible_resolvers, x[k])
            end
        end
        @constraint(model, possible_resolvers >= 1)
    end

    optimize!(model)
    @assert termination_status(model) == OPTIMAL
    return model
end

function smallest_resolving_set(g::AbstractGraph; kwargs...)
    model = smallest_resolving_set_ilp(g; kwargs...)
    x = value.(model[:x])
    R = filter(i -> x[i] > 0, eachindex(x))
    return R
end

function metric_dimension(g::AbstractGraph; kwargs...)
    model = smallest_resolving_set_ilp(g; kwargs...)
    return objective_value(model)
end
