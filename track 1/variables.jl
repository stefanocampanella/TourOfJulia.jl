### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 572ea734-62bf-11ee-3757-4752db64b2b8
md"""
# Variables

In Julia, a variable is a name bound to an object (a region of allocated memory at some location).

The assignment operator `=` is used to define a variable, and variable names can be reused several times[^1].

These are case sensitive and can include alphanumeric characters and other Unicode symbols, including `!` and `_`. There are however some limitation on the first character. For example, `!` is excluded, being the negation operator, and numeric literals too, since multiplication is implied. Names containing only underscores can be used only as lvalues. Finally, Julia keywords are reserved and cannot be used.

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
4pi

# ╔═╡ 16004b13-0425-420d-88dc-edb30386d370
# The same rule applies to parenthesised expressions
2(pi + pi)

# ╔═╡ eb35275a-285b-4253-97e1-850b5d9739b4
truth = true

# ╔═╡ 4fac80eb-2e83-49c9-b3ce-ece520027d39
!truth

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

The scope of a variable is the region of code where that variable is accessible, that is the region of code where, unless there is an assignment, the same name refers to the same object.

Scopes are a conceptual tool to referring to multiple things using the same name, and to give precise meaning to assignment.

Scopes are organized in blocks, which can be nested or chained. In Julia, different constructs correspond to different types of scopes. There are the global scope, the soft local scope, and the hard local scope. Local scopes can be nested: a variable defined in an outer scope is accessible in all the inner scopes. The difference between hard and soft scopes is in the way shadowing (assignment to an already defined variable) of global variables works.

The constructs introducing scope blocks are:

| Construct              | Scope type   | Allowed within |
|:-----------------------|:-------------|:---------------|
| `module`, `baremodule` | global       | global         |
| `struct`               | local (soft) | global         |
| `for`, `while`, `try`  | local (soft) | global, local  |
| `macro`                | local (hard) | global         |
| functions, `do` blocks, `let` blocks, comprehensions, generators | local (hard) | global, local |

!!! note
	`begin` blocks and `if` blocks which do *not* introduce new scopes. Here's the rationale.
	
	Consider the common pattern of initializing a variable with a different value depending on some condition using an `if` block. In Julia, usually, a variable is declared implicitly with assignment. Having `if` blocks introducing new scopes would have required to initialize the variable with a default value outside, which is ugly and error prone. As a consequence, it is possible to have code paths where a variable is not defined. The Julia compiler is able to detect them and generate machine code that will eventually throw an error without performance penalty.

Notice that you can define a module within another module, but the scopes will not be nested: the variables defined in the outer module will not accessible in the inner one only via qualified access. 
"""

# ╔═╡ 64ea16be-71c4-4b25-b560-9e0cebc51e87
module example

module A
a = 1 # a global in A's scope
end;

module B
	module C
    c = 2
    end
    
	b = C.c    # can access the namespace of a nested global scope
               # through a qualified access
    import ..A # makes module A available
    
	d = A.a
end;

module D
b = a # errors as D's global scope is separate from A's
end
end

# ╔═╡ b64c7042-099f-460c-8546-de72106d2112
md"""
### Shadowing

Since local scopes can be nested, there might be assignments within inner scopes using the same name of a variable defined in an outer scope, which called shadowing. In this case, one could either define a new variable using the same name or assign to the outer variable. Generally, Julia adopts the second option (assignment to the variable defined in the outer scope). However, the rule has a few exceptions.

These exceptions entail the type of scope in which assignment occurs, and corner cases have been introduced to exploit interactive environments (REPL, notebooks, etc.) to the best.

The following diagram illustrates the logic.

!!! note
	In non-interactive contexts the hard and soft scope behaviors are identical except that a warning is printed.
"""

