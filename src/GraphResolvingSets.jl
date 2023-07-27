module GraphResolvingSets

using Combinatorics
using FillArrays
using Graphs
using HiGHS
using JuMP
using LinearAlgebra
using MathOptInterface
using SimpleUnPack
using SpecialFunctions
using StatsBase

export shortest_path_distances, resistance_distances
export check_resolving_set, check_strong_resolving_set, check_unordered_resolving_set
export smallest_resolving_set, smallest_strong_resolving_set
export smallest_unordered_resolving_set, equivariant_unordered_resolving_set
export metric_dimension, strong_metric_dimension
export approximate_smallest_resolving_set, approximate_metric_dimension
export StandardWL, DistanceWL
export UseShortestPathDistances, UseResistanceDistances, UseBothDistances
export UseAllVertices, UseResolvingSet
export color_refinement, isomorphism_test

include("utils.jl")
include("distances.jl")
include("resolving_set.jl")
include("strong_resolving_set.jl")
include("unordered_resolving_set.jl")
include("information_content.jl")
include("color_refinement.jl")
include("test_graphs.jl")

end
