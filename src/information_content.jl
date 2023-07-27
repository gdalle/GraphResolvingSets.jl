function partition_entropy(
    R::AbstractVector{<:Integer}, g::AbstractGraph, d::AbstractMatrix; unordered=false
)
    n = nv(g)
    e = logfactorial(0)
    for i in 1:n
        d_Ri = d[R, i]
        unordered && sort!(d_Ri)
        # Decide if i starts a new class in the partition
        new_class = true
        for j in 1:(i - 1)
            d_Rj = d[R, j]
            unordered && sort!(d_Rj)
            if recursive_isapprox(d_Ri, d_Rj)
                new_class = false
            end
        end
        new_class || continue
        # Count the number of js in the same class as i
        A = 1
        for j in (i + 1):n
            d_Rj = d[R, j]
            unordered && sort!(d_Rj)
            if recursive_isapprox(d_Ri, d_Rj)
                A += 1
            end
        end
        e += logfactorial(A)
    end
    return e
end

function approximate_smallest_resolving_set(
    g::AbstractGraph,
    d::AbstractMatrix=shortest_path_distances(g);
    unordered=false,
    permutation_invariant=false,
)
    R = Int[]
    current_e = partition_entropy(R, g, d; unordered)
    while current_e > eps()
        best_e = current_e
        best_rs = Int[]
        for r in 1:nv(g)
            r in R && continue
            push!(R, r)
            e = partition_entropy(R, g, d; unordered)
            pop!(R)
            if e ≈ best_e
                if permutation_invariant
                    push!(best_rs, r)  # get them all
                end
            elseif e < best_e
                best_e = e
                best_rs = [r]
            end
        end
        if isempty(best_rs)
            break
        else
            append!(R, best_rs)
            current_e = partition_entropy(R, g, d; unordered)
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
