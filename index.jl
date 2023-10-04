### A Pluto.jl notebook ###
# v0.19.29

#> [frontmatter]
#> title = "A tour of Julia"
#> date = "2023-02-07"
#> description = "Seminar outline"

using Markdown
using InteractiveUtils

# ╔═╡ 8d964530-9e3d-11ed-301f-43882004bcd5
md"""
# A tour of Julia

Julia is a general purpose programming language suited for technical computing. It is a dynamic, high-level language, which means that executing a program written in Julia does not require the user to compile it beforehand, as for C or Fortran, and its syntax is similar to MATLAB or Python. Nonetheless, its performance is close to that of statically compiled languages. This is possible thanks to clever design, and Just In Time (JIT) compilation (as JavaScript/TypeScript in your browser or Python when using Numba).
"""

# ╔═╡ b26ee80f-d113-4c31-80ff-903d6f1b947b
md"""
## About the author

Hi! My name is Stefano Campanella, I work at [OGS](https://www.ogs.it/), I like Julia.

> _He had a lot to say. He had a lot of nothing to say._ -- Eulogy, Tool (Ænima, 1996)
"""

# ╔═╡ a5c40f9a-0109-4baa-8225-a15e59010e35
begin
	if "HTML" in keys(ENV)
		root = ""
		extension = ".html"
	else
		root = "./open?path="
		extension = ".jl"
	end
	
	Markdown.parse("""
	## Seminar outline
		
	The material covered in this seminar is hardly original. It is mostly a reworking of the [official Julia documentation](https://docs.julialang.org/en/v1/), which is extensive and well written, and which I will refer to on several occasions. 
		
	I will begin with some [preliminary stuff]($(root * "extra/prelims" * extension)) (installation, package management, editors and IDE support). After that, we will touch some topics from two tracks. Finally, we will see simple examples and applications showing features and putting together a few things seen along the way.
		
	### Track 1
	
	The first track contains a more gentle introduction to programming in Julia, and requires only a limited coding experience.
	
	1. [Built-in data types and variables]($(root * "track 1/built-ins" * extension))
	1. [Control flow]($(root * "track 1/controlflow" * extension))
	1. [Multidimensional arrays]($(root * "track 1/arrays" * extension))
		
	### Track 2
	
	The second track contains more advanced topics and references to computer science concepts.
	
	1. [The Julia type system]($(root * "track 2/types" * extension))
	1. [Building abstractions with procedures]($(root * "track 2/procedures" * extension))
	1. [Building abstractions with data]($(root * "track 2/data" * extension))
	
	### Examples
	
	The examples have a varied degree of complexity and present the implementation of algorithms from numerical analysis and other fields.
	
	1. [Huffman coding]($(root * "examples/huffman" * extension))
	1. [Two-dimensional Laplace equation]($(root * "examples/jacobi" * extension))
	1. [One-dimensional advection equation]($(root * "examples/smolarkiewicz" * extension))
	1. [Sudoku puzzles]($(root * "examples/sudoku" * extension))
		
	### Applications

	The applications section shows how to solve simple tasks relevant to statistics and Earth science. Here I will showcase some popular libraries.
		
	1. Open a NetCDF and make a plot
	1. Analyse a tabular dataset
		
	Let's begin with a digression and answer the question _why should I learn programming in Julia?_
	""")
end

# ╔═╡ 98a176d7-5140-4492-8a18-b42ca3c3e87d
md"""
## Motivation

The great pyramid of Giza resisted the forces of nature, the winds, the sun, and the movements of the Earth, serving its purpose for more than four thousands years. Its thick walls might even provide good insulation, but nobody would ever immagine to make new buildings using the same solutions adopted in the ancient Egypt. This analogy illustrate why, in the opinion of the author, you should **stop writing scientific code in Fortran 77 _whenever possible_**. Which language one might use then? 

Julia is a language that allows to easily write code that is correct[^1], maintainable, and sufficiently fast to shortcircuit prototipation and production cycle (the so-called _two language problem_).[^2]

On a less technical level, **writing Julia code is fun**[^3] (as long as you have freedom of choice, this is a perfectly reasonable argument).

Before moving on, I'll add a few words about expectations on Julia.

[^1]: 
	[In the words of Robert F. Rosin, Ph.D.](https://youtu.be/L5daPjK00bo)
	> A program that produces a wrong answer at the speed of light isn't efficient; it's merely fast.

[^2]:
	To put it more colorfully, Julia provides you the tools to write code that comply with the virtues proposed by Italo Calvino in "Six Memos for the Next Millennium": lightness, quickness, exactitude, visibility, multiplicity, and consistency--at the end, code is literature, and Calvino's lectures are an unrecognized treatise about software engineering. These tools (abstractions and facilities) are missing from the venerable FORTRAN 77, for example.

[^3]:
	As in the famous quote of Alan J. Perlis that opens the memorable Structure and Interpretation of Computer Programs by Abelson and Sussmann:

	>I think that it's extraordinarily important that we in computer science keep fun in computing. When it started out, it was an awful lot of fun. Of course, the paying customers got shafted every now and then, and after a while we began to take their complaints seriously. We began to feel as if we really were responsible for the successful, error-free perfect use of these machines. I don't think we are. I think we're responsible for stretching them, setting them off in new directions, and keeping fun in the house. I hope the field of computer science never loses its sense of fun. Above all, I hope we don't become missionaries. Don't feel as if you're Bible salesmen. The world has too many of those already. What you know about computing other people will learn. Don't feel as if the key to successful computing is only in your hands. What's in your hands, I think and hope, is intelligence: the ability to see the machine as more than when you were first led up to it, that you can make it more.
"""

# ╔═╡ fff6699a-ae06-4ec5-8cd6-bdea86d84371
md"""
## Disclaimer

Julia **will not make your code automagically fast**, and you could potentially write awfully slow Julia code. Nonetheless the language will make it easy to write efficient code. Also, it encourages the re-use of code, which is one of the most fundamental principles of software engineering

Julia is a **young programming language** (first public release in 2012, 1.0 release in 2018), and some tools and libraries might not be available. The package ecosystem is vast, but some packages might not have the maturity of the alternatives in other programming languages. 

Finally, when choosing the programming language for your next project, you should take into account the effort of learning a new one, the man-months spent on existing codebase, and the expertise of the colleagues you collaborate with. Indeed, you should also consider that Julia requires more sensibility and inclination towards computer science in comparison with MATLAB or R,.

So in when Julia is a good choice?

One example is when you have to write **new algorithms from scratch**, when they cannot be written as array operations (i.e. with loops), and you want to avoid the clumsiness of verbose, low-level languages without loosing efficiency. 

Another scenario might be **data-model integration using machine learning**: there will exist more feature-complete models written in Fortran, and the de facto standard for ML is Python, but writing an interface between the two is non-trivial. Julia solves the issue by having a single language for the two purposes.
"""

# ╔═╡ Cell order:
# ╟─8d964530-9e3d-11ed-301f-43882004bcd5
# ╟─b26ee80f-d113-4c31-80ff-903d6f1b947b
# ╟─a5c40f9a-0109-4baa-8225-a15e59010e35
# ╟─98a176d7-5140-4492-8a18-b42ca3c3e87d
# ╟─fff6699a-ae06-4ec5-8cd6-bdea86d84371
