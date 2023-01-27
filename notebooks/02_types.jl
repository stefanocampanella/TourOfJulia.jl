### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ f2ce55d8-64da-11ed-3294-3b3ff9b2b364
using BenchmarkTools

# ╔═╡ 69058b15-d1ea-4b6b-84df-0c9250379e6f
using PlutoUI

# ╔═╡ 497dacf1-fc19-484f-800b-64bc1497820a
md""" # The Julia Type System

It is possible to write simple Julia programs while being unaware of the type system in the language. These Julia programs would look very similar to the ones that unexperienced programmers would write in Python or Matlab. However, to write more complex or general programs, to debug them and to ensure good performance, it is necessary to have some understanding of the Julia type system. Fortunately, a description of the type system sufficient for the purposes of this document can be given in few notions. The interested reader can find the details in the Julia [documentation](https://docs.julialang.org/en/v1/) (which is well written, extensive and clear).

"""


# ╔═╡ e19cfce3-e223-4f10-a8b4-d090098dc0e1
md"""

According to Pierce, _"a type system is a syntactic method for automatically checking the absence of certain erroneous behaviors by classifying program phrases according to the kinds of values they compute"_. Without being too formal, I will call program phrases (like `y` or `1 + 1` or `sort(xs)`) expressions or combinations. In order to evaluate an expression, Julia must know its type, which is inferred at runtime from the type of the parts of which it is composed. This is called dynamic typing, as opposed to static typing. In Julia the concept of "static type" does not exist. 

In Julia, you have the primitive types you are familiar with from other programming languages (ex. numerical types). You can ask Julia about the type of literals and objects using the function `typeof`. If you ask for the type of an expressions in the REPL or in Pluto, it is evaluated and the result assigned to a temporary object. Notice that it is customary to name types using camel case, as with classes in Python or C++ (at least, according to most common style guides).
"""


# ╔═╡ 2c1cf2cf-306a-45d9-a1d2-ac393f276e40
typeof(1.0)

# ╔═╡ 5717f990-c6e8-4734-9984-8edfd9c583e2
typeof(1f0)

# ╔═╡ ef1161d0-8a28-4a91-992e-7b7c3b714e96
typeof(0x1)

# ╔═╡ bb5e8508-393f-4722-b790-57984756fba9
typeof('a')

# ╔═╡ d89a0b74-c934-4da7-8be3-97be1dbc8c6b
typeof("A string")

# ╔═╡ 90cf2d0e-f64d-4dcb-9fc9-50bf901fec17
x = 1

# ╔═╡ badcb581-821f-49dc-bafa-7274202760cb
typeof(x)

# ╔═╡ 8f130b81-7dd3-4c33-aee8-54970bb5d667
# Julia does not have function types in the categorical sense,
# however each function has a singleton type which is a subtype of Function
# (more on that later)
typeof(typeof)

# ╔═╡ f7f2503b-a415-4c82-9afe-13ba3bf7e966
md"""You can also annotate the type of a literal or an object using `::`. Quoting from the manual ''Adding annotations serves three primary purposes: to take advantage of Julia's powerful multiple-dispatch mechanism, to improve human readability, and to catch programmer errors.''"""

# ╔═╡ 7dc1b2ef-dbb3-4ecb-b7c0-60d9c7184530
1.0::Float64

# ╔═╡ 6a67fecb-e92f-4e2f-8c57-f0d131481422
md"""If you annotate a variable on the left hand side of an assignment, that annotation will work as the type declarations of statically typed languages. Type declarations are valid in the whole scope of the variable and the right hand side of assignments will be converted to the right type, if possible."""

# ╔═╡ 6bcd9def-1fda-4ff2-bc40-3f8c70d36370
let
	y::Float64 = 2
	y
end

# ╔═╡ 0cab47f9-cf8b-49be-9a66-89af9a03ebd6
examplestring :: String = 2

