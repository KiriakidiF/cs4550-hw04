defmodule Practice.Factor do
	
	#returns normal factors of a number
	def factors(x, start \\ 2, res \\ []) do
		cond do
			start > x -> res
			rem(x,start)==0 ->
				factors(div(x, start), start, res ++ [start])
			true -> factors(x, start + 1, res)
		end
	end

	def prime_factors(x) do
		if x < 1 do
			:error
		else
			facts = factors(x)
			IO.inspect(facts)
			facts
		end
	end
end
			
