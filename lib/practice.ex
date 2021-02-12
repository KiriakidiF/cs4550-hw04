defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def double(x) do
		cond do
			is_number(x) -> 2 * x
			true -> :error
		end
  end

  def calc(expr) do
    # This is more complex, delegate to lib/practice/calc.ex
    Practice.Calc.calc(expr)
  end

  def factor(x) do
    # Maybe delegate this too.
		if is_integer(x) do
			Practice.Factor.prime_factors(x)
		else
			Practice.Factor.prime_factors(elem(Integer.parse(x),0))
		end
		
    #[1,2,x]
  end

	def palindrome(word) do
		word == String.reverse(word)	
	end
end
