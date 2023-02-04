### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 08fb4f24-2a35-43ca-b15e-b58d7ad85cd0
using Test

# ╔═╡ 4c1c048d-cd84-48ef-bff8-67a357b87dba
using PlutoUI

# ╔═╡ 112089a6-9cc5-11ed-2723-53e7aa71e6c5
md"""
# Code reuse

The principal way of organizing code in Julia is via modules. Eventually, modules can be packaged together and distributed. Indeed, there is a list of published packages, the Julia official registry, which is where the Pkg looks by default when one ask to install a package.  

## Modules and packages

Module are defined using the syntax
```julia
module MyModule
# module body
end
```

It is customary to not indent the code inside a module and to use CamelCase for module names. Modules have the following features:

1. They have separate namespaces, and each of them introduce a new (global) scope. This allows to use the same name for different objects in separate modules.
2. There is specific syntaxt for namespace management.
3. Modules can be precompiled for faster loading.

It is customary to organize the code into multiple files, expecially for large packages. This is done using the `include` function, which is analogous to preprocessor directive found in C/C++ (however, `include` is a regular function). The behavior is the same as if the code in the included file was listed in the current file.

All names in Julia are defined inside a module. To get the name of the parent module, you can use the function `parentmodule`. By prefixing the module name to a name one obtains its _qualified name_. Qualifying a name containing only symbols, like operators `+` and `==`, needs inserting a colon `:`. Since modules can be nested, module names can have a qualified name. In this case the chain of names separated by `.` is called a _module path_.

The `export` keyword in a module introduce a statement which lists the names in the current module that one want to make visible outside. Module namespaces are imported with the keyword `import` or `using`. The former will import into the current namespace only the name of the module, the latter also all the names in the export list. One can specified using `:` which names want to import in the current namespace. This makes the two form almost equivalent. Indeed, if one want to add methods to a function defined in another module, he has to use its fully qualified name or use `import`, but not `using`. Finally, you can rename imported names using `as`, like you would do in Python. 

!!! warning
	You can extend or redefine functions for types that you have not defined. This is usually called _type piracy_ and should be avoided.
"""

# ╔═╡ 57cdcc59-1444-4786-bc03-b65da4374bc1
module MyModuleA
	
export alpha, func
	
alpha = 1/137
	
func(x, coeffs...) = sum(c * x^(n-1) for (n, c) in enumerate(coeffs))

# address will not be exported
address = "1 W 72nd St, New York, NY 10023, United States"
	
end

# ╔═╡ c9c060e5-21b8-426c-99fd-e9551a3471b6
import LinearAlgebra # equivalent to "using LinearAlgebra: LinearAlgebra

# ╔═╡ 03a9a335-9653-4cb5-9ff3-2c717c917927
LinearAlgebra.I = 1.0 # imported variables are read-only

# ╔═╡ c5f4d3c6-0efe-42ad-91c9-c83622d54e13
md"""
Modules automatically contain `using Core`, `using Base` and definitions of `eval` and `include`. These are two of the standard modules:

* `Core` contains all functionality "built into" the language.
* `Base` contains all basic functionality that is useful in almost all cases.
* `Main` is the top-level module and the current module, when Julia is started.
* Finally, Julia ships with some standard library modules. These behave like regular julia packages, except that they don't have to be installed explicitly.
"""

# ╔═╡ c35620cc-7cbd-4162-b285-b5e9f4963a74
md"""
## Documentation

"""

# ╔═╡ cea92712-473f-40e1-ba43-02a0e4b611a0
"""
    bar(x[, y])

Compute the Bar index between `x` and `y`.

If `y` is unspecified, compute the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
function bar(x, y) end

# ╔═╡ 6f9004ae-d6d7-4b26-b5ee-eaa156e1e051
md"""
## Unit testing

"""

# ╔═╡ 217b2281-2744-4fa2-9bf8-7ff4dab3d7a9
@testset "trigonometric identities" begin
	θ = 2/3*π
    @test sin(-θ) ≈ -sin(θ)
    @test cos(-θ) ≈ cos(θ)
	@test sin(2θ) ≈ 2*sin(θ)*cos(θ)
    @test cos(2θ) ≈ cos(θ)^2 - sin(θ)^2
end

# ╔═╡ 9e0c5da2-e3ed-447e-a032-f2ff1e92c42b
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "b33abc2fd4c65e33c89dfcbc078cb794bd39326a"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "151d91d63d8d6c1a5789ecb7de51547e00480f1b"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.4"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─112089a6-9cc5-11ed-2723-53e7aa71e6c5
# ╠═57cdcc59-1444-4786-bc03-b65da4374bc1
# ╠═c9c060e5-21b8-426c-99fd-e9551a3471b6
# ╠═03a9a335-9653-4cb5-9ff3-2c717c917927
# ╟─c5f4d3c6-0efe-42ad-91c9-c83622d54e13
# ╟─c35620cc-7cbd-4162-b285-b5e9f4963a74
# ╠═cea92712-473f-40e1-ba43-02a0e4b611a0
# ╟─6f9004ae-d6d7-4b26-b5ee-eaa156e1e051
# ╠═08fb4f24-2a35-43ca-b15e-b58d7ad85cd0
# ╠═217b2281-2744-4fa2-9bf8-7ff4dab3d7a9
# ╟─4c1c048d-cd84-48ef-bff8-67a357b87dba
# ╟─9e0c5da2-e3ed-447e-a032-f2ff1e92c42b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
