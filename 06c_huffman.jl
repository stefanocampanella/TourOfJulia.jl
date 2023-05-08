### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# ╔═╡ 6b3d1cb2-96d2-407c-bf0a-c63c1cde77f1
md"# Huffman Encoding"

# ╔═╡ c5bdc482-3f8f-4465-abf0-1721d9454fc7
message = Vector{Char}("Stately, plump Buck Mulligan came from the stairhead, bearing a bowl of lather on which a mirror and a razor lay crossed.")

# ╔═╡ a7934f5c-e9a9-11ed-056b-897201423671
begin
	struct HuffmanTree{T}
		symbols::Set{T}
		weight::Int
		left::Union{HuffmanTree{T}, Nothing}
		right::Union{HuffmanTree{T}, Nothing}
	end

	HuffmanTree(symbols::Set{T}, weight::Int) where T = HuffmanTree{T}(symbols, weight, nothing, nothing)
end

# ╔═╡ 05ec711f-7858-400a-8bdf-597d586aa366
function merge(l::HuffmanTree{T}, r::HuffmanTree{T}) where T
	HuffmanTree{T}(union(l.symbols, r.symbols), l.weight + r.weight, l, r)
end

# ╔═╡ 3d7243d6-dcd7-4a15-8c9b-9d666de92811
function mergetrees!(trees::AbstractVector{HuffmanTree{T}}) where T
	if length(trees) > 1
		sort!(trees, lt=(x, y) -> isless(x.weight, y.weight))
		left = pop!(trees)
		right = pop!(trees)
		tree = merge(left, right)
		push!(trees, tree)
		mergetrees!(trees)
	end
end

# ╔═╡ dafdeb64-4031-4078-b5d3-8aa6a8d94b95
function maketree(message::AbstractVector{T}) where T
	trees = [HuffmanTree(Set(key), count(==(key), message)) for key in Set(message)]
	mergetrees!(trees)
	only(trees)
end

# ╔═╡ dac04966-15c6-4345-ab1d-35ea2060613a
ht = maketree(message)

# ╔═╡ 23977796-3ac8-48bf-92a5-236caf77c544
function encode!(code::BitVector, symbol::T, tree::HuffmanTree{T}) where T
	if !isnothing(tree.left) && symbol in tree.left.symbols
		encode!(push!(code, false), symbol, tree.left)
	elseif !isnothing(tree.right) && symbol in tree.right.symbols
		encode!(push!(code, true), symbol, tree.right)
	else
		code
	end
end

# ╔═╡ 04db8dc2-1262-4c10-a5a7-f64a4d9eb8ce
function encode(symbol::T, tree::HuffmanTree{T}) where T
	code = BitVector()
	encode!(code, symbol, tree)
end

# ╔═╡ 1a83b131-9a47-4958-a61c-f17ef73e6332
function encode(stream::AbstractVector{T}, tree::HuffmanTree{T}) where T
	reduce(vcat, map(symbol -> encode(symbol, tree), stream))
end

# ╔═╡ 366fc338-287d-4b65-a080-505720bd9e4e
encoded_message = encode(message, ht)

# ╔═╡ 79a2cfe0-af17-4577-8f42-ff5ece14f176
bitstring(encoded_message)

# ╔═╡ 79bb6334-d966-4188-bc27-cb6228897c8b
md"Compression rate is $(round(sizeof(encoded_message) / sizeof(message), digits=2))%"

# ╔═╡ ce9f7749-3b7f-4a1c-8c48-075659c76e7f
function decodeprefix!(prefixcode::BitVector, tree::HuffmanTree{T}) where T
	if length(tree.symbols) > 1
		subtree = popfirst!(prefixcode) ? tree.right : tree.left
		decodeprefix!(prefixcode, subtree)
	else
		only(tree.symbols)
	end
end

# ╔═╡ 92f9f4b7-d20e-4b42-a9a6-cf82bcda0489
function decode!(message::AbstractVector{T}, code::BitVector, tree::HuffmanTree{T}) where T
	if isempty(code)
		message
	else
		symbol = decodeprefix!(code, tree)
		decode!(push!(message, symbol), code, tree)
	end
end

# ╔═╡ 52c62466-57e0-4b11-906d-34c8c2600b8b
function decode(code::BitVector, tree::HuffmanTree{T}) where T
	message = Vector{T}(undef, 0)
	code_copy = copy(code)
	decode!(message, code_copy, tree)
end

# ╔═╡ aa381f3b-5383-42e3-bc83-223807a8713e
decode(encoded_message, ht)

# ╔═╡ fd3915a1-bf99-4b2f-942d-f336d6ab758f
message == decode(encoded_message, ht)

# ╔═╡ Cell order:
# ╟─6b3d1cb2-96d2-407c-bf0a-c63c1cde77f1
# ╠═c5bdc482-3f8f-4465-abf0-1721d9454fc7
# ╠═a7934f5c-e9a9-11ed-056b-897201423671
# ╠═05ec711f-7858-400a-8bdf-597d586aa366
# ╠═3d7243d6-dcd7-4a15-8c9b-9d666de92811
# ╠═dafdeb64-4031-4078-b5d3-8aa6a8d94b95
# ╠═dac04966-15c6-4345-ab1d-35ea2060613a
# ╠═23977796-3ac8-48bf-92a5-236caf77c544
# ╠═04db8dc2-1262-4c10-a5a7-f64a4d9eb8ce
# ╠═1a83b131-9a47-4958-a61c-f17ef73e6332
# ╠═366fc338-287d-4b65-a080-505720bd9e4e
# ╠═79a2cfe0-af17-4577-8f42-ff5ece14f176
# ╠═79bb6334-d966-4188-bc27-cb6228897c8b
# ╠═ce9f7749-3b7f-4a1c-8c48-075659c76e7f
# ╠═92f9f4b7-d20e-4b42-a9a6-cf82bcda0489
# ╠═52c62466-57e0-4b11-906d-34c8c2600b8b
# ╠═aa381f3b-5383-42e3-bc83-223807a8713e
# ╠═fd3915a1-bf99-4b2f-942d-f336d6ab758f