# ╔═╡ 8e2028a7-15b6-44ab-93b9-c91dd691d05e
md"""
## Subtyping

In Julia, types form a tree. The root of the tree is called `Any` and all the types `A` descendant of a type `B` (i.e. the children of `B`, their children, and so on) is said to be a subtype of the latter: `A <: B`. 

Moreover a type is a subtype of itself, thus the subtype relation forms a preorder category, with `Any` (also called top) as its initial object. There is also a final object which is `Union{}` or bottom, which is a subtype of every type.

"""

# ╔═╡ 0b83a591-ff64-44df-b096-775471c9429b
Union{} <: Int <: Integer <: Number <: Any

# ╔═╡ 8240e88c-4044-430c-852a-548e7af7f6f4
md"""
The nodes in this tree that cannot be instantiated are called abstract types, while the others concrete types. Every object in Julia must have a concrete type, not an abstract one. All concrete types are final (leaves in the tree). The subtype relation together with dispatch model inheritance of behaviour (but not of structure).

Abstract types are defined using the `abstract` keyword. The supertype of a type must be indicated during declaration, if omitted that type will be a subtype of `Any`. 
"""

# ╔═╡ 53f48d6c-2b77-4f2f-a0ff-d742ad73252e
abstract type Animal end

# ╔═╡ 954ebe2f-9145-4bb2-b6bf-5fc24f5eedfd
abstract type Mammal <: Animal end

# ╔═╡ 19627c7d-65ec-4bee-a485-5d361c31b417
# struct is used to define immutable concrete types (in this case a singleton),
# more on that later on
struct Human <: Mammal end

# ╔═╡ 17ea0a23-ba36-4aba-bb5f-7e6f546d9631
Human <: Mammal <: Animal

# ╔═╡ a5a8b7d3-e0f8-4cf0-b053-a897581847fb
Human() isa Animal

# ╔═╡ 57a28269-0128-469c-8e03-3dd69a4a8432
md"""When defining a function, the programmer can indicate the type (abstract or concrete) of the arguments. Being polymorphic, there can be several definitions of the same function with different number or types of arguments. When that function is called, the Julia compiler select the most specific implementation: the one where the types of the arguments in the definition are more closely related to the actual concrete types of the arguments at the call site[^1].

[^1] The actual algorithm used by Julia is not straightforward enough to be put in a single sentence, plus there are several corner cases. However, it has been formalized and checked against alternative implementations. More information [here](https://doi.org/10.1145/3276483)"""

# ╔═╡ 755bf8cd-c615-4ff7-8091-2e269bd4bea2
md"""
## Parametric Types

The Julia type system is parametric, i.e. types can depend on other things. In Julia, types can depend on other types, symbols, and values for which `isbits` returns true.

A good example is the (multidimensional) Array type, a container type which is parametric both in the elements type and in the dimensionality[^1] of the container (vectors, matrices, and higher order tensors). There are some utility functions to create arrays, like `ones`, `zeros`, `fill` or `similar`, which respectively creates arrays full of ones, zeros, arbitrary values or uninitialized arrays of the same type and shape of a given one. Let's create a vector filled with 1.0 and inspect the type of the result.

[^1] Notice that the arrays of the Julia standard library are not parametric in their sizes along dimensions. The third party package [StaticArrays](https://github.com/JuliaArrays/StaticArrays.jl) provides such data structures, that can be more performant for certain algorithms (thanks, for example, to stack allocations and loop unrolling) and in certain contexts (tipically for small arrays). 
"""

# ╔═╡ ed3064fa-798b-458d-98cc-596217cbbc91
v = ones(3)

# ╔═╡ f8a71122-4e46-418a-b9ed-143a60aff4af
typeof(v)

# ╔═╡ 79eeca9f-55a5-40b2-91c3-7a59ea191ced
md"""
This vector has type `Vector{Float64}`, which is an alias for `Array{Float64, 1}`. Types are first class objects, and the type (kind, in type theory) of a type `T` is the singleton (more on that later) type `Type{T}`, which is a subtype of `Type`.
"""

