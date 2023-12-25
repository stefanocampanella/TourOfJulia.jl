### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 02dfc0c7-bf40-48e1-8ce1-c5922ef81889
using PlutoUI

# ╔═╡ 85a06828-6206-11ee-392a-657673baf430
md"""
# Control flow

Julia provides a variety of control flow constructs:

* Compound Expressions: `begin` and `;`.
* Conditional Evaluation: `if-elseif-else` and `?:` (ternary operator).
* Short-Circuit Evaluation: logical operators `&&` (“and”) and `||` (“or”), and also chained comparisons.
* Repeated Evaluation: Loops: `while` and `for`.
* Exception Handling: `try-catch`, `error` and `throw`.

There are also `Tasks` (green routines, or coroutines), but it is an andvanced feature that will be treated in a later notebook.
"""

# ╔═╡ 16e6e894-05c4-4676-9686-b432d08ddd8c
md"""
The `begin` block has already been discussed in the notebook on variables and scopes. Its purpose is to chain expressions and return the latest one. It is the simplest form of control flow, in the sense that is a way to just evaluate an expression after the other, in a consecutive fashion, without branching.
"""

# ╔═╡ f875d478-7e09-4d07-9f7c-89021dadefd7
begin
	# statements can be chained using a `begin ... end` block
	z = begin
		x = 1
		y = 2
		x + y
	end
	
	# this is equivalent to the following one line
	z = begin x = 1; y = 2; x + y end

	# or the following
	z = (x = 1; y = 2; x + y)
end

# ╔═╡ 83e85bf6-e369-4eaf-a477-99d34320a950
md"""
## Conditional evaluation

Julia provides two constructs for conditional evaluation, `if-elseif-else` blocks and the ternary operator `a ? b : c`.

These are regular Julia expressions, and return the value of the latest expression evaluated in a particular branch. As in Scheme, these are special forms, and the expressions are evaluated only in the branches for which the condition evaluates to true, i.e. the following expression would not error.

```scheme
(if (> 1 0) "Aloha!" (error "Oh shoot!"))
```
"""

# ╔═╡ 8abe2a7d-187b-4086-8923-8dd562a8bf32
# Will throw an error, more on that later.
error("Alarm!")

# ╔═╡ 48c0d0dc-8212-4541-8b5d-1699b0c7d12b
# The evaluation strategy for functions (procedures, in Scheme parlance) 
# is to evaluate each operand, after the operator
(1 > 0 ? (println("min"); min) : (println("max"); max))("Aloha!", error("Oh shoot!"))

# ╔═╡ 3be7eb69-fcb6-4037-b5eb-937dcdf5cb70
# If expressions are special forms, the evaluation strategy is different from function evaluation, and their value is the last evaluated expression. Hence the following will not error.
if x < y
	"y is greater than x"
elseif x > y
	"x is greater than y"
	error("Alarm!")
else
	"x equals y"
end

# ╔═╡ 3b33d359-7033-4b9f-bb59-636776f5e4b7
md"""
!!! note
	Unlike Python and other programming languages, in Julia the condition in a conditional expression has to evaluate to a boolean value (`true` or `false`), and no automatic conversions are performed. If such an expression is feeded with a value of another type, it will error.
"""

# ╔═╡ 7cad08b9-d2a9-4d02-bb30-01d1ddcb03e7
"true" ? nothing : nothing

# ╔═╡ 7436f5bd-46bb-4c94-b012-1389aea88dbd
md"""
Finally, as already discussed in the notebook on scopes, `if` blocks do not introduce a new scope.
"""

# ╔═╡ 5b01677c-b164-42ee-955a-4edc71acd0f1
let
	if rand() > 0.5
		face = "head"
	else
		face = "tail"
	end
	"Coin tossing resulted in $face"
end

# ╔═╡ 89797c0a-b03a-4f23-9bfa-f6e32fc26456
md"""
## Short-circuit evalution

The `&&` and `||` operators have the usual meaning found in other programming languages, like C or Bash, respectively of boolean multiplication and addition. These are special operators: cannot be overloaded, short-cuircuit (are a special form), and the latest expression in a chain might be of non-boolean type. The latest property is useful for using them for control flow, evaluating an expression only if all or at least one of the previous expressions evaluates to `true`.

"""

