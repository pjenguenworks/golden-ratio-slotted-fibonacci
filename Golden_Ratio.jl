### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 1cf2bc85-cb63-4303-afb0-d10e2b058471
using PlutoUI, Plots, Roots; plotly(); 

# ╔═╡ 509846e8-aacd-11ed-131d-6be4cb610555
md"# Base of Growth in Slotted Fibonacci Sequence, implemented in Julia Programming Language"

# ╔═╡ dc3ad3a7-4247-4974-b5c9-87e5e7245c70
md"# Iterate (Recursive) Function"

# ╔═╡ e466ed9e-8a91-494f-a6b0-fba7d3a508d8
function iterate(scoop::Int64, seed::Array{BigInt, 1}, i::Int64, to_print::Bool=false; multiplier::Vector{<:Real}=[1])
	to_print ? println(seed) : Nothing
	series = sort([i for i in seed])
	if length(multiplier) == length(seed)
		ij = multiplier .* seed
		interval_sum = [sum(ij[1:scoop])]
	else
		interval_sum = [sum(series[1:scoop])]
	end
	interval_series = series[2:end]
	new_series = sort([interval_sum;interval_series])
	
	if i == 1
		return seed, new_series
	else
		return iterate(scoop, new_series, i-1, to_print; multiplier=multiplier)
	end	
end

# ╔═╡ ee3dcadc-a3b7-4a8e-8dff-2e97e2043dec
function parseSeed(seed:: String)
	if occursin(",", seed)
		# Split seed: 45,50,66 -> [45, 50, 66]
		seed_arr = sort(map((x)->parse(BigInt, x), [i for i in split(seed, ",")]))
		return seed_arr
	else
		# Split seed: 011 -> [0, 1, 1]
		seed_arr = sort(map((x)->parse(BigInt, x), [i for i in split(seed, "")]))
		return seed_arr
	end
end

# ╔═╡ ec065c20-7fe6-4f3d-be4f-fed3184b9ae0
function create_fibonacci_seed(i::Int)
	i_1 = BigInt(0)
	i_2 = BigInt(1)
	initial_i = i
	seed_arr = [i_1, i_2]
	while i > 1
		to_add = [BigInt(sum(seed_arr[end-minimum([length(seed_arr), initial_i])+1:end]))]
		seed_arr = [seed_arr; to_add]
		i -= 1
		initial_i += 1
	end
	return seed_arr
end

# ╔═╡ 50a1854a-4924-4c9d-a7a2-6e9a9d9c6b05
function fibonacci_seed_iterate(length_of_array::Int, scoop_minus::Int, num_cycles::Int=20_000, to_print=false)
	fib_seed = create_fibonacci_seed(length_of_array)
	to_print ? println(fib_seed) : Nothing

	#want to take at least scoop size of 2, else i+1-scoop_minus
	results = iterate(length_of_array+1-scoop_minus, fib_seed, num_cycles, to_print)
	to_print ? println(results) : Nothing

	# right hand number n-1/n == base
	base = results[2][end]/results[1][end]
	return base
end

# ╔═╡ 2699dbcb-b0da-4dbd-af8e-47c7a5f95196
function iterate_fibonacci_limits(i::Int, num_cycles::Int, accuracy::Int, to_print::Bool=false)
	base_arr = []
	iter = 0
	while i > 1
		base = fibonacci_seed_iterate(accuracy, iter, num_cycles, to_print)
		push!(base_arr, base)	
		i -= 1
		iter += 1
	end
	return base_arr
end

# ╔═╡ 05ae28e6-d560-4fef-8012-a5de79fedef2
function fib_length_minus_scoop(iterations::Int, scoop_subtract, num_cycles::Int, to_print::Bool=false)
	i = scoop_subtract
	results_arr = []
	while iterations > 0
		base = fibonacci_seed_iterate(i, i - scoop_subtract, num_cycles, to_print)
		push!(results_arr, base)
		to_print ? println("Base $(base) for i $(i)") : Nothing

		iterations -= 1
		i += 1
	end
	return results_arr
end

# ╔═╡ ab3a9006-885a-4682-8cbe-61ec1af67ad9
function tetranacci(iterations::Int, num_cycles::Int, to_print::Bool=false)
	i = 0
	results_arr = []
	while iterations > 0
		base = fib_length_minus_scoop(1, i, num_cycles, to_print)
		push!(results_arr, base[1])
		iterations -= 1
		i += 1

	end
	return results_arr

end

