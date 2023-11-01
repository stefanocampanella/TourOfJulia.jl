### A Pluto.jl notebook ###
# v0.19.30

using Markdown
using InteractiveUtils

# ╔═╡ b11e6a20-f27f-4b13-94c8-31ec68f2d3ca
using Test

# ╔═╡ ef71c963-5319-4402-94e1-33de2cc99a30
md"""
# Built-in numerical types and missing values

At its most basic level, Julia is a calculator (overkill). To evaluate an arithmetic expression in Julia (in the REPL, in a script, or in a Jupyter/Pluto notebook), you first have to somehow type the numbers on your keyboard. The representations of numbers as strings in code are called _numeric literals_. 

In Julia, numeric literals follows common conventions adopted by other languages.
"""

# ╔═╡ 211a7ce3-7722-456b-8d56-63236aab4f15
md"## Integers"

# ╔═╡ 108badde-6d75-46d2-a008-a6c3f8126b7d
# Integer literals: a sequence of digits is parsed as an integer
1 + 1

# ╔═╡ 7c536ab4-06ca-4ce6-a3ea-721ec0a7b7d5
# For Python users: multiplication use the common `*` symbols, but exponentiation is done with `^`
10 * 10, 10 ^ 10

# ╔═╡ 42c3a7b3-a511-4723-9472-c5e25daf8922
# Notice that the division between two integers is a floating point number
10 / 10

# ╔═╡ cae86ab8-4fc2-4546-805d-2c55bdc4495e
# Notice! Integer division uses a slightly different syntax than in Python, and it's done using the `div` function or the `÷` operator. The double-slash operator constructs a rational number.
10 // 10, 10 ÷ 10

# ╔═╡ b880fc93-6d4b-4ab4-857e-5572905ac3f1
# Integers prepended by `0x` are parsed as unsigned exadecimals
0x1f + 0x1

# ╔═╡ 12104137-e968-4d20-b6b4-c0da2f67b3b0
# Underscore can be used as a digit separator
1_000 + 1

# ╔═╡ fc52210f-b401-43bb-8989-45ac7457a6bf
# Notice that integers dont overflow
2 ^ 63

# ╔═╡ 2de5f7dd-41a2-4082-96b4-9ea9d924de5c
# Indeed, integers form a modular arithmetic
typemax(Int) + 1 == typemin(Int)

# ╔═╡ f622935b-1255-42d6-8174-de5e6b6d8a4a
# You can use integers as large as your RAM allows by using arbitrary precision
big(2) ^ 63 

# ╔═╡ 8ba4f052-7a40-43fb-8897-b672c9990ace
md"""
The bit representation of integer and floating point numbers are called _numeric primitives_. Julia can represent many types of integer numbers (the concept of type will be treated extensively in track 2).


| Type      | Signed? | Number of bits | Smallest value | Largest value |
|:--------- |:------- |:-------------- |:-------------- |:------------- |
| `Int8`    | ✓       | 8              | -2^7           | 2^7 - 1       |
| `UInt8`   |         | 8              | 0              | 2^8 - 1       |
| `Int16`   | ✓       | 16             | -2^15          | 2^15 - 1      |
| `UInt16`  |         | 16             | 0              | 2^16 - 1      |
| `Int32`   | ✓       | 32             | -2^31          | 2^31 - 1      |
| `UInt32`  |         | 32             | 0              | 2^32 - 1      |
| `Int64`   | ✓       | 64             | -2^63          | 2^63 - 1      |
| `UInt64`  |         | 64             | 0              | 2^64 - 1      |
| `Int128`  | ✓       | 128            | -2^127         | 2^127 - 1     |
| `UInt128` |         | 128            | 0              | 2^128 - 1     |
| `Bool`    | N/A     | 8              | `false` (0)    | `true` (1)    |

!!! note 
	`Int` is an alias for `Int32` on 32-bit architectures and `Int64` on 64-bit architectures.
"""