# ╔═╡ 92a5450c-f4f1-4192-85ab-0550afaf6259
# Equivalent to if isodd(1); "Aloha!"; end
isodd(1) && "Aloha!"

# ╔═╡ 8b459c2d-f429-4dfb-916b-b1abf53f9781
# Equivalent to if !iseven(1); "Aloha!"; end
iseven(1) || "Aloha!"

# ╔═╡ 3a8926fd-8555-4370-b6cf-cc81632dafb5
# Allowed
isempty([71, 105, 110, 101, 118, 114, 97]) || isodd(1) && "Aloha!"

# ╔═╡ 3e21f5ac-bd24-4b0a-8998-3bc0499cc143
# Not allowed
isempty([71, 105, 110, 101, 118, 114, 97]) || sin(1) && "Aloha!"

# ╔═╡ 20881b2d-afba-434b-a2ea-20cf2317051e
md"""
## Looping

Julia has two constructs for looping, `while` and `for`, the second being (almost) syntactic sugar for the second. Indeed, the follwing

```julia
for item in iterator
	# body
end
```

is equivalent to

```julia
next = iterate(iterator)
while next !== nothing
	item, state = next
	# body
	next = iterate(iterator, state)
end
```

The iterator interface will be discussed in track 2.
"""

# ╔═╡ c0a4c3f5-ca27-4477-bf03-95a87ce25ea7
# Notice that, even for looping on simple ranges, the `for` loop uses always require an iterator. Although the syntax is very similar to FORTRAN 77, here `1:10` is a range object
let
	sum = 0
	# Contrary to conditional expressions, for and while loops return nothing
	for i = 1:10
		sum += i
	end
	# Hence one needs to evaluate sum to make the cell return its value
	sum
end