# ╔═╡ 4482e039-30e0-4390-9df1-8268c278304a
function tetranacci_with_increasing_scoop(iterations::Int, length_of_lists::Int, num_cycles::Int, to_print::Bool=false)
	i = 0
	results_arr = []
	while iterations > 0
		results = fib_length_minus_scoop(length_of_lists, i, num_cycles, to_print)
		iterations -= 1
		push!(results_arr,results)
		i += 1
	end
	return results_arr
end

# ╔═╡ 49731a60-5a34-4c07-8e09-94b74e5a9501
function fib_seed_iterate_app(iterations::Int, scoop_minus::Int, num_cycles::Int, to_print::Bool=false)
	i = 1
	results_arr = []
	while iterations > 0
		base = fibonacci_seed_iterate(i, scoop_minus, num_cycles, to_print)
		push!(results_arr, base)
		to_print ? println("Base $(base) for i $(i)") : Nothing

		iterations -= 1
		i += 1
	end
	return results_arr
end

# ╔═╡ 9c2a3e3c-1e1c-4279-bc54-5ad0c74d71d6
function iterate_fibonacci_seeds_app()
	println("How many length-x = scoop to iterate? (default: 300)")
	n = readline()
	if length(n) > 0
		n = parse(Int, n)
	else
		n = 300
	end

	println("Internal iterations? Default: 20000")
	num_cycles = readline()
	if length(num_cycles) > 0
		num_cycles = parse(Int, num_cycles)
	else
		num_cycles = 20_000
	end

	println("Accuracy? Default: 125")
	accuracy = readline()
	if length(accuracy) > 0
		accuracy = parse(Int, accuracy)
	else
		accuracy = 125
	end

	println("Print results? N/y")
	to_print = readline()
	if length(to_print) > 0 && lowercase(to_print) == "y"
		to_print = true
	else
		to_print = false
	end
	

	results_arr = iterate_fibonacci_limits(n, num_cycles, accuracy, to_print)
	println(results_arr)
end

# ╔═╡ 3f6b4aee-0536-45f4-bd7d-1f5b2d7f835e

function process()
	println("Provide a seed to iterate")
	seed = readline()
	println("How many starting digits to sum?")
	scoop = parse(Int, readline())
	
	if scoop > length(seed)  
		println("Scoop is larger than seed. Try again.")
		return
	end
	println("How many times to iterate? (default/enter: 20,000)")
	iter_input = readline()
	if length(iter_input) == 0
		iter = 20_000
	else
		iter = parse(Int, iter_input)
	end
	println("Print steps? y/n")
	print_response = readline()
	if lowercase(print_response) == "y"
		to_print = true
	else
		to_print = false
	end
	seed_arr = parseSeed(seed)
	println(seed_arr)
	results = iterate(scoop, length(seed_arr), seed_arr, iter, to_print) #20000
	# println("Base:")
	base = results[2][end]/results[1][end]
	# println(base)


end

# ╔═╡ cd6129e0-0581-43a8-9fcc-cc832f242614
function return_base_multiplier(seed)
	len = length(split(seed, ','))
	return "1, "^(len - 1) * "1"
end

# ╔═╡ f007df5a-83ec-420b-9dbe-628375e727e2
md"""

# Demonstration of Algorithm - Slotted Fibonacci With Scoop

### $(@bind checklist1 CheckBox(default=false)) 2-Slot, Scoop 0

### $(@bind checklist1 CheckBox(default=false)) 3-Slot, Scoop 0

### $(@bind checklist1 CheckBox(default=false)) 3-Slot, Scoop -1

### $(@bind checklist1 CheckBox(default=false)) 4-Slot, Scoop -1

### $(@bind checklist1 CheckBox(default=false)) 4-Slot, Scoop -2

### $(@bind checklist1 CheckBox(default=false)) 20+-Slot, Scoop 0

### $(@bind checklist1 CheckBox(default=false)) 20+-Slot, Scoop -1

### $(@bind checklist1 CheckBox(default=false)) 20+-Slot, Scoop -2

"""

# ╔═╡ d733b6db-2fda-4391-82cf-e4609afc6277
@bind reset_app1 Button("Reset Settings")

# ╔═╡ c629a464-44dc-4b22-a1e5-486a78cc432a


# ╔═╡ ce406608-9f5f-489f-a202-931d1c1fd86d
begin
	reset_app1
	md"""
	Seed (list): $(@bind defaultSeedApp1 TextField((60,6); default="0, 1, 1"))

	Scoop Size: $(@bind scoopSizeApp1 Slider(0:-1:(-(length(parseSeed(defaultSeedApp1)))), -1, true))
	
	Iterations? $(@bind iterationsApp1 Slider(1:3_000, 25, true))

	To Print? $(@bind to_print_App1 CheckBox(default=true))

	Multiplier: $(@bind defaultMultiplierApp1 TextField((30,1); default=return_base_multiplier(defaultSeedApp1)))

	Activate Multiplier? $(@bind multiplier_app1 CheckBox(default=false)) 
	"""
