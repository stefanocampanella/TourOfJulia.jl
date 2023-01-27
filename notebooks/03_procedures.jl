### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 6d0071a2-9f72-4d65-8770-b4e8283bd7c1
using PlutoUI

# ╔═╡ f0ea7b68-80f1-45d4-8c3d-5be293baf539
md"""
# Building abstractions with procedures

When writing computer programs, one defines abstractions involving procedures or data (as in the title of Wirth's book, _Algorithms + Data Structures = Programs_). Although the boundary between the two is blurred, and almost disappear in purely functional programming languages (as Haskell), in most programming languages these two kinds of abstractions are quite distinct, Julia making no exception. 

When writing library code, one usually defines both procedures and data structures (and types). Instead, when writing user code (i.e. a scientist trying to solve a problem), one usually just needs to define procedures. Most of the time, it is sufficient (and strongly recommended[^1]) to glue other peoples code, and procedures are usually enough for that. 

In this first part we'll see how to define procedures, or functions in julian terms.

[^1]: In the words of Douglas Crockford, _"code reuse is the holy grail of software engineering"_.
"""


# ╔═╡ 09efad7a-7eec-42e0-bed2-e7d2d4a8136a
md"""
## Syntax and usage

### Function definition

Function can be defined using the one-line syntax (_assignment form_) or a `function` block. The return value of a function is the value of the last expression of the function body that is evaluated. In block definitions, one can use the `return` keyword, which cause the function to evaluate the expression following the `return`, and exit immediately. This is useful in functions with multiple exit points. If one wants to return `nothing`, he can do it explicitly with `return nothing`, or `return`, or `nothing`. These three forms are equivalent and the choice is a matter of coding style. 

Some coding style practices have been adopted in the writing of the Julia codebase (language and standard library) and are strongly encouraged. One of them, is the exclamation point in the name of functions that modify one or more of their arguments (which is a legacy from Lisp[^1]). If only one arguments is mutated by the function, it is the first, hence `f!(x, y, z)` is expected to modify `x` (surprisingly, in most cases, a well written function needs to modify at most one of its arguments).

Notice that functions in Julia are first class objects, and can be assigned and passed around.

Anonymous functions can be defined using the arrow syntax `(argument_list) -> function_body`.

[^1]: Julia has a strong legacy from Lisp (Scheme, in particular), and the more one dives into the programming language the more it becomes evident. Indeed, part of the implementation (parsing) is in Femtolisp (a scheme-like language) and an interpreter is hidden within each Julia installation (you can  try it with `julia --lisp`). 
"""

# ╔═╡ 76cdb0f0-a8c4-42df-825a-aebaf0fc919d
myma_oneline(α, x, y) = α * x + y

# ╔═╡ 9c0a719f-9d3d-4621-81e6-d46563c2f072
function myma_block(α, x, y)
	return α * x + y
end

# ╔═╡ e3b49739-49e8-4267-877c-247abcd9ecfb
@code_typed myma_block(1., 1., 1.)

# ╔═╡ c58c11b4-2f3d-4d60-9e4b-82064b6f98d5
@code_typed myma_oneline(1., 1., 1.)

# ╔═╡ ae4565a1-8981-4c49-99e7-1f56b7284dd6
# Here we use argument destructuring (pattern matching), we'll talk about it later
comparema(f, g, (α, x, y)) = f(α, x, y) == g(α, x, y)

# ╔═╡ fbf788cc-dd64-460d-9a80-d2a1832d6337
comparema(myma_oneline, myma_block, (1, 2, 3))

# ╔═╡ 4295c563-d12f-4143-adf5-c8c08fc97e6f
myma_builtin = muladd

# ╔═╡ 8a2754c4-9af3-4181-9f20-1d0c04fb6549
comparema(myma_oneline, myma_builtin, (1, 2, 3))

# ╔═╡ 946c29bf-961f-4d2d-ae45-8b79fb8899a4
comparema(myma_oneline, (α, x, y) -> α * x + y, (1, 2, 3))

# ╔═╡ 99b1c847-56ac-4f5b-81cd-9eeffdbc58db
md"""

### Operators

Infix operators are just functions, with the exception of short-circuit operators (`&&` and `||`), which need special evaluation rules (special forms) since in Julia all arguments (operands) are evaluated before procedure evaluation. Indeed, it is possible to apply them using prefix notation.

The syntax for some operations, such as containers elements access and assignment, is desugared to prefix notation: `A[n] == getindex(A, n)` and `A[n] = x == setindex!(A, x, n)`
"""

