### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ b11e6a20-f27f-4b13-94c8-31ec68f2d3ca
using Test

# ╔═╡ ef71c963-5319-4402-94e1-33de2cc99a30
md"""
# Built-in numerical types

At its most basic level, Julia is a calculator (overkill). To evaluate an arithmetic expression in Julia (in the REPL, in a script, or in a Jupyter/Pluto notebook), you first have to somehow type the numbers on your keyboard. The representations of numbers as strings in code are called _numeric literals_. 

In Julia, numeric literals follows common conventions adopted by other languages.
"""

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
# ╠═c1e6e0fa-8d03-4248-84cc-9cf22ae513e7
# ╟─b95b8c5f-9bce-4107-936b-4d269a3cf591
# ╠═80d2636e-27f9-4117-adcb-b3e1ad76f0e3
# ╠═2344493c-13c6-46d9-9202-c4356a6033a3
# ╠═14542f07-f224-4625-8654-98ac3d61414f
# ╠═cf037e98-caa4-42e4-aa1a-2e2d8ff5b34d
# ╠═d5d5313a-7486-4769-b898-271f5fb61710
# ╠═d0a9c61c-d2aa-49b9-b8a8-8aa06dcb1a1b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
