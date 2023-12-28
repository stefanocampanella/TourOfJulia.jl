### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 4ccae334-857b-4957-9c58-d2354894148b
using PlutoUI

# ╔═╡ f10d73fa-9676-11ed-0fa8-0dbdd750d8b4
md"""

# Building abstractions with data

Via subtyping Julia types inherit behaviour (via method definitions on abstract types), but not structure. Composite types are a way out to this problem.

"""

# ╔═╡ 0d7b7787-1ae8-45a8-a04d-be5a54ffd43e
md"""
## Immutable structs

Composite types are called structs (C, C++) or records (Haskell), and are a collection of named fields that, once instantiated, can be treated as a single value. In Julia composite types are defined using a `struct` block. Julia provides a default constructor for composite types, which has the same name. Finally, the fields can be accessed using the dot notation.

The trivial composite type has no fields, hence two instances are identical by definition: is a singleton type.
"""

# ╔═╡ e1ea848f-259a-45c4-85c0-b38ef700d601
struct Unit end

# ╔═╡ ceda105f-73e9-4973-bac8-7faa8e63f0ad
Unit()

# ╔═╡ 9fef0755-b5d2-4d31-ad9a-4e7ebc2ffc49
struct MyCompositeType_v1
	x
	y
end

# ╔═╡ 9ffdf326-ab6b-4773-9f72-3ea2da733ea8
obj = MyCompositeType_v1(3, "Hi!")

# ╔═╡ 4fec7d89-8f51-44d4-9de6-ed791f422625
obj.x

# ╔═╡ 9a5d0523-eb97-4411-a6eb-b64a1316b2ad
md"""
The type of the fields can (and, most of the time, should) be specified using the `::` syntax. When omitted, it is equivalent to specify the type `Any`. When the types of fields is specified, Julia creates also a constructor that tries to convert the arguments to the given type.
"""

# ╔═╡ 2736a2f9-f9d0-490a-9424-a467acc7aff5
struct MyCompositeType_v2
	x::Int
	y::String
end

# ╔═╡ ea42271d-e9b6-4f39-8d83-fe26bd3df0a9
MyCompositeType_v2(3.0, "Hi!")

# ╔═╡ cfd050cf-71f8-46c2-adda-96be30bbb42e
md"""

## Mutable structs

These records are immutable (as in Haskell, but not C/C++). Which means that you cannot assign a value to a field after the object has been created. If you want an object with the new value, you have to create a new one. Immutability of objects makes code easier to reason about and may enhance performance, but sometimes is undesired.

Mutable struct can be defined using the `mutable` keyword. Since Julia v1.8 it is possible to annotate single fields of a mutable struct with the keyword `const`, to make them immutable and allow compiler optimizations.
"""

# ╔═╡ a62cdec3-fe42-49cd-9733-dde3c7234a9a
mutable struct MyCompositeType_v3
	x::Int
	y::String
end

# ╔═╡ e4d6f870-455f-4747-af80-838b9da7daf1
mobj = MyCompositeType_v3(3.0, "Hi!")

# ╔═╡ 752f4d32-4e46-458e-9811-93186926632f
mobj.y = "Hello!"

# ╔═╡ b8b3b76c-8b24-4a56-977a-3ca9f2f6ad69
mutable struct MyCompositeType_v4
	const x::Int
	y::String
end

# ╔═╡ acd61e18-c0ed-4e48-8b19-e13deeb09180
mobj2 = MyCompositeType_v4(3.0, "Hi!")

# ╔═╡ 4089293f-f342-4cce-903e-3b2f02e855d0
mobj2.x = 4

# ╔═╡ 3a738e75-ac2d-4949-9033-3e8dca70eeec
md"""
### Note on automatic memory management

Like Python, although using a different strategy, Julia has automatic memory management, which means that allocations and deallocations of memory are not managed by the programmer. This makes possible to avoid several kinds of bugs (memory leaks, dangling pointers, etc.) while maintaining the "illusion of infinite memory", in the words of Abelson and Sussman.

Allocations happens within the default constructor (or in the inner constructor methods), as we'll see. The deallocations is done by the garbage collector. Garbage collection is one of the techniques available for the purpose (another one is reference counting, used by Python), in particular Julia uses the mark and sweep algorithm.

Garbage collection comes with some downsides (and it's the reason why, for example, C++ does not use it), but for normal usage 
"""

