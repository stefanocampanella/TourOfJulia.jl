### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ e332628d-d38a-49a7-84bc-7ace31ad0d4d
using DataFrames

# ╔═╡ 525b4126-e6fa-4616-9676-b8b6f31e403f
using CSV

# ╔═╡ 93b98458-2288-48e5-acf2-0b849bc4aaba
using Statistics

# ╔═╡ 7d05f65d-ff26-41a6-889e-b03df04dd48b
using XGBoost

# ╔═╡ 884905d7-ef97-4b62-acc9-843ce2e79f79
md"""
# Julia DataFrames
"""

# ╔═╡ 10373ad9-66d6-4f2b-b715-8c04fbdb7d08
md"""
## Constructors and loading CSVs
"""

# ╔═╡ d6b94b10-ffe4-4368-85f0-03ddaede3f7f
iris = mktempdir() do dir_path
	zip_path = joinpath(dir_path, "iris.zip")
	download("https://archive.ics.uci.edu/static/public/53/iris.zip", zip_path)
	run(`unzip $zip_path -d $dir_path`)
	csv_path = joinpath(dir_path, "iris.data")
	CSV.read(csv_path, DataFrame, header=[:sepal_length, :sepal_width, :petal_length, :petal_width, :class])
end

# ╔═╡ 5ca4d705-dd91-4fa8-a70c-598077769615
md"""
## Accessing columns and column names
"""

# ╔═╡ 8533ce8a-460e-4b62-97c4-119b9a6fc6f2
iris.sepal_length #= iris[!, :sepal_length] =# === iris[:, :sepal_length] 

# ╔═╡ 32944ad3-641d-4da4-80aa-e3fa29ecbbe9
names(iris), propertynames(iris)

# ╔═╡ 77c66f83-b02c-4ebd-987b-45c3e8928a3b
md"""
## Describe a DataFrame and computing statistics
"""

# ╔═╡ d06db870-6995-4b32-a838-d0ce284bc6d6
describe(iris)

# ╔═╡ bdba45b6-6e2f-449b-a1a6-c44023b78b81
std(iris.sepal_length)

# ╔═╡ 3ed5a310-7853-437a-b01f-6ab6fa744472
first(iris, 5)

# ╔═╡ 8df9f8aa-3253-4f7e-a801-4cc64a38ed0c
md"""
## Indexing and views
"""

# ╔═╡ 020a6d64-1b6f-4485-8bce-0814277f1386
iris[rand(Bool, nrow(iris)), [:sepal_length, :class]]

# ╔═╡ 8b08efcb-5efd-440a-a980-97bb3e459aec
iris[1:10, "class"]

# ╔═╡ 94075008-cc6f-4bbe-a9bb-46d587349e39
iris[1:10, 1:4]

# ╔═╡ 58d46e1d-3b30-46f1-b142-a068c001a765
(@view iris[1:end, [2, 3, 5]]) |> typeof

# ╔═╡ e8cb2729-37ec-4f60-a529-d7b139ac5133
iris[!, r"sepal_*"]

# ╔═╡ f865cb0d-c4a5-4dcc-89ed-a44d0acf88d2
iris[!, Not(:class)]

# ╔═╡ 9db64168-338c-4bf7-b430-98c2efd39db3
md"""
## Classifying the Iris dataset with XGBoost
"""

# ╔═╡ cbef1767-4c50-4f40-aa29-e9bddbaeb2a0
import Random: shuffle

# ╔═╡ 226ecb13-12d4-407c-b58a-924c421e2423
function split(df, at=0.8)
	df = shuffle(df)
	endpoint = round(Int, nrow(df) * at)
	df[1:endpoint, :], df[endpoint + 1:end, :]
end

# ╔═╡ 1815eda4-0d09-4b47-ba41-5c568f6804bc
train, test = split(iris)

# ╔═╡ d684258f-a215-4b1a-a6ab-8d4d114e7b16
classes = unique(iris.class)

# ╔═╡ 42dc519a-506b-4013-bace-5c7f1f1c18f7
encode(x) :: Float32 = findfirst(==(x), classes)

# ╔═╡ b9ee45ad-37a7-4f6f-a044-28dd60e04de6
decode(x) = classes[round(Int, x)]

# ╔═╡ d96c37be-da2f-4c0a-93c4-9ebf7f060603
train_labels = map(encode, train.class)

# ╔═╡ 1a112052-f7e3-4bc8-bec6-70fcaa28eb1f
model = xgboost((train[:, Not(:class)], train_labels))

# ╔═╡ e36eecca-feb6-4c76-9a14-0ffb675e904d
predictions = predict(model, test[:, Not(:class)])

# ╔═╡ 7557839c-a580-44c3-a135-b9384cff89c3
√mean(abs2, encode.(test.class) - predictions) # RMSE

# ╔═╡ 73413e5f-5c7f-4955-9acb-f5c5c996a903
count(encode.(test.class) .!= round.(predictions))

# ╔═╡ 697135f2-cf29-4769-bb75-0c615d30a2ab
let
	df = copy(iris)
	df.prediction = decode.(predict(model, df[:, Not(:class)]))
	df[df.class .!= df.prediction, :]
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
XGBoost = "009559a3-9522-5dbb-924b-0b6ed2b22bb9"

