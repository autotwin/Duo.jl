using Duo
using Documenter

DocMeta.setdocmeta!(Duo, :DocTestSetup, :(using Duo); recursive=true)

makedocs(;
    modules=[Duo],
    authors="Chad Hovey",
    repo="https://github.com/autotwin/Duo.jl/blob/{commit}{path}#{line}",
    sitename="Duo.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://autotwin.github.io/Duo.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/autotwin/Duo.jl",
    devbranch="main",
    devurl="latest",
)
