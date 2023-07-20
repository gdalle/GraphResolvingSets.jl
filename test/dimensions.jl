using GraphResolvingSets
using Graphs
using Test

@testset "Path" begin
    for n in 3:7
        g = path_graph(n)
        @test metric_dimension(g) ≈ 1 <= approximate_metric_dimension(g)
        @test strong_metric_dimension(g) ≈ 1
    end
end

@testset "Cycle" begin
    for n in 3:7
        g = cycle_graph(n)
        @test metric_dimension(g) ≈ 2 <= approximate_metric_dimension(g)
        @test strong_metric_dimension(g) ≈ ceil(n / 2)
    end
end

@testset "Grid" begin
    for n in 2:7
        g = grid((n, n))
        @test metric_dimension(g) ≈ 2 <= approximate_metric_dimension(g)
    end
end

@testset "Complete" begin
    for n in 2:7
        g = complete_graph(n)
        @test metric_dimension(g) ≈ n - 1 <= approximate_metric_dimension(g)
        @test strong_metric_dimension(g) ≈ n - 1
    end
end