# ╔═╡ 96226625-bb1a-4c58-ba14-e27f27b9a78d
md"""

## Constructors

### Default constructors

When a composite type is declared, Julia defines two default constructors: one with arguments of the declared type and one that accept arguments of any type, and tryies to convert them (throwing an error if that isn't possible).

Constructors are just functions, convenience constructors that can be expressed in terms of the default one, can be defined as such.
"""

# ╔═╡ d4bdee63-5580-466f-be76-5ffeddc5d9aa
methods(MyCompositeType_v2)

# ╔═╡ 2df43970-20a8-4936-94fe-38df31eadb83
MyCompositeType_v2("should not be a string", "a string")

# ╔═╡ 1d8fea5b-86d3-41b9-9905-66fbceb241fb
begin
	struct EmbellishedInt
		n::Int
		repr::String
	end

	EmbellishedInt(n) = EmbellishedInt(n, "String representation of $n")
end

# ╔═╡ b18eac39-f75d-4a51-9627-aead7a9bee24
EmbellishedInt(13)

# ╔═╡ 885c3368-c7cb-43a3-a973-9ff495f27b4b
EmbellishedInt(13)

# ╔═╡ 6ee40305-5217-45cf-b106-6eb5b32637d4
# You might want to enforce the usage of the other constructor
EmbellishedInt(13, "String representation of 14")

# ╔═╡ ac81d1bc-af19-4194-9ad2-b5aad9959c2d
md"""

### Parametric constructors

"""

# ╔═╡ 03801f8a-ac77-488a-abba-8f6e0fd573f6
struct Point{T<:Real}
	x::T
    y::T
end

# ╔═╡ 197bb855-93b8-48b8-83f8-bbc273cc7c0c
Point(1,2) ## implicit T ##

# ╔═╡ ae508055-20e5-41c7-818c-7bd31c6bb5e2
Point(1.0,2.5) ## implicit T ##

# ╔═╡ eb26aec5-c098-42e6-899a-87e145bad369
Point(1,2.5) ## implicit T ##

# ╔═╡ e082e8c4-c502-41b0-b485-579a0ee9f672
Point{Int64}(1.0,2.5) ## explicit T ##

# ╔═╡ 075ecd9d-65c3-405e-83f2-66156bf6ae0b
begin
	struct Point_v2{T<:Real}
		x::T
	    y::T
	end

	Point_v2(x::Real, y::Real) = Point_v2(promote(x,y)...)
end

# ╔═╡ 8cde7fca-b5bb-4f2c-ad7d-447f7c063ebf
Point_v2(1, 2.5)

# ╔═╡ 515db4c8-fb26-4b64-a22d-954ebf24bc21
md"""

### Internal constructors

The previous discussion leaves out the problem of un-initialized objects. Since, up to this point, every constructor is expressed in terms of the defaul one, which requires a value for every field of the struct. To overcome this problem, Julia uses "internal constructors", which are useful also to enforce preconditions on constructor arguments.

Julia internal constructor works by exposing the `new` variadic function, which creates a new object, possibly partially un-initialized (if not all arguments were passed). Also, internal constructors override default constructors, hence they might be useful to disallow their usage.
"""

# ╔═╡ e3b0b38b-797d-4f74-bc3a-182158bdcf5c
struct List{T}
	value::T
	next::Union{Nothing, List{T}}
	List(x) = new{typeof(x)}(x)
end

# ╔═╡ 8d0a913d-365b-4695-b67e-25efd6b8c977
begin
	struct OrderedPair{T}
		first::T
		second::T
		OrderedPair(a::T, b::T) where T = a < b ? new{T}(a, b) : new{T}(b, a)
	end

	OrderedPair(a, b) = OrderedPair(promote(a, b)...)
end

# ╔═╡ 08469e55-5462-4037-97b4-91e74751d64d
OrderedPair(2, 1.)

# ╔═╡ 6cf5cd93-6772-49b5-a38f-52dd55f5660b
struct EmbellishedInt_v2
	n::Int
	repr::String

	EmbellishedInt_v2(n) = new(n, "String representation of $n")
end

# ╔═╡ 1b53989c-97be-419a-b08f-b11d143762f8
EmbellishedInt_v2(13, "String representation of 14")

