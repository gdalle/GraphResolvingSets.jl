module GraphResolvingSets

using Graphs
using HiGHS
using JuMP
using MathOptInterface
using SimpleUnPack
using SpecialFunctions

export check_resolving_set, check_strong_resolving_set
export smallest_resolving_set, smallest_strong_resolving_set
export metric_dimension, strong_metric_dimension
export approximate_smallest_resolving_set, approximate_metric_dimension
export Multiset
export WL, SPDWL, RDWL, GDWL, color_refinement, isomorphism_test
export example_c9, example_c10

include("resolving_set.jl")
include("strong_resolving_set.jl")
include("information_content.jl")
include("multiset.jl")
include("color_refinement.jl")
include("test_graphs.jl")

end
