abstract type AbstractWL end
abstract type AbstractGDWL <: AbstractWL end

struct WL <: AbstractWL end
struct SPDWL <: AbstractGDWL end
struct RDWL <: AbstractGDWL end
struct GDWL <: AbstractGDWL end

function messages(::WL, g, v, c, dₛₚ, dᵣ)
    return (c[v], Multiset((c[u] for u in neighbors(g, v))))
end

function messages(::SPDWL, g, v, c, dₛₚ, dᵣ)
    return Multiset(((c[u], dₛₚ[v, u]) for u in vertices(g)))
end

function messages(::RDWL, g, v, c, dₛₚ, dᵣ)
    return Multiset(((c[u], dᵣ[v, u]) for u in vertices(g)))
end

function messages(::GDWL, g, v, c, dₛₚ, dᵣ)
    return Multiset(((c[u], dₛₚ[v, u], dᵣ[v, u]) for u in vertices(g)))
end

"""
    color_refinement(algo, g)

References:
- WL: Algorithm 3.1 in <https://publications.rwth-aachen.de/record/785831/files/785831.pdf>
- GDWL: Equation (3) in <https://arxiv.org/abs/2301.09505>
"""
function color_refinement(algo::AbstractWL, g::AbstractGraph)
    dₛₚ = johnson_shortest_paths(g).dists
    dᵣ = nothing
    c = ones(Int, nv(g))
    c_prehash = [messages(algo, g, v, c, dₛₚ, dᵣ) for v in vertices(g)]
    while true
        L = unique(c_prehash)
        length(L) == maximum(c) && break
        sort!(L)
        for v in vertices(g)
            c[v] = searchsortedfirst(L, c_prehash[v])
        end
        for v in vertices(g)
            c_prehash[v] = messages(algo, g, v, c, dₛₚ, dᵣ)
        end
    end
    return c
end

"""
    isomorphism_test(algo, g1, g2)

References:
- Pages 30-31 in <https://publications.rwth-aachen.de/record/785831/files/785831.pdf>
"""
function isomorphism_test(algo::AbstractWL, g1::AbstractGraph, g2::AbstractGraph)
    # TODO: debug
    g_union = blockdiag(g1, g2)
    c = color_refinement(algo, g_union)
    c1 = c[begin:nv(g1)]
    c2 = c[(nv(g1) + 1):end]
    return Multiset(c1) == Multiset(c2)
end