end

# ╔═╡ 8f52b64e-fca2-43fa-a574-aacaeaf2d1a3
md"""

#### $(length(parseSeed(defaultSeedApp1)))-Slot Slotted Fibonacci With Scoop $(scoopSizeApp1)

"""

# ╔═╡ e9168880-7605-49ca-be5a-3c102d9efa2a
app1_results = iterate(length(parseSeed(defaultSeedApp1))+scoopSizeApp1, parseSeed(defaultSeedApp1), iterationsApp1, to_print_App1; multiplier=multiplier_app1 ? parseSeed(defaultMultiplierApp1) : [1])

# ╔═╡ c9d7d036-783a-4c19-be68-79b58bc569f8
md"## Base: $(app1_results[2][end]/app1_results[1][end])"

# ╔═╡ 5b51b5c3-6e7c-47af-8aa4-1630291274f1
md"---"

# ╔═╡ ac6eb76e-8a1b-4130-a2cb-b17b12b0cb66
md"# Increasing length of the list from 2 to 25, keeping the same scoop"

# ╔═╡ 4ceba7e2-fad1-4fb3-ac17-97569ed0d672
@bind reset_app2 Button("Reset settings")

# ╔═╡ 90c1379e-392b-4202-8710-43e20895b3b6
begin
	reset_app2
	md"""
	Length of Slots? $(@bind iters_app2 Slider(1:1:200, 25, true))
	
	Scoop from Right? $(@bind scoop_minus_app2 Slider(0:-1:-25, -1, true))
	
	Number of Iterations? $(@bind num_cycles_app2 Slider(1:1:12_000, 20, true))
	
	Print Results? $(@bind to_print_app2 CheckBox(default=false) )
	"""
end

# ╔═╡ 6cdfa66c-7792-4631-b671-eb0c209c6149
results_2_arr = fib_seed_iterate_app(iters_app2, -(scoop_minus_app2), num_cycles_app2, to_print_app2)

# ╔═╡ 702a769f-fc08-4b35-9491-f42182c83dc6
plot(results_2_arr, xlabel="Number of Slots", ylabel="Base of Growth", title="N-Slots With Scoop $(scoop_minus_app2) Converges to a Base", name="N-Slots")

# ╔═╡ 44e255be-5945-448a-b735-8bc0bb0c70bf
md"### Base of Growth At List Length $(iters_app2): $(results_2_arr[end])"

# ╔═╡ b99a7cde-7353-4163-8fee-96d526192193
md"""

---

# Increasing List Length but Keeping Scoop a Set Difference Apart
"""

# ╔═╡ 13265cff-30a7-4694-a189-eb1d060bddde
md"""## Scoop of -(length - 2)

### For example:

2-Slot == Scoop 0

3-Slot == Scoop -1

4-Slot == Scoop -2

5-Slot == Scoop -3

"""

# ╔═╡ 0e5ed47a-996d-4d6e-a489-762c92f5a360
results_length_minus_2__ = fib_length_minus_scoop(10, 1, 2_000, false)

# ╔═╡ 5592945c-2f14-4d70-8f85-d7cb9089309e
md"""

### 1.61803

Fibonacci Sequence: $F_n = F_{n-1} + F_{n-2}$

1.61803 :: $\phi$ :: $x^2 - x - 1 = 0$

1.32472 :: Plastic Number :: $x^3 - x - 1 = 0$

1.22074 :: $x^4 - x - 1 = 0$

1.1673 :: $x^5 -x - 1 = 0$ 

1.13472 :: $x^6 -x - 1 = 0$

1.11278 :: $x^7 - x - 1 = 0$

"""

# ╔═╡ d0be3e6d-5964-4aaf-b4cc-ef6159d717c6
md"""## Scoop of -(length - 3)

3-Slot == Scoop 0

4-Slot == Scoop -1

5-Slot == Scoop -2

6-Slot == Scoop -3

"""

# ╔═╡ bd6c89c1-7cfa-4408-924c-af8886183913
results_minus_3__ = fib_length_minus_scoop(10, 2, 2000, false)

