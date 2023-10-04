### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 572ea734-62bf-11ee-3757-4752db64b2b8
md"""
# Variables

A variable in Julia is a name bound to an object (a region of allocated memory).

The assignment operator is `=` and a variable name can be reused several times[^1].

Variable names are case sensitive and can include alphanumeric characters and other Unicode symbols, including `!` and `_`. There are however some limitation on the first character. For example, `!` is excluded, being the negation operator, and numeric literals too, since multiplication is implied.

Names containing only underscores can be used only as lvalues.

Julia keywords are reserved and cannot be used.

[^1]: Due to the limitations of its execution model, in Pluto we will have to use a `let` or a `begin` block. These blocks will be discussed in track 1 and 2.
"""

# ╔═╡ f6d768a6-42a4-4502-ad36-709a70032752
let
	# Assignment
	x = 41
	@show x

	# Use x both as lvalue and rvalue
	x = x + 1
	@show x

	# Change type of variable `x` (types are discussed in track 2)
	x = "Hello world!"
	@show x
end

# ╔═╡ eb1b8eb9-18e7-4ca1-978c-a6883d9b578a
pi

# ╔═╡ 5fe70ca9-1b02-475e-bbc7-873c76fcb262
2pi

# ╔═╡ eb35275a-285b-4253-97e1-850b5d9739b4
x = true

# ╔═╡ 4fac80eb-2e83-49c9-b3ce-ece520027d39
!x

# ╔═╡ eefa4b20-a589-4379-b66c-934aeec512f3
# Unicode characters are allowed, to enter them use \[extended name]<tab>, such as \delta<tab> here
δ = 0.0001

# ╔═╡ 30ea2528-dcca-4f37-983e-149714df9ce6
let
	# `___` is an lvalue (simplifying, something that could be used on the left hand side of an assignment)
	x, ___ = size([2 2; 1 1])
	# Illegal use of `___` as a rvalue (right hand side of an assignment)
	y = ___
	# This will throw an error too
	println(___)
end

# ╔═╡ f2a24699-2442-4111-a0ec-8e3df55a836a
# Assignments are expressions, and return the assigned value
a = (b = 1) + 1

# ╔═╡ 12be6882-3c11-4dca-81d2-4cd8e297654c
let
	# Hence, assignments can be chained (right to left)
	x = y = 1
	@show x y
	
	y = 2
	@show x y
end

# ╔═╡ 612851d7-0e77-4cee-9cac-f795613dd926
let
	# Here the vector `[1, 2, 3]` is assigned to both `x` and `y`
	x = y = [1, 2, 3]
	@show x y

	# `x` and `y` are bound to the same object, mutating it via one variable will be visible through the other
	y[1] = -1
	@show x y

	# Of course, assigning a new object to `y` will not affect `x`
	y = 42
	@show x y
end

# ╔═╡ 3a5fa678-85fd-4726-9051-36e53fa88b77
md"""
## Variables scope
"""

# ╔═╡ Cell order:
# ╟─572ea734-62bf-11ee-3757-4752db64b2b8
# ╠═f6d768a6-42a4-4502-ad36-709a70032752
# ╠═eb1b8eb9-18e7-4ca1-978c-a6883d9b578a
# ╠═5fe70ca9-1b02-475e-bbc7-873c76fcb262
# ╠═eb35275a-285b-4253-97e1-850b5d9739b4
# ╠═4fac80eb-2e83-49c9-b3ce-ece520027d39
# ╠═eefa4b20-a589-4379-b66c-934aeec512f3
# ╠═30ea2528-dcca-4f37-983e-149714df9ce6
# ╠═f2a24699-2442-4111-a0ec-8e3df55a836a
# ╠═12be6882-3c11-4dca-81d2-4cd8e297654c
# ╠═612851d7-0e77-4cee-9cac-f795613dd926
# ╠═3a5fa678-85fd-4726-9051-36e53fa88b77