[compat]
CSV = "~0.10.12"
DataFrames = "~1.6.1"
XGBoost = "~2.5.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "f397abcce5970fb0bcf05ebb743a7ab5e4c03c76"

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "679e69c611fff422038e9e21e270c4197d49d918"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.12"

[[deps.CUDA_Driver_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "d01bfc999768f0a31ed36f5d22a76161fc63079c"
uuid = "4ee394cb-3365-5eb0-8335-949819d2adfc"
version = "0.7.0+1"

[[deps.CUDA_Runtime_jll]]
deps = ["Artifacts", "CUDA_Driver_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "8e25c009d2bf16c2c31a70a6e9e8939f7325cc84"
uuid = "76a88914-d11a-5bdc-97e0-2f5a05c973a2"
version = "0.11.1+0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "886826d76ea9e72b35fcd000e535588f7b60f21d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "eb3edce0ed4fa32f75a0a11217433c31d56bd48b"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.14.0"

    [deps.JSON3.extensions]
    JSON3ArrowExt = ["ArrowTypes"]

    [deps.JSON3.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

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

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SparseMatricesCSR]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "38677ca58e80b5cad2382e5a1848f93b054ad28d"
uuid = "a0a7dd2c-ebf4-11e9-1f05-cf50bc540ca1"
version = "0.6.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "ca4bccb03acf9faaf4137a9abc1881ed1841aa70"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.10.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XGBoost]]
deps = ["AbstractTrees", "CEnum", "JSON3", "LinearAlgebra", "OrderedCollections", "SparseArrays", "SparseMatricesCSR", "Statistics", "Tables", "XGBoost_jll"]
git-tree-sha1 = "bacb62e07d104630094c8dac2fd070f5d4b9b305"
uuid = "009559a3-9522-5dbb-924b-0b6ed2b22bb9"
version = "2.5.1"

    [deps.XGBoost.extensions]
    XGBoostCUDAExt = "CUDA"
    XGBoostTermExt = "Term"

    [deps.XGBoost.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    Term = "22787eb5-b846-44ae-b979-8e399b8463ab"

[[deps.XGBoost_jll]]
deps = ["Artifacts", "CUDA_Runtime_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "1c0aa2390a7ebb28a3d6c214f64e57a24091fbd7"
uuid = "a5c6f535-4255-5ca2-a466-0e519f119c46"
version = "2.0.1+0"

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
# ╟─884905d7-ef97-4b62-acc9-843ce2e79f79
# ╠═e332628d-d38a-49a7-84bc-7ace31ad0d4d
# ╠═525b4126-e6fa-4616-9676-b8b6f31e403f
# ╟─10373ad9-66d6-4f2b-b715-8c04fbdb7d08
# ╠═d6b94b10-ffe4-4368-85f0-03ddaede3f7f
# ╟─5ca4d705-dd91-4fa8-a70c-598077769615
# ╠═8533ce8a-460e-4b62-97c4-119b9a6fc6f2
# ╠═32944ad3-641d-4da4-80aa-e3fa29ecbbe9
# ╟─77c66f83-b02c-4ebd-987b-45c3e8928a3b
# ╠═d06db870-6995-4b32-a838-d0ce284bc6d6
# ╠═93b98458-2288-48e5-acf2-0b849bc4aaba
# ╠═bdba45b6-6e2f-449b-a1a6-c44023b78b81
# ╠═3ed5a310-7853-437a-b01f-6ab6fa744472
# ╟─8df9f8aa-3253-4f7e-a801-4cc64a38ed0c
# ╠═020a6d64-1b6f-4485-8bce-0814277f1386
# ╠═8b08efcb-5efd-440a-a980-97bb3e459aec
# ╠═94075008-cc6f-4bbe-a9bb-46d587349e39
# ╠═58d46e1d-3b30-46f1-b142-a068c001a765
# ╠═e8cb2729-37ec-4f60-a529-d7b139ac5133
# ╠═f865cb0d-c4a5-4dcc-89ed-a44d0acf88d2
# ╟─9db64168-338c-4bf7-b430-98c2efd39db3
# ╠═7d05f65d-ff26-41a6-889e-b03df04dd48b
# ╠═cbef1767-4c50-4f40-aa29-e9bddbaeb2a0
# ╠═226ecb13-12d4-407c-b58a-924c421e2423
# ╠═1815eda4-0d09-4b47-ba41-5c568f6804bc
# ╠═d684258f-a215-4b1a-a6ab-8d4d114e7b16
# ╠═42dc519a-506b-4013-bace-5c7f1f1c18f7
# ╠═b9ee45ad-37a7-4f6f-a044-28dd60e04de6
# ╠═d96c37be-da2f-4c0a-93c4-9ebf7f060603
# ╠═1a112052-f7e3-4bc8-bec6-70fcaa28eb1f
# ╠═e36eecca-feb6-4c76-9a14-0ffb675e904d
# ╠═7557839c-a580-44c3-a135-b9384cff89c3
# ╠═73413e5f-5c7f-4955-9acb-f5c5c996a903
# ╠═697135f2-cf29-4769-bb75-0c615d30a2ab
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
