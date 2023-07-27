function check_resolving_set(
    R, g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g)
)
    for i in 1:nv(g), j in 1:(i - 1)
        resolved = false
        for r in R
            if !recursive_isapprox(d[i, r], d[j, r])
                resolved = true
            end
        end
        if !resolved
            return false
        end
    end
    return true
end

function smallest_resolving_set_ilp(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g); fractional=false
)
    if is_directed(g)
        throw(ArgumentError("Metric dimension is only defined for undirected graphs."))
    end

    model = Model(HiGHS.Optimizer; add_bridges=false)
    set_silent(model)
    @variable(model, 0 <= x[r=1:nv(g)] <= 1, binary = !fractional)
    @objective(model, Min, sum(x))

    for i in 1:nv(g), j in 1:(i - 1)
        possible_resolvers = AffExpr(0.0)
        for r in 1:nv(g)
            if !recursive_isapprox(d[i, r], d[j, r])
                add_to_expression!(possible_resolvers, x[r])
            end
        end
        @constraint(model, possible_resolvers >= 1)
    end

    optimize!(model)
    @assert termination_status(model) == OPTIMAL
    return model
end

function smallest_resolving_set(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g); kwargs...
)
    model = smallest_resolving_set_ilp(g, d; kwargs...)
    x = value.(model[:x])
    R = filter(r -> x[r] > eps(), eachindex(x))
    return sort(R)
end

function metric_dimension(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g); kwargs...
)
    model = smallest_resolving_set_ilp(g, d; kwargs...)
    return objective_value(model)
end