# ╔═╡ 5f729a1f-2b37-4150-a107-65c0aca9bd4c
md"""

### 1.83929

Tribonacci Sequence: $F_n = F_{n-1} + F_{n-2} + F_{n-3}$

1.83929 :: Tribonacci :: $x^3 - x^2 - x - 1 = 0$

1.4655 :: $x^4 - x^2 - x - 1 = 0$

1.3247 :: Plastic Number:: $x^5 - x^2 - x - 1 = 0$

1.24985 :: $x^6 - x^2 -x -1 = 0$



"""

# ╔═╡ 1f1ea10c-891b-45a4-9df4-b4b84f973015
md"""## Scoop of -(length - 4)"""


# ╔═╡ c5acd471-a323-4dc1-8e9e-30ec070e35b3
results_minus_3___ = fib_length_minus_scoop(10, 3, 2000, false)

# ╔═╡ fd4769a1-9426-43b5-88a8-bc6aca18cbc8
md"""
### 1.92756

Tetranacci = $F_n = F_{n-1} + F_{n-2} + F_{n-3} + F_{n+4}$

1.92756 :: Tetranacci :: $x^4-x^3-x^2-x-1=0$

"""

# ╔═╡ d018a1eb-9fb1-4420-b051-6582044dda3d
md"""

# N-Bonacci Sequence

## Process:

### Take first number of sequence

1-Slot, Scoop 0

2-Slot, Scoop 0

3-Slot, Scoop 0

4-Slot, Scoop 0

5-Slot, Scoop 0

6-Slot, Scoop 0

"""

# ╔═╡ 076200ec-63b7-440f-b397-6698d7b46693
results_tet = tetranacci(10, 2000)

# ╔═╡ 6aff28d1-d044-4adc-a68a-7ca66d5e4990
md"""

1-Slot, Scoop 0

1.0 :: Base Case :: $F_n = F_{n-1}$

---

2-Slot, Scoop 0

1.61803 :: Fibonacci :: $F_n = F_{n-1} + F_{n-2}$

---

3-Slot, Scoop 0

1.83929 :: Tribonacci  :: $F_n = F_{n-1} + F_{n-2} + F_{n-3}$

---

4-Slot, Scoop 0

1.92756 :: Tetranacci :: $F_n = F_{n-1} + F_{n-2} + F_{n-3} + F_{n-4}$

---

5-Slot, Scoop 0

1.96595 :: Pentanacci :: $F_n = F_{n-1} + F_{n-2} + F_{n-3} + F_{n-4} + F_{n-5}$

---

6-Slot, Scoop 0

1.98358 :: Hexanacci :: $F_n = F_{n-1} + F_{n-2} + F_{n-3} + F_{n-4} + F_{n-5} + F_{n-6}$

---

7-Slot, Scoop 0

1.99196 :: Septanacci :: $F_n = F_{n-1} + F_{n-2} + F_{n-3} + F_{n-4} + F_{n-5}  + F_{n-6} + F_{n-7}$

etc...

"""

# ╔═╡ 6d8342a8-9d57-4237-b253-c92069bf2bfd
md"---"

# ╔═╡ 5167f2bd-12eb-4d13-bcd5-636f791c74be
md"""

Automate:

1-Slot: Scoop 0, -1, -2, -3, -4, -5, ...

2-Slot: Scoop 0, -1, -2, -3, -4, -5, ...

3-Slot: Scoop 0, -1, -2, -3, -4, -5, ...

4-Slot: Scoop 0, -1, -2, -3, -4, -5, ...

Graph Individual Series Base of Growth

"""

# ╔═╡ 8ddb9961-278e-45fd-9c04-1e09f552a83a
md"""

N-Slots: $(@bind n_length_tetranacci Slider(1:1:50, 20, true))

"""

# ╔═╡ a531d37f-a9e1-4870-94d4-0517b575c9c5
results_scoop_iterate = tetranacci_with_increasing_scoop(n_length_tetranacci, 80, 1000, false)

