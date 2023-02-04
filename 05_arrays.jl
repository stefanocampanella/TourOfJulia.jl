### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 3e1a5e86-9cc8-11ed-35da-5f21a6e28fb6
md"""
# Multi-dimensional arrays

Being a programming language designed for technical computing, Julia has a comprehensive support for multi-dimensional arrays. Furthermore, since the implementation of arrays is written in Julia, the array interface is easily extendible to data structures that exibhit similar behavior. 

The crucial point is that the performance comes from Julia design and, in contrast to other languages like Matlab of Python, there is no need to use vectorized operations. Although array-programming might make more readable certain implementation (and more easily portable to accelerators, for example), you can write loops and use scalar indexing in Julia obtaining good performance.
"""

# ╔═╡ 890b8096-972b-4c88-bf35-5d2fc54a3aeb
md"""

## Construction, initialization and basic functions
 
The array type `Array{T, N}` is a parametric type having two parameters, the rank (number of dimensions) of the array and the type of the elements of the array. The elements can be any object and will be stored in contigous memory locations. Notice that the size of the array along each dimension is not a parameter of the array type. Indeed, arrays can be resized without changing their type and are mutable objects. However, if you have to deal with small arrays of known size you might consider using [`StaticArrays`](https://github.com/JuliaArrays/StaticArrays.jl), which have fixed lenght and, in certain algorithms, can show a considerable speedup.

Arrays can be constructed using the `Array{T}(initializer, sizes...)` constructor, the type of the element `T` defaults to `Float64` if not indicated. The rank of the array is deduced from the sizes. The initializer can be `undef`, an object of the singleton type `UndefInitializer` that will not initialize the array. If `Missing <: T` or `Noting <: T` the initializer can be respectively `missing` or `nothing`.

If you want to create an array containing elements you can use the 
"""

# ╔═╡ e38c43ca-7d90-40ec-88b4-86102527e585
methods(Array{Float64, 3})

# ╔═╡ Cell order:
# ╟─3e1a5e86-9cc8-11ed-35da-5f21a6e28fb6
# ╠═890b8096-972b-4c88-bf35-5d2fc54a3aeb
# ╠═e38c43ca-7d90-40ec-88b4-86102527e585
