### A Pluto.jl notebook ###
# v0.19.29

#> [frontmatter]
#> title = "A tour of Julia"
#> date = "2023-02-07"
#> description = "Seminar outline"

using Markdown
using InteractiveUtils

# ╔═╡ efc045a0-41b1-471d-9c51-fa828eb411b0
# Automatically create a local environment and install needed packages
using PyCall, BenchmarkTools

# ╔═╡ 8d964530-9e3d-11ed-301f-43882004bcd5
md"""
# A tour of Julia

Julia is a general purpose programming language suited for technical computing. It is a dynamic, high-level language, which means that executing a program written in Julia does not require the user to compile it beforehand, as for C or Fortran, and its syntax is similar to MATLAB or Python. Nonetheless, its performance is close to that of statically compiled languages. This is possible thanks to clever design, and Just In Time (JIT) compilation (as JavaScript/TypeScript in your browser or Python when using Numba).
"""

# ╔═╡ b26ee80f-d113-4c31-80ff-903d6f1b947b
md"""
## About the author

Hi! My name is Stefano Campanella, I work at [OGS](https://www.ogs.it/), I like Julia.

> _He had a lot to say. He had a lot of nothing to say._ -- Eulogy, Tool (Ænima, 1996)
"""

# ╔═╡ a5c40f9a-0109-4baa-8225-a15e59010e35
begin
	if "HTML" in keys(ENV)
		root = ""
		extension = ".html"
	else
		root = "./open?path="
		extension = ".jl"
	end
	
	Markdown.parse("""
	## Seminar outline
		
	The material covered in this seminar is hardly original. It is mostly a reworking of the [official Julia documentation](https://docs.julialang.org/en/v1/), which is extensive and well written, and which I will refer to on several occasions. 
		
	I will begin with some [preliminary stuff]($(root * "extra/prelims" * extension)) (installation, package management, editors and IDE support). After that, we will touch some topics from two tracks. Finally, we will see simple examples and applications showing features and putting together a few things seen along the way.
		
	### Track 1
	
	The first track contains a more gentle introduction to programming in Julia, and requires only a limited coding experience.
	
	1. [Built-in numerical types]($(root * "track 1/built-ins" * extension))
	1. [Variables]($(root * "track 1/variables" * extension))
	1. [Control flow]($(root * "track 1/controlflow" * extension))
	1. [Multidimensional arrays]($(root * "track 1/arrays" * extension))
		
	### Track 2
	
	The second track contains more advanced topics and references to computer science concepts.
	
	1. [The Julia type system]($(root * "track 2/types" * extension))
	1. [Building abstractions with procedures]($(root * "track 2/procedures" * extension))
	1. [Building abstractions with data]($(root * "track 2/data" * extension))
	
	### Examples
	
	The examples have a varied degree of complexity and present the implementation of algorithms from numerical analysis and other fields.
	
	1. [Huffman coding]($(root * "examples/huffman" * extension))
	1. [Two-dimensional Laplace equation]($(root * "examples/jacobi" * extension))
	1. [One-dimensional advection equation]($(root * "examples/smolarkiewicz" * extension))
	1. [Sudoku puzzles]($(root * "examples/sudoku" * extension))
		
	### Applications

	The applications section shows how to solve simple tasks relevant to statistics and Earth science. Here I will showcase some popular libraries.
		
	1. [Open a NetCDF and make a plot]($(root * "applications/ncplots" * extension))
	1. Analyse a tabular dataset
		
	Let's begin with a digression and answer the question _why should I learn programming in Julia?_
	""")
end

# ╔═╡ 98a176d7-5140-4492-8a18-b42ca3c3e87d
md"""
## Motivation

The great pyramid of Giza resisted the forces of nature, the winds, the sun, and the movements of the Earth, serving its purpose for more than four thousands years. Its thick walls might even provide good insulation, but nobody would ever immagine to make new buildings using the same solutions adopted in the ancient Egypt. This analogy illustrate why, in the opinion of the author, you should **stop writing scientific code in Fortran 77 _whenever possible_**. Which language one might use then? 

Julia is a language that allows to easily write code that is correct[^1], maintainable, and sufficiently fast to shortcircuit prototipation and production cycle (the so-called _two language problem_).[^2]

On a less technical level, **writing Julia code is fun**[^3] (as long as you have freedom of choice, this is a perfectly reasonable argument).

Before moving on, I'll add a few words about expectations on Julia.

[^1]: 
	[In the words of Robert F. Rosin, Ph.D.](https://youtu.be/L5daPjK00bo)
	> A program that produces a wrong answer at the speed of light isn't efficient; it's merely fast.

[^2]:
	To put it more colorfully, Julia provides you the tools to write code that comply with the virtues proposed by Italo Calvino in "Six Memos for the Next Millennium": lightness, quickness, exactitude, visibility, multiplicity, and consistency--at the end, code is literature, and Calvino's lectures are an unrecognized treatise about software engineering. These tools (abstractions and facilities) are missing from the venerable FORTRAN 77, for example.

[^3]:
	As in the famous quote of Alan J. Perlis that opens the memorable Structure and Interpretation of Computer Programs by Abelson and Sussmann:

	>I think that it's extraordinarily important that we in computer science keep fun in computing. When it started out, it was an awful lot of fun. Of course, the paying customers got shafted every now and then, and after a while we began to take their complaints seriously. We began to feel as if we really were responsible for the successful, error-free perfect use of these machines. I don't think we are. I think we're responsible for stretching them, setting them off in new directions, and keeping fun in the house. I hope the field of computer science never loses its sense of fun. Above all, I hope we don't become missionaries. Don't feel as if you're Bible salesmen. The world has too many of those already. What you know about computing other people will learn. Don't feel as if the key to successful computing is only in your hands. What's in your hands, I think and hope, is intelligence: the ability to see the machine as more than when you were first led up to it, that you can make it more.
"""

