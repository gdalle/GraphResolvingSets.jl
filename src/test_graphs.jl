function example_c9(m, k)
    @assert m * k >= 3
    km = k * m
    n = 2km + 1

    E1 = vcat(
        [(i, (i % 2km) + 1) for i in 1:(2km)],  #
        [(n, i) for i in 1:(2km) if i % m == 0],  #
    )

    E2 = vcat(
        [(i, (i % km) + 1) for i in 1:km],  #
        [(i + km, (i % km) + km + 1) for i in 1:km],  #
        [(n, i) for i in 1:(2km) if i % m == 0],  #
    )

    g1 = SimpleGraph(Edge.(E1))
    g2 = SimpleGraph(Edge.(E2))
    @assert nv(g1) == nv(g2) == n
    return g1, g2
end

function example_c10(m)
    @assert m >= 3
    n = 2m

    E1 = vcat(
        [(i, (i % n) + 1) for i in 1:n],  #
        [(m, 2m)],  #
    )

    E2 = vcat(
        [(i, (i % m) + 1) for i in 1:m], #
        [(i + m, (i % m) + m + 1) for i in 1:m], #
        [(m, 2m)],  #
    )

    g1 = SimpleGraph(Edge.(E1))
    g2 = SimpleGraph(Edge.(E2))
    @assert nv(g1) == nv(g2) == n
    return g1, g2
end

fig_2a() = example_c9(2, 2)
fig_2b() = example_c9(4, 1)
fig_2c() = example_c9(1, 4)
fig_2d() = example_c10(4)

function fig_12a()
    g1 = DodecahedralGraph()
    g2 = DesarguesGraph()
    return g1, g2
end

function fig_12b()
    g1 = shrikhande_graph()
    g2 = rook4_graph()
    return g1, g2
end

"""
    latin_square_graph(latin_square)

Construct the graph associated with a latin square.

# References

https://cameroncounts.wordpress.com/2010/08/26/the-shrikhande-graph/
"""
function latin_square_graph(latin_square)
    n = size(latin_square, 1)
    g = SimpleGraph(n^2)
    for i1 in 1:n, j1 in 1:n
        for i2 in 1:n, j2 in 1:n
            (i1, j1) == (i2, j2) && continue
            if (i1 == i2) || (j1 == j2) || (latin_square[i1, j1] == latin_square[i2, j2])
                u = n * (i1 - 1) + (j1 - 1) + 1
                v = n * (i2 - 1) + (j2 - 1) + 1
                add_edge!(g, u, v)
            end
        end
    end
    return g
end

const rook_latin_square_order_4 = [
    1 2 3 4
    2 1 4 3
    3 4 1 2
    4 3 2 1
]

const shrikhande_latin_square_order_4 = [
    1 2 3 4
    2 3 4 1
    3 4 1 2
    4 1 2 3
]

function rook4_graph()
    return complement(latin_square_graph(rook_latin_square_order_4))
end

function shrikhande_graph()
    return complement(latin_square_graph(shrikhande_latin_square_order_4))
end
