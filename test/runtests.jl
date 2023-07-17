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
end
