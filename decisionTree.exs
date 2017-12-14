defmodule DecisionTree do
  
  # Added types to future @spec annotations

  @type attName :: String.t
  @type attValue :: String.t
  @type attribute :: {attName, [attValue]}
  @type header :: [attribute]
  @type row :: [attValue]
  @type dataSet :: {header, [row]}
  @type partition :: [{attValue, dataSet}]

  @result %{"result" => ["good", "bad"]}

  def result(), do: @result

  @outlook %{"outlook" => ["sunny", "overcast", "rainy"]}

  def outlook(), do: @outlook
  
  @header  %{"outlook" => ["sunny", "overcast", "rainy"], "temp" => ["hot", "mild", "cool"], "humidity" => ["high", "normal"], "wind" => ["windy", "calm"], "result" => ["good", "bad"]}
  
  def header(), do: @header

  @table [["sunny",    "hot",  "high",   "calm",  "bad" ],
               ["sunny",    "hot",  "high",   "windy", "bad" ],
               ["overcast", "hot",  "high",   "calm",  "good"],
               ["rainy",    "mild", "high",   "calm",  "good"],
               ["rainy",    "cool", "normal", "calm",  "good"],
               ["rainy",    "cool", "normal", "windy", "bad" ],
               ["overcast", "cool", "normal", "windy", "good"],
               ["sunny",    "mild", "high",   "calm",  "bad" ],
               ["sunny",    "cool", "normal", "calm",  "good"],
               ["rainy",    "mild", "normal", "calm",  "good"],
               ["sunny",    "mild", "normal", "windy", "good"],
               ["overcast", "mild", "high",   "windy", "good"],
               ["overcast", "hot",  "normal", "calm",  "good"],
               ["rainy",    "mild", "high",   "windy", "bad" ]]

  def table(), do: @table

  @fishingData {@header, @table}

  def fishingData(), do: @fishingData

  @fig2 {:node, "outlook", [{"sunny", {:node, "humidity", [{"high", {:leaf, "bad"}}, {"normal", {:leaf, "good"}}]}}, {"overcast", {:leaf, "good"}}, {"rainy", {:node, "wind", [{"windy", {:leaf, "bad"}}, {"calm", {:leaf, "good"}}]}}]}

  def fig2(), do: @fig2
  def xlogx(d) do
    cond do
      d <= 1.0e-100 -> 0.0
      true -> d * :math.log2(d)  
    end
  end

  def allSame([]), do: true
  def allSame(list = [x | _xs]) do
    list |> Enum.map(fn(y) -> x == y end) |> Enum.all?
  end

  def remove(item, map), do: Map.delete(map, item)

  def lookUpAtt(att, h, r) do
    for x <- r,
        x in Map.get(h, att), do: x
  end

  def removeAtt(attN, h, r) do
    y = lookUpAtt(attN, h, r)
    for x <- r,
        not x in y, do: x
  end

  def buildFrequencyTable(attName, {_h, table} = _data) do
    # attribute has the name and the possible values
    name = hd Map.keys(attName)
    vals = attName[name]
    valuesToBuildTable = for y <- table,
      x <- vals,
      x in y,
      do: x
    %{} |> initialiseMap(vals) |> putValues(valuesToBuildTable)
  end

  defp initialiseMap(map, []), do: map
  defp initialiseMap(map, [x | xs]), do: initialiseMap(Map.put(map, x, 0), xs) 

  defp putValues(map, []), do: map
  defp putValues(map, [x | xs]), do: putValues(Map.put(map, x, Map.get(map, x) + 1), xs)

  def nodes({:null}), do: 0
  def nodes({:leaf, attval}), do: 1
  def nodes({:node, attname, list}) do
    1 + Enum.sum(for pair <- list,
                 do: pair |> snd |> nodes)
  end  
  
  defp snd(pair), do: elem(pair, 1)

end
