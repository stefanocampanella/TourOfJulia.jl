### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> title = "A tour of Julia"
#> date = "2023-02-07"
#> description = "Seminar outline"

using Markdown
using InteractiveUtils

# ╔═╡ 98a176d7-5140-4492-8a18-b42ca3c3e87d
md"""
## Motivation

The great pyramid of Giza resisted the forces of nature, the winds, the sun, and the movements of the Earth, serving its purpose for more than four thousands years. Its thick walls might even provide good insulation, but nobody would ever immagine to make new buildings using the same solutions adopted in the ancient Egypt. This analogy illustrate why, in the opinion of the author, you should **stop writing scientific code in Fortran _whenever possible_**. Which language one might use then? 

There are practical reasons why **Julia it's a good choice**: it's a language that allows to easily write code that is correct[^1], maintainable, and sufficiently fast to shortcircuit prototipation and production cycle (the so-called _two language problem_).

To put it more colorfully, Julia provides you the tools to write code that comply with the virtues proposed by Italo Calvino in "Six Memos for the Next Millennium": lightness, quickness, exactitude, visibility, multiplicity, and consistency--code is literature, and Calvino's lectures are an unrecognized treatise about software engineering. These tools (abstractions and facilities) are missing from the venerable FORTRAN 77, for example.

On a less technical level, and this is my favourite answer, Julia is a good choice because **writing Julia code is fun**. This is a perfectly reasonable argument to choose a programming language, as long as you have freedom of choice.

As in the quote of Alan J. Perlis that opens the memorable Structure and Interpretation of Computer Programs by Abelson and Sussmann:

>I think that it's extraordinarily important that we in computer science keep fun in computing. When it started out, it was an awful lot of fun. Of course, the paying customers got shafted every now and then, and after a while we began to take their complaints seriously. We began to feel as if we really were responsible for the successful, error-free perfect use of these machines. I don't think we are. I think we're responsible for stretching them, setting them off in new directions, and keeping fun in the house. I hope the field of computer science never loses its sense of fun. Above all, I hope we don't become missionaries. Don't feel as if you're Bible salesmen. The world has too many of those already. What you know about computing other people will learn. Don't feel as if the key to successful computing is only in your hands. What's in your hands, I think and hope, is intelligence: the ability to see the machine as more than when you were first led up to it, that you can make it more.

[^1]: 
	[In the words of Robert F. Rosin, Ph.D.](https://youtu.be/L5daPjK00bo)
	> A program that produces a wrong answer at the speed of light isn't efficient; it's merely fast.
"""

# ╔═╡ 6d206f7c-6015-4aec-93dd-4cf56643a455
if "HTML" in keys(ENV)
	root = ""
	extension = ".html"
else
	root = "./open?path="
	extension = ".jl"
end;

# ╔═╡ 8d964530-9e3d-11ed-301f-43882004bcd5
Markdown.parse("""
# A tour of Julia

Julia is a general purpose programming language suited for technical computing. It is a dynamic, high-level language, which means that executing a program written in Julia does not require the user to compile it beforehand, as for C or Fortran, and its syntax is similar to MATLAB or Python. Nonetheless, its performance is close to that of statically compiled languages. This is possible thanks to clever design, and Just In Time (JIT) compilation (as JavaScript/TypeScript in your browser or Python when using Numba).

## Prelude, about the author

Hi! My name is Stefano Campanella, I work at [OGS](https://www.ogs.it/), I like Julia.

> _He had a lot to say. He had a lot of nothing to say._ -- Eulogy, Tool (Ænima, 1996)

## Seminar outline

The material covered in this seminar is hardly original. It is mostly a reworking of the [official Julia documentation](https://docs.julialang.org/en/v1/), which is extensive and well written, and which I will refer to on several occasions. 

Here there are the core topics that I would like to touch in this short series of notebooks:

1. [Preliminary stuff]($(root * "01_prelims" * extension)) (installation, package management, editors and IDE support)
2. [The Julia type system]($(root * "02_types" * extension))
3. [Building abstractions with procedures]($(root * "03_procedures" * extension))
4. [Building abstractions with data]($(root * "04_data" * extension))
5. [Multidimensional arrays]($(root * "05_arrays" * extension))

Finally, we will see how to solve a [sudoku puzzle]($(root * "06a_sudoku" * extension)), how to solve the [one-dimensional advection equation]($(root * "06b_smolarkiewicz" * extension)), or how to compress a message with [Huffman coding]($(root * "06c_huffman" * extension)) using Julia.

Let's begin with a digression and answer the question _why should I learn programming in Julia?_
""")

# ╔═╡ Cell order:
# ╟─8d964530-9e3d-11ed-301f-43882004bcd5
# ╟─98a176d7-5140-4492-8a18-b42ca3c3e87d
# ╟─6d206f7c-6015-4aec-93dd-4cf56643a455