# ╔═╡ 531c8655-7737-4f08-ba98-0e3f5e98d1f1
md"""

### Tuple and Union type

In type systems that have both, subtyping and parametric types can interact in interesting ways. In Julia, parametric types are not covariant, which means that if `A <: B`, then `C{A} <: C{B}` does **not** hold. This is something to keep in mind when designing a type hierarchy.
"""

# ╔═╡ 03318c4d-6367-4a6c-836e-8dc83a64c56c
Int <: Number

# ╔═╡ 7d7d1863-ccaa-42f2-b33e-1c546c56da9b
Vector{Int} <: Vector{Number}

# ╔═╡ 22f9ab06-f24d-4d2e-8353-e199149eb120
md"""
However, the parametric type `Tuple{A, B, ...}` makes an exception and it's covariant in its arguments; that is if `T <: S` and `Tuple{A1, A2, ..., An} <: Tuple{B1, B2, ..., Bn}` then `Tuple{A1, A2, ..., An, T} <: Tuple{B1, B2, ..., Bn, S}`.

The reason is that this special type is used in _multiple dispatch_, something which will discuss in more detail later. The main idea is that it represents the type of the input of a function (a tuple of arguments). Quoting the Julia documentation, "_tuples are an abstraction of the arguments of a function – without the function itself_".  If we want to use subtyping in the selection of a function implementation based on its arguments, we need covariance.
"""

# ╔═╡ bdb4e1fd-64fd-477f-95df-045e5eb5d1ca
Tuple{Int, Float64} <: Tuple{Integer, AbstractFloat}

# ╔═╡ 1193273b-c159-47c9-ba87-42dfaf9acdbf
md"""
A particular parametric type is `Union`. It is not a union type in the categorical sense (or a tagged type), but rather a variadic parametric type such that, `T <: Union{A, B, ..., T}`.
"""

# ╔═╡ 6d7f0d0a-8d09-4b89-8abe-51786402d122
IntOrString = Union{Int,AbstractString}

# ╔═╡ 08174909-8658-48be-844b-df95f5b553b2
1 :: IntOrString

# ╔═╡ 191d31c9-3d87-44a3-8d69-48573fabcd70
"Hello!" :: IntOrString

# ╔═╡ f6ffb520-acc5-41ab-9724-3d21a5d8b9cf
1.0 :: IntOrString

# ╔═╡ 42883895-0add-4b7a-a425-959d6eb1b736
md"""
Finally, several intuitive (in a set-theoretic point of view) relations holds. `Tuples` distribute over `Unions`, `Union{A, B}` is associative, and `Union{}` (the bottom value) is the neutral element with respect to `Union{A, B}`.

A more in detail description of the type system and of the reasons behind its design can be found in the [Abstraction in technical computing](https://dspace.mit.edu/handle/1721.1/99811) (2015), the PhD thesis of Jeff Bezanson, one of the creators Julia.
"""

# ╔═╡ 72c818f8-ee5b-4329-9deb-66e96c3d9353
Tuple{Union{Int, Float64}, String} == Union{Tuple{Int, String}, Tuple{Float64, String}}

# ╔═╡ dc0ac71b-f781-4af2-9786-3b7a5d720f25
Int == Union{Int, Union{}}

# ╔═╡ ae5ea55e-780c-4bac-84f1-6096739335ea
Union{Union{Int, Float64}, String} == Union{Int, Float64, String}

# ╔═╡ fa5e3286-da7a-4773-97d2-b4ade6b1d23a
md"""

## UnionAll types

We've seen the `Function` type and the `Type` type, which are supertypes respectively of all the `Function{f}` and `Type{T}` types, where `f` is the name of a function and `T` of a type. How is this possible? If one defines a new function `g` or a new type `S`, then `Function{g} <: Function` and `Type{S} <: Type` will hold, without any explicit declaration. We can ask Julia what is the type of `Type` and `Function`.
"""

# ╔═╡ 90223ffd-75aa-40c9-935f-f7a847bcdf43
typeof(Type)

