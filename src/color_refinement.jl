## Distances

abstract type AbstractDistanceChoice end

struct ShortestPathDistances <: AbstractDistanceChoice end
struct ResistanceDistances <: AbstractDistanceChoice end
struct BothDistances <: AbstractDistanceChoice end

compute_distances(::ShortestPathDistances, g) = shortest_path_distances(g)
compute_distances(::ResistanceDistances, g) = resistance_distances(g)

function compute_distances(::BothDistances, g)
    return collect(zip(shortest_path_distances(g), resistance_distances(g)))
end

## Messages

abstract type AbstractSourceChoice end

struct OnlyNeighbors <: AbstractSourceChoice end
struct OnlyAnchors <: AbstractSourceChoice end
struct NeighborsAndAnchors <: AbstractSourceChoice end

get_sources(::OnlyNeighbors, g; v, a) = neighbors(g, v)
get_sources(::OnlyAnchors, g; v, a) = a
get_sources(::NeighborsAndAnchors, g; v, a) = union(a, neighbors(g, v))

## Anchors

abstract type AbstractAnchorChoice end

struct AllVertices <: AbstractAnchorChoice end
struct ResolvingSet <: AbstractAnchorChoice end

compute_anchors(::AllVertices, g; d) = vertices(g)
compute_anchors(::ResolvingSet, g; d) = error("not implemented")

## Algorithm settings

abstract type AbstractWL end

struct StandardWL <: AbstractWL end

@kwdef struct GeneralizedDistanceWL{
    D<:AbstractDistanceChoice,A<:AbstractAnchorChoice,S<:AbstractSourceChoice
} <: AbstractWL
    distances::D
    anchors::A
    sources::S
end

function messages(::StandardWL, g; v, c, kwargs...)
    us = neighbors(g, v)
    return (c[v], sort([c[u] for u in us]))
end

function messages(alg::GeneralizedDistanceWL, g; v, c, d, a)
    us = get_sources(alg.sources, g; v, a)
    return sort([(c[u], d[v, u]) for u in us])
end

## Actual color refinement

"""
    color_refinement(alg, g)

# References

- Algorithm 3.1 of _Power and Limits of the Weisfeiler-Leman Algorithm_ (Kiefer, 2020, https://publications.rwth-aachen.de/recoResistanceDistances/785831/files/785831.pdf)
- Equation (3) of _Rethinking the Expressive Power of GNNs via Graph Biconnectivity_ (Zhang et al., 2023, https://arxiv.org/abs/2301.09505)
"""
function color_refinement(alg::AbstractWL, g::AbstractGraph; d, a)
    c = ones(Int, nv(g))
    c_prehash = [messages(alg, g; v, c, d, a) for v in vertices(g)]
    while true
        H = approx_unique_sorted(c_prehash)
        length(H) == maximum(c) && break
        for v in vertices(g)
            c[v] = approx_searchsortedfirst(H, c_prehash[v])
        end
        for v in vertices(g)
            c_prehash[v] = messages(alg, g; v, c, d, a)
        end
    end
    return c
end

function color_refinement(alg::StandardWL, g::AbstractGraph)
    return color_refinement(alg, g; d=nothing, a=nothing)
end

function color_refinement(alg::GeneralizedDistanceWL, g::AbstractGraph)
    d = compute_distances(alg.distances, g)
    a = compute_anchors(alg.anchors, g; d)
    return color_refinement(alg, g; d, a)
end

"""
    isomorphism_test(algo, g1, g2)

# References

Pages 30-31 of _Power and Limits of the Weisfeiler-Leman Algorithm_ (Kiefer, 2020, https://publications.rwth-aachen.de/recoResistanceDistances/785831/files/785831.pdf)
"""
function isomorphism_test(alg::AbstractWL, g1::AbstractGraph, g2::AbstractGraph)
    g_union = blockdiag(g1, g2)
    c = color_refinement(alg, g_union)
    c1 = c[begin:nv(g1)]
    c2 = c[(nv(g1) + 1):end]
    return countmap(c1) == countmap(c2)
end

## Shortcuts

WL() = StandardWL()

function SPDWL()
    return GeneralizedDistanceWL(;
        distances=ShortestPathDistances(), anchors=AllVertices(), sources=OnlyAnchors()
    )
end

function RDWL()
    return GeneralizedDistanceWL(;
        distances=ResistanceDistances(), anchors=AllVertices(), sources=OnlyAnchors()
    )
end

function GDWL()
    return GeneralizedDistanceWL(;
        distances=BothDistances(), anchors=AllVertices(), sources=OnlyAnchors()
    )
end
