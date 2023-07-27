using GraphResolvingSets
using GraphResolvingSets:
    fig_2a, fig_2b, fig_2c, fig_2d, fig_12a, fig_12b, example_c9, example_c10
using Graphs
using Test

@testset "WL" begin
    alg = StandardWL()
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a(), fig_12b()]
        @test isomorphism_test(alg, g1, g2)
    end
end

@testset "SPD-WL" begin
    alg = DistanceWL(; distances=UseShortestPathDistances(), anchors=UseAllVertices())
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2d()]
        @test !isomorphism_test(alg, g1, g2)
    end
    for (g1, g2) in [fig_2c(), fig_12a(), fig_12b()]
        @test isomorphism_test(alg, g1, g2)
    end
end

@testset "RD-WL" begin
    alg = DistanceWL(; distances=UseResistanceDistances(), anchors=UseAllVertices())
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a()]
        @test !isomorphism_test(alg, g1, g2)
    end
    for (g1, g2) in [fig_12b()]
        @test isomorphism_test(alg, g1, g2)
    end
    # for m in 1:7, k in 1:7
    #     k * m >= 3 || continue
    #     (g1, g2) = example_c9(m, k)
    #     @test !isomorphism_test(alg, g1, g2)
    # end
end

@testset "GD-WL" begin
    alg = DistanceWL(; distances=UseBothDistances(), anchors=UseAllVertices())
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a()]
        @test !isomorphism_test(alg, g1, g2)
    end
    for (g1, g2) in [fig_12b()]
        @test isomorphism_test(alg, g1, g2)
    end
end
