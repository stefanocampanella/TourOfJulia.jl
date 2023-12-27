### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ b6f88cd9-4ce3-490f-a15f-b461b196b3be
# parametric types, union types, missing
Grid = Matrix{Union{Int, Missing}}

# ╔═╡ 0b0fa9da-63c2-416d-991f-99f3a3abbbf0
fortran_indexing = Grid(reshape(1:81, (9, 9)))

# ╔═╡ a13ae96e-c81a-40f3-83f0-9a77e3a4dafc
transp(x) = PermutedDimsArray(x, (2, 1))

# ╔═╡ d9665dd4-d496-4432-b865-79dd6aa5ffe4
transposed_indexing = transp(fortran_indexing)

# ╔═╡ de33c856-ebb7-428e-b45f-dba5432ff6e2
# metaprogramming, generated functions
@generated function boxindx(::Boxs{S, T, L, R}, z) where {S, T, L, R}
    quote
        b, l = divrem(z - 1, $L^2)
        bc, br = divrem(b, $R)
        lc, lr = divrem(l, $L)
        j = bc * $R + lc
        i = br * $R + lr
        j * L * R + i + 1
    end
end

# ╔═╡ cd7092b3-31e3-4c63-bb8a-f1bf7e2d202d
# lambda functions
choices(g) = map(x -> ismissing(x) ? collect(1:9) : [x], g)

# ╔═╡ 179a45fa-e7d7-4f8c-9ede-2c76f1ddaaaa
# function objects
islengthone = ==(1) ∘ length

# ╔═╡ 80755e62-611e-40d3-b847-28de32981f93
# deepcopy
function fix!(f!, x)
    y = deepcopy(x)
    f!(x)
    if x != y
        fix!(f!, x)
    end
end

# ╔═╡ 87dad19d-7b38-48c8-b22d-c74223319e6d
iscomplete(chs) = all(islengthone, chs)

# ╔═╡ 0922e20d-7321-4c4b-9ad6-a542ddf476f1
begin
	struct ExpandChoices
		choices::Matrix{Vector{Int}}
		indx::CartesianIndex{2}
		stack::Vector{Int}
	end

	function ExpandChoices(chs)
		indx = findfirst(!islengthone, chs)
		stack = copy(chs[indx])
		ExpandChoices(chs, indx, stack)
	end
end

# ╔═╡ 90b894c4-55f7-4d36-a251-ac57c96f2b14
# iterators
function Base.iterate(iter::ExpandChoices, stack=copy(iter.stack))
	if isempty(stack)
		return
	else
		item = deepcopy(iter.choices)
		item[iter.indx] = [pop!(stack)]
		(item, stack)
	end
end

# ╔═╡ 79cb6bb1-8992-42ae-b36f-3b308ef6bcaf
# iterator traits
Base.IteratorEltype(::Type{ExpandChoices}) = Base.HasEltype()

# ╔═╡ e353e757-2294-4779-adda-ea4b796a79e4
Base.eltype(::Type{ExpandChoices}) = Matrix{Vector{Int}}

# ╔═╡ f1dca892-160a-4fa3-9c74-5ae285ca1d6a
# user defined types, inner constructors, subtypes, exceptions, string interpolations
struct Boxs{T, S, L, R} <: AbstractMatrix{T}
    parent::S
    function Boxs(s, l, r)
        if size(s, 1) == size(s, 2) == l * r
            new{eltype(s), typeof(s), l, r}(s) 
        else
            throw(ArgumentError("Argument is not a square matrix of side length $(l * r) = $l * $r."))
        end
    end
end

# ╔═╡ ac386887-4111-4914-ba86-76e6ce04d8dc
# how dispatch works
boxs(A::AbstractMatrix) = Boxs(A, 3, 3)

# ╔═╡ fbecde76-b1ad-4db0-9ddf-8e1e764aa468
# boxs . boxs = id
boxs(A::Boxs) = A.parent

# ╔═╡ 01ec92e8-7077-432d-bdc3-ccf9aa330c28
# generators
views(g) = (f(g) for f in (identity, transp, boxs))

# ╔═╡ da1d9160-65e1-4b1a-9e30-29d35cda639b
begin
	import Base: getindex, size

	# multiple dispatch
	getindex(A::Boxs, z::Int) = A.parent[boxindx(A, z)]
	getindex(A::Boxs, i::Int, j::Int) = getindex(A, LinearIndices(A.parent)[i, j])

	# stdlib function overload
	size(A::Boxs) = size(A.parent)

	boxing_indexing = boxs(fortran_indexing)
end

# ╔═╡ 8f22cc75-1ee6-47b3-bdd5-024d378122da
md"""
# A Sudoku Solver

In this notebook I will code a sudoku solver in Julia. The implementation is based on the [Haskell one](http://www.cs.nott.ac.uk/~pszgmh/sudoku.lhs) provided by Graham Sutton in his course on advanced functional programming. This will be an excuse to illustrate with an example many of the features we encountered.
"""

# ╔═╡ 5617c883-48dd-4f43-8d6f-dfe60a26f9c8
# ternary operator (control flow), algorithms (reduce, foldl, folr)
function singlevalues(col)
    singles = filter(islengthone, col)
    isempty(singles) ? eltype(col)[] : reduce(vcat, singles)
end

# ╔═╡ 0ec6b398-5c7c-4ec6-adde-50ddf9de4a3e
# nothing, mutating functions, pass by object reference
simplifycol!(col) = foreach(xs -> islengthone(xs) ? nothing : filter!(!in(singlevalues(col)), xs), col)

# ╔═╡ efd6086d-6d07-45ab-8e9b-4d847b93ab22
simplify!(chs) = foreach(v -> foreach(simplifycol!, eachcol(v)), views(chs))

