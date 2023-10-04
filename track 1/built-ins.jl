### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ ef71c963-5319-4402-94e1-33de2cc99a30
md"""
# Built-in numerical types

At its most basic level, Julia is a calculator (overkill). To evaluate an arithmetic expression in Julia, you first have to somehow type the numbers on your keyboard. The representations of numbers as strings in code are called _numeric literals_. 

In Julia, numeric literals follows common conventions adopted by other languages.
"""

# ╔═╡ 108badde-6d75-46d2-a008-a6c3f8126b7d
# Integer arithmetic: a sequence of digits is parsed as an integer
1 + 1

# ╔═╡ 7c536ab4-06ca-4ce6-a3ea-721ec0a7b7d5
# For Python users: multiplication use the common `*` symbols, but exponentiation is done with `^`
10 * 10, 10 ^ 10

# ╔═╡ 42c3a7b3-a511-4723-9472-c5e25daf8922
# Notice that the division between two integers is a floating point number
10 / 10

# ╔═╡ cae86ab8-4fc2-4546-805d-2c55bdc4495e
# Notice! Integer division is different from Python
10 // 10, 10 ÷ 10

# ╔═╡ b880fc93-6d4b-4ab4-857e-5572905ac3f1
# Integers prepended by `0x` are parsed as unsigned exadecimals
0x1f + 0x1

# ╔═╡ 12104137-e968-4d20-b6b4-c0da2f67b3b0
# Underscore can be used as a digit separator (ex. for thousands)
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
# For Python users: boolean literals begin with a small letter and are promoted to integers in arithmetic operations and comparisons
true == false + 1

# ╔═╡ f5917cc6-d0b8-4f4f-8dd7-c6a01fa1028d
# Floating point arithmetic: the dot signal that the numeric literal is a floating point
2. * 2.

# ╔═╡ 4c732919-65f0-49f5-a0dc-db7eba4029b7
# Exponential notation is also possible
2.0e0 * 2.

# ╔═╡ 74f94d41-4016-49ee-ab74-4ae23ca8019a
# Floating point numbers are by default 64-bit long, but 32-bit can be input with exponential notation and `f` instead of `e`
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
1/Inf

# ╔═╡ aefc0873-293b-43b2-8c8b-ac4a19bc6021
1/0

# ╔═╡ 8ada6f19-0f7e-41a1-af71-274d05321f62
500 + Inf

# ╔═╡ 9a20375d-4269-4c11-929f-359ae1874e19
-5/0

# ╔═╡ b7f36a86-11cc-49d8-8655-66b938de1995
500 - Inf

# ╔═╡ 98bf70ce-8865-445f-8a88-20dfc9522d6b
Inf + Inf

# ╔═╡ 74104309-607e-489c-821e-46d16a379f09
Inf * Inf

# ╔═╡ 136f111a-14e8-4df8-972d-0133e2fb0fc2
0/0

# ╔═╡ d05ecf02-c8ab-46db-b769-382ea3e82d7e
Inf - Inf

# ╔═╡ 2f73e914-c675-4973-a661-ffba32f7e7ca
Inf / Inf

# ╔═╡ b9979e41-b5ba-48be-8f1a-34c5358c110f
0 * Inf

# ╔═╡ bbe2a733-8d95-4e79-a664-330a03e3551c
# NaN is not semantically equal to NaN
NaN == NaN

# ╔═╡ 9b32ebdd-a10a-4c00-95a2-68626e91c4fb
NaN != NaN

# ╔═╡ f49fa439-3f03-459a-9fdb-d5c6e78bf080
NaN <= NaN

# ╔═╡ 7a71a070-652a-4bfe-8cc1-008756a8fe1c
# But, of course, NaN is bit-wise equal to NaN
NaN === NaN

# ╔═╡ b95b8c5f-9bce-4107-936b-4d269a3cf591
md"""
!!! warning
	Finally, and Julia makes exception, beware of floating point numbers arithmetic!
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
# ╠═3674ae59-b628-418b-a0b2-0cab6eb399a0
# ╠═aefc0873-293b-43b2-8c8b-ac4a19bc6021
# ╠═8ada6f19-0f7e-41a1-af71-274d05321f62
# ╠═9a20375d-4269-4c11-929f-359ae1874e19
# ╠═b7f36a86-11cc-49d8-8655-66b938de1995
# ╠═98bf70ce-8865-445f-8a88-20dfc9522d6b
# ╠═74104309-607e-489c-821e-46d16a379f09
# ╠═136f111a-14e8-4df8-972d-0133e2fb0fc2
# ╠═d05ecf02-c8ab-46db-b769-382ea3e82d7e
# ╠═2f73e914-c675-4973-a661-ffba32f7e7ca
# ╠═b9979e41-b5ba-48be-8f1a-34c5358c110f
# ╠═bbe2a733-8d95-4e79-a664-330a03e3551c
# ╠═9b32ebdd-a10a-4c00-95a2-68626e91c4fb
# ╠═f49fa439-3f03-459a-9fdb-d5c6e78bf080
# ╠═7a71a070-652a-4bfe-8cc1-008756a8fe1c
# ╟─b95b8c5f-9bce-4107-936b-4d269a3cf591
# ╠═80d2636e-27f9-4117-adcb-b3e1ad76f0e3
# ╠═2344493c-13c6-46d9-9202-c4356a6033a3
# ╠═14542f07-f224-4625-8654-98ac3d61414f
# ╠═cf037e98-caa4-42e4-aa1a-2e2d8ff5b34d
# ╠═d5d5313a-7486-4769-b898-271f5fb61710
# ╠═d0a9c61c-d2aa-49b9-b8a8-8aa06dcb1a1b