# ╔═╡ 924680e5-50e8-41ea-b07e-e5cf07044c0b
md"""
1 | 2 | 3 | 4 | $\dots$ | n |
----|-----|-----|-----|----|----|
 $x^2 - x - 1 = 0$ |  $x^3 - x - 1 = 0$ | $x^4 - x - 1 = 0$ | $x^5 - x - 1 = 0$ | $\dots$ | $lim_{n \to \infty} (x^n - x - 1) = 0$ |
 $x^3 - x^2 - x - 1 = 0$ | $x^4 - x^2 - x - 1 = 0$ |  $x^5 - x^2 - x - 1 = 0$ |  $x^6 - x^2 - x - 1 = 0$ | $\dots$ | $lim_{n \to \infty} (x^n - x^2 - x - 1) = 0$ |
 $x^4 - x^3 - x^2 - x - 1 = 0$ | $x^5 - x^3 - x^2 - x - 1 = 0$ | $x^6 - x^3 - x^2 - x - 1 = 0$ | $x^7 - x^3 - x^2 - x - 1 = 0$ | $\dots$ | $lim_{n \to \infty} (x^n - x^3 - x^2 - x - 1) = 0$ |
 $x^5 - x^4 - x^3 - x^2 - x - 1 = 0$ | $x^6 - x^4 - x^3 - x^2 - x - 1 = 0$ | $x^7 - x^4 - x^3 - x^2 - x - 1 = 0$ | $x^8 - x^4 - x^3 - x^2 - x - 1 = 0$ | $\dots$ | $lim_{n \to \infty} (x^n - x^4 - x^3 - x^2 - x - 1) = 0$ |
$\dots$ | $\dots$ | $\dots$ | $\dots$ | $\dots$ | $\dots$ |
$lim_{n \to \infty} (x^n + \sum_{i=0}^{n-1} (-1)x^i = 0$ | $lim_{n \to \infty} (x^{n+1} + \sum_{i=0}^{n-1} (-1)x^i = 0$ | $lim_{n \to \infty} (x^{n+2} + \sum_{i=0}^{n-1} (-1)x^i = 0$ | $lim_{n \to \infty}\] (x^{n+3} + \sum_{i=0}^{n-1} (-1)x^i = 0$ | $\dots$ | $lim_{n \to \infty} (x^{n+n} + \sum_{i=0}^{n-1} (-1)x^i = 0$ |
"""

# ╔═╡ cea16faf-a544-4d37-b6eb-2f92307d9ffa
md"""### $(@bind plot_roots_limit CheckBox(default=false)) Plot Base of Growth/Roots When A Long List is Iterated With A Varying Scoop?"""

# ╔═╡ 01d735f4-35f8-4aae-a223-2ba856681b10
md"""

#### 🏝️🏝️ Chaos in 2-Slot or just Machine Precision Error? 😮

##### No! Just Machine Precision Error!
"""

# ╔═╡ 4d0813ec-cd67-4ab6-bd29-cc466fda1243
md"""

---

"""


# ╔═╡ aefd0523-28e4-42fa-a8eb-0b77345c287b
md"# Base of Growth When Decreasing Scoop Sizes from 0 to -200 In A Large List, Plotted"

# ╔═╡ 4efb0354-052b-4be3-bec7-1e77822aa258
@bind reset_app3 Button("Reset settings")

# ╔═╡ ac91cf9a-229b-4f0c-821b-86452307c951
begin
	reset_app3

	md"""
	Scoops from 0 to negative what? $(@bind iter_app3 Slider(1:1:600, 200, true))
	
	How many internal iterations? $(@bind cycles_app3 Slider(1:1:13_000, 2_000, true))
	
	Number of Slots (accuracy)? $(@bind accuracy_app3 Slider(1:1:250, 200, true))
	
	"""
end

# ╔═╡ a857b4c5-a739-4610-9a51-655fccf7d12d
results_3_arr = iterate_fibonacci_limits(iter_app3, cycles_app3, accuracy_app3, false)

# ╔═╡ ff1a1594-de5c-4ada-a3b8-a25b2a03cb81
md"## Base of Growth When A Long List is Iterated With A Varying Scoop"

# ╔═╡ 78e14763-d39f-4645-b48e-f7c8e0e0c7f7
begin
	plot(results_3_arr, name="Slotted Fibonacci", xlabel="Scoop (Negative)", ylabel="Base of Growth")
	#plot!(plot_roots(iter_app3 - 2))
	#plot!(super_fib_list)
end

# ╔═╡ 6f7c306b-0a19-4472-a1d5-1ab8724bfb35
md"---"

# ╔═╡ 7df556e0-ffbd-4c87-a6cb-bf9ce426803a
md"#### [Wikipedia - Super Golden Ratio](https://en.wikipedia.org/wiki/Supergolden_ratio)"

# ╔═╡ 00bc92f0-246b-436d-b760-2b2ee381a63e
md"#### [Wikipedia - Pisot Number](https://en.wikipedia.org/wiki/Pisot%E2%80%93Vijayaraghavan_number)"

# ╔═╡ 0edce2b0-08de-438b-b7e8-b2af409d4e5c
md"#### [Wikipedia - Plastic Number](https://en.wikipedia.org/wiki/Plastic_number)"