# ╔═╡ 5a0d7143-3f68-41e4-84e9-08c110cc9fcf
html"""<iframe frameborder="0" style="width:100%;height:933px;" src="https://viewer.diagrams.net/?highlight=0000ff&nav=1&title=scope.svg#R7VrbVts4FP2aPIble5JH7mWGUmbRGaAvXcIWsQbZCrJCkvn6ObIl36GG4jppm5dER1efs%2FfWkZyRfRitTzlahB9ZgOnIMoL1yD4aWfCZufAlLRtlMd1JZplzEmQ2szBckf%2BwMhrKuiQBTioNBWNUkEXV6LM4xr6o2BDnbFVtds9oddYFmuOG4cpHtGm9JoEIM%2BvUmhT2D5jMQz2z6c2ymgjpxupJkhAFbFUy2ccj%2B5AzJrJf0foQU%2Bk97Zfrs801PX%2FwTv%2F4K3lEfx%2F8%2Bfnin3E22MlruuSPwHEs3jz0py9fROCd0ZswhEg9Gsuv4aexOc3GfkJ0qRx2wdTjio32IQ7AparIuAjZnMWIHhfWA86WcYDlTAaUijbnjC3AaILxXyzERuEDLQUDUygiqmrhyfjmRvbfc3XxVg2XFo7WldJGlSi6w%2FSSJUQQFoPNh2rMoeIJc0EABue1BhEJgnTJiJJ5a499VZG3zPwhnVCD1DfiodolbMl9%2FEI7T9EC8Tl%2BcbwCdcBXzCIMnoCOHFMkyFN1dUjxZp63K7ABPxQ8XoFCr4GU4zVJBInnYKUMHDeyTxrQ4SGL7pawloNVSAS%2BWqDUFStQmyoAcnbJqN6zWJygiFAZ5g%2BYPmEZGVWhMGS6bUFMBGcPOdPTgWFKuUj7yCtKn1NYjh09pFqw8brISsTgdcntzdhoIdVEUzI6Ud5cFZJkap0Jy3Kkjd8Tzlbma5yU4nkLOr1D1MdrIm70GPD7thgCSkUnWdB9%2Bqay3vXKXG4X3iGprFdZiv0VuxfjxGcLvJss7ou47mxvNqtQN89sBuTuZGu4OywHn6dWBwpa3g%2Fi4EurLIXwlLI7lGbf%2BJ7EMiq7S8QGwbrG91kimjOvzkTbHZyJ5mSXdszemWd1zGSHZZ7VoN7I8iis9yAgT5Vgeo9Lebo7oMDHsUbUPjQxDUCUm7rUkCQaJ2ms0ip3sU4rdGf4NVff6STAmbh1ljvkP8xTcIx9RhnPxiMxHF1kci3nSlk%2FTjLay9qY8UhXdl3IGirTieEZPBRJ5UgXljlEmyprBkdny64%2Byh1vfZDXegRGTz2vrTVGVUXIagidzFmOovVc3mDs3VO28kPExV4CMBRfrWe0si595WOA%2BZJm9iVwlmXUBW48bRE4024ROLM3gXMaZDlPz3pyrgR2C9Cxd4oX7DgRiZGQwH9DyHoKi%2B3alZjAPtSMiduy6Xi9hcTdmuzvrSc3WbrEnIBDZJrxM9%2FkvMCqwTbAWQNAF3iV3%2BIUCehPTWwQ1z3DmJU%2B1eSyTXvbksveeO7YW8PzLTzlWV25Zk%2BG5JrVvDY9kyqF%2FGzu30e80lZr2%2FUMyOnKwv6OeHbzsiU%2Fqf8aKZDjTetx8douwZwfqY5uk1g7pI6yUE%2BA%2BlZMx%2BmomK47pGI6zRPHGcTV%2BIhI3KaXTf3qRLUA%2ByRJE8lOROuLW5bRuNZq5ZbRpnlGb6lH84gx0GthxS3jNdx6z1PJ1qQxzqBHBrcJiGvE4%2FTl7%2FtsfQFJFhRtBqajbTboOLE60rG3rc77zcb3Z%2BN3vr6dDclGr5n77CAgzAocCnRskzx3fZc4MB6aR5QdwkNLKvycaJjbiJHOefXAIJkOiogcBbelmrcgYgdUQ2dL%2FSMi7brPOdqUGiwYiUVSGvlSGkpJjtYLleFMndo%2FR2vtx%2Fnlyls7OKZRw2%2B25gLN%2BcO3ARyKxd9ss%2BbFv5Xt4%2F8B"></iframe>"""