# ╔═╡ 7369cf00-2b76-488f-afdb-59514a517c98
# For Python users: boolean literals begin with a lower case and are promoted to integers in arithmetic operations and comparisons
true == false + 1 && true > false

# ╔═╡ 25bf1d02-9448-4ad0-9d51-16765a9dbf7f
md"## Floating point numbers"

# ╔═╡ f5917cc6-d0b8-4f4f-8dd7-c6a01fa1028d
# Floating point arithmetic: the dot signal that the numeric literal is a floating point
2. * 2.

# ╔═╡ 4c732919-65f0-49f5-a0dc-db7eba4029b7
# Exponential notation is also possible
2.0e0 * 2.

# ╔═╡ 74f94d41-4016-49ee-ab74-4ae23ca8019a
# Floating point numbers are by default 64-bit long, but 32-bit can be input with exponential notation by using `f` instead of `e`
2.0f0 * 2.0f0

# ╔═╡ 0d0ef953-259f-43f6-bf89-3ddfb44008ed
# Floating point numbers have two zeros, which are considered equal in comparisons
0.0 == -0.0

# ╔═╡ 074a36e7-043b-4e55-b327-d65579a137d5
bitstring(0.0)

# ╔═╡ 2c160e9a-4767-4b0a-a347-33a2355f08aa
bitstring(-0.0)

# ╔═╡ 263e7e27-23cc-45db-aa6b-ac510ea0741a
# The `===` operator can be used to compare bit representations and mutable objects (similarly to `is` in Python)
0.0 === -0.0

# ╔═╡ 4ce8404c-7634-49b9-93e7-52459c109e73
md"""
Floating point numbers follow the IEEE standards.

| Type      | Precision  | Number of bits |
|:----------|:-----------|:-------------- |
| `Float16` | [half](https://en.wikipedia.org/wiki/Half-precision_floating-point_format) | 16 |
| `Float32` | [single](https://en.wikipedia.org/wiki/Single_precision_floating-point_format) | 32 |
| `Float64` | [double](https://en.wikipedia.org/wiki/Double_precision_floating-point_format) | 64 |
"""

# ╔═╡ bbbbb0cf-0bf5-4906-ba8d-2bfae510d965
md"""
Floating point numbers includes also `Inf`, `-Inf` and `NaN` and their algebra is prescribed by IEEE. You should also be aware of how comparison works for these numbers.
"""

# ╔═╡ 3674ae59-b628-418b-a0b2-0cab6eb399a0
@testset begin
	@test 1/Inf == 0.0
	@test 1 / 0 == Inf
	@test -1 / 0 == -Inf
	@test Inf + 1 == Inf
	@test Inf + Inf == Inf
	@test Inf * Inf == Inf
end

# ╔═╡ 136f111a-14e8-4df8-972d-0133e2fb0fc2
0/0

# ╔═╡ bbe2a733-8d95-4e79-a664-330a03e3551c
# NaN is not "semantically" equal to NaN
NaN == NaN

# ╔═╡ 9b32ebdd-a10a-4c00-95a2-68626e91c4fb
NaN != NaN

# ╔═╡ f49fa439-3f03-459a-9fdb-d5c6e78bf080
NaN <= NaN

# ╔═╡ 7a71a070-652a-4bfe-8cc1-008756a8fe1c
# But, of course, NaN is bit-wise equal to NaN
NaN === NaN

# ╔═╡ 43d6c90c-e183-4841-836b-b8202f236153
# "Nantheless" not all NaNs are bitwise equal
0 / 0 === NaN

# ╔═╡ 4ab88acf-d369-4497-8365-b24bd5581485
bitstring(0 / 0)

# ╔═╡ f5b56bfa-f211-47d7-b256-a1fdf871ae83
bitstring(NaN)

# ╔═╡ fb091f60-92a6-4666-b2e9-86944c00ba13
# The reason is that the literal NaN is a quiet NaN, 0 / 0 is a signaling NaN.
# The function `isequal` ignores these differences
isequal(0 / 0, NaN)