# ╔═╡ 53c0e594-432a-46b7-a0ef-4acaeb535f9e
md"""
Scoop 0

2.0

root of $x^1 - x^0 - 1 = 0$

---

Scoop -1

1.61803: $\phi$ (Golden Ratio)

root of $x^2 - x^1 - 1 = 0$

---

Scoop -2

1.46557: Pisot #4: $\psi$ (Supergolden Ratio)

root of $x^3 - x^2 - 1 = 0$

---

Scoop -3

1.38028: Pisot #2

root of $x^4 - x^3 - 1 = 0$

---

Scoop -4

1.32472: Pisot #1: Plastic Number: a(n-2) + a(n-3)

root of $x^5 - x^4 - 1 = 0$

---

Scoop -5

1.2852

root of $x^6 - x^5 - 1 = 0$

---

Scoop -6

1.25542

root of $x^7 - x^6 -1 = 0$

---

Scoop -7

1.23205

root of $x^8 - x^7 -1 = 0$

---

Scoop -8

1.21315

root of $x^9 - x^8 -1 = 0$
"""

# ╔═╡ 3d8f5893-dc6b-48c1-a644-3e8ac6636680
function newton_root(func, func_deriv, x0; tol=1e-14)
    x_n = x0+1
    x_nplus1 = x0
    while abs(x_nplus1 - x_n) > tol
        x_n = x_nplus1
        x_nplus1 = x_nplus1 - func(x_nplus1)/func_deriv(x_nplus1)
    end
    x_nplus1
end

# ╔═╡ d76c9d4f-d68e-4acd-b99d-829a5b131f14
function plot_roots(n)
	arr = Array{BigFloat}(undef, n+1)
	for i=0:n
		func = x -> x^(i+1) - x^(i) - 1
		deriv_func = x -> ((i + 1) * x^(i)) - (i * x^(i - 1))
		root = newton_root(func, deriv_func, 1.0; tol=1e-14)
		arr[i+1] = root
	end
	return arr
end

# ╔═╡ b30cbbe8-5c41-4918-bd08-d9b24d83070e
begin
	p = plot(xlabel="Scoop (negative)", ylabel="Base of Growth")
	for i=1:n_length_tetranacci
		plot!(p, [results_scoop_iterate[i]], name="$(i)-Slot")
	end
	plot_roots_limit ? plot!(plot_roots(iter_app3 - 2)[1:n_length_tetranacci]) : Nothing
p
end

# ╔═╡ e3d35739-8394-482a-a1fa-38cfc0505b76
md"""
#### Characteristic Equations versus Recursive Formula

---

Scoop 0

2.0

$x^1 - x^0 - 1 = 0$

$F_n = F_{n-1} + F_{n-1}$

---

Scoop -1

1.61803

$x^2 - x^1 - 1 = 0$

$F_n = F_{n-2} + F_{n-1}$

---

Scoop -2

1.46557 

$x^3 - x^2 - 1 = 0$

$F_n = F_{n-3} + F_{n-1}$

---

Scoop -3

1.38028 

$x^4 - x^3 - 1 = 0$ 

$F_n = F_{n-4} + F_{n-1}$

---

Scoop -4

1.32472 

$x^5 - x^4 - 1 = 0$ 

$F_n = F_{n-5} + F_{n-1}$

---

Scoop -5

1.2852 

$x^6 - x^5 - 1 = 0$ 

$F_n = F_{n-6} + F_{n-1}$

---

Scoop -6

1.25542 

$x^7 - x^6 -1 = 0$

$F_n = F_{n-7} + F_{n-1}$

---

Scoop -7

1.23205 

$x^8 - x^7 -1 = 0$ 

$F_n = F_{n-8} + F_{n-1}$

---

Scoop -8

1.21315 

$x^9 - x^8 -1 = 0$ 

$F_n = F_{n-9} + F_{n-1}$

---
"""

# ╔═╡ 1dfa13ff-af6c-48c0-aa82-9124ed1c131d
md"## Plot of Slotted Fibonacci versus roots of Characteristic Equation"

# ╔═╡ cf50a10e-b8c7-4b8d-8de0-10d1a9c00d9b
begin
	plot(results_3_arr, name="Slotted Fibonacci", xlabel=:Scoop)
	plot!(plot_roots(iter_app3 - 2), name="Roots of Characteristic Equation", xlabel="Roots of x^n - x^(n-1) - 1 = 0", ylabel="Base of Growth")
	#plot!(super_fib_list)
end