# ╔═╡ fff6699a-ae06-4ec5-8cd6-bdea86d84371
md"""
## Disclaimer

Julia **will not make your code automagically fast**, and you could potentially write awfully slow Julia code. Nonetheless the language will make it easy to write efficient code. Also, it encourages the re-use of code, which is one of the most fundamental principles of software engineering

Julia is a **young programming language** (first public release in 2012, 1.0 release in 2018), and some tools and libraries might not be available. The package ecosystem is vast, but some packages might not have the maturity of the alternatives in other programming languages. 

Finally, when choosing the programming language for your next project, you should take into account the effort of learning a new one, the man-months spent on existing codebase, and the expertise of the colleagues you collaborate with. Indeed, you should also consider that Julia requires more sensibility and inclination towards computer science in comparison with MATLAB or R,.

So in when Julia is a good choice?

One example is when you have to write **new algorithms from scratch**, when they cannot be written as array operations (i.e. with loops), and you want to avoid the clumsiness of verbose, low-level languages without loosing efficiency. 

Another scenario might be **data-model integration using machine learning**: there will exist more feature-complete models written in Fortran, and the de facto standard for ML is Python, but writing an interface between the two is non-trivial. Julia solves the issue by having a single language for the two purposes.
"""

# ╔═╡ b0caa168-c18e-4f71-a4af-6dd3d6110b91
md"""
## Brief features/performance show-off

Consider the following oversimplified illustration of the capabilities of Julia.
"""

# ╔═╡ 28a20b93-b534-4c7d-a4aa-d105537c22f8
# Import a Python library as Julia object
np = pyimport("numpy")

# ╔═╡ e02dba57-3e24-404e-84a9-5244793943cb
# Create a random Julia array of ten thousands elements
xs = rand(10_000_000)

# ╔═╡ 8fbbf443-3220-4069-8fa4-b13936740c13
# Pass a Julia array to the `numpy.sort` Python function, evaluate several times the function, print the minimum of the evaluation times to terminal, and convert the resulting `numpy.array` to a Julia array and assign it to a local variable.
# ... In one line of code
xs_sorted_numpy = @btime np.sort(xs)

# ╔═╡ 05ff3195-a071-4d0b-80e5-82395652ceae
# Perform the same operations in Julia (the Julia implementation is as fast as, if not faster than, the low-level language implementation used by NumPy).
xs_sorted_julia = @btime sort(xs)

# ╔═╡ 1e03fa5f-966a-443e-a488-987457887776
# The compare the results
xs_sorted_numpy == xs_sorted_julia

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
BenchmarkTools = "~1.3.2"
PyCall = "~1.96.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "b6cddb3f2b91667ae3febe97e27f2e3761e4d57c"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "8c86e48c0db1564a1d49548d3515ced5d604c408"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.9.1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "43d304ac6f0354755f1d60730ece8c499980f7ba"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.96.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

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
# ╟─8d964530-9e3d-11ed-301f-43882004bcd5
# ╟─b26ee80f-d113-4c31-80ff-903d6f1b947b
# ╟─a5c40f9a-0109-4baa-8225-a15e59010e35
# ╟─98a176d7-5140-4492-8a18-b42ca3c3e87d
# ╟─fff6699a-ae06-4ec5-8cd6-bdea86d84371
# ╟─b0caa168-c18e-4f71-a4af-6dd3d6110b91
# ╠═efc045a0-41b1-471d-9c51-fa828eb411b0
# ╠═28a20b93-b534-4c7d-a4aa-d105537c22f8
# ╠═e02dba57-3e24-404e-84a9-5244793943cb
# ╠═8fbbf443-3220-4069-8fa4-b13936740c13
# ╠═05ff3195-a071-4d0b-80e5-82395652ceae
# ╠═1e03fa5f-966a-443e-a488-987457887776
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
