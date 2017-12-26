defmodule AttSelector do
  
  @type attName :: String.t
  @type attValue :: String.t
  @type attribute :: {attName, [attValue]}
  @type dataSet :: {header, [row]}
  @type header :: [attribute]
  @type row :: [attValue]

  @callback nextAtt(dataSet, attribute) :: attribute
end