# ╔═╡ 2e5d152b-da19-4cf4-88c1-c0387e99d91d
function recursive_super_fibonacci(n, subtraction, memo)
	if n <= subtraction
		soln_1 = BigInt(1)
		memo[n] = soln_1
		return soln_1
	end
	if haskey(memo, n)
		return memo[n]
	end
	solution = recursive_super_fibonacci(n - subtraction, subtraction, memo) + recursive_super_fibonacci(n - 1, subtraction, memo)
	memo[n] = solution
	return solution
end

# ╔═╡ a9d1ef99-3d58-42d9-a9e2-9e722f10ba9d
function super_fibonacci(n_minus; cycles=3000)
	memo = Dict()
	soln = recursive_super_fibonacci(cycles, n_minus, memo)
	return memo[cycles-1]/memo[cycles-2], memo
end

# ╔═╡ ec162079-30aa-48e1-bcac-08c8b9ec1226
function super_sequence(n; length=20)
	[super_fibonacci(n)[2][i] for i=1:length]
end


# ╔═╡ 9d40a049-ea65-468c-a5e2-6ef62c70b3a4
function iterable_super_sequence(n; length=20)
	[super_sequence(i; length=length) for i=1:n  ]
end

# ╔═╡ bd111618-2298-40ae-be97-885468fb4d8d
iterable_super_sequence(5)

# ╔═╡ 1d6993de-06ee-481f-8e6c-33ee21caf089
super_fib_list = [super_fibonacci(n)[1] for n=1:199]

# ╔═╡ 6299d1bd-b3bd-4f7c-949a-b477024ace8a
md"## Plot of Slotted Fibonacci versus Roots of Characteristic Equation versus Recursive Fibonacci Implementation"

# ╔═╡ 2401de4e-020e-45f5-a340-2178a167b41e
begin
	plot(results_3_arr, name="Slotted")
	plot!(plot_roots(iter_app3 - 2), name="Characteristic Equation")
	plot!(super_fib_list, name="Recursive Implementation", xlabel="F_n = F_{n-x} + F_{n-1}", ylabel="Base of Growth")
end

