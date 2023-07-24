using GraphResolvingSets
using Graphs
using Test

for (g1, g2) in [example_c9(2, 2), example_c9(4, 1), example_c9(1, 4), example_c10(4)]
    @test isomorphism_test(WL(), g1, g2)
end