# ╔═╡ 0db3aa04-356f-42a2-8538-603a7a6452e2
md"""
How do you shadow a local variable in a local scope? How do you assign to a global variable from a hard local scope? The `local` and `global` keywords exist for that.
"""

# ╔═╡ e52fc50d-0a61-465c-8d07-2e1982fbbf24
module globalscope

n = 0 # defined in global scope, hence is a global variable

function counter() # functions introduce a hard local scope
	global n # subsequent assignments will be visible from the global scope
	n = n + 1
end

for _ = 1:10
	@show counter()
end

end

# ╔═╡ 5d089849-2515-46a3-be31-d73c80f9badc
let
	greetings = "I'm a local variable"
		
	function shadowing()
		local greetings
		greetings = "I'm an example of shadowing"
	end

	function nonshadowing()
		greetings = "I'm not an example of shadowing"
	end

	greetings, shadowing(), greetings, nonshadowing(), greetings
end

# ╔═╡ 6974f0e7-a029-4d72-97a8-78c93903571c
function sum_to_def_closure(n)
    
	function loop_body(i)
        t = s + i # new local `t`
        s = t # assign same local `s` as below
    end
	
	s = 0 # new local
    for i = 1:n
        loop_body(i)
    end

    return s
end

# ╔═╡ 29592c11-9093-468b-9fce-d78e0cb4ecce
sum_to_def_closure(10) == sum(1:10)

# ╔═╡ 2b502881-a145-4575-b9b1-1a950fadb545
code = """
       s = 0 # global
       for i = 1:10
           t = s + i # new local `t`
           s = t # new local `s` with warning
       end
       s, # global
       @isdefined(t) # global
       """

# ╔═╡ 81420b57-a395-4071-9daf-6526d1509bff
include_string(Main, code)

# ╔═╡ 386450e8-322f-4ec9-a22a-6d7a756dd5b9
md"""
The previous example has been taken verbatim from the manual. Notice the following crucial point.

>[...] in a scope, each variable can only have one meaning, and that meaning is determined regardless of the order of expressions. The presence of the expression `s = t` in the loop causes s to be local to the loop, which means that it is also local when it appears on the right hand side of `t = s + i`, even though that expression appears first and is evaluated first. One might imagine that the `s` on the first line of the loop could be global while the s on the second line of the loop is local, but that's not possible since the two lines are in the same scope block and each variable can only mean one thing in a given scope.
"""

# ╔═╡ 756539c8-61f5-4e3f-8008-a18dde94e0dd
md"""
## The `let` block

Let's start with reviewing the `begin` block.
"""

# ╔═╡ da7c3418-ec3c-4edd-92d1-7225f58097cc
module beginblock
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

		# But do not introduce a new local scope, indeed `x` is visible here
		@show x
	end
end

# ╔═╡ 59275e3d-7390-4c68-b6d3-53abbf7ff14d
md"""
We've seen that `begin` blocks do not enclose a new local scope, how do you introduce a new one in your code? Looping constructs (eg. `for` and `while`, which will be discussed in another notebook) introduce a new local soft scope, hence might be used for this purpose.
"""

# ╔═╡ b59ec260-b4e1-4739-9634-4f667f68b795
for _ = 1:1
	x = 1
	for _ = 1:1
		x = x + 1
	end
	# We need to print `x` to the standard output since for blocks return nothing.
	@show x
end

# ╔═╡ 6f65ebc5-3930-4d52-b6c1-9cc4b5b885c5
md"""
However, this is obviously cumbersome, and the `let` block exist for that.
"""

# ╔═╡ ea119384-8f68-43b5-959a-a17221251059
let
	x = 1
	let
		x = x + 1
	end
	# Instead, here the `@show` macro is pleonastic.
	@show x
end

# ╔═╡ b00af10a-812a-437e-bcb1-1b3dc85f2b5a
md"""
The `let` block accept comma separated optional arguments, which introduce new bindigs. This is usually unobservable, apart from closures (discussed in track 2).
"""

