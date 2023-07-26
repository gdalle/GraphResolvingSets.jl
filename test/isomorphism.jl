using GraphResolvingSets
using GraphResolvingSets: fig_2a, fig_2b, fig_2c, fig_2d, fig_12a, fig_12b
using Graphs
using Test

@testset "WL" begin
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a(), fig_12b()]
        @test isomorphism_test(WL(), g1, g2)
    end
end

@testset "SPD-WL" begin
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2d()]
        @test !isomorphism_test(SPDWL(), g1, g2)
    end
    for (g1, g2) in [fig_2c(), fig_12a(), fig_12b()]
        @test isomorphism_test(SPDWL(), g1, g2)
    end
end

@testset "RD-WL" begin
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a()]
        @test !isomorphism_test(RDWL(), g1, g2)
    end
    for m in 1:10, k in 1:10
        k * m >= 3 || continue
        (g1, g2) = GraphResolvingSets.example_c9(m, k)
        @test !isomorphism_test(RDWL(), g1, g2)
    end
    for m in 3:10
        (g1, g2) = GraphResolvingSets.example_c10(m)
        @test !isomorphism_test(RDWL(), g1, g2)
    end
    for (g1, g2) in [fig_12b()]
        @test isomorphism_test(RDWL(), g1, g2)
    end
end

@testset "GD-WL" begin
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a()]
        @test !isomorphism_test(GDWL(), g1, g2)
    end
    for (g1, g2) in [fig_12b()]
        @test isomorphism_test(GDWL(), g1, g2)
    end
end
