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

> _He had a lot to say. He had a lot of nothing to say._ -- Eulogy, Tool (Ænima, 1996)

## Seminar outline

The material covered in this seminar is hardly original. It is mostly a reworking of the [official Julia documentation](https://docs.julialang.org/en/v1/), which is extensive and well written, and which I will refer to on several occasions. 

Here there are the core topics that I would like to touch in this short series of notebooks:

1. [Preliminary stuff](01_prelims.html) (installation, package management, editors and IDE support)
2. [The Julia type system](02_types.html)
3. [Building abstractions with procedures](03_procedures.html)
4. [Building abstractions with data](04_data.html)
5. [Multidimensional arrays](05_arrays.html)
6. [Code reuse](07_reuse.html) (how to organize, test and distribute Julia code)
7. [HPC related topics](08_hpc.html) (concurrency, noteworthy packages, etc.)

Finally, we will see how to [solve a sudoku puzzle or the one-dimensional advection equation](06_examples.html) using Julia, and putting together a few thing seen along the way.

Let's begin with a digression and answer the question _why should I learn programming in Julia?_
"""

# ╔═╡ 98a176d7-5140-4492-8a18-b42ca3c3e87d
md"""
## Motivation

The great pyramid of Giza resisted the forces of nature, the winds, the sun, and the movements of the Earth, serving its purpose for more than four thousands years. Its thick walls might even provide good insulation, but nobody would ever immagine to make new buildings using the same solutions adopted in the ancient Egypt. This analogy illustrate why, in the opinion of the author, you should **stop writing scientific code in Fortran _whenever possible_**. Which language one might use then? 

There are practical reasons why **Julia it's a good choice**: it's a language that allows to easily write code that is maintainable, correct and sufficiently fast to shortcircuit prototipation and production cycle (the so-called _two language problem_).

To put it more colorfully, Julia provides you the tools to write code that comply with the virtues proposed by Italo Calvino in "Six Memos for the Next Millennium": lightness, quickness, exactitude, visibility, multiplicity, and consistency--code is literature, and Calvino's lectures are an unrecognized treatise about software engineering. These tools (abstractions and facilities) are missing from the venerable FORTRAN 77, for example.

On a less technical level, and this is my favourite answer, Julia is a good choice because **writing Julia code is fun**. This is a perfectly reasonable argument to choose a programming language, as long as you have freedom of choice.

As in the quote of Alan J. Perlis that opens the memorable Structure and Interpretation of Computer Programs by Abelson and Sussmann:

>I think that it's extraordinarily important that we in computer science keep fun in computing. When it started out, it was an awful lot of fun. Of course, the paying customers got shafted every now and then, and after a while we began to take their complaints seriously. We began to feel as if we really were responsible for the successful, error-free perfect use of these machines. I don't think we are. I think we're responsible for stretching them, setting them off in new directions, and keeping fun in the house. I hope the field of computer science never loses its sense of fun. Above all, I hope we don't become missionaries. Don't feel as if you're Bible salesmen. The world has too many of those already. What you know about computing other people will learn. Don't feel as if the key to successful computing is only in your hands. What's in your hands, I think and hope, is intelligence: the ability to see the machine as more than when you were first led up to it, that you can make it more.
"""

# ╔═╡ Cell order:
# ╟─8d964530-9e3d-11ed-301f-43882004bcd5
# ╟─98a176d7-5140-4492-8a18-b42ca3c3e87d