# ╔═╡ 00c7faf7-e6c7-475e-a8d8-55a775a8d2f2
+(1, 2), 1 + 2

# ╔═╡ 3b22f6dd-ef9c-4702-8e60-61a022cbf913
md"""

### Argument passing behaviour

In Julia variables are names, within a scope, associated (or _bound_) to objects[^1].

The scope of a variable is the region of code in which that variable is accessible. Outside of it, the same name might refer to another variable or be undefined. This model our intuition about using the same name for different things in different contexts. 

These regions of code (scope blocks) are not arbitrarily defined. Instead, they correspond to syntactic constructs, such as the ones for looping or defining functions. Scoping rules are described in detail in [the documentation](https://docs.julialang.org/en/v1/manual/variables-and-scoping/). For the purpose of this discussion, it will be sufficient to say that a function definition introduce a new scope, in which variables defined in outer scopes (scopes can be nested) will be visible.

In Julia there is neither passing by reference nor by value. In Julia, as in Python, the evaluation strategy is sometime called pass by sharing or pass by object reference.

When a function `f(x, y) = α * x + y` is called with `f(u, v)`, the variables in lexical scoping of the function body which are also arguments of `f` (that is `x` and `y`) will be bound to the same objects bound to variables `u` and `v` in the caller (as if there was an assignment `x, y = u, v` right before the function body). After that, the function is evaluated. If there is an assignment in the function body, local variables will reference a new object, and the information of that outside of the callee is lost. However, in case of mutations, the mutating part of the function definition will operate on the initial object and the change of state will be visible outside. In order to mutate, an object must be an instance of a _mutable_ `DataType`, and the mutating part, somewhere in the call-stack, will call some low-level function acting directly on memory (usually via `setindex!` or `setfield!`).

[^1]: In this sense, Julia (or Python) variables looks like references in C++. However, as we will see, because of automatic memory management, they behave also like smart pointers, and `std::shared_ptr` in particular.
"""

# ╔═╡ be0cd0fb-aed9-42ce-bc01-12351022d79a
typeof(Array{Int, 1})

# ╔═╡ 69e35605-5007-4e5b-8dc0-0a194619678b
function assignment_within_func(x)
	x = Array{Float64}(undef, 10)
	fill!(x, π)
	pointer(x), x
end

# ╔═╡ e171312d-4e27-40b1-9c20-eb40e5ee4384
function mutation_within_func(x)
	fill!(x, π)
	pointer(x), x
end

# ╔═╡ 1c2c41bf-6040-4b40-9b01-e313d71d11a2
x = rand(10)

# ╔═╡ f9081f03-f7b8-4e2d-9f78-e27a02a77f5d
pointer(x)

# ╔═╡ 98d00c40-4e84-4e07-82a0-01675000e178
assignment_within_func(x)

# ╔═╡ db010da8-5f29-45fc-a4c4-5e67df29f297
x

# ╔═╡ d7e23be5-f01e-4a0a-a2c5-09967b4096c0
mutation_within_func(x)

# ╔═╡ 12c80959-e412-4558-815c-0a833e089585
x

# ╔═╡ 3ebb05ef-3db1-4785-873c-6fa4b3c8f26a
md"""

### Optional arguments and keyword arguments

Julia functions can have optional arguments, it is sufficient to provide default values in the definition after the `=` sign. This is syntactic sugar for multiple methods definitions (more on that later), one in terms of the other, as in the following example.
"""

# ╔═╡ 9bc7a3e4-a2c9-4363-88d9-9740d27269e5
f_without_optional(α, x, y) = α * x + y

# ╔═╡ 3995f081-62dc-49ed-9a5d-0e021d896236
f_without_optional(α, x) = f_without_optional(α, x, 0.0)

# ╔═╡ 6723859e-a8ad-4d85-8476-10a62d018c36
f_optional(α, x, y=0.0) = α * x + y

# ╔═╡ 757c6022-816b-40e4-88d3-1de9e3566369
methods(f_optional)

# ╔═╡ 6e7f1c45-9223-4b9f-bbb4-b2a9b16878d6
md"""
Keyword arguments have a similar syntax to optional arguments, the former following the semicolon instead of a colon. However, function definitions with keyword arguments will not define multiple methods.

To ease the syntax, function with keyword parameters can be called without specifying the "keyword", if the variables following the semicolon has the same name (or a field with the same name) the equal sign can be omitted. As shown in the following example.
"""

# ╔═╡ 42dc594d-fb79-4d59-9015-ac26302a9138
f_keyword(α, x; y=0.0) = α * x + y