# ╔═╡ 8db54a5d-fa04-43e3-a115-585db749f211
md"""

# Resources Used:

### [The On-Line Encyclopedia of Integer Sequences - https://oeis.org/](https://oeis.org/)

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "551c9d46aacb222cd0efe3a262511a8c4d2ce2dc"

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

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "485193efd2176b88e6622a39a246f8c5b600e74e"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSolve]]
git-tree-sha1 = "9441451ee712d1aec22edad62db1a9af3dc8d852"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.3"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "61fdd77467a5c3ad071ef8277ac6bd6af7dd4c04"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "89a9db8d28102b094992472d333674bd1a83ce2a"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "660b2ea2ec2b010bb02823c6d0ff6afd9bdc5c16"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.71.7"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d5e1fd17ac7f3aa4c5287a61ee28d4f8b8e98873"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.71.7+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "da1d3fb7183e38603fcdd2061c47979d91202c97"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Roots]]
deps = ["ChainRulesCore", "CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "9c2f5d3768804ed465f0c51540c6074ae9f63900"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.9"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c6edfe154ad7b313c01aceca188c05c835c67360"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.4+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─509846e8-aacd-11ed-131d-6be4cb610555
# ╠═1cf2bc85-cb63-4303-afb0-d10e2b058471
# ╟─dc3ad3a7-4247-4974-b5c9-87e5e7245c70
# ╠═e466ed9e-8a91-494f-a6b0-fba7d3a508d8
# ╠═ee3dcadc-a3b7-4a8e-8dff-2e97e2043dec
# ╠═50a1854a-4924-4c9d-a7a2-6e9a9d9c6b05
# ╠═ec065c20-7fe6-4f3d-be4f-fed3184b9ae0
# ╠═2699dbcb-b0da-4dbd-af8e-47c7a5f95196
# ╠═05ae28e6-d560-4fef-8012-a5de79fedef2
# ╠═ab3a9006-885a-4682-8cbe-61ec1af67ad9
# ╠═4482e039-30e0-4390-9df1-8268c278304a
# ╠═49731a60-5a34-4c07-8e09-94b74e5a9501
# ╠═9c2a3e3c-1e1c-4279-bc54-5ad0c74d71d6
# ╠═3f6b4aee-0536-45f4-bd7d-1f5b2d7f835e
# ╠═cd6129e0-0581-43a8-9fcc-cc832f242614
# ╟─f007df5a-83ec-420b-9dbe-628375e727e2
# ╟─d733b6db-2fda-4391-82cf-e4609afc6277
# ╟─c629a464-44dc-4b22-a1e5-486a78cc432a
# ╟─ce406608-9f5f-489f-a202-931d1c1fd86d
# ╟─8f52b64e-fca2-43fa-a574-aacaeaf2d1a3
# ╠═e9168880-7605-49ca-be5a-3c102d9efa2a
# ╟─c9d7d036-783a-4c19-be68-79b58bc569f8
# ╟─5b51b5c3-6e7c-47af-8aa4-1630291274f1
# ╟─ac6eb76e-8a1b-4130-a2cb-b17b12b0cb66
# ╟─90c1379e-392b-4202-8710-43e20895b3b6
# ╟─4ceba7e2-fad1-4fb3-ac17-97569ed0d672
# ╟─702a769f-fc08-4b35-9491-f42182c83dc6
# ╠═6cdfa66c-7792-4631-b671-eb0c209c6149
# ╟─44e255be-5945-448a-b735-8bc0bb0c70bf
# ╟─b99a7cde-7353-4163-8fee-96d526192193
# ╟─13265cff-30a7-4694-a189-eb1d060bddde
# ╠═0e5ed47a-996d-4d6e-a489-762c92f5a360
# ╟─5592945c-2f14-4d70-8f85-d7cb9089309e
# ╟─d0be3e6d-5964-4aaf-b4cc-ef6159d717c6
# ╠═bd6c89c1-7cfa-4408-924c-af8886183913
# ╟─5f729a1f-2b37-4150-a107-65c0aca9bd4c
# ╟─1f1ea10c-891b-45a4-9df4-b4b84f973015
# ╠═c5acd471-a323-4dc1-8e9e-30ec070e35b3
# ╟─fd4769a1-9426-43b5-88a8-bc6aca18cbc8
# ╟─d018a1eb-9fb1-4420-b051-6582044dda3d
# ╠═076200ec-63b7-440f-b397-6698d7b46693
# ╟─6aff28d1-d044-4adc-a68a-7ca66d5e4990
# ╟─6d8342a8-9d57-4237-b253-c92069bf2bfd
# ╟─5167f2bd-12eb-4d13-bcd5-636f791c74be
# ╠═a531d37f-a9e1-4870-94d4-0517b575c9c5
# ╟─8ddb9961-278e-45fd-9c04-1e09f552a83a
# ╟─924680e5-50e8-41ea-b07e-e5cf07044c0b
# ╟─b30cbbe8-5c41-4918-bd08-d9b24d83070e
# ╟─cea16faf-a544-4d37-b6eb-2f92307d9ffa
# ╟─01d735f4-35f8-4aae-a223-2ba856681b10
# ╟─4d0813ec-cd67-4ab6-bd29-cc466fda1243
# ╟─aefd0523-28e4-42fa-a8eb-0b77345c287b
# ╟─4efb0354-052b-4be3-bec7-1e77822aa258
# ╟─ac91cf9a-229b-4f0c-821b-86452307c951
# ╠═a857b4c5-a739-4610-9a51-655fccf7d12d
# ╟─ff1a1594-de5c-4ada-a3b8-a25b2a03cb81
# ╟─78e14763-d39f-4645-b48e-f7c8e0e0c7f7
# ╟─6f7c306b-0a19-4472-a1d5-1ab8724bfb35
# ╠═7df556e0-ffbd-4c87-a6cb-bf9ce426803a
# ╠═00bc92f0-246b-436d-b760-2b2ee381a63e
# ╠═0edce2b0-08de-438b-b7e8-b2af409d4e5c
# ╟─53c0e594-432a-46b7-a0ef-4acaeb535f9e
# ╠═3d8f5893-dc6b-48c1-a644-3e8ac6636680
# ╠═d76c9d4f-d68e-4acd-b99d-829a5b131f14
# ╟─e3d35739-8394-482a-a1fa-38cfc0505b76
# ╟─1dfa13ff-af6c-48c0-aa82-9124ed1c131d
# ╟─cf50a10e-b8c7-4b8d-8de0-10d1a9c00d9b
# ╠═2e5d152b-da19-4cf4-88c1-c0387e99d91d
# ╠═a9d1ef99-3d58-42d9-a9e2-9e722f10ba9d
# ╠═ec162079-30aa-48e1-bcac-08c8b9ec1226
# ╠═9d40a049-ea65-468c-a5e2-6ef62c70b3a4
# ╠═bd111618-2298-40ae-be97-885468fb4d8d
# ╠═1d6993de-06ee-481f-8e6c-33ee21caf089
# ╟─6299d1bd-b3bd-4f7c-949a-b477024ace8a
# ╟─2401de4e-020e-45f5-a340-2178a167b41e
# ╟─8db54a5d-fa04-43e3-a115-585db749f211
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