# ╔═╡ 5ed830c3-df89-4173-aae9-d7eaaae818c6
# The standard library contains the iterator interface implementation for ranges
iterate(1:10 #= range object =#, 3 #= iterator state =#)

# ╔═╡ 8b88a9df-1d23-4226-a5a2-dd81a78c6d78
# Ranges do not store the actual values, but those can be collected
collect(1:10)

# ╔═╡ 84c4aa8e-51b1-4f69-94c0-3f041437544c
# For loops can be chained, and the resulting loop iterate over the cartesian product of the starting iterators (the last one being the fastest)
begin
	pairs = Tuple{Int, Int}[]
	for i = 1:3, j = 1:3
		push!(pairs, (i, j))
	end
	pairs
end

# ╔═╡ cedeccda-bbfd-4b66-a6da-4bbb13435e57
# The following syntax is equivalent, but more readable in case of non-range objects
let
	sum = 0
	for p in pairs # or `for p in ∈ pairs`
		i, j = p
		sum += i + j
	end
	sum
end

# ╔═╡ 6715341f-a256-4a31-966e-a107bd73a9d6
md"""
The `continue` and `break` keyword have the same meaning that in C. Notice however the difference between chained and nested loops.
"""

# ╔═╡ 27e2c73c-a744-45c9-adb0-94c1bbeaa817
for i = 1:10, j = 1:10
	if i + j == 5
		@show i, j
		break
	end
end

# ╔═╡ c5a7d45c-192b-4707-92b2-aa3c3caf9621
for i = 1:10
	for j = 1:10
		if i + j == 5
			@show i, j
			break
		end
	end
end

# ╔═╡ 21e8952c-0192-4ce8-947f-33a5e969a15b
md"""
## Exceptions

In Julia exceptions are regular objects (immutable structs, more on that on track 2). They have a constructor which might take optinal arguments, usually to include a debug message or other pieces of information.

Some example of exceptions are `ArgumentError`, `DomainError` and the rather generic `ErrorException`.

Just constructing an exception objects does not interrupt the evaluation of an expression, as in the following example.
"""

# ╔═╡ fcc9b741-711d-4b43-ab11-877ab2d47454
for i = 1:10
	ErrorException("Oh shoot!")
	@show i
end

# ╔═╡ ef743b59-b23d-400c-81a9-d61a3ba57580
md"""
To interrupt the execution of your code you need to `throw` the exception.
"""

# ╔═╡ 9f0ab375-978f-47af-ab6f-b5dd6c338295
ErrorException("Oh shoot!") |> throw

# ╔═╡ 25e15246-05a3-490d-8e85-f88ccbb68885
# Equivalent syntax for ErrorExecptions
error("Oh shoot!")

# ╔═╡ 295c5af6-4d47-42a5-9337-b67a0035784c
# General case
throw(ArgumentError("I don't like your arguments!"))

# ╔═╡ c1cb5f25-3773-4ac3-ad72-16236efd174f
# Many function in the stdlib throws exceptions
sqrt(-1.0)

# ╔═╡ ab96fe25-c6a1-4f5b-b5c0-6ee26d8bd302
# Exceptions can be tested for using the try/catch block
function safe_invsqrt(x)
	# The try, catch, and else (and finally) sub-blocks of a try/catch block introduce their own scope, hence a variable declaration is needed
	local y, invsqrt
	try
    	y = sqrt(x)
	catch e
        if isa(e, DomainError)
        	y = sqrt(complex(x, 0))
        end
	else
		# Executed if no error are thrown
		println("All is well.")
	finally
		# Executed whatever the case
		invsqrt = 1 / y
	end
	invsqrt
end

# ╔═╡ 3caf526a-7709-4696-b909-fdb624f7384d
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "3c61004d0ad425a97856dfe604920e9ff261614a"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

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
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

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
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

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
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

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
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

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
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─85a06828-6206-11ee-392a-657673baf430
# ╟─16e6e894-05c4-4676-9686-b432d08ddd8c
# ╠═f875d478-7e09-4d07-9f7c-89021dadefd7
# ╟─83e85bf6-e369-4eaf-a477-99d34320a950
# ╠═8abe2a7d-187b-4086-8923-8dd562a8bf32
# ╠═48c0d0dc-8212-4541-8b5d-1699b0c7d12b
# ╠═3be7eb69-fcb6-4037-b5eb-937dcdf5cb70
# ╟─3b33d359-7033-4b9f-bb59-636776f5e4b7
# ╠═7cad08b9-d2a9-4d02-bb30-01d1ddcb03e7
# ╟─7436f5bd-46bb-4c94-b012-1389aea88dbd
# ╠═5b01677c-b164-42ee-955a-4edc71acd0f1
# ╟─89797c0a-b03a-4f23-9bfa-f6e32fc26456
# ╠═92a5450c-f4f1-4192-85ab-0550afaf6259
# ╠═8b459c2d-f429-4dfb-916b-b1abf53f9781
# ╠═3a8926fd-8555-4370-b6cf-cc81632dafb5
# ╠═3e21f5ac-bd24-4b0a-8998-3bc0499cc143
# ╟─20881b2d-afba-434b-a2ea-20cf2317051e
# ╠═c0a4c3f5-ca27-4477-bf03-95a87ce25ea7
# ╠═5ed830c3-df89-4173-aae9-d7eaaae818c6
# ╠═8b88a9df-1d23-4226-a5a2-dd81a78c6d78
# ╠═84c4aa8e-51b1-4f69-94c0-3f041437544c
# ╠═cedeccda-bbfd-4b66-a6da-4bbb13435e57
# ╟─6715341f-a256-4a31-966e-a107bd73a9d6
# ╠═27e2c73c-a744-45c9-adb0-94c1bbeaa817
# ╠═c5a7d45c-192b-4707-92b2-aa3c3caf9621
# ╟─21e8952c-0192-4ce8-947f-33a5e969a15b
# ╠═fcc9b741-711d-4b43-ab11-877ab2d47454
# ╟─ef743b59-b23d-400c-81a9-d61a3ba57580
# ╠═9f0ab375-978f-47af-ab6f-b5dd6c338295
# ╠═25e15246-05a3-490d-8e85-f88ccbb68885
# ╠═295c5af6-4d47-42a5-9337-b67a0035784c
# ╠═c1cb5f25-3773-4ac3-ad72-16236efd174f
# ╠═ab96fe25-c6a1-4f5b-b5c0-6ee26d8bd302
# ╟─02dfc0c7-bf40-48e1-8ce1-c5922ef81889
# ╟─3caf526a-7709-4696-b909-fdb624f7384d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