# ╔═╡ 13b3e900-21ae-4b02-93cb-54f0c586b024
md"""
## Default data structures

Several data structures are readily available in Julia. The underlying types (abstract or concrete) have different interfaces, for example, you can use the same `Vector` as an array or a deque. Here I list some of them, without differentiating between abstract types and concrete types.

* Arrays (see notebook on multidimensional arrays)
* Dicts ([`Dict`](https://docs.julialang.org/en/v1/base/collections/#Base.Dict), [`IdDict`](https://docs.julialang.org/en/v1/base/collections/#Base.IdDict), [`WeakKeyDict`](https://docs.julialang.org/en/v1/base/collections/#Base.WeakKeyDict), [`ImmutableDict`](https://docs.julialang.org/en/v1/base/collections/#Base.ImmutableDict), [EnvDict](https://docs.julialang.org/en/v1/base/base/#Base.EnvDict))
* Tuples ([`Tuple`](https://docs.julialang.org/en/v1/base/base/#Core.Tuple), [`NTuple`](https://docs.julialang.org/en/v1/base/base/#Core.NTuple), [`Vararg`](https://docs.julialang.org/en/v1/base/base/#Core.Vararg), [`Pair`](https://docs.julialang.org/en/v1/base/collections/#Core.Pair), [`NamedTuples`](https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple))
* Sets ([`Set`](https://docs.julialang.org/en/v1/base/collections/#Base.Set), [`BitSet`](https://docs.julialang.org/en/v1/base/collections/#Base.BitSet))
"""

# ╔═╡ 4282a40a-e833-4eb3-b208-64fc99236060
d = Dict("one" => 1, "two" => 2)

# ╔═╡ 5e15857a-9be7-46dc-a6da-dcb474b311d1
collect(keys(d)), collect(values(d))

# ╔═╡ 54ee6d73-aff2-4b92-afdc-8b5db533d499
md"""

## Metaprogramming: programs as data

Julia is a homoiconic language: it represents its own code as a data structure of the language itself. This is the strongest legacy of Lisp and enable powerful code transformations, generations and introspection. With respect to C and C++, which just do textual manipulation, in Julia the code is parsed and stored as a data structure representing its abstract syntax tree. This is why we're discussing it here.

### Expressions, quoting, and interpolation

The main data structure for code representation is an expression, and correspond to the `Expr` type. An object of this type will have a head, which is a `Symbol` (an interned string), and a `Vector{Any}` of zero or more arguments, which may be symbols, other expressions, or literal values. You can construct expressions using the `Expr` constructor or you can parse Julia code using the `Meta.parse` function. You can also use the function `Meta.show_sexpr`, which will format an expression as an S-expression, if you are familiar with them from Lisp.

The double colon symbol `:` is used to declare a `Symbol` (if it's a valid identifier) or to _quote_ some expression, that is prevent Julia from evaluating it and instead parse it and return an object. More complex expressions and chains of expressions can be quoted using the `quote ... end` block. The resulting expression will contain information about the file and line containing the code that has been parsed.

!!! note
	A `Symbol` can be whathever string. However, if it has a non-valid identifier, it has to be built using the `Symbol(...)` constructor. Notice that this will return a `Symbol` object: you can't use it, for example, in an assignment. You can use it to construct an expression which contains an assignment, and then evaluate that expression.
"""

# ╔═╡ 4a188514-97f6-4f25-bafc-f0517d1d32ef
Meta.@dump 1 + 2

# ╔═╡ dd7a8bd7-055d-4574-9baf-30c5a191d1a7
Meta.parse("1 + 2") == Meta.parse("+(1, 2)") == :(1 + 2) == Expr(:call, :+, 1, 2)

# ╔═╡ ae26ca38-6d4b-43d0-822f-8c948e163ce3
Symbol("This is a symbol with spaces")

# ╔═╡ 05505b87-fe4a-4420-a76c-2f9ab828673e
Meta.show_sexpr(:(x = 1))

# ╔═╡ 8219e408-cfaa-4236-a80d-aed158772115
e =	quote
		x = 1
		y = 1
		x + y
	end

# ╔═╡ 4e45777d-539b-4b88-9416-ddf12b2bf7da
dump(e)