# ╔═╡ 53441a57-0c64-4984-8700-fecdec03ffae
md"""
The `UnionAll` type is a special kind that expresses the iterated union of types for all values of some parameter.
"""

# ╔═╡ e6578476-5184-47bd-82da-d9aaac5eb397
Vector{Int} isa DataType && Vector isa UnionAll && UnionAll isa DataType 

# ╔═╡ 25221458-20ab-4df7-808c-18f24be06bbe
md"""

## Singleton types

A singleton type is a type of which there is only one instance (in the category Set, a set containing only one element). Formally, `T` is a singleton type iff `a isa T && b isa T` implies `a === b` (they are identical). Such a type (there can be more than one, all isomorphic one another), are defined singleton types (the `void` type of C++ or `()`, the unit type, in Haskell). 
"""

# ╔═╡ 1ba15d0b-fda6-4f0c-b6fd-8f23f242b94d
md"""
A particular case of sigleton types are `Missing` and `Nothing`. They are similar, but they are used with different intentions and functions usually implement a method for one or the other.


On the one hand, `Missing` represents, as the name suggests, a missing value, for example in tabular data. This means that missings propagates in arithmetic operations (like NaNs) and that statistic functions usually can be instructed for skipping missings.

On the other hand, `Nothing` represents a void. For example, it is the return type of the execution of instructions that do not correspond to a value (i.e. have only side effects, as `println`) and is used to implement the C++ `std::optional` or Haskell `Maybe`.
"""

# ╔═╡ f81e6114-b046-4adf-bc8a-68f0624e91af
1 + missing

# ╔═╡ ce484dea-b7e2-4e08-9138-b24b004911a8
typeof(println("Hello!"))

# ╔═╡ dba01f0b-0041-4246-9c98-d941ec65ccb5
md"""
## Type Stability

When writing Julia code, one tipically defines new procedures (functions) or types. In the next sections we will discuss more in details these parts of Julia programming. I already used function application, with the usual syntax using parenthesis. To discuss the type system, I will define some functions using the following syntax."""

# ╔═╡ 558a5c89-6569-435e-a12a-bd5ce6e2aea5
addone(x) = x + 1

# ╔═╡ e79ee8ba-b47d-4038-92ee-52d6afb1cfeb
addone(1)

# ╔═╡ 6b281640-d447-4741-822c-d6a574dfe45d
md"""Since Julia feature function overloading, the same expressions containing `f(x1, x2, ..., xn)` can be evaluated differently depending on the types of `x1`, `x2`, and so on. This is called polymorphism. However, being a dynamic language, the type of an expression is not known at compile time, but only at run time, when also values are available. Consider the following function as an example.
"""

# ╔═╡ 7af55453-d581-4134-b127-bfc408f71176
activation_unstable(x) = x < 0  ? 0 : x

# ╔═╡ 253e76ab-dca4-40f0-94c0-d0c4b34d77cd
typeof(activation_unstable(1.0))

# ╔═╡ a983819c-66f5-4951-b0cd-d86e590362eb
typeof(activation_unstable(-1.0))

# ╔═╡ 499f279b-fb1d-489c-9caa-c70304c2d499
md"""We can see that the return type depends on the value of `x`. The `@code_typed` macro (I will introduce macros in the next sections), allow us to inspect this behaviour: the return type of `f` is a `Union`"""

# ╔═╡ 814aff0c-7053-43af-8cbd-4563230e94d7
@code_typed activation_unstable(0.0)

# ╔═╡ ef7ac6cf-5270-40cf-9743-950c34be5801
md"""Not knowing the concrete type of an argument of a function means that the compiler cannot select the most performant implementation beforehand. For the same reason, an object with unknown type will be allocated on the heap in a data structure that contains the information about its runtime type, called a box (variables binded to such object are said to be boxed variables). Moreover, packing objects into boxes introduce cache inefficiencies.

This problem is known as **type instability** and it propagates: the composition of `f` with another function `g` will be type unstable (unless `g` does not depend on the type of its argument, and the compiler is able to infer that)."""

