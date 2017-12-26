defmodule NaiveAttSelector do

  import Utils
  
  @behaviour AttSelector

  @impl AttSelector
  def nextAtt({h, _t}, att) do
    attName = fst att
    h |> Enum.filter(fn(item) -> (fst item) != attName end) |> hd
  end

end
