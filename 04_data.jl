### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 4ccae334-857b-4957-9c58-d2354894148b
using PlutoUI

# ╔═╡ f10d73fa-9676-11ed-0fa8-0dbdd750d8b4
md"""

# Building abstractions with data

Via subtyping Julia types inherit behaviour (via method definitions on abstract types), but not structure. Composite types are a way out to this problem.

"""

# ╔═╡ 0d7b7787-1ae8-45a8-a04d-be5a54ffd43e
md"""
## Immutable structs

Composite types are called structs (C, C++) or records (Haskell), and are a collection of named fields that, once instantiated, can be treated as a single value. In Julia composite types are defined using a `struct` block. Julia provides a default constructor for composite types, which has the same name. Finally, the fields can be accessed using the dot notation.

The trivial composite type has no fields, hence two instances are identical by definition: is a singleton type.
"""

# ╔═╡ e1ea848f-259a-45c4-85c0-b38ef700d601
struct Unit end

# ╔═╡ ceda105f-73e9-4973-bac8-7faa8e63f0ad
Unit()

# ╔═╡ 9fef0755-b5d2-4d31-ad9a-4e7ebc2ffc49
struct MyCompositeType_v1
	x
	y
end

# ╔═╡ 9ffdf326-ab6b-4773-9f72-3ea2da733ea8
obj = MyCompositeType_v1(3, "Hi!")

# ╔═╡ 4fec7d89-8f51-44d4-9de6-ed791f422625
obj.x

# ╔═╡ 9a5d0523-eb97-4411-a6eb-b64a1316b2ad
md"""
The type of the fields can (and, most of the time, should) be specified using the `::` syntax. When omitted, it is equivalent to specify the type `Any`. When the types of fields is specified, Julia creates also a constructor that tries to convert the arguments to the given type.
"""

# ╔═╡ 2736a2f9-f9d0-490a-9424-a467acc7aff5
struct MyCompositeType_v2
	x::Int
	y::String
end

# ╔═╡ ea42271d-e9b6-4f39-8d83-fe26bd3df0a9
MyCompositeType_v2(3.0, "Hi!")

# ╔═╡ cfd050cf-71f8-46c2-adda-96be30bbb42e
md"""

## Mutable structs

These records are immutable (as in Haskell, but not C/C++). Which means that you cannot assign a value to a field after the object has been created. If you want an object with the new value, you have to create a new one. Immutability of objects makes code easier to reason about and may enhance performance, but sometimes is undesired.

Mutable struct can be defined using the `mutable` keyword. Since Julia v1.8 it is possible to annotate single fields of a mutable struct with the keyword `const`, to make them immutable and allow compiler optimizations.
"""

# ╔═╡ a62cdec3-fe42-49cd-9733-dde3c7234a9a
mutable struct MyCompositeType_v3
	x::Int
	y::String
end

# ╔═╡ e4d6f870-455f-4747-af80-838b9da7daf1
mobj = MyCompositeType_v3(3.0, "Hi!")

# ╔═╡ 752f4d32-4e46-458e-9811-93186926632f
mobj.y = "Hello!"

# ╔═╡ b8b3b76c-8b24-4a56-977a-3ca9f2f6ad69
mutable struct MyCompositeType_v4
	const x::Int
	y::String
end

# ╔═╡ acd61e18-c0ed-4e48-8b19-e13deeb09180
mobj2 = MyCompositeType_v4(3.0, "Hi!")

# ╔═╡ 4089293f-f342-4cce-903e-3b2f02e855d0
mobj2.x = 4

# ╔═╡ 3a738e75-ac2d-4949-9033-3e8dca70eeec
md"""
### Note on automatic memory management

Like Python, although using a different strategy, Julia has automatic memory management, which means that allocations and deallocations of memory are not managed by the programmer. This makes possible to avoid several kinds of bugs (memory leaks, dangling pointers, etc.) while maintaining the "illusion of infinite memory", in the words of Abelson and Sussman.

Allocations happens within the default constructor (or in the inner constructor methods), as we'll see. The deallocations is done by the garbage collector. Garbage collection is one of the techniques available for the purpose (another one is reference counting, used by Python), in particular Julia uses the mark and sweep algorithm.

Garbage collection comes with some downsides (and it's the reason why, for example, C++ does not use it), but for normal usage 
"""

# ╔═╡ 96226625-bb1a-4c58-ba14-e27f27b9a78d
md"""

## Default constructors

When a composite type is declared, Julia defines two default constructors: one with arguments of the declared type and one that accept arguments of any type, and tryies to convert them (throwing an error if that isn't possible).

Constructors are just functions, convenience constructors that can be expressed in terms of the default one, can be defined as such.
"""

# ╔═╡ d4bdee63-5580-466f-be76-5ffeddc5d9aa
methods(MyCompositeType_v2)

# ╔═╡ 2df43970-20a8-4936-94fe-38df31eadb83
MyCompositeType_v2("should not be a string", "a string")

# ╔═╡ 1d8fea5b-86d3-41b9-9905-66fbceb241fb
begin
	struct EmbellishedInt
		n::Int
		repr::String
	end

	EmbellishedInt(n) = EmbellishedInt(n, "String representation of $n")
end

# ╔═╡ b18eac39-f75d-4a51-9627-aead7a9bee24
EmbellishedInt(13)

# ╔═╡ 885c3368-c7cb-43a3-a973-9ff495f27b4b
EmbellishedInt(13)

