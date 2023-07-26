abstract type AbstractWL end
abstract type AbstractGDWL <: AbstractWL end

struct WL <: AbstractWL end
struct SPDWL <: AbstractGDWL end
struct RDWL <: AbstractGDWL end
struct SPDRDWL <: AbstractGDWL end

function messages(::WL, g, v, c, d)
    return (c[v], sort([c[u] for u in neighbors(g, v)]))
end

function messages(::AbstractGDWL, g, v, c, d)
    return sort([(c[u], d[v, u]) for u in vertices(g)])
end

distances(::WL, g::AbstractGraph) = Fill(nothing, nv(g), nv(g))
distances(::SPDWL, g::AbstractGraph) = shortest_path_distances(g)
distances(::RDWL, g::AbstractGraph) = resistance_distances(g)

function distances(::SPDRDWL, g::AbstractGraph)
    return collect(zip(shortest_path_distances(g), resistance_distances(g)))
end

"""
    color_refinement(algo, g)

# References

- WL: Algorithm 3.1 of _Power and Limits of the Weisfeiler-Leman Algorithm_ (Kiefer, 2020, https://publications.rwth-aachen.de/record/785831/files/785831.pdf)
- GDWL: Equation (3) of _Rethinking the Expressive Power of GNNs via Graph Biconnectivity_ (Zhang et al., 2023, https://arxiv.org/abs/2301.09505)
"""
function color_refinement(
    algo::AbstractWL, g::AbstractGraph, d::AbstractMatrix=distances(algo, g)
)
    c = ones(Int, nv(g))
    c_prehash = [messages(algo, g, v, c, d) for v in vertices(g)]
    while true
        L = unique(c_prehash)
        length(L) == maximum(c) && break
        sort!(L)
        for v in vertices(g)
            c[v] = searchsortedfirst(L, c_prehash[v])
        end
        for v in vertices(g)
            c_prehash[v] = messages(algo, g, v, c, d)
        end
    end
    return c
end

"""
    isomorphism_test(algo, g1, g2)

# References

Pages 30-31 of _Power and Limits of the Weisfeiler-Leman Algorithm_ (Kiefer, 2020, https://publications.rwth-aachen.de/record/785831/files/785831.pdf)
"""
function isomorphism_test(algo::AbstractWL, g1::AbstractGraph, g2::AbstractGraph)
    g_union = blockdiag(g1, g2)
    c = color_refinement(algo, g_union)
    c1 = c[begin:nv(g1)]
    c2 = c[(nv(g1) + 1):end]
    return countmap(c1) == countmap(c2)
end
