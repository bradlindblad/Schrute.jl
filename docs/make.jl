using Documenter, Schrute

makedocs(;
    modules=[Schrute],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "Tutorial" => "tutorial.md"
    ],
    repo="https://github.com/bradlindblad/Schrute.jl/blob/{commit}{path}#L{line}",
    sitename="Schrute.jl",
    authors="Brad Lindblad",
    assets=String[],
)

deploydocs(;
    repo="github.com/bradlindblad/Schrute.jl",
)
