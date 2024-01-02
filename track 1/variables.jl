### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 03f94632-0629-4ff6-b18f-60d5fd6e49e2
using PlutoUI

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

# ╔═╡ 00e00121-70b9-434e-ab2b-2afc5b3a596f
md"""
!!! exercise
	The following cell evaluates a random polinomial 
	```math
	P(x) = c_1 + c_2 x + c_3 x^2 + c_4 x^3
	```
	in ``x = -0.1``. Rewrite the same expression using the [Horner's method](https://en.wikipedia.org/wiki/Horner%27s_method) and check that the results are the same.

!!! hint
	You can write a more readable expression by using the implied multiplication. 
"""

# ╔═╡ 570395c2-f5b8-45cf-a5e7-b0415049f4a3
let
	cs = rand(4)
	cs[1] + cs[2] * (-0.1) + cs[3] * (-0.1)^2 + cs[4] * (-0.1)^3
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
module Example

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
module GlobalScope

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

# ╔═╡ 5212de4f-c337-4ba6-80a8-dc37bc5b514f
md"""
!!! exercise

	Evaluate the following code snippet in a file and in the REPL and explain the results.

	```julia
	s = 0
    for i = 1:10
    	t = s + i
        s = t
    end
    s, @isdefined(t)
	```
"""

# ╔═╡ 386450e8-322f-4ec9-a22a-6d7a756dd5b9
md"""

!!! hint
	The previous example has been taken verbatim from the manual. Notice the following crucial point.
	
	>[...] in a scope, each variable can only have one meaning, and that meaning is determined regardless of the order of expressions. The presence of the expression `s = t` in the loop causes s to be local to the loop, which means that it is also local when it appears on the right hand side of `t = s + i`, even though that expression appears first and is evaluated first. One might imagine that the `s` on the first line of the loop could be global while the s on the second line of the loop is local, but that's not possible since the two lines are in the same scope block and each variable can only mean one thing in a given scope.
"""

# ╔═╡ 387521a3-f7c1-48b6-8c90-fcd89a23f146
md"""

## Constants and typed globals

Variables can be declared as constants using the `constant` keyword in the global scope on globals. Redifining a constant is, in some cases allowed, but it is discouraged and might result in undefined behaviour.
"""

# ╔═╡ 7b26a226-87ed-49e1-9143-a7fc1c196157
module RedifiningConstantsNoop

const x = 1.0

x = 1.0

end

# ╔═╡ 4f993364-6306-4dd4-a8f6-fdf8adfa12d1
module RedefiningConstantsWarning

const x = 1.0

x = 2.0

end

# ╔═╡ 15fee563-3574-45f9-9f67-541926586ec8
module RedefiningConstantsErroring

const x = 1.0

x = 2

end

# ╔═╡ 01081ece-fb98-44cd-ab99-c3ad65ef860b
md"""
Since Julia 1.8, the type of global variables can be specified, allowing compiler optimizations.
"""

# ╔═╡ 95ef309c-8fb5-4e6a-9cef-1c6f5f8d6112
module TypedGlobals

e::Float64 = 2.718
x = 42

f() = e
theanswer() = x

@show Base.return_types(f), Base.return_types(theanswer)
end

# ╔═╡ 8e6d8cdd-495a-47d3-bee2-e0936cf560b4
md"""
!!! exercise
	Retype the code within the `RedefiningConstantsUndefinedBehaviour` module in your REPL and inspect the emitted code and intermediate representations for `p` using the `@code_lowered`, `@code_llvm` and `@code_native` macros. What can you deduce from the results?
"""

# ╔═╡ 12775ef5-bf7d-48d7-b397-ef7f2328635f
module RedefiningConstantsUndefinedBehaviour

const x = 1
p() = isodd(x) ? 42 : 24

@show p()

x = 2

@show p()

end

# ╔═╡ 756539c8-61f5-4e3f-8008-a18dde94e0dd
md"""
## The `let` block

Let's start with reviewing the `begin` block.
"""

# ╔═╡ da7c3418-ec3c-4edd-92d1-7225f58097cc
module BeginBlock
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