# ╔═╡ 79b3f92d-de44-44c5-bc82-b1355f2c3c7a
g(y) = 2y

# ╔═╡ 9a35c602-a278-4aa3-a8f4-1aa8184d098f
@code_typed (g ∘ activation_unstable)(0.0)

# ╔═╡ 0904364a-73a0-4751-a792-222affd81584
md"""For this reason the convenience functions `one` and `zero` exist, so that one can idiomatically implement the type-stable `activation_stable` function."""

# ╔═╡ 9116aa9c-f368-4a2d-8452-cb495e7c7ea0
activation_stable(x) = x < 0 ? zero(x) : x

# ╔═╡ e809ece1-2156-409a-a7bc-81e8631bc69e
@code_typed (g ∘ activation_stable)(0.0)

# ╔═╡ 4b46c105-a632-45b7-9783-2e0a308b960d
md"""Writing type stable functions is one of the most important points to look after to write performant Julia code, and many other revolves around type issues."""

# ╔═╡ fda8f33f-7846-41fa-92fd-97fd350a0565
silly(f, xs) = sum(2 ^ f(x) for x in xs) # A silly function designed to prove a point.

# ╔═╡ 796d4c9c-b177-44f2-b83c-48a76139d3fd
@benchmark silly(activation_unstable, 1:10.)

# ╔═╡ 3bd09960-0320-4f7e-bcb4-767b63ccf6bc
@benchmark silly(activation_stable, 1:10.)

# ╔═╡ 7c9db2a9-2fec-4bcc-a48a-fb80e9cad4e9
silly(activation_unstable, 1:10.) ≈ silly(activation_stable, 1:10.)