# ╔═╡ b558d311-a5fc-49ae-a934-b738bba1a748
# Also, in most architectures, the mantissa is irrelevant. 
# If you are so inclined, you can use the not-a-number of the beast (especially useful for Iron Maiden fans).
let
	n = reinterpret(Int, NaN) | 666
	evil_nan = reinterpret(Float64, n)
	evil_nan, bitstring(evil_nan)
end

# ╔═╡ c1e6e0fa-8d03-4248-84cc-9cf22ae513e7
@test all(isequal(NaN), [0/0, Inf - Inf, Inf / Inf, 0 * Inf])

# ╔═╡ b95b8c5f-9bce-4107-936b-4d269a3cf591
md"""
!!! warning
	Finally, and Julia makes no exception, [beware of floating point numbers arithmetic](https://dl.acm.org/doi/pdf/10.1145/103162.103163)!
"""

# ╔═╡ 80d2636e-27f9-4117-adcb-b3e1ad76f0e3
0.1 + 0.2 - 0.3

# ╔═╡ 2344493c-13c6-46d9-9202-c4356a6033a3
# Machine epsilon
eps(Float32)

# ╔═╡ 14542f07-f224-4625-8654-98ac3d61414f
eps(Float32) == eps(1.0f0)

# ╔═╡ cf037e98-caa4-42e4-aa1a-2e2d8ff5b34d
eps(0.1)

# ╔═╡ d5d5313a-7486-4769-b898-271f5fb61710
0.1 + eps(0.1) == nextfloat(0.1)

# ╔═╡ d0a9c61c-d2aa-49b9-b8a8-8aa06dcb1a1b
prevfloat(0.1) + eps(prevfloat(0.1)) == 0.1

# ╔═╡ 18a9b640-eeac-4483-b348-00576ff59671
md"""
## Missing values

NaNs are sometimes used to represent missing values, but they might not work as intended. 

For this reason, Julia implements the `missing` value, which behaves similarly to `NA` in R.
"""

# ╔═╡ 0a022203-e586-43a1-b7ea-56dc6dc25d54
1 + NaN # Ok

# ╔═╡ 7cb1f647-2df5-4790-8986-d04204d5f3f3
0 < NaN # Information loss

# ╔═╡ 0d0c5637-a9ba-49cd-a4fd-e5b159be5baa
1 + missing # Still ok

# ╔═╡ 6085a50f-50de-4109-83dd-05c49e7a5991
0 < missing # As intended

# ╔═╡ 6eb7ce56-392c-4975-b59e-ada4a1b59a40
# Missing propagates also in the `==` comparison operator, hence you cannot use it to check if a value is missing
missing == missing

# ╔═╡ 3c905d54-16e6-4a5b-8f94-26e2d10fbac4
# However, the `isequal` function and the bitwise comparison `===` do not propagate
isequal(missing, missing) && missing === missing

# ╔═╡ 403fb416-1f22-4c58-a6a3-3d9b592d1d5f
# Also, Julia implements the three-valued logic on `missing`, `true` and `false
true || missing

# ╔═╡ 879324ca-b15e-4275-a2ad-3c6879611537
# The recommended way of testing for missing values is the `ismissing` function
let
	sum = 0.0
	for x in [1.0, missing, 3.0]
		if !ismissing(x)
			sum += x
		end
	end
	sum
end

# ╔═╡ 35031575-fa94-4b2c-862c-9175c2d2c079
# Arrays (which will be introduced later) can contain missing values
xs = [1.0, missing, 3.0]

# ╔═╡ 75e78554-c6d5-49a4-9db5-e95a2e3e5346
sum(xs)

# ╔═╡ 00f0fda7-fc44-48c5-a425-d1a639d30957
# Note that the `isless` function here evaluates to true
isless(0, missing)

