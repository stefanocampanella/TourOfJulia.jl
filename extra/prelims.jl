### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 005d8679-5e59-4259-8971-30e50a40c1d6
using PlutoUI

# ╔═╡ 62113025-371c-4dec-9501-709f9d29612a
md"""
# Prelims

## Installation

Julia focuses on interactivity and includes a Read-Eval-Print-Loop (REPL). Other ways of interacting with Julia are via advanced editors (es. VS Code), IDEs (es. Jetbrains IDEs, via plugin), or notebooks (es. Jupyter or Pluto, like the current one). Of course, it is also possible to execute Julia scripts non-interactively.

I will use the VS Code, the REPL and Pluto notebooks. It is useful to get acquainted with the REPL. But first, let's install Julia.

There are several ways of installing Julia, using your OS package manager, downloading a pre-built binary, or compiling yourself (Julia is an open-source project and a community effort). The [homepage of the Julia language](https://julialang.org/) has a download section, however I would recommend using `juliaup`. This is a tool inspired by `rustup` (the installer of the Rust toolchain), and is written in Rust indeed. On MacOS/GNU Linux, you can install `juliaup` with
```bash
curl -fsSL https://install.julialang.org | sh
```
Microsoft Windows is also supported. But I'll focus on the other two.

From the GitHub page of `juliaup`
> One can use juliaup to install specific Julia versions, it alerts users when new Julia versions are released and provides a convenient Julia release channel abstraction.

VS Code support editing Julia code (syntax highlighting, autocompletion, inline results, plot pane, integrated REPL, variable view, code navigation, and more) is provided via a plugin, which can be installed using the VS Code plugin manager.

Pluto and IJulia (the Julia kernel for Jupyter) can be installed via the Julia package manager, which will be discussed in a later section.
"""

# ╔═╡ f8f75354-d5e5-4f7a-ad90-f6d1c3c05fce
md"""
## The CLI

Notice that the Julia CLI has several options. The complete list is available from the documentation and via the usual `--help` switch. Here I list some examples.

|Switch                                 |Description|
|:---                                   |:---|
|`--project[={<dir>\|@.}]`              |Set `<dir>` as the home project/environment. The default `@.` option will search through parent directories until a `Project.toml` or `JuliaProject.toml` file is found.|
|`-e`, `--eval <expr>`                  |Evaluate `<expr>`|
|`-L`, `--load <file>`                  |Load `<file>` immediately on all processors|
|`-t`, `--threads {N\|auto`}            |Enable N threads; `auto` tries to infer a useful default number of threads to use but the exact behavior might change in the future.  Currently, `auto` uses the number of CPUs assigned to this julia process based on the OS-specific affinity assignment interface, if supported (Linux and Windows). If this is not supported (macOS) or process affinity is not configured, it uses the number of CPU threads.|
|`--check-bounds={yes\|no\|auto*}`      |Emit bounds checks always, never, or respect `@inbounds` declarations ($)|
|`--math-mode={ieee,fast}`              |Disallow or enable unsafe floating point optimizations (overrides `@fastmath` declaration)|
"""

# ╔═╡ 59aae636-769a-42f4-9403-d0f0f784f503
md"""
## The REPL

Once `juliaup` is installed, you should have also a functioning version of Julia in your PATH (the latest stable release). You can type `julia` in a terminal, hit enter and (right below a nice banner) a `julia>` prompt should show, you are now in the REPL. From here, you can write an expression (like `1 + 1` or `sort(["banana", "coconut", "apple"])`), which will be evaluated upon hitting enter (when in the REPL, the value of the last evaluated expression will be bound to a variable named `ans`). You can execute the code in `path/to/file.jl` (`jl` is the conventional extension of Julia code) calling the function 
```
julia> include("path/to/file.jl")
```

Finally, you can exit the loop with `CTRL-D` or calling the function `exit()`. This is just one of the modes of the REPL, other important ones are the `help?`, `pkg`, and `shell` modes. You can access these modes prepending respectively `?`, `]` or `;` to a command.

The help mode can be used to acces the documentation (it prints the docstring of a function, variables, and modules). The `pkg` mode is used to install, update or remove packages and environments. The `shell` mode can execute shell commands. Notice that `shell` mode is not a shell session, you are still inside Julia and, for example, interpolation works. 

```julia
julia> filename = "My awesome text file.txt"
shell> touch $filename
julia> ls
```
should print the content of your directory, plus a file named "My awesome text file.txt".
"""