# ╔═╡ 5aa927ea-2216-42b2-bae9-ed529f178af7
f_keyword(2.0, 1.0; y=2.0) # or f_keyword(2.0, 1.0, y=2.0)

# ╔═╡ 9db44048-e7ae-45b3-9a9f-de67bbb6bd23
let y = 2.0, named_tuple = (; x=1.0, y=2.0)
	f_keyword(2.0, 1.0; y) == f_keyword(2.0, 1.0; named_tuple.y) ==  4.0
end

# ╔═╡ 49f67ab4-6f06-4c01-8bcc-a7a34db4ac38
md"""

### Destructuring, splatting and slurping

In variable assignment or function invocation, tuples and arrays in the RHS can be destructured to pattern match the structure of the LHS, and assign each l-value to the corresponding r-value. In this case, the LHS must be composed of, possibly nested, tuples of symbols. The special symbol `_`, cannot be used as r-value and means that the corresponding value in an assignment can be discarded. The RHS can be composed of nested tuples, arrays, and generators (or whatever container can be iterated over) of objects and literals. 
"""

# ╔═╡ 502425ce-e872-486d-acac-1ff2dcc976e2
# One simple, recurring pattern is to use destructuring to swap variables
let
	a = "Hello"
	b = "World"
	b, a = a, b
	a, b
end

# ╔═╡ 9dc83fbf-be99-495c-a0f6-10ed1ec40498
# More complex destructuring is possible
let
	str = split("Seek & Destroy!")
	n = 3
	_, (_, (_, _, x)) = [n, (13, str)]
	x
end

# ╔═╡ 9b1f8de5-0781-4a3c-83cd-200e1783249e
# unzip using destructuring in function definition
unzip(itr) = map(f -> map(f, itr), [((x, y),) -> x, ((x, y),) -> y])

# ╔═╡ 0b775977-f314-47ed-bf49-7938def8be10
unzip(zip(rand(3), split("Seek & Destroy!")))

# ╔═╡ 7e0e1bbc-b81b-4382-b65d-e056e0829ecc
# Question: Julia will complain about the following input, why?
# https://github.com/JuliaLang/julia/issues/32727
f(_, x=1) = x

# ╔═╡ fc71f0ba-968f-43ef-9ad2-e67589689152
md"""
When doing destructuring, it might be useful to expand or collapse elements: this is called splatting and slurping and shows up often in function definitions. The following examples should explain what these terms mean.
"""

# ╔═╡ 0b18e138-ca0f-4dcc-b01c-43ae01c0aaae
# Splatting
((1, 2)..., 3)

# ╔═╡ 5b458442-8d36-4007-bdae-93ad90e4b30d
# Slurping
let
	head, tail... = 1, 2, 3
	head, tail
end

# ╔═╡ 24b123f4-eb89-4a77-9e3a-d92184d3d1a6
# right fold definition using splatting and slurping
rfold(f, x, xs...) = isempty(xs) ? x : f(x, rfold(f, xs...))

# ╔═╡ ae284bf3-29e9-47e5-8442-b02b341b7bd5
mysum(xs...) = rfold(+, xs...)

# ╔═╡ d745d90f-7053-44d8-9ecd-34bdad9b85d5
# The Julia compiler might be surprising at times, consider the following
@code_typed mysum(1, 2, 3, 4, 5)

# ╔═╡ e020eae5-e884-4b43-b559-d0966d426b4c
md"""
It is also possible to do property destructuring using field names and named tuples. As usual, consult [the documentation](https://docs.julialang.org/en/v1/manual/functions/#Property-destructuring) for more details.
"""

# ╔═╡ 90008619-b02d-4ce1-aef2-2583d7b854b6
# "Property" destructuring and slurping (assignment)
let
	x, y... = (; x=1, a=2, b=3)
	x, y
end

# ╔═╡ 3218fcf5-d951-4a9e-885b-f10f991f8ac1
# Property destructuring (function definition)
foo((; x, y)) = x + y

# ╔═╡ 32688bdc-a2f8-4702-9beb-e5f25a8e07a3
struct A
	x
	y
end

# ╔═╡ bc41ad7b-883f-45de-bf5b-9759471fe380
foo((; x=1, y=2)) == foo(A(1, 2)) == 3

# ╔═╡ 1c7c4966-428f-483c-acea-25b4e7c677fb
# "Property" splatting (function definition)
bar(; kwargs...) = kwargs

# ╔═╡ cf8cdafd-4814-4a18-8b96-29db5a86872f
bar(x=1, y=2)

