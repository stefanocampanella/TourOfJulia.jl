### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ ef71c963-5319-4402-94e1-33de2cc99a30
md"""
# Built-in types and variables

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

# ╔═╡ f5917cc6-d0b8-4f4f-8dd7-c6a01fa1028d
# Floating point arithmetic: the dot signal that the numeric literal is a floating point
2. * 2.

# ╔═╡ 4c732919-65f0-49f5-a0dc-db7eba4029b7
# Exponential notation is achieved as usual
2.0e0 * 2.

# ╔═╡ 74f94d41-4016-49ee-ab74-4ae23ca8019a
# Floating point numbers are by default 64-bit long, but 32-bit can be input with exponential notation and `f` instead of `e`
2.0f0 * 2.0f0

# ╔═╡ Cell order:
# ╟─ef71c963-5319-4402-94e1-33de2cc99a30
# ╠═108badde-6d75-46d2-a008-a6c3f8126b7d
# ╠═7c536ab4-06ca-4ce6-a3ea-721ec0a7b7d5
# ╠═42c3a7b3-a511-4723-9472-c5e25daf8922
# ╠═cae86ab8-4fc2-4546-805d-2c55bdc4495e
# ╠═b880fc93-6d4b-4ab4-857e-5572905ac3f1
# ╟─8ba4f052-7a40-43fb-8897-b672c9990ace
# ╠═f5917cc6-d0b8-4f4f-8dd7-c6a01fa1028d
# ╠═4c732919-65f0-49f5-a0dc-db7eba4029b7
# ╠═74f94d41-4016-49ee-ab74-4ae23ca8019a