# ╔═╡ 93fefea7-6b0f-4803-9d4e-702f9abf3017
md"""
## Pluto

Pluto, the software that is rendering the text you are reading, is a Julia library for writing notebooks similar (but better in many respect) to Jupyter notebooks. The current document is a Pluto notebook.

A Pluto notebook is a sequence of cells. Each cell contain some Julia code, which can be executed. In Julia, every statement is an expression and hence evaluates to a value. Pluto converts that value to an HTML element and shows it. What you are reading is the output of a cell containing just a string, which returns the string itself [^1]. Pluto is able to parse the content of cells and detect dependencies between one cell and another. When the user evaluates a cell, for example changing the value of a variable, Pluto will re-evaluate all the cells that depend on that one and in the right order.


Notice that Pluto requires one statement per cell, hence if you want to put more than one statement in a single cell you need to wrap them between the keywords `begin` and `end`, which are used to chain statements. The resulting block will evaluate to the value of the last statement.

For example:

[^1]: Actually, the value that is rendered as the piece of text you are reading is not a string, but an object whose type is defined in the Markdown module of the standard library. You can create these object prefixing the string literals with `md`. In this way, the content will be formatted using Markdown. Otherwise you can use plain strings.
"""

# ╔═╡ 2c42712d-dfbb-42b7-8d81-b107893ba162
let
	x = 1
	y = x + 1
	"hello world"
	2 * y
end

# ╔═╡ 08a9435a-7ce0-485f-b182-90cdc6e6e309
md"""
evaluates to 4.

Up to this point, the similarities between Pluto and Jupyter should be clear. Moreover, in case you are wondering, there exist a Julia kernel for Jupyter. Why one might prefer to work with Pluto instead of Jupyter? 

The main motivation is that Jupyter notebooks execution is stateful: the same notebook can be executed twice by the same kernel and obtain different results, because the kernel’s internal state can change between executions. Indeed, for this reason, users often need to restart the kernel and re-evaluate code cells. The hidden state problem has been criticized, and other implementations of _reactive notebooks_ exist. One of them is Pluto for Julia.

Pluto parse the code to find the dependencies between cells and evaluates them. It watches for changes in cells and evaluate only the ones that need to, and in the right order.
"""

# ╔═╡ 1c3c8d1d-9177-4c51-9c38-25b36c20841b
md"""Take for example the following cells in which `radius` and `area` variables are assigned (we will talk about variables in the following): by changing the first value you should see almost instantly the modifications in the second, and deleting the first cell should produce an error message in the second."""

# ╔═╡ cc18596a-63c8-4228-a7f8-ee22b28fc496
radius = 10

# ╔═╡ 44ed2314-3601-476c-b849-9190cf17f236
area = π * radius^2

# ╔═╡ 29736cc4-f8a3-4c85-9896-29a4e9a1b8e3
md"""This mechanic allows for interactive visualizations and other forms of interactivity within Pluto. The documentation of Pluto and other useful links can be found at the [GitHub repository of the project](https://github.com/fonsp/Pluto.jl)"""

# ╔═╡ 1ece9654-2e9e-4a77-be20-bf18bb754c64
md"""
## About Julia syntax

As noted above, Julia syntax closely resembles the one of other scripting languages such as Python or Matlab. For this reason, elementary statements (such as assignment, control flow or expressions containing aritmetic operators) will not be introduced systematically and will be considered self explanatory.

However, I will list here some differences from Python (taken from [here](https://docs.julialang.org/en/v1/manual/noteworthy-differences/)).

### General syntax

* Julia's `for`, `if`, `while`, etc. blocks are terminated by the `end` keyword and do not make use of `:`. Indentation level is not significant as it is in Python. Unlike Python, Julia has no `pass` keyword.
* In Python, the majority of values can be used in logical contexts (e.g. `if "a":` means the following block is executed, and `if "":` means it is not). In Julia, you need explicit conversion to Bool (e.g. `if "a"` throws an exception). If you want to test for a non-empty string in Julia, you would explicitly write `if !isempty("")`. 
* Strings are denoted by double quotation marks (`"text"`) in Julia (with three double quotation marks for multi-line strings), whereas in Python they can be denoted either by single (`'text'`) or double quotation marks (`"text"`). Single quotation marks are used for characters in Julia (`'c'`).
* String concatenation is done with `*` in Julia, not `+` like in Python. Analogously, string repetition is done with `^`, not `*`. Implicit string concatenation of string literals like in Python (e.g. `'ab' 'cd' == 'abcd'`) is not done in Julia.
* Julia has no line continuation syntax: if, at the end of a line, the input so far is a complete expression, it is considered done; otherwise the input continues. One way to force an expression to continue is to wrap it in parentheses.

### Math notation
* In Julia, the exponentiation operator is `^`, not `**` as in Python.
* The imaginary unit `sqrt(-1)` is represented in Julia as `im`, not `j` as in Python.


### Arrays

* Python Lists—flexible but slow—correspond to the Julia `Vector{Any}` type or more generally `Vector{T}` where `T` is some non-concrete element type. "Fast" arrays like NumPy arrays that store elements in-place can be represented by `Array{T}` where `T` is a concrete, immutable element type. This includes built-in types like `Float64`, `Int32`, `Int64` but also more complex types like `Tuple{UInt64,Float64}` and many user-defined types as well.
* Julia arrays are column-major (Fortran-ordered) whereas NumPy arrays are row-major (C-ordered) by default. To get optimal performance when looping over arrays, the order of the loops should be reversed in Julia relative to NumPy
* In Julia, indexing of arrays, strings, etc. is 1-based not 0-based.
* Julia's slice indexing includes the last element, unlike in Python. `a[2:3]` in Julia is `a[1:3]` in Python.
* Python's special interpretation of negative indexing, `a[-1]` and `a[-2]`, should be written `a[end]` and `a[end-1]` in Julia.
* Julia requires end for indexing until the last element. `x[1:]` in Python is equivalent to `x[2:end]` in Julia.
* Julia's range indexing has the format of `x[start:step:stop]`, whereas Python's format is `x[start:(stop+1):step]`. Hence, `x[0:10:2]` in Python is equivalent to `x[1:2:10]` in Julia. Similarly, `x[::-1]` in Python, which refers to the reversed array, is equivalent to `x[end:-1:1]` in Julia.
* In Julia, the standard operators over a matrix type are matrix operations, whereas, in Python, the standard operators are element-wise operations. When both `A` and `B` are matrices, `A * B` in Julia performs matrix multiplication, not element-wise multiplication as in Python. `A * B` in Julia is equivalent with `A @ B` in Python, whereas `A * B` in Python is equivalent with `A .* B` in Julia.
"""

