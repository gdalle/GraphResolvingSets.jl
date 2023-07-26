function recursive_isapprox(X, Y)
    for (x, y) in zip(X, Y)
        if !recursive_isapprox(x, y)
            return false
        end
    end
    return true
end

function recursive_isapprox(x::Number, y::Number)
    return isapprox(x, y)
end

function approx_unique_sorted(X::Vector)
    U = sort(X)
    for i in length(X):-1:2
        if recursive_isapprox(U[i - 1], U[i])
            deleteat!(U, i)
        end
    end
    return U
end

function approx_searchsortedfirst(haystack, needle)
    for i in eachindex(haystack)
        if recursive_isapprox(needle, haystack[i])
            return i
        end
    end
    return lastindex(haystack) + 1
end
