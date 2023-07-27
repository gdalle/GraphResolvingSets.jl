## Distances

abstract type AbstractDistanceChoice end

struct UseShortestPathDistances <: AbstractDistanceChoice end
struct UseResistanceDistances <: AbstractDistanceChoice end
struct UseBothDistances <: AbstractDistanceChoice end

compute_distances(::UseShortestPathDistances, g) = shortest_path_distances(g)
compute_distances(::UseResistanceDistances, g) = resistance_distances(g)

function compute_distances(::UseBothDistances, g)
    return collect(zip(shortest_path_distances(g), resistance_distances(g)))
end

## Anchors

abstract type AbstractAnchorChoice end

struct UseAllVertices <: AbstractAnchorChoice end
struct UseResolvingSet <: AbstractAnchorChoice end

compute_anchors(::UseAllVertices, g; d) = vertices(g)

function compute_anchors(::UseResolvingSet, g; d)
    R = equivariant_unordered_resolving_set(g, d)
    return R === nothing ? vertices(g) : R
end

## Algorithm settings

abstract type AbstractWL end

struct StandardWL <: AbstractWL end

@kwdef struct DistanceWL{D<:AbstractDistanceChoice,A<:AbstractAnchorChoice} <: AbstractWL
    distances::D
    anchors::A
end

function messages(::StandardWL, g; v, c, kwargs...)
    return (c[v], sort([c[u] for u in neighbors(g, v)]))
end

function messages(::DistanceWL, g; v, c, d, a)
    return sort([(c[u], d[v, u]) for u in a])
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

function color_refinement(alg::DistanceWL, g::AbstractGraph)
    d = compute_distances(alg.distances, g)
    a = compute_anchors(alg.anchors, g; d)
    if length(a) < nv(g)
        @info "Using $(length(a)) anchors out of $(nv(g)) vertices"
    end
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