# ╔═╡ 157ac882-2fe3-4818-83d0-39d829b28c94
let
	x = 1
	# `x` is a local variable defined in the outer local scope, hence is referenced every time the closure is run.
	f = () -> let 
		x = x + 1
		x
	end
	[f() for _ = 1:3], x
end

# ╔═╡ b7cb512a-bef2-4e68-91e5-a990057bb07a
let
	x = 1
	# A new variable binding is introduced each time `f` is evaluated
	f = () -> let x = x + 1
		x
	end
	# Hence `x` does not change its value
	[f() for _ = 1:3], x
end

# ╔═╡ 760dad2d-ea9a-4fa0-bf17-1159f9acedfb
md"""
## Loops and comprehensions

As listed in the table above, looping construct (which will be the subject of the next notebook in track 1), introduce a new soft local scope. However, there is a caveat. Consider the following.
"""

# ╔═╡ a14b2f44-e6ed-44c7-982d-e4c677d6797d
let
	# `i` and `j` are local variables
	i, j = 0, 0
	for i = 1:10
		# Being in an inner local scope, assignment should change their value
		j = i
		i = 42
	end
	# However, `i` does not change. How come?
	i, j
end

# ╔═╡ 4f59f693-9c8c-47c0-b144-36d42052ee59
md"""
The previous statement of looping constructs introducing a new local (soft) scope is referred to their body.

```julia
for x = iterator
	#= for body =#
end
```

Indeed, the name `x` in the previous code listing is bounded to a new object at each loop iteration, and effectively shadows any previous local definition. 

The same is true for comprehensions.
"""

# ╔═╡ 7f78e0f2-bdd1-4f8d-a866-40f8484d511b
let
	fs = [() -> i for i = 1:3]

	fs[1](), fs[2](), fs[3]()
end

# ╔═╡ 76c3771f-a4ec-4d49-9715-049d4c90df50
md"""
However, there are cases where it is useful to assign the values yield by the iterator in the looping construct to an existing local variable. The `outer` keyword exist for that (but only for `for` loops).
"""

# ╔═╡ b96dc659-843a-4df4-b53c-f3c0b9a4cc29
let
	i, j = 0, 0
	for outer i = 1:10
		j = i
		i = 42
	end
	i, j
end

# ╔═╡ edd23354-2973-4995-ba6a-4d15fda97f43
md"""

## Modules and packages

The principal way of organizing code in Julia is via modules. Eventually, modules can be packaged together and distributed. Indeed, there is a list of published packages, the Julia official registry, which is where the Pkg looks by default when one ask to install a package.  

Module are defined using the syntax
```julia
module MyModule
# module body
end
```

It is customary to not indent the code inside a module and to use CamelCase for module names. Modules have the following features:

1. They have separate namespaces, and each of them introduce a new (global) scope. This allows to use the same name for different objects in separate modules.
2. There is specific syntaxt for namespace management.
3. Modules can be precompiled for faster loading.

It is customary to organize the code into multiple files, expecially for large packages. This is done using the `include` function, which is analogous to preprocessor directive found in C/C++ (however, `include` is a regular function). The behavior is the same as if the code in the included file was listed in the current file.

All names in Julia are defined inside a module. To get the name of the parent module, you can use the function `parentmodule`. By prefixing the module name to a name one obtains its _qualified name_. Qualifying a name containing only symbols, like operators `+` and `==`, needs inserting a colon `:`. Since modules can be nested, module names can have a qualified name. In this case the chain of names separated by `.` is called a _module path_.

The `export` keyword in a module introduce a statement which lists the names in the current module that one want to make visible outside. Module namespaces are imported with the keyword `import` or `using`. The former will import into the current namespace only the name of the module, the latter also all the names in the export list. One can specified using `:` which names want to import in the current namespace. This makes the two form almost equivalent. Indeed, if one want to add methods to a function defined in another module, he has to use its fully qualified name or use `import`, but not `using`. Finally, you can rename imported names using `as`, like you would do in Python. 

!!! warning
	You can extend or redefine functions for types that you have not defined. This is usually called _type piracy_ and should be avoided, more on that in track 2.
"""

