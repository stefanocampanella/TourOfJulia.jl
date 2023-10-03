### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 85a06828-6206-11ee-392a-657673baf430
md"""
# Control flow

Julia provides a variety of control flow constructs:

* Compound Expressions: `begin` and `;`.
* Conditional Evaluation: `if-elseif-else` and `?:` (ternary operator).
* Short-Circuit Evaluation: logical operators `&&` (“and”) and `||` (“or”), and also chained comparisons.
* Repeated Evaluation: Loops: `while` and `for`.
* Exception Handling: `try-catch`, `error` and `throw`.
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

# ╔═╡ 31b3e28e-34da-4117-8f77-93380399668c
# if expressions are special forms, the evaluation strategy is different from function evaluation
if x < y
	"y is greater than x"
elseif x > y
	"x is greater than y"
else
	"x equals y"
end

# ╔═╡ 8abe2a7d-187b-4086-8923-8dd562a8bf32
# Will throw an error, on real domain
error("Alarm!")

# ╔═╡ 48c0d0dc-8212-4541-8b5d-1699b0c7d12b
minmax(error("Alarm!"), 1)

# ╔═╡ 3be7eb69-fcb6-4037-b5eb-937dcdf5cb70
# if expressions are special forms, the evaluation strategy is different from function evaluation
if x < y
	"y is greater than x"
elseif x > y
	"x is greater than y"
	error("Alarm!")
else
	"x equals y"
end

# ╔═╡ Cell order:
# ╟─85a06828-6206-11ee-392a-657673baf430
# ╠═f875d478-7e09-4d07-9f7c-89021dadefd7
# ╠═31b3e28e-34da-4117-8f77-93380399668c
# ╠═8abe2a7d-187b-4086-8923-8dd562a8bf32
# ╠═48c0d0dc-8212-4541-8b5d-1699b0c7d12b
# ╠═3be7eb69-fcb6-4037-b5eb-937dcdf5cb70
