defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

	# Handles tagging a number or operator
	# with the coresponding tag :num or :op
	def tokenize(item) do
		if Enum.any?(["+", "-", "*", "/"], fn(i) -> i == item end) do
			{:op, item}
		else
			{:num, parse_float(item)}
		end
	end

	# helper for convert_to_postfix
	# accumulate the result of possibly multiple operation comparisons and accumulate
	# resulting list to append to answer as well as the new temporary operations
	def compareOps(op, accRes) do
		# if no stored temp operators, add current operator
		if [] == accRes[:temp] do 
			[appnd: accRes[:appnd], temp: [op]]
		else
			#priority of operators, idea from https://www.digitalocean.com/community/conceptual_articles/understanding-order-of-operations
			order = %{"*" => 2, "/" => 2, "+" => 1, "-" => 1}

			opStr = elem(op, 1)
			fstTmp = elem(hd(accRes[:temp]), 1)
			cond do
				# higher priority operator gets pushed to front of temp list
				order[opStr] > order[fstTmp] -> 
					[appnd: accRes[:appnd], temp: [op | accRes[:temp]]]
				order[opStr] == order[fstTmp] -> 
					[appnd: accRes[:appnd] ++ [hd(accRes[:temp])], temp: [op | tl(accRes[:temp])]]
				order[opStr] < order[fstTmp] ->
					compareOps(op, [appnd: accRes[:appnd] ++ [hd(accRes[:temp])], temp: tl(accRes[:temp])])
			end
		end
	end


	# converts a list of tokenized operators and operands into postfix
	def convert_to_postfix(expr, tempOps \\ []) do
		case expr do
			[] -> tempOps
			[{:op, op} = head | tail] -> 
				IO.inspect(tempOps)
				res = compareOps(head, [appnd: [], temp: tempOps])
				res[:appnd] ++ convert_to_postfix(tail, res[:temp])
			[{:num, num} = head | tail] -> [head | convert_to_postfix(tail, tempOps)]
		end
	end

	def evalExpr(expr) do
		case hd(expr) do		
			{:num, x} -> {x, tl(expr)}	
			{:op, op} ->
				firstEval = evalExpr(tl(expr))
				firstNum = elem(firstEval, 0)
				secondEval = evalExpr(elem(firstEval, 1)) 
				secondNum = elem(secondEval,0)
				retExpr = elem(secondEval,1)
				case op do
					"*" -> {firstNum * secondNum, retExpr}
					"/" -> {secondNum / firstNum, retExpr}
					"+" -> {secondNum + firstNum, retExpr}
					"-" -> {secondNum - firstNum, retExpr}
				end
			end
	end


  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
		|> Enum.map(fn (n) -> tokenize(n) end)
		|> convert_to_postfix
		|> Enum.reverse
		|> IO.inspect
		|> evalExpr
		|> elem(0)

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