# ╔═╡ a63fe8aa-19f4-48f1-990f-be41fc253e8f
md"""
## The Julia package manager

Julia built-in package manager can deal with multiple _environments_, which are similar to Conda envs or Python virtualenv.

You can _activate_ an environment with `Pkg.activate("path/to/dir")` or with `activate path/to/dir`, while in `pkg`. Once an environment has been activated you can add, update and remove packages.

While in `pkg` mode, type "add Pluto" and hit enter. The Pluto.jl package will be installed in the current environment.
"""

# ╔═╡ 2d5c9202-fd66-4584-82ea-7c48e9efbe6d
md"""
## Reflection, profiling and debugging from the REPL

Julia code is compiled into machine code in steps (that is, translated to intermediate representations). Loosely speaking, the code is desugared, typed, compiled to LLVM IR and finally to native code. It is possible to inspect these intermediate representations to debug and optimize the performance of a piece of code (of course, there are a debugger and a profiler too).

 Typing in your REPL
```julia
julia> @code_warntype sin(1.0)
```
should print the lowered and type-inferred AST of `sin` (the trigonometric function). 

What `@code_warntype` means? It doesn't look like a function call. Indeed, it is a macro invocation. We will come back later on the subject, while talking about metaprogramming.

Other similar macros exist, among them `@code_lowered`, `@code_typed`, `@code_llvm`, and `@code_native`, corresponding respectively to the steps listed above.

The `@code_native f(x, y, ...)` macro spits out the machine code which would be executed by the function call `f(x, y, ...)`. If you are fluent in assembly, you might find it useful. Most of the times, the most interesting macro is `@code_warntype` for reasons related to performance which will be discussed in the following (spoiler: the essence of performance in Julia is type stability).

There are also other types of reflection in Julia (for example, regarding data structures instead of functions). As always, the documentation is comprehensive and well written.

A key point of JIT compilation is that, once the type of the arguments is inferred (usually upon first call), a function is compiled. In principle, there can be more than one JIT compilations for the same function, as previous function calls can provide pieces of information to the optimizer. However, the current implementation of Julia compiles a function only once, the first time. This has an important consequence: the first function call might take a long time to run. This is especially true with complex libraries, as the ones for plotting. Indeed, the problem has its own name, Time To First Plot (TTFP), and if you google it you'll find discussions on the web on the subject.

More importantly, the time spent by the Julia runtime upon the first invocation of a function is known as warmup time and one should take that into account when profiling and benchmarking functions. 

Julia includes a statistical profiler in the standard library but external tools can be used (as before, look at the documentation).

Finally, a debugger is available as a separate package.
"""

# ╔═╡ 7f5d4c23-19ef-436d-94e4-83a2cf5b0cd9
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

julia_version = "1.9.3"
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
version = "1.0.5+0"

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
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
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
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

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
# ╟─62113025-371c-4dec-9501-709f9d29612a
# ╟─f8f75354-d5e5-4f7a-ad90-f6d1c3c05fce
# ╟─59aae636-769a-42f4-9403-d0f0f784f503
# ╟─93fefea7-6b0f-4803-9d4e-702f9abf3017
# ╠═2c42712d-dfbb-42b7-8d81-b107893ba162
# ╟─08a9435a-7ce0-485f-b182-90cdc6e6e309
# ╟─1c3c8d1d-9177-4c51-9c38-25b36c20841b
# ╠═cc18596a-63c8-4228-a7f8-ee22b28fc496
# ╠═44ed2314-3601-476c-b849-9190cf17f236
# ╟─29736cc4-f8a3-4c85-9896-29a4e9a1b8e3
# ╟─1ece9654-2e9e-4a77-be20-bf18bb754c64
# ╟─a63fe8aa-19f4-48f1-990f-be41fc253e8f
# ╟─2d5c9202-fd66-4584-82ea-7c48e9efbe6d
# ╟─005d8679-5e59-4259-8971-30e50a40c1d6
# ╟─7f5d4c23-19ef-436d-94e4-83a2cf5b0cd9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