# ╔═╡ bfc6c55c-fc2e-493c-a11a-2be6496f9582
fullsimplify!(chs) = fix!(simplify!, chs)

# ╔═╡ db9bfb9a-aad0-41ec-b771-8bd918d5b760
# function composition
isconsistent(chs) = all(v -> all(allunique ∘ singlevalues ,eachcol(v)), views(chs))

# ╔═╡ f464b57e-996a-4101-8ecb-87e9e8d0d389
function search(parent::Matrix{Vector{T}}) where {T}
    fullsimplify!(parent) 
    if !isconsistent(parent)
        Matrix{T}[]
	elseif iscomplete(parent)
        [map(only, parent)]
    else
        [grid for child in ExpandChoices(parent) for grid in search(child)]
    end
end

# ╔═╡ 692c8d8f-21fd-414f-8746-babb436601a6
Base.length(iter::ExpandChoices) = length(iter.stack)

# ╔═╡ af8f43ae-3e04-4e09-9826-abf5b766a86c
# function definition, control flow, multidimensional arrays, parsing
function parsegrid(gstrs)
    g = Grid(missing, 9, 9)
    for (i, s) in enumerate(gstrs), (j, c) in enumerate(s)
        if c != '.'
            g[i, j] = parse(Int, c)
        end
    end
    g
end

# ╔═╡ d7a70447-b1ba-4340-b500-4d8e97d8a665
easy = parsegrid(
    ["2....1.38", 
     "........5", 
     ".7...6...", 
     ".......13", 
     ".981..257", 
     "31....8..", 
     "9..8...2.", 
     ".5..69784", 
     "4..25...."])

# ╔═╡ 836656f8-5874-4374-b1df-a54fea0cc6a1
easy_chs = choices(easy)

# ╔═╡ 026f7fdd-f878-42aa-a115-452a536766de
let chs = deepcopy(easy_chs)
	fullsimplify!(chs)
	chs
end

# ╔═╡ ba3c7fc7-750d-461b-a164-20ae4e96dbad
diabolical =  parsegrid(
    [".9.7..86.",
     ".31..5.2.",
     "8.6......",
     "..7.5...6",
     "...3.7...",
     "5...1.7..",
     "......1.9",
     ".2.6..35.",
     ".54..8.7."])

# ╔═╡ 1e2bff72-2611-4f2d-81cf-05acadf30bc2
let chs = deepcopy(choices(diabolical))
	fullsimplify!(chs)
	chs
end

# ╔═╡ cdc235e9-a2a2-43a5-94ef-832795e7fa2e
diabolical_sol = first(search(choices(diabolical))); diabolical_sol

# ╔═╡ e2af96a9-e977-4d14-a52a-84b44bbb92b5
valid(g) = all(all(allunique , eachcol(v)) for v in views(g))

# ╔═╡ 26975725-62d5-4d1c-87d3-c18e3ad52f4d
valid(diabolical_sol)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─8f22cc75-1ee6-47b3-bdd5-024d378122da
# ╠═b6f88cd9-4ce3-490f-a15f-b461b196b3be
# ╠═0b0fa9da-63c2-416d-991f-99f3a3abbbf0
# ╠═a13ae96e-c81a-40f3-83f0-9a77e3a4dafc
# ╠═d9665dd4-d496-4432-b865-79dd6aa5ffe4
# ╠═f1dca892-160a-4fa3-9c74-5ae285ca1d6a
# ╠═ac386887-4111-4914-ba86-76e6ce04d8dc
# ╠═fbecde76-b1ad-4db0-9ddf-8e1e764aa468
# ╠═de33c856-ebb7-428e-b45f-dba5432ff6e2
# ╠═da1d9160-65e1-4b1a-9e30-29d35cda639b
# ╠═01ec92e8-7077-432d-bdc3-ccf9aa330c28
# ╠═cd7092b3-31e3-4c63-bb8a-f1bf7e2d202d
# ╠═179a45fa-e7d7-4f8c-9ede-2c76f1ddaaaa
# ╠═5617c883-48dd-4f43-8d6f-dfe60a26f9c8
# ╠═0ec6b398-5c7c-4ec6-adde-50ddf9de4a3e
# ╠═efd6086d-6d07-45ab-8e9b-4d847b93ab22
# ╠═80755e62-611e-40d3-b847-28de32981f93
# ╠═bfc6c55c-fc2e-493c-a11a-2be6496f9582
# ╠═87dad19d-7b38-48c8-b22d-c74223319e6d
# ╠═db9bfb9a-aad0-41ec-b771-8bd918d5b760
# ╠═f464b57e-996a-4101-8ecb-87e9e8d0d389
# ╠═0922e20d-7321-4c4b-9ad6-a542ddf476f1
# ╠═90b894c4-55f7-4d36-a251-ac57c96f2b14
# ╠═79cb6bb1-8992-42ae-b36f-3b308ef6bcaf
# ╠═e353e757-2294-4779-adda-ea4b796a79e4
# ╠═692c8d8f-21fd-414f-8746-babb436601a6
# ╠═af8f43ae-3e04-4e09-9826-abf5b766a86c
# ╠═d7a70447-b1ba-4340-b500-4d8e97d8a665
# ╠═836656f8-5874-4374-b1df-a54fea0cc6a1
# ╠═026f7fdd-f878-42aa-a115-452a536766de
# ╠═ba3c7fc7-750d-461b-a164-20ae4e96dbad
# ╠═1e2bff72-2611-4f2d-81cf-05acadf30bc2
# ╠═cdc235e9-a2a2-43a5-94ef-832795e7fa2e
# ╠═e2af96a9-e977-4d14-a52a-84b44bbb92b5
# ╠═26975725-62d5-4d1c-87d3-c18e3ad52f4d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