# ╔═╡ 55a5f32c-f859-4eae-97ab-2f5612f435f3
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.3.2"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "0da5d17056461ac0abf65ae8365452a13a39bc03"

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

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

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
git-tree-sha1 = "cceb0257b662528ecdf0b4b4302eb00e767b38e7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

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
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

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
# ╟─497dacf1-fc19-484f-800b-64bc1497820a
# ╟─e19cfce3-e223-4f10-a8b4-d090098dc0e1
# ╠═2c1cf2cf-306a-45d9-a1d2-ac393f276e40
# ╠═5717f990-c6e8-4734-9984-8edfd9c583e2
# ╠═ef1161d0-8a28-4a91-992e-7b7c3b714e96
# ╠═bb5e8508-393f-4722-b790-57984756fba9
# ╠═d89a0b74-c934-4da7-8be3-97be1dbc8c6b
# ╠═90cf2d0e-f64d-4dcb-9fc9-50bf901fec17
# ╠═badcb581-821f-49dc-bafa-7274202760cb
# ╠═8f130b81-7dd3-4c33-aee8-54970bb5d667
# ╟─f7f2503b-a415-4c82-9afe-13ba3bf7e966
# ╠═7dc1b2ef-dbb3-4ecb-b7c0-60d9c7184530
# ╟─6a67fecb-e92f-4e2f-8c57-f0d131481422
# ╠═6bcd9def-1fda-4ff2-bc40-3f8c70d36370
# ╠═0cab47f9-cf8b-49be-9a66-89af9a03ebd6
# ╟─8e2028a7-15b6-44ab-93b9-c91dd691d05e
# ╠═0b83a591-ff64-44df-b096-775471c9429b
# ╟─8240e88c-4044-430c-852a-548e7af7f6f4
# ╠═53f48d6c-2b77-4f2f-a0ff-d742ad73252e
# ╠═954ebe2f-9145-4bb2-b6bf-5fc24f5eedfd
# ╠═19627c7d-65ec-4bee-a485-5d361c31b417
# ╠═17ea0a23-ba36-4aba-bb5f-7e6f546d9631
# ╠═a5a8b7d3-e0f8-4cf0-b053-a897581847fb
# ╟─57a28269-0128-469c-8e03-3dd69a4a8432
# ╟─755bf8cd-c615-4ff7-8091-2e269bd4bea2
# ╠═ed3064fa-798b-458d-98cc-596217cbbc91
# ╠═f8a71122-4e46-418a-b9ed-143a60aff4af
# ╟─79eeca9f-55a5-40b2-91c3-7a59ea191ced
# ╟─531c8655-7737-4f08-ba98-0e3f5e98d1f1
# ╠═03318c4d-6367-4a6c-836e-8dc83a64c56c
# ╠═7d7d1863-ccaa-42f2-b33e-1c546c56da9b
# ╟─22f9ab06-f24d-4d2e-8353-e199149eb120
# ╠═bdb4e1fd-64fd-477f-95df-045e5eb5d1ca
# ╟─1193273b-c159-47c9-ba87-42dfaf9acdbf
# ╠═6d7f0d0a-8d09-4b89-8abe-51786402d122
# ╠═08174909-8658-48be-844b-df95f5b553b2
# ╠═191d31c9-3d87-44a3-8d69-48573fabcd70
# ╠═f6ffb520-acc5-41ab-9724-3d21a5d8b9cf
# ╟─42883895-0add-4b7a-a425-959d6eb1b736
# ╠═72c818f8-ee5b-4329-9deb-66e96c3d9353
# ╠═dc0ac71b-f781-4af2-9786-3b7a5d720f25
# ╠═ae5ea55e-780c-4bac-84f1-6096739335ea
# ╟─fa5e3286-da7a-4773-97d2-b4ade6b1d23a
# ╠═90223ffd-75aa-40c9-935f-f7a847bcdf43
# ╟─53441a57-0c64-4984-8700-fecdec03ffae
# ╠═e6578476-5184-47bd-82da-d9aaac5eb397
# ╟─25221458-20ab-4df7-808c-18f24be06bbe
# ╟─1ba15d0b-fda6-4f0c-b6fd-8f23f242b94d
# ╠═f81e6114-b046-4adf-bc8a-68f0624e91af
# ╠═ce484dea-b7e2-4e08-9138-b24b004911a8
# ╠═dba01f0b-0041-4246-9c98-d941ec65ccb5
# ╠═558a5c89-6569-435e-a12a-bd5ce6e2aea5
# ╠═e79ee8ba-b47d-4038-92ee-52d6afb1cfeb
# ╟─6b281640-d447-4741-822c-d6a574dfe45d
# ╠═7af55453-d581-4134-b127-bfc408f71176
# ╠═253e76ab-dca4-40f0-94c0-d0c4b34d77cd
# ╠═a983819c-66f5-4951-b0cd-d86e590362eb
# ╟─499f279b-fb1d-489c-9caa-c70304c2d499
# ╠═814aff0c-7053-43af-8cbd-4563230e94d7
# ╟─ef7ac6cf-5270-40cf-9743-950c34be5801
# ╠═79b3f92d-de44-44c5-bc82-b1355f2c3c7a
# ╠═9a35c602-a278-4aa3-a8f4-1aa8184d098f
# ╟─0904364a-73a0-4751-a792-222affd81584
# ╠═9116aa9c-f368-4a2d-8452-cb495e7c7ea0
# ╠═e809ece1-2156-409a-a7bc-81e8631bc69e
# ╟─4b46c105-a632-45b7-9783-2e0a308b960d
# ╠═f2ce55d8-64da-11ed-3294-3b3ff9b2b364
# ╠═fda8f33f-7846-41fa-92fd-97fd350a0565
# ╠═796d4c9c-b177-44f2-b83c-48a76139d3fd
# ╠═3bd09960-0320-4f7e-bcb4-767b63ccf6bc
# ╠═7c9db2a9-2fec-4bcc-a48a-fb80e9cad4e9
# ╠═69058b15-d1ea-4b6b-84df-0c9250379e6f
# ╠═55a5f32c-f859-4eae-97ab-2f5612f435f3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