# ╔═╡ 84d5e04e-f828-42e6-a45e-cebdcd13cd1a
md"""
## Is Julia an OOP language?

Some (if not most) concepts in computer science don't have rigorous definitions, at least when it comes to real systems, and in contrast with mathematics or physics. Object-Oriented Programming (OOP) is one of them. I'll quote verbatim the first few paragraph of "What Is Object-Oriented Programming?" from the chapter 18 of Types and Programming Languages, by Benjamin Pierce.

> Most arguments about "What is the essence of...?" do more to reveal the prejudices of the partecipants than to uncover any objective truth about the topic of discussion. Attempts to define the term "object-oriented" precisely are no exception. Nonetheless, we can identify a few fundamental features that are found in most object-oriented languages and that, in concert, support a distinctive programming style with well-understood advantages and disadvantages.
> 1. **Multiple representations.** Perhaps the most basic characteristic of the object-oriented style is that, when an operation is invoked on an object, the object itself determines what code gets executed. [...] These implementations are called the object's _methods_. Invoking an operation on a object--called _method invocation_ or, more colorfully, sending it a _message_--involves looking up the operation's name at run time in a method table associated with the object, a process called _dynamic dispatch_. [...]
> 2. **Encapsulation.** The internal representation of an object is generally hidden from view outside of the object's definition: only the object's own methods can directly inspect or manipulate its fields. This means that changes to the internal representation of an object can affect only a small, easily identifiable region of the program; this constraint greatly improves the readability and mainteainability of large systems. [...]
> 3. **Subtyping.** The type of an object--its _interface_--is just the set of names and types of its operations. The object's internal representation does _not_ appear in its type, since it does not affect the set of things that we can directly do with the object. Object interfaces fit naturally into the subtype relation. If an object satisfies an interface `I`, then it clearly also satisfies any interfae `J` that lists fewer operations than `I`, since any context that expects a `J`-object can invoke only `J`-operations on it and so providing an `I`-object should always be safe [_Liskov substitution principle_]. [...] The ability to ignore parts of an object's interface allows us to write a single piece of code that manipulates many different sorts of objects in a uniform way, demanding only a certain common set of operations [_generic programming_].
> 4. **Inheritance.** Objects that share parts of their interface will also often share some behaviors, and we would like to implement these common behaviors just once. Most object-object oriented languages achieve this reuse of behaviors via structures called _classes_--templates from which objects can be instantiated--and a mechanism of _subclassing_ that allows new classes to be derived from old ones by adding implementations for new methods and, when necessary, selectively overriding impolementations of old methods. [...]
> 5. **Open recursion.** Another handy feature offered by most languages with objects and classes is the ability for one method body to invoke another method of the same object via a special variable called `self` or, in some languages, `this`. The special behavior of `self` is that it is _late-bound_, allowing a method defined in one class to invoke another method that is defined later, in some subclass of the first.

Let's check if Julia meets the requirements to be considered an OOP language one by one.

1. **Multiple representations.** Julia has dynamic dispatch, indeed it has _multiple dispatch_[^1]. This means that if an operation involves multiple objects, the choice of the implementation that is selected is based on all of them, not just one. Methods are defined separately from objects and since a method does not belong to an object, methods names do not belong to the object namespace. Hence, there isn't the equivalent to the `object.method` syntax popular in many OOP languages.
2. **Encapsulation.** Julia does not have private member variables (struct fields) nor member functions (methods).
3. **Subtyping.** As we've seen while discussing types, the Julia type system has been designed expressly for using subtyping in method specialization.
4. **Inheritance.** Julia does not have inheritance, only composition.
5. **Open recursion.** Since methods are defined separately and are specialized on the actual type of objects, there is no need for `self` or `this`.

Therefore, Julia shouldn't be considered an OOP language in the usual sense of the expression. 

[^1]: Julia multiple dispatch is very similar to the one found in CLOS (_multi-methods_, as called by Pierce), another legacy of Lisp.
"""

# ╔═╡ 80768236-9675-11ed-3cfb-c31606f7223e
md"""
## Methods

## Conversions and promotions
"""

# ╔═╡ e6751e0d-2e6f-4324-8d36-3755d50e5a4a
md"""
## Interfaces

### Example: the iterator interface

### Example: pretty printing
"""

# ╔═╡ 74047318-2e47-4829-abff-1301e7fc0caa
md"""

"""

