"""
    shortest_path_distances(g)

Compute the matrix of all-pairs shortest path distances using Johnson's algorithm.
"""
function shortest_path_distances(g)
    return johnson_shortest_paths(g).dists
end

"""
    resistance_distances(g)

Compute the matrix of all-pairs resistance distances using a connection with the graph Laplacian.

# References

- Equation 2 of _Resistance distance and Laplacian spectrum_ (Xiao and Gutman, 2003, https://link.springer.com/article/10.1007/s00214-003-0460-4)
"""
function resistance_distances(g)
    L = laplacian_matrix(g)
    L⁺ = pinv(Matrix(L))
    d = similar(L⁺)
    for i in axes(L⁺, 1), j in axes(L⁺, 2)
        d[i, j] = L⁺[i, i] + L⁺[j, j] - L⁺[i, j] - L⁺[j, i]
    end
    return d
end
