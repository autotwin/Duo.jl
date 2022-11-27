# Duo setup

Dualization experiment

## Install Julia

* Install [Julia v1.8](https://julialang.org/downloads/), e.g., 1.8.3 released 14 Nov 2022.
* Check the download shasum:

```bash
shasum -a 256 ~/Downloads/julia-1.8.3-macaarch64.dmg
829d57ab4c3ef02c714e3c73d47e97ddd7dd422043f85e1e34a0690552a494f5  /Users/chovey/Downloads/julia-1.8.3-macaarch64.dmg
```

* Create a symbolic link to allow Julia to be run from the terminal.
  * Reference Fix the [macOS permissions](macos-permission.md) so Julia can be run from the command line.

```bash
cd /usr/local/bin
sudo ln -s /Applications/Julia-1.8.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
```

## AAP `setup-jl`

From the `setup-jl` [repo](https://github.com/anirudh2/setup-jl)

> An opinionated way to create Julia packages with Semantic Release
> 
> Much Credit to Jaan Tollander de Balsch. I modified much of this from his work.
> Usage
> 
> 1. Clone this repository.
> 2. Instantiate the project (download the dependencies) by running `julia --project -e 'import Pkg; Pkg.instantiate()'`
> 3. Modify config.toml to match your preferences.
> 4. Create an empty repository with the correct path on GitHub.
> 5. Run the script with `julia --project -e 'include("setup.jl"); createpackage("config.toml")'`. This will populate that empty repo automatically.
>  Follow the instructions in the created README to finish setting the repo up.
> 
> That's it!
> 
> Make sure to familiarise yourself with [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) as these are how you'll trigger the release pipeline.
> 
> I generally recommend doing step 1 running this script, but it's not a big deal if you do it after.
> 
> 1. Go to [Coveralls](https://coveralls.io/) and activate this repo.
> 2. Once CI finishes running for the first time, go to Settings, Pages, and select the branch `gh-pages`
> 3. Once you've done these things, delete this TODO section and commit the change with the message `chore: finished repo setup`
> 