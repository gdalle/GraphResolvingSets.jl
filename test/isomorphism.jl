using GraphResolvingSets
using GraphResolvingSets: fig_2a, fig_2b, fig_2c, fig_2d, fig_12a, fig_12b
using Graphs
using Test

@testset "WL" begin
    alg = StandardWL()
    for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a(), fig_12b()]
        @test isomorphism_test(alg, g1, g2)
    end
end

@testset "SPD-WL" begin
    alg_dense = DistanceWL(; distances=UseShortestPathDistances(), anchors=UseAllVertices())
    alg_sparse = DistanceWL(;
        distances=UseShortestPathDistances(), anchors=UseResolvingSet()
    )
    for alg in (alg_dense, alg_sparse)
        for (g1, g2) in [fig_2a(), fig_2b(), fig_2d()]
            @test !isomorphism_test(alg, g1, g2)
        end
        for (g1, g2) in [fig_2c(), fig_12a(), fig_12b()]
            @test isomorphism_test(alg, g1, g2)
        end
    end
end

@testset "RD-WL" begin
    alg_dense = DistanceWL(; distances=UseResistanceDistances(), anchors=UseAllVertices())
    alg_sparse = DistanceWL(; distances=UseResistanceDistances(), anchors=UseResolvingSet())
    for alg in (alg_dense, alg_sparse)
        for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a()]
            @test !isomorphism_test(alg, g1, g2)
        end
        for (g1, g2) in [fig_12b()]
            @test isomorphism_test(alg, g1, g2)
        end
    end
end

@testset "GD-WL" begin
    alg_dense = DistanceWL(; distances=UseBothDistances(), anchors=UseAllVertices())
    alg_sparse = DistanceWL(; distances=UseBothDistances(), anchors=UseResolvingSet())
    for alg in (alg_dense, alg_sparse)
        for (g1, g2) in [fig_2a(), fig_2b(), fig_2c(), fig_2d(), fig_12a()]
            @test !isomorphism_test(alg, g1, g2)
        end
        for (g1, g2) in [fig_12b()]
            @test isomorphism_test(alg, g1, g2)
        end
    end
end
