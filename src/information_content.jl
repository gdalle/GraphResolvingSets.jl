function entropy(R::AbstractVector, g::AbstractGraph, d::AbstractMatrix)
    n = nv(g)
    e = 0.0
    for i in 1:n
        new_class = true
        for j in 1:(i - 1)
            if view(d, R, i) ≈ view(d, R, j)
                new_class = false
            end
        end
        new_class || continue
        A = 1
        for j in (i + 1):n
            if view(d, R, i) ≈ view(d, R, j)
                A += 1
            end
        end
        e += logfactorial(A)
    end
    return e
end

function approximate_smallest_resolving_set(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g)
)
    R = Int[]
    current_e = entropy(R, g, d)
    while current_e > eps()
        best_e = current_e
        best_r = 0
        for r in 1:nv(g)
            r in R && continue
            push!(R, r)
            e = entropy(R, g, d)
            pop!(R)
            if e < best_e
                best_e = e
                best_r = r
            end
        end
        if best_r == 0
            break
        else
            push!(R, best_r)
            current_e = entropy(R, g, d)
        end
    end
    return sort(R)
end

function approximate_metric_dimension(
    g::AbstractGraph, d::AbstractMatrix=shortest_path_distances(g)
)
    R = approximate_smallest_resolving_set(g, d)
    return length(R)
end