# ╔═╡ 23a39643-eed6-409d-b6ea-accf93227cb1
# So that a sorted array will have missing values at the end
sort(xs)

# ╔═╡ 12b974d2-a94a-463c-b29c-1f1d80d03e82
# If you want to exclude missing values from your calculations, you can create a new special array with `skipmissing`
xs_nomissings = skipmissing(xs)

# ╔═╡ 1d670adf-5b7b-4075-9635-b9273eeb28b9
# Functions that iterate over the array will skip missing values
sum(xs_nomissings)

# ╔═╡ f8f3aed6-8332-4651-b4d4-d86e362def99
# And indexing is the same as the parent array
findall(>(0), xs_nomissings)

# ╔═╡ 2b5ef054-697f-4933-b582-ff22883504ce
# However, accessing the array on a missing value index will throw an error
xs_nomissings[2]

# ╔═╡ 84780473-db82-47c7-97c5-0ea74dda8087
md"Arrays containing missing values are as memory efficient as they can be."

# ╔═╡ 0d859212-74b1-4905-9ecb-0634cbcc7bb7
Base.summarysize(1.0) # in bytes

# ╔═╡ f8c46877-07dc-4dec-9e85-14f54a17d09f
Base.summarysize(Float64[]) # Empty array size

# ╔═╡ e58b709b-467b-42a7-a59a-509bd3737f6e
Base.summarysize([1.0, 2.0, 3.0, 4.0]) # size of `Float64[]` + 4 × 8 bytes

# ╔═╡ 90ce096e-451b-4708-90f1-d32ed530948d
Base.summarysize([1.0, 2.0, 3.0, missing]) # size of `Float64[]` + 4 × 8 + 4 × 1 bytes

# ╔═╡ 00664936-4635-4b4e-8794-74cb841ac1ae
md"""
In general, arrays containing union types (which should be avoided for performance reasons) will align elements in memory as if they were all of the largest type, and reinterpret them upon access according to a support array containing information about their type.

Finally, you should be aware that Julia contemplates both `missing` and `nothing`, _but that's a story for another time..._
"""

