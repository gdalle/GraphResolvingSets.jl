using Aqua
using GraphResolvingSets
using JET
using JuliaFormatter
using Test

@testset verbose = true "GraphResolvingSets.jl" begin
    @testset "Code formatting" begin
        @test JuliaFormatter.format(GraphResolvingSets; verbose=false, overwrite=false)
    end

    @testset "Code quality" begin
        Aqua.test_all(GraphResolvingSets; ambiguities=false)
    end

    @testset "Code linting" begin
        if VERSION >= v"1.9"
            JET.test_package(GraphResolvingSets; target_defined_modules=true)
        end
    end

    @testset verbose = true "Metric dimensions" begin
        include("dimensions.jl")
    end

    @testset verbose = true "Resolving sets" begin
        include("sets.jl")
    end

    @testset verbose = true "Isomorphism tests" begin
        include("isomorphism.jl")
    end
end
