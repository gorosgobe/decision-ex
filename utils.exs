defmodule Utils do

  def allSame([]), do: true
  def allSame(list = [x | _xs]) do
    list |> Enum.map(fn(y) -> x == y end) |> Enum.all?
  end

  def remove(_, []), do: []
  def remove(x, ps) do
    for p <- ps,
      x != (fst p), 
      do: p
  end

  def lookUp(x, pairList) do
    # returns the first one, assumes there is always one match
    pairList |> Enum.filter(fn(pair) -> x == fst pair end) |> hd
  end

  def xlogx(d) do
    cond do
      d <= 1.0e-100 -> 0.0
      true -> d * :math.log2(d)  
    end
  end

  def snd(pair), do: elem(pair, 1)
  def fst(pair), do: elem(pair, 0)
end
