using GraphResolvingSets
using Graphs
using Test

for n in 3:7
    for g in (path_graph(n), cycle_graph(n), grid((n, n)), complete_graph(n))
        @test check_resolving_set(smallest_resolving_set(g), g)
        @test check_resolving_set(approximate_smallest_resolving_set(g), g)
        @test check_strong_resolving_set(smallest_strong_resolving_set(g), g)
    end
end
