struct Multiset{T}
    data::Vector{T}
    function Multiset(x)
        data = collect(x)
        sort(data)
        return new{eltype(data)}(data)
    end
end

Base.length(ms::Multiset) = length(ms.data)

Base.hash(ms::Multiset, h::UInt64) = hash(ms.data, h)
Base.:(==)(ms1::Multiset, ms2::Multiset) = ms1.data == ms2.data
Base.isequal(ms1::Multiset, ms2::Multiset) = isequal(ms1.data, ms2.data)

function isless_lexicographic(x, y)
    for i in eachindex(x, y)
        if x[i] < y[i]
            return true
        elseif x[i] > y[i]
            return false
        end
    end
    return false
end

function Base.isless(ms1::Multiset, ms2::Multiset)
    if length(ms1) < length(ms2)
        return true
    elseif length(ms1) > length(ms2)
        return false
    else
        return isless_lexicographic(ms1.data, ms2.data)
    end
end
