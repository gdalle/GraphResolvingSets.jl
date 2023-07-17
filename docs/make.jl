using GraphResolvingSets
using Documenter

DocMeta.setdocmeta!(GraphResolvingSets, :DocTestSetup, :(using GraphResolvingSets); recursive=true)

makedocs(;
    modules=[GraphResolvingSets],
    authors="Guillaume Dalle <22795598+gdalle@users.noreply.github.com> and contributors",
    repo="https://github.com/gdalle/GraphResolvingSets.jl/blob/{commit}{path}#{line}",
    sitename="GraphResolvingSets.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://gdalle.github.io/GraphResolvingSets.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/gdalle/GraphResolvingSets.jl",
    devbranch="main",
)