# ╔═╡ ef7704a0-64d8-429d-a7a3-4c84b650afd9
md"""
As with string, you can interpolate expressions using `$`. This means that Julia will evaluate the expression following the dollar sign and insert that in the un-evaluated quoted outer expression. Quotes can be nested and so interpolations, in this case multiple `$` will interpolate more internal levels.

Finally, expressions can be evaluated via the `eval` function.
"""

# ╔═╡ faab6a10-6bb7-45ec-b529-42b018141d53
str = "Seek & Destroy!"

# ╔═╡ f59f04f6-c9d2-4d93-a0d1-c019f14a83ec
quote
	println($str)
end

# ╔═╡ 47b9b45c-e7ba-4fe8-a504-6019d19ee166
quote quote println($$str) end end

# ╔═╡ 632b3f75-7b08-40ba-a2e6-9d82f65b3741
eval(eval(quote quote println($$str) end end))

# ╔═╡ c61a7dff-67c5-48dd-9316-f0f91b12ea31
# Using these ingredients it is possible to generate code programmatically and avoid 
# repetitions (which means more chances of errors and code to mantain).
for (name, op) in [("add", :+), ("subtract", :-)]
	eval(
		quote
			function $(Symbol("my", name))(a, b)
				$(op)(a, b)
			end
		end)
end

# ╔═╡ 360ee01e-fd15-4021-bdf7-f6a629b391e8
myadd(1, 2), mysubtract(1, 2)

# ╔═╡ d62b0f00-f30a-463d-bcbc-c2037b73c708
#Indeed, this is a pattern so common that the `@eval` macro can be used 
# to avoid quoting and evaluating
for (name, op) in [("multiply", :*), ("divide", :/)]
	@eval function $(Symbol("my", name))(a, b)
		$(op)(a, b)
	end
	
end

# ╔═╡ 1855a9ec-4378-44b1-ba1f-d63126affdb6
mymultiply(1, 2), mydivide(1, 2)

# ╔═╡ 62ca9ea4-7042-4ea1-94b7-bbcfe939cc95
md"""
### Macros

Macros are a way to generate code at parse time. They map the arguments to a returned expression which then is compiled directly rather than requiring a runtime `eval` call. Consider the comparison between the following macro and function.
"""

# ╔═╡ fbd19e98-be70-481f-a9b7-83834b0b7b38
function twostep(arg)
	println("I execute at run time. The argument is ", arg)
	eval(:(println("I execute at runtime. The argument is ", $arg)))
end

# ╔═╡ 6f87cf11-eb29-475c-b41f-28bc346f3306
twostep((1, 2, 3))

# ╔═╡ 0598395e-48ad-4277-9f63-dd2492d81d99
macro twostep(arg)
	println("I execute at parse time. The argument is ", arg)
	return :(println("I execute at runtime. The argument is ", $arg))
end

# ╔═╡ 93154251-99a9-4828-a023-49a049b75019
@twostep (1, 2, 3)

# ╔═╡ 986fdbd6-2d77-41fd-a66f-1650c7914181
md"""
The two appear to be the same. Their behavior is different when we just parse the code. Which is more apparent when the `macroexpand(Context, Expression)` or the `@macroexpand` macro is used.
"""

# ╔═╡ 7a000c30-0447-4de3-a4a5-59071ffce7fb
ex_f = @macroexpand twostep((1, 2, 3))

# ╔═╡ b355e425-6c44-4e4e-9de5-d99106c25286
ex_m = @macroexpand @twostep (1, 2, 3)

# ╔═╡ 0d6255e3-1424-411c-ad4f-353be964469a
eval(ex_f)

# ╔═╡ f021a15d-f0ab-4c47-a38c-a8aeb1c7fa7e
eval(ex_m)

# ╔═╡ f0e9dbfc-1e22-48b1-aa87-64542a87537d
# A simplified version of the @assert macro makes 
# a good example of how macros work
macro myassert(ex)
	return :( $ex ? nothing : println($(string(ex)), " is false!") )
end

# ╔═╡ 7e3cda18-a6d9-479b-8dfd-6a95bd68598f
@myassert 1 == 2