# ╔═╡ 1ec7df3f-0235-4bb2-98df-04b8386aeada
html"""<iframe src="https://giphy.com/embed/mx9fVEF08tyne" width="480" height="334" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/80s-neverending-story-falkor-mx9fVEF08tyne">via GIPHY</a></p>"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "71d91126b5a1fb1020e1098d9d492de2a4438fd2"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ Cell order:
# ╟─ef71c963-5319-4402-94e1-33de2cc99a30
# ╟─211a7ce3-7722-456b-8d56-63236aab4f15
# ╠═108badde-6d75-46d2-a008-a6c3f8126b7d
# ╠═7c536ab4-06ca-4ce6-a3ea-721ec0a7b7d5
# ╠═42c3a7b3-a511-4723-9472-c5e25daf8922
# ╠═cae86ab8-4fc2-4546-805d-2c55bdc4495e
# ╠═b880fc93-6d4b-4ab4-857e-5572905ac3f1
# ╠═12104137-e968-4d20-b6b4-c0da2f67b3b0
# ╠═fc52210f-b401-43bb-8989-45ac7457a6bf
# ╠═2de5f7dd-41a2-4082-96b4-9ea9d924de5c
# ╠═f622935b-1255-42d6-8174-de5e6b6d8a4a
# ╟─8ba4f052-7a40-43fb-8897-b672c9990ace
# ╠═7369cf00-2b76-488f-afdb-59514a517c98
# ╟─25bf1d02-9448-4ad0-9d51-16765a9dbf7f
# ╠═f5917cc6-d0b8-4f4f-8dd7-c6a01fa1028d
# ╠═4c732919-65f0-49f5-a0dc-db7eba4029b7
# ╠═74f94d41-4016-49ee-ab74-4ae23ca8019a
# ╠═0d0ef953-259f-43f6-bf89-3ddfb44008ed
# ╠═074a36e7-043b-4e55-b327-d65579a137d5
# ╠═2c160e9a-4767-4b0a-a347-33a2355f08aa
# ╠═263e7e27-23cc-45db-aa6b-ac510ea0741a
# ╟─4ce8404c-7634-49b9-93e7-52459c109e73
# ╟─bbbbb0cf-0bf5-4906-ba8d-2bfae510d965
# ╠═b11e6a20-f27f-4b13-94c8-31ec68f2d3ca
# ╠═3674ae59-b628-418b-a0b2-0cab6eb399a0
# ╠═136f111a-14e8-4df8-972d-0133e2fb0fc2
# ╠═bbe2a733-8d95-4e79-a664-330a03e3551c
# ╠═9b32ebdd-a10a-4c00-95a2-68626e91c4fb
# ╠═f49fa439-3f03-459a-9fdb-d5c6e78bf080
# ╠═7a71a070-652a-4bfe-8cc1-008756a8fe1c
# ╠═43d6c90c-e183-4841-836b-b8202f236153
# ╠═4ab88acf-d369-4497-8365-b24bd5581485
# ╠═f5b56bfa-f211-47d7-b256-a1fdf871ae83
# ╠═fb091f60-92a6-4666-b2e9-86944c00ba13
# ╠═b558d311-a5fc-49ae-a934-b738bba1a748
# ╠═c1e6e0fa-8d03-4248-84cc-9cf22ae513e7
# ╟─b95b8c5f-9bce-4107-936b-4d269a3cf591
# ╠═80d2636e-27f9-4117-adcb-b3e1ad76f0e3
# ╠═2344493c-13c6-46d9-9202-c4356a6033a3
# ╠═14542f07-f224-4625-8654-98ac3d61414f
# ╠═cf037e98-caa4-42e4-aa1a-2e2d8ff5b34d
# ╠═d5d5313a-7486-4769-b898-271f5fb61710
# ╠═d0a9c61c-d2aa-49b9-b8a8-8aa06dcb1a1b
# ╟─18a9b640-eeac-4483-b348-00576ff59671
# ╠═0a022203-e586-43a1-b7ea-56dc6dc25d54
# ╠═7cb1f647-2df5-4790-8986-d04204d5f3f3
# ╠═0d0c5637-a9ba-49cd-a4fd-e5b159be5baa
# ╠═6085a50f-50de-4109-83dd-05c49e7a5991
# ╠═6eb7ce56-392c-4975-b59e-ada4a1b59a40
# ╠═3c905d54-16e6-4a5b-8f94-26e2d10fbac4
# ╠═403fb416-1f22-4c58-a6a3-3d9b592d1d5f
# ╠═879324ca-b15e-4275-a2ad-3c6879611537
# ╠═35031575-fa94-4b2c-862c-9175c2d2c079
# ╠═75e78554-c6d5-49a4-9db5-e95a2e3e5346
# ╠═00f0fda7-fc44-48c5-a425-d1a639d30957
# ╠═23a39643-eed6-409d-b6ea-accf93227cb1
# ╠═12b974d2-a94a-463c-b29c-1f1d80d03e82
# ╠═1d670adf-5b7b-4075-9635-b9273eeb28b9
# ╠═f8f3aed6-8332-4651-b4d4-d86e362def99
# ╠═2b5ef054-697f-4933-b582-ff22883504ce
# ╟─84780473-db82-47c7-97c5-0ea74dda8087
# ╠═0d859212-74b1-4905-9ecb-0634cbcc7bb7
# ╠═f8c46877-07dc-4dec-9e85-14f54a17d09f
# ╠═e58b709b-467b-42a7-a59a-509bd3737f6e
# ╠═90ce096e-451b-4708-90f1-d32ed530948d
# ╟─00664936-4635-4b4e-8794-74cb841ac1ae
# ╟─1ec7df3f-0235-4bb2-98df-04b8386aeada
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
