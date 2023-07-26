using GraphResolvingSets
using GraphResolvingSets: fig_2a, fig_2b, fig_2c, fig_2d
using Graphs
using Test

@testset "WL" begin
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d()]
        @test isomorphism_test(WL(), g1, g2)
    end
end

@testset "SPD-WL" begin
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2d()]
        @test !isomorphism_test(SPDWL(), g1, g2)
    end
    for (g1, g2) in [fig_2c()]
        @test isomorphism_test(SPDWL(), g1, g2)
    end
end

@testset "SPDRD-WL" begin
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d()]
        @test !isomorphism_test(SPDRDWL(), g1, g2)
    end
end