# ╔═╡ 4a2a9a03-c10a-44b4-9fd4-35c117075707
md"""
!!! exercise
	The Collatz sequence, given ``a_0`` has the following recursive definition

	```math
	a_{n + 1} = 
	\begin{cases}
		a_n / 2 & a_n = 0 \mod 2 \\
		3 a_n + 1 & \text{otherwise}
	\end{cases}
	```

	An algorithm to count the elements of the Collatz sequences starting at ``a_0 = 1, 2, \cdots`` has been implemented in the next cell. It should stop when the length of the sequence exceeds 100, and print the associated `a_0`. 

	The innermost `let` contains a bug. Fix it!
"""

# ╔═╡ 1781168b-da7c-43cd-a7d8-b192c08e93b7
let
	n = 1
	counter = 1

	while true
		let # Fix me!
			while n != 1
				if isodd(n)
					n = 3n + 1
				else
					n = n ÷ 2
				end
				counter += 1
			end
			if counter > 100
				break
			end
		end
		n += 1
	end
	n
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

# ╔═╡ 920dd279-43c5-4099-9713-f6d2a5aeb503
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "3c61004d0ad425a97856dfe604920e9ff261614a"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
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
# ╟─00e00121-70b9-434e-ab2b-2afc5b3a596f
# ╠═570395c2-f5b8-45cf-a5e7-b0415049f4a3
# ╟─3a5fa678-85fd-4726-9051-36e53fa88b77
# ╠═64ea16be-71c4-4b25-b560-9e0cebc51e87
# ╟─b64c7042-099f-460c-8546-de72106d2112
# ╟─5a0d7143-3f68-41e4-84e9-08c110cc9fcf
# ╟─0db3aa04-356f-42a2-8538-603a7a6452e2
# ╠═e52fc50d-0a61-465c-8d07-2e1982fbbf24
# ╠═5d089849-2515-46a3-be31-d73c80f9badc
# ╠═6974f0e7-a029-4d72-97a8-78c93903571c
# ╠═29592c11-9093-468b-9fce-d78e0cb4ecce
# ╟─5212de4f-c337-4ba6-80a8-dc37bc5b514f
# ╟─386450e8-322f-4ec9-a22a-6d7a756dd5b9
# ╟─387521a3-f7c1-48b6-8c90-fcd89a23f146
# ╠═7b26a226-87ed-49e1-9143-a7fc1c196157
# ╠═4f993364-6306-4dd4-a8f6-fdf8adfa12d1
# ╠═15fee563-3574-45f9-9f67-541926586ec8
# ╟─01081ece-fb98-44cd-ab99-c3ad65ef860b
# ╠═95ef309c-8fb5-4e6a-9cef-1c6f5f8d6112
# ╟─8e6d8cdd-495a-47d3-bee2-e0936cf560b4
# ╠═12775ef5-bf7d-48d7-b397-ef7f2328635f
# ╟─756539c8-61f5-4e3f-8008-a18dde94e0dd
# ╠═da7c3418-ec3c-4edd-92d1-7225f58097cc
# ╟─59275e3d-7390-4c68-b6d3-53abbf7ff14d
# ╠═b59ec260-b4e1-4739-9634-4f667f68b795
# ╟─6f65ebc5-3930-4d52-b6c1-9cc4b5b885c5
# ╠═ea119384-8f68-43b5-959a-a17221251059
# ╟─b00af10a-812a-437e-bcb1-1b3dc85f2b5a
# ╠═157ac882-2fe3-4818-83d0-39d829b28c94
# ╠═b7cb512a-bef2-4e68-91e5-a990057bb07a
# ╟─4a2a9a03-c10a-44b4-9fd4-35c117075707
# ╠═1781168b-da7c-43cd-a7d8-b192c08e93b7
# ╟─760dad2d-ea9a-4fa0-bf17-1159f9acedfb
# ╠═a14b2f44-e6ed-44c7-982d-e4c677d6797d
# ╟─4f59f693-9c8c-47c0-b144-36d42052ee59
# ╠═7f78e0f2-bdd1-4f8d-a866-40f8484d511b
# ╟─76c3771f-a4ec-4d49-9715-049d4c90df50
# ╠═b96dc659-843a-4df4-b53c-f3c0b9a4cc29
# ╟─edd23354-2973-4995-ba6a-4d15fda97f43
# ╠═8e5fd692-8a5a-4b9a-89c7-4b569af4ed63
# ╟─ceb559d1-1156-4064-852d-f61222505ead
# ╟─03f94632-0629-4ff6-b18f-60d5fd6e49e2
# ╟─920dd279-43c5-4099-9713-f6d2a5aeb503
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