# ╔═╡ 8e5fd692-8a5a-4b9a-89c7-4b569af4ed63
module MyModuleA
	
export alpha
	
alpha = 1/137

# address will not be exported
address = "1 W 72nd St, New York, NY 10023, United States"
	
end

# ╔═╡ ceb559d1-1156-4064-852d-f61222505ead
md"""
Modules automatically contain `using Core`, `using Base` and definitions of `eval` and `include`. These are two of the standard modules:

* `Core` contains all functionality "built into" the language.
* `Base` contains all basic functionality that is useful in almost all cases.
* `Main` is the top-level module and the current module, when Julia is started.
* Finally, Julia ships with some standard library modules. These behave like regular julia packages, except that they don't have to be installed explicitly.
"""

# ╔═╡ Cell order:
# ╟─572ea734-62bf-11ee-3757-4752db64b2b8
# ╠═f6d768a6-42a4-4502-ad36-709a70032752
# ╠═eb1b8eb9-18e7-4ca1-978c-a6883d9b578a
# ╠═5fe70ca9-1b02-475e-bbc7-873c76fcb262
# ╠═16004b13-0425-420d-88dc-edb30386d370
# ╠═eb35275a-285b-4253-97e1-850b5d9739b4
# ╠═4fac80eb-2e83-49c9-b3ce-ece520027d39
# ╠═eefa4b20-a589-4379-b66c-934aeec512f3
# ╠═30ea2528-dcca-4f37-983e-149714df9ce6
# ╠═f2a24699-2442-4111-a0ec-8e3df55a836a
# ╠═12be6882-3c11-4dca-81d2-4cd8e297654c
# ╠═612851d7-0e77-4cee-9cac-f795613dd926
# ╟─3a5fa678-85fd-4726-9051-36e53fa88b77
# ╠═64ea16be-71c4-4b25-b560-9e0cebc51e87
# ╟─b64c7042-099f-460c-8546-de72106d2112
# ╟─5a0d7143-3f68-41e4-84e9-08c110cc9fcf
# ╟─0db3aa04-356f-42a2-8538-603a7a6452e2
# ╠═e52fc50d-0a61-465c-8d07-2e1982fbbf24
# ╠═5d089849-2515-46a3-be31-d73c80f9badc
# ╠═6974f0e7-a029-4d72-97a8-78c93903571c
# ╠═29592c11-9093-468b-9fce-d78e0cb4ecce
# ╠═2b502881-a145-4575-b9b1-1a950fadb545
# ╠═81420b57-a395-4071-9daf-6526d1509bff
# ╟─386450e8-322f-4ec9-a22a-6d7a756dd5b9
# ╟─756539c8-61f5-4e3f-8008-a18dde94e0dd
# ╠═da7c3418-ec3c-4edd-92d1-7225f58097cc
# ╟─59275e3d-7390-4c68-b6d3-53abbf7ff14d
# ╠═b59ec260-b4e1-4739-9634-4f667f68b795
# ╟─6f65ebc5-3930-4d52-b6c1-9cc4b5b885c5
# ╠═ea119384-8f68-43b5-959a-a17221251059
# ╟─b00af10a-812a-437e-bcb1-1b3dc85f2b5a
# ╠═157ac882-2fe3-4818-83d0-39d829b28c94
# ╠═b7cb512a-bef2-4e68-91e5-a990057bb07a
# ╟─760dad2d-ea9a-4fa0-bf17-1159f9acedfb
# ╠═a14b2f44-e6ed-44c7-982d-e4c677d6797d
# ╟─4f59f693-9c8c-47c0-b144-36d42052ee59
# ╠═7f78e0f2-bdd1-4f8d-a866-40f8484d511b
# ╟─76c3771f-a4ec-4d49-9715-049d4c90df50
# ╠═b96dc659-843a-4df4-b53c-f3c0b9a4cc29
# ╟─edd23354-2973-4995-ba6a-4d15fda97f43
# ╠═8e5fd692-8a5a-4b9a-89c7-4b569af4ed63
# ╟─ceb559d1-1156-4064-852d-f61222505ead