# ╔═╡ 4a68ec6c-5838-4bc4-b9e6-e0b047854c05
md"""
### Generated functions

_Metaprogramming and generated functions are a tough topic, I am late on the preparation of these notebooks and a bit tired. I'll quote verbatim the manual without all the bells and whistles._

A very special macro is `@generated`, which allows you to define so-called generated functions. These have the capability to generate specialized code depending on the types of their arguments with more flexibility and/or less code than what can be achieved with multiple dispatch. While macros work with expressions at parse time and cannot access the types of their inputs, a generated function gets expanded at a time when the types of the arguments are known, but the function is not yet compiled.

Instead of performing some calculation or action, a generated function declaration returns a quoted expression which then forms the body for the method corresponding to the types of the arguments. When a generated function is called, the expression it returns is compiled and then run. To make this efficient, the result is usually cached. And to make this inferable, only a limited subset of the language is usable. Thus, generated functions provide a flexible way to move work from run time to compile time, at the expense of greater restrictions on allowed constructs.

When defining generated functions, there are five main differences to ordinary functions:

1. You annotate the function declaration with the `@generated` macro. This adds some information to the AST that lets the compiler know that this is a generated function.
2. In the body of the generated function you only have access to the types of the arguments – not their values.
3. Instead of calculating something or performing some action, you return a quoted expression which, when evaluated, does what you want.
4. Generated functions are only permitted to call functions that were defined before the definition of the generated function. (Failure to follow this may result in getting MethodErrors referring to functions from a future world-age.)
5. Generated functions must not mutate or observe any non-constant global state (including, for example, IO, locks, non-local dictionaries, or using hasmethod). This means they can only read global constants, and cannot have any side effects. In other words, they must be completely pure. Due to an implementation limitation, this also means that they currently cannot define a closure or generator.
"""

# ╔═╡ 3e9c6041-6dd4-4f8c-83b7-6dd0ea01aeb6
@generated function foo(x)
	Core.println(x)
    return :(x * x * x)
end

# ╔═╡ e95601f6-139b-42e3-a182-aec0abe4a8e9
foo("Oh! ")

# ╔═╡ 6c05e7f6-373f-4eb7-a88b-608a3c34448e
foo("Exterminate! ")

# ╔═╡ 97c1a800-9e54-4af1-bd0f-34d8f502772f
foo(3)

# ╔═╡ ba0d8418-41fe-4851-b00c-b34c8b09b843
foo(2)

