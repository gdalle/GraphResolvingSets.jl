module GraphResolvingSets

using Graphs
using HiGHS
using JuMP
using MathOptInterface
using SimpleUnPack: @unpack

export smallest_resolving_set, metric_dimension
export smallest_strongly_resolving_set, strong_metric_dimension

include("metric_dimension.jl")
include("strong_metric_dimension.jl")

end
