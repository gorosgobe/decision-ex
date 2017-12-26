defmodule InformationGainSelector do
   
  import Utils
  import DecisionTree

  @type attName :: String.t
  @type attValue :: String.t
  @type attribute :: {attName, [attValue]}
  @type dataSet :: {header, [row]}
  @type header :: [attribute]
  @type row :: [attValue]
   
  @behaviour AttSelector

  @impl AttSelector
  def nextAtt({h, _t} = dataset, classAtt) do
    listOfGains = for attribute <- h,
      attribute != classAtt, do: {gain(dataset, attribute, classAtt), attribute}
    listOfGains 
    |> Enum.map(fn(pair) -> fst pair end)
    |> Enum.max
    |> lookUp(listOfGains)
    |> snd
  end

  @spec entropy(dataSet, attribute) :: number()
  def entropy({_, []}, _), do: 0.0
  def entropy(dataset, attribute) do
    listOfProbs = for val <- (snd attribute),
                      prob = probability(dataset, attribute, val) do 
                        -xlogx(prob)
                      end
    listOfProbs |> Enum.sum
  end

  @spec probability(dataSet, attribute, attValue) :: number()
  def probability({_h, r} = dataset, attribute, value) do
    numRows = length r
    table = buildFrequencyTable attribute, dataset
    numx = snd (lookUp value, table)
    numx / numRows
  end

  @spec gain(dataSet, attribute, attribute) :: number()
  def gain(dataset, partitionAtt, classAtt) do
    edc = entropy(dataset, classAtt)
    totalSum = for val <- (snd partitionAtt),
      prob = probability(dataset, partitionAtt, val),
      part = snd(lookUp val, (partitionData dataset, partitionAtt)),
      ent = entropy(part, classAtt), do: prob * ent
    edc - Enum.sum totalSum
  end

end
