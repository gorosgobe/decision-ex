defmodule DecisionTree do
  
  import Utils

  @type attName :: String.t
  @type attValue :: String.t
  @type attribute :: {attName, [attValue]}
  @type header :: [attribute]
  @type row :: [attValue]
  @type dataSet :: {header, [row]}
  @type partition :: [{attValue, dataSet}]
  @type decisionTree :: {:null} | {:leaf, attValue} | {:node, attName, list({attValue, decisionTree})}

  @result {"result", ["good", "bad"]}

  def result(), do: @result

  @outlook {"outlook", ["sunny", "overcast", "rainy"]}

  def outlook(), do: @outlook
  
  @header  [{"outlook", ["sunny", "overcast", "rainy"]}, {"temp", ["hot", "mild", "cool"]}, {"humidity", ["high", "normal"]}, {"wind", ["windy", "calm"]}, {"result", ["good", "bad"]}]
  
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

  @spec lookUpAtt(attName, header, row) :: attValue
  def lookUpAtt(attName, h, r) do
   hd (for x <- r,
      x in (snd (lookUp(attName, h))), do: x)
  end

  @spec removeAtt(attName, header, row) :: row
  def removeAtt(attN, h, r) do
    y = lookUpAtt(attN, h, r)
    for x <- r,
        x != y, do: x
  end

  @spec buildFrequencyTable(attribute, dataSet) :: list({attValue, integer()})
  def buildFrequencyTable({_attName, vals}, {_h, table} = _data) do
    # attribute has the name and the possible values
    valuesToBuildTable = for y <- table,
      x <- vals,
      x in y,
      do: x
    initialiseToZero(vals -- valuesToBuildTable) |> putValues(valuesToBuildTable)
  end

  defp initialiseToZero(vals) do
    for val <- vals, do: {val, 0}
  end

  defp putValues(list, []), do: list
  defp putValues(list, [x | xs] = valuesToBuildTable) do
    if x not in (Enum.map(list, &fst(&1))) do
     # add with its total count
      putValues([{x, Enum.count(valuesToBuildTable, fn(item) -> item == x end)} | list], xs)
    else
      putValues(list, xs)
    end
  end
  
  @spec nodes(decisionTree) :: integer()
  def nodes({:null}), do: 0
  def nodes({:leaf, _attval}), do: 1
  def nodes({:node, _attname, list}) do
    1 + Enum.sum(for pair <- list,
                 do: pair |> snd |> nodes)
  end

  @spec evalTree(decisionTree, header, row) :: attValue
  def evalTree({:null}, _h, _r), do: ""
  def evalTree({:leaf, attval}, _h, _r), do: attval
  # assuming tree is well formed, will always match one branch
  def evalTree({:node, atname, [{value, decTree} | ps]}, h, r) do
    if value in r do
      evalTree(decTree, h, r)
    else
      evalTree({:node, atname, ps}, h, r)
    end
  end

  @spec partitionData(dataSet, attribute) :: partition
  def partitionData({h, t}, attToPartitionWith) do
    # returns partition :: [{attVal, dataset} | xs] 
    attName = getAttributeName attToPartitionWith

    for attval <- (snd attToPartitionWith),
      do: {attval, {remove(attName, h), (for row <- t, attval in row, do: removeAtt(attName, h, row))}} 
  end

  # return decision tree
  @spec buildTree(dataSet, attribute, module()) :: decisionTree
  def buildTree({_, []}, _, _), do: {:null}
  def buildTree({h, t} = dataset, classificationAtt, attSelector) do
    if allSame(for row <- t, do: lookUpAtt((fst classificationAtt), h, row)) do
      {:leaf, lookUpAtt((fst classificationAtt), h, hd t)}
    else
      att = attSelector.nextAtt(dataset, classificationAtt)
      partitions = partitionData(dataset, att)
      {:node, (getAttributeName att), buildTreePartitions(partitions, classificationAtt, attSelector)}
    end
  end

  defp getAttributeName(att), do: fst att
  defp buildTreePartitions([], _, _), do: []
  defp buildTreePartitions([{pattVal, pdataset} | ps], classAtt, attSelector) do
    [{pattVal, buildTree(pdataset, classAtt, attSelector)} | buildTreePartitions(ps, classAtt, attSelector)]
  end

end