# ╔═╡ cf07a313-9931-473b-8fe4-906b71af387c
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "08cc58b1fbde73292d848136b97991797e6c5429"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

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
version = "1.0.1+0"

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
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
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
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "8175fc2b118a3755113c8e68084dc1a9e63c61ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
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

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─f0ea7b68-80f1-45d4-8c3d-5be293baf539
# ╟─09efad7a-7eec-42e0-bed2-e7d2d4a8136a
# ╠═76cdb0f0-a8c4-42df-825a-aebaf0fc919d
# ╠═9c0a719f-9d3d-4621-81e6-d46563c2f072
# ╠═e3b49739-49e8-4267-877c-247abcd9ecfb
# ╠═c58c11b4-2f3d-4d60-9e4b-82064b6f98d5
# ╠═ae4565a1-8981-4c49-99e7-1f56b7284dd6
# ╠═fbf788cc-dd64-460d-9a80-d2a1832d6337
# ╠═4295c563-d12f-4143-adf5-c8c08fc97e6f
# ╠═8a2754c4-9af3-4181-9f20-1d0c04fb6549
# ╠═946c29bf-961f-4d2d-ae45-8b79fb8899a4
# ╟─99b1c847-56ac-4f5b-81cd-9eeffdbc58db
# ╠═00c7faf7-e6c7-475e-a8d8-55a775a8d2f2
# ╟─3b22f6dd-ef9c-4702-8e60-61a022cbf913
# ╠═be0cd0fb-aed9-42ce-bc01-12351022d79a
# ╠═69e35605-5007-4e5b-8dc0-0a194619678b
# ╠═e171312d-4e27-40b1-9c20-eb40e5ee4384
# ╠═1c2c41bf-6040-4b40-9b01-e313d71d11a2
# ╠═f9081f03-f7b8-4e2d-9f78-e27a02a77f5d
# ╠═98d00c40-4e84-4e07-82a0-01675000e178
# ╠═db010da8-5f29-45fc-a4c4-5e67df29f297
# ╠═d7e23be5-f01e-4a0a-a2c5-09967b4096c0
# ╠═12c80959-e412-4558-815c-0a833e089585
# ╟─3ebb05ef-3db1-4785-873c-6fa4b3c8f26a
# ╠═9bc7a3e4-a2c9-4363-88d9-9740d27269e5
# ╠═3995f081-62dc-49ed-9a5d-0e021d896236
# ╠═6723859e-a8ad-4d85-8476-10a62d018c36
# ╠═757c6022-816b-40e4-88d3-1de9e3566369
# ╟─6e7f1c45-9223-4b9f-bbb4-b2a9b16878d6
# ╠═42dc594d-fb79-4d59-9015-ac26302a9138
# ╠═5aa927ea-2216-42b2-bae9-ed529f178af7
# ╠═9db44048-e7ae-45b3-9a9f-de67bbb6bd23
# ╟─49f67ab4-6f06-4c01-8bcc-a7a34db4ac38
# ╠═502425ce-e872-486d-acac-1ff2dcc976e2
# ╠═9dc83fbf-be99-495c-a0f6-10ed1ec40498
# ╠═9b1f8de5-0781-4a3c-83cd-200e1783249e
# ╠═0b775977-f314-47ed-bf49-7938def8be10
# ╠═7e0e1bbc-b81b-4382-b65d-e056e0829ecc
# ╟─fc71f0ba-968f-43ef-9ad2-e67589689152
# ╠═0b18e138-ca0f-4dcc-b01c-43ae01c0aaae
# ╠═5b458442-8d36-4007-bdae-93ad90e4b30d
# ╠═24b123f4-eb89-4a77-9e3a-d92184d3d1a6
# ╠═ae284bf3-29e9-47e5-8442-b02b341b7bd5
# ╠═d745d90f-7053-44d8-9ecd-34bdad9b85d5
# ╟─e020eae5-e884-4b43-b559-d0966d426b4c
# ╠═90008619-b02d-4ce1-aef2-2583d7b854b6
# ╠═3218fcf5-d951-4a9e-885b-f10f991f8ac1
# ╠═32688bdc-a2f8-4702-9beb-e5f25a8e07a3
# ╠═bc41ad7b-883f-45de-bf5b-9759471fe380
# ╠═1c7c4966-428f-483c-acea-25b4e7c677fb
# ╠═cf8cdafd-4814-4a18-8b96-29db5a86872f
# ╟─84d5e04e-f828-42e6-a45e-cebdcd13cd1a
# ╠═80768236-9675-11ed-3cfb-c31606f7223e
# ╠═e6751e0d-2e6f-4324-8d36-3755d50e5a4a
# ╠═74047318-2e47-4829-abff-1301e7fc0caa
# ╠═6d0071a2-9f72-4d65-8770-b4e8283bd7c1
# ╠═cf07a313-9931-473b-8fe4-906b71af387c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
