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
    return (; g1, g2)
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
    return (; g1, g2)
end

fig_2a() = example_c9(2, 2)
fig_2b() = example_c9(4, 1)
fig_2c() = example_c9(1, 4)
fig_2d() = example_c10(4)