# ╔═╡ 09699783-a094-49ea-9f28-50c65c1e0259
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
# ╠═b18eac39-f75d-4a51-9627-aead7a9bee24
# ╟─f10d73fa-9676-11ed-0fa8-0dbdd750d8b4
# ╟─0d7b7787-1ae8-45a8-a04d-be5a54ffd43e
# ╠═e1ea848f-259a-45c4-85c0-b38ef700d601
# ╠═ceda105f-73e9-4973-bac8-7faa8e63f0ad
# ╠═9fef0755-b5d2-4d31-ad9a-4e7ebc2ffc49
# ╠═9ffdf326-ab6b-4773-9f72-3ea2da733ea8
# ╠═4fec7d89-8f51-44d4-9de6-ed791f422625
# ╟─9a5d0523-eb97-4411-a6eb-b64a1316b2ad
# ╠═2736a2f9-f9d0-490a-9424-a467acc7aff5
# ╠═ea42271d-e9b6-4f39-8d83-fe26bd3df0a9
# ╟─cfd050cf-71f8-46c2-adda-96be30bbb42e
# ╠═a62cdec3-fe42-49cd-9733-dde3c7234a9a
# ╠═e4d6f870-455f-4747-af80-838b9da7daf1
# ╠═752f4d32-4e46-458e-9811-93186926632f
# ╠═b8b3b76c-8b24-4a56-977a-3ca9f2f6ad69
# ╠═acd61e18-c0ed-4e48-8b19-e13deeb09180
# ╠═4089293f-f342-4cce-903e-3b2f02e855d0
# ╟─3a738e75-ac2d-4949-9033-3e8dca70eeec
# ╟─96226625-bb1a-4c58-ba14-e27f27b9a78d
# ╠═d4bdee63-5580-466f-be76-5ffeddc5d9aa
# ╠═2df43970-20a8-4936-94fe-38df31eadb83
# ╠═1d8fea5b-86d3-41b9-9905-66fbceb241fb
# ╠═885c3368-c7cb-43a3-a973-9ff495f27b4b
# ╠═6ee40305-5217-45cf-b106-6eb5b32637d4
# ╟─ac81d1bc-af19-4194-9ad2-b5aad9959c2d
# ╠═03801f8a-ac77-488a-abba-8f6e0fd573f6
# ╠═197bb855-93b8-48b8-83f8-bbc273cc7c0c
# ╠═ae508055-20e5-41c7-818c-7bd31c6bb5e2
# ╠═eb26aec5-c098-42e6-899a-87e145bad369
# ╠═e082e8c4-c502-41b0-b485-579a0ee9f672
# ╠═075ecd9d-65c3-405e-83f2-66156bf6ae0b
# ╠═8cde7fca-b5bb-4f2c-ad7d-447f7c063ebf
# ╟─515db4c8-fb26-4b64-a22d-954ebf24bc21
# ╠═e3b0b38b-797d-4f74-bc3a-182158bdcf5c
# ╠═8d0a913d-365b-4695-b67e-25efd6b8c977
# ╠═08469e55-5462-4037-97b4-91e74751d64d
# ╠═6cf5cd93-6772-49b5-a38f-52dd55f5660b
# ╠═1b53989c-97be-419a-b08f-b11d143762f8
# ╟─13b3e900-21ae-4b02-93cb-54f0c586b024
# ╠═4282a40a-e833-4eb3-b208-64fc99236060
# ╠═5e15857a-9be7-46dc-a6da-dcb474b311d1
# ╟─54ee6d73-aff2-4b92-afdc-8b5db533d499
# ╠═4a188514-97f6-4f25-bafc-f0517d1d32ef
# ╠═dd7a8bd7-055d-4574-9baf-30c5a191d1a7
# ╠═ae26ca38-6d4b-43d0-822f-8c948e163ce3
# ╠═05505b87-fe4a-4420-a76c-2f9ab828673e
# ╠═8219e408-cfaa-4236-a80d-aed158772115
# ╠═4e45777d-539b-4b88-9416-ddf12b2bf7da
# ╟─ef7704a0-64d8-429d-a7a3-4c84b650afd9
# ╠═faab6a10-6bb7-45ec-b529-42b018141d53
# ╠═f59f04f6-c9d2-4d93-a0d1-c019f14a83ec
# ╠═47b9b45c-e7ba-4fe8-a504-6019d19ee166
# ╠═632b3f75-7b08-40ba-a2e6-9d82f65b3741
# ╠═c61a7dff-67c5-48dd-9316-f0f91b12ea31
# ╠═360ee01e-fd15-4021-bdf7-f6a629b391e8
# ╠═d62b0f00-f30a-463d-bcbc-c2037b73c708
# ╠═1855a9ec-4378-44b1-ba1f-d63126affdb6
# ╟─62ca9ea4-7042-4ea1-94b7-bbcfe939cc95
# ╠═fbd19e98-be70-481f-a9b7-83834b0b7b38
# ╠═6f87cf11-eb29-475c-b41f-28bc346f3306
# ╠═0598395e-48ad-4277-9f63-dd2492d81d99
# ╠═93154251-99a9-4828-a023-49a049b75019
# ╟─986fdbd6-2d77-41fd-a66f-1650c7914181
# ╠═7a000c30-0447-4de3-a4a5-59071ffce7fb
# ╠═b355e425-6c44-4e4e-9de5-d99106c25286
# ╠═0d6255e3-1424-411c-ad4f-353be964469a
# ╠═f021a15d-f0ab-4c47-a38c-a8aeb1c7fa7e
# ╠═f0e9dbfc-1e22-48b1-aa87-64542a87537d
# ╠═7e3cda18-a6d9-479b-8dfd-6a95bd68598f
# ╟─4a68ec6c-5838-4bc4-b9e6-e0b047854c05
# ╠═3e9c6041-6dd4-4f8c-83b7-6dd0ea01aeb6
# ╠═e95601f6-139b-42e3-a182-aec0abe4a8e9
# ╠═6c05e7f6-373f-4eb7-a88b-608a3c34448e
# ╠═97c1a800-9e54-4af1-bd0f-34d8f502772f
# ╠═ba0d8418-41fe-4851-b00c-b34c8b09b843
# ╟─4ccae334-857b-4957-9c58-d2354894148b
# ╟─09699783-a094-49ea-9f28-50c65c1e0259
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
