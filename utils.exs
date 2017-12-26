defmodule Utils do
  
  @spec allSame(list()) :: boolean()
  def allSame([]), do: true
  def allSame(list = [x | _xs]) do
    list |> Enum.map(fn(y) -> x == y end) |> Enum.all?
  end

  @spec remove(term(), list()) :: list()
  def remove(_, []), do: []
  def remove(x, ps) do
    for p <- ps,
      x != (fst p), 
      do: p
  end

  @spec lookUp(term(), list({term(), term()})) :: {term(), term()}
  def lookUp(x, pairList) do
    # returns the first one, assumes there is always one match
    pairList |> Enum.filter(fn(pair) -> x == fst pair end) |> hd
  end

  @spec xlogx(number()) :: number()
  def xlogx(d) do
    cond do
      d <= 1.0e-100 -> 0.0
      true -> d * :math.log2(d)  
    end
  end

  @spec snd({term(), term()}) :: term()
  def snd(pair), do: elem(pair, 1)

  @spec fst({term(), term()}) :: term()
  def fst(pair), do: elem(pair, 0)
end
