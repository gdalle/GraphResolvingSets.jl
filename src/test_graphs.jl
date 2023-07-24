function example_c9(m, k)
    @assert m * k >= 3
    km = k * m
    n = 2km + 1

    g1 = SimpleGraph(n)
    for i in 1:(2km)
        add_edge!(g1, i, (i % 2km) + 1)
        if i % m == 0
            add_edge!(g1, n, i)
        end
    end

    g2 = SimpleGraph(n)
    for i in 1:km
        add_edge!(g2, i, (i % km) + 1)
        add_edge!(g2, i + km, (i % km) + km + 1)
    end
    for i in 1:(2km)
        if i % m == 0
            add_edge!(g2, n, i)
        end
    end

    return (; g1, g2)
end

function example_c10(m)
    @assert m >= 3
    n = 2m

    g1 = SimpleGraph(n)
    for i in 1:n
        add_edge!(g1, i, (i % n) + 1)
    end
    add_edge!(g1, m, 2m)

    g2 = SimpleGraph(n)
    for i in 1:m
        add_edge!(g2, i, (i % m) + 1)
        add_edge!(g2, i + m, (i % m) + m + 1)
    end
    add_edge!(g2, m, 2m)

    return (; g1, g2)
end
