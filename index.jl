### A Pluto.jl notebook ###
# v0.19.20

#> [frontmatter]
#> title = "A tour of Julia"
#> date = "2023-02-07"
#> description = "Seminar outline"

using Markdown
using InteractiveUtils

# ╔═╡ 8d964530-9e3d-11ed-301f-43882004bcd5
md"""# A tour of Julia

Julia is a general programming language suited for scientific computing applications. It is a dynamic, high-level language: executing a program written in Julia does not require the user to compile it beforehand, as for C or Fortran, and its syntax is similar to MATLAB or Python. Nonetheless, its performance is close to that of statically compiled languages. This is possible thanks to Just In Time (JIT) compilation (as JavaScript/TypeScript in your browser or Python when using Numba).

## Prelude, about the author

Hi! My name is Stefano Campanella, I work at [OGS](https://www.ogs.it/), I like Julia.

> _He had a lot to say. He had a lot of nothing to say._ -- Eulogy, Ænima , Tool

## Seminar outline

The material covered in this seminar is hardly original. It is mostly a reworking of the [official Julia documentation](https://docs.julialang.org/en/v1/), which is extensive and well written, and which I will refer to on several occasions. 

Here there are the core topics that I would like to touch in this short series of notebooks:

1. [Preliminary stuff](01_introduction.html) (installation, package management, editors and IDE support)
2. [The Julia type system](02_types.html)
3. [Building abstractions with procedures](03_procedures.html)
4. [Building abstractions with data](04_data.html)
5. [Multidimensional arrays](05_arrays.html)
6. [Code reuse](07_reuse.html) (how to organize, test and distribute Julia code)
7. [HPC related topics](08_hpc.html) (concurrency, noteworthy packages, etc.)

Finally, we will see how to [solve a sudoku puzzle or the one-dimensional advection equation](06_examples.html) using Julia, and putting together a few thing seen along the way.

Let's begin with a digression and answer the question _why should I learn programming in Julia?_
"""

# ╔═╡ Cell order:
# ╟─8d964530-9e3d-11ed-301f-43882004bcd5