# ╔═╡ 6ee40305-5217-45cf-b106-6eb5b32637d4
# You might want to enforce the usage of the other constructor
EmbellishedInt(13, "String representation of 14")

# ╔═╡ def9ec21-9b8d-4283-bb05-e7d2ec76d880


# ╔═╡ ac81d1bc-af19-4194-9ad2-b5aad9959c2d
md"""

## Parametric constructors

"""

# ╔═╡ 515db4c8-fb26-4b64-a22d-954ebf24bc21
md"""

## Internal constructors

The previous discussion leaves out the problem of un-initialized objects. Since, up to this point, every constructor is expressed in terms of the defaul one, which requires a value for every field of the struct. To overcome this problem, Julia uses "internal constructors", which are useful also to enforce preconditions on constructor arguments.

Julia internal constructor works by exposing the `new` variadic function, which creates a new object, possibly partially un-initialized (if not all arguments were passed). Also, internal constructors override default constructors, hence they might be useful to disallow their usage.
"""

# ╔═╡ e3b0b38b-797d-4f74-bc3a-182158bdcf5c
struct List{T}
	value::T
	next::Union{Nothing, List{T}}
	List(x) = new{typeof(x)}(x)
end

# ╔═╡ 8d0a913d-365b-4695-b67e-25efd6b8c977
begin
	struct OrderedPair{T}
		first::T
		second::T
		OrderedPair(a::T, b::T) where T = a < b ? new{T}(a, b) : new{T}(b, a)
	end

	OrderedPair(a, b) = OrderedPair(promote(a, b)...)
end

# ╔═╡ 08469e55-5462-4037-97b4-91e74751d64d
OrderedPair(2, 1.)

# ╔═╡ 6cf5cd93-6772-49b5-a38f-52dd55f5660b
struct EmbellishedInt_v2
	n::Int
	repr::String

	EmbellishedInt_v2(n) = new(n, "String representation of $n")
end

# ╔═╡ 1b53989c-97be-419a-b08f-b11d143762f8
EmbellishedInt_v2(13, "String representation of 14")

# ╔═╡ 54ee6d73-aff2-4b92-afdc-8b5db533d499
md"""

## Metaprogramming: programs as data
"""

# ╔═╡ 09699783-a094-49ea-9f28-50c65c1e0259
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "08cc58b1fbde73292d848136b97991797e6c5429"

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
git-tree-sha1 = "8175fc2b118a3755113c8e68084dc1a9e63c61ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.3"

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
# ╠═b18eac39-f75d-4a51-9627-aead7a9bee24
# ╟─f10d73fa-9676-11ed-0fa8-0dbdd750d8b4
# ╟─0d7b7787-1ae8-45a8-a04d-be5a54ffd43e
# ╠═e1ea848f-259a-45c4-85c0-b38ef700d601
# ╠═ceda105f-73e9-4973-bac8-7faa8e63f0ad
# ╠═9fef0755-b5d2-4d31-ad9a-4e7ebc2ffc49
# ╠═9ffdf326-ab6b-4773-9f72-3ea2da733ea8
# ╠═4fec7d89-8f51-44d4-9de6-ed791f422625
# ╟─9a5d0523-eb97-4411-a6eb-b64a1316b2ad
# ╠═2736a2f9-f9d0-490a-9424-a467acc7aff5
# ╠═ea42271d-e9b6-4f39-8d83-fe26bd3df0a9
# ╟─cfd050cf-71f8-46c2-adda-96be30bbb42e
# ╠═a62cdec3-fe42-49cd-9733-dde3c7234a9a
# ╠═e4d6f870-455f-4747-af80-838b9da7daf1
# ╠═752f4d32-4e46-458e-9811-93186926632f
# ╠═b8b3b76c-8b24-4a56-977a-3ca9f2f6ad69
# ╠═acd61e18-c0ed-4e48-8b19-e13deeb09180
# ╠═4089293f-f342-4cce-903e-3b2f02e855d0
# ╟─3a738e75-ac2d-4949-9033-3e8dca70eeec
# ╟─96226625-bb1a-4c58-ba14-e27f27b9a78d
# ╠═d4bdee63-5580-466f-be76-5ffeddc5d9aa
# ╠═2df43970-20a8-4936-94fe-38df31eadb83
# ╠═1d8fea5b-86d3-41b9-9905-66fbceb241fb
# ╠═885c3368-c7cb-43a3-a973-9ff495f27b4b
# ╠═6ee40305-5217-45cf-b106-6eb5b32637d4
# ╠═def9ec21-9b8d-4283-bb05-e7d2ec76d880
# ╠═ac81d1bc-af19-4194-9ad2-b5aad9959c2d
# ╟─515db4c8-fb26-4b64-a22d-954ebf24bc21
# ╠═e3b0b38b-797d-4f74-bc3a-182158bdcf5c
# ╠═8d0a913d-365b-4695-b67e-25efd6b8c977
# ╠═08469e55-5462-4037-97b4-91e74751d64d
# ╠═6cf5cd93-6772-49b5-a38f-52dd55f5660b
# ╠═1b53989c-97be-419a-b08f-b11d143762f8
# ╠═54ee6d73-aff2-4b92-afdc-8b5db533d499
# ╠═4ccae334-857b-4957-9c58-d2354894148b
# ╠═09699783-a094-49ea-9f28-50c65c1e0259
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
