# decision-ex
My first attempt at Elixir, a basic implementation of decision trees. 
Implementation based on the Decision Trees 2017 Haskell exam for first year Computing students at Imperial College London, course taught by Tony Field. 
Spec available at: https://www.doc.ic.ac.uk/~ajf/haskelltests/decisiontrees/spec.pdf

# How to use
Using the Elixir interpreter:

```elixir
$ iex decisionTree.exs
Erlang/OTP 20 [erts-9.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [kernel-poll:false]

Interactive Elixir (1.5.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> DecisionTree.buildTree DecisionTree.fishingData, DecisionTree.result, &DecisionTree.bestGainAtt/2
{:node, "outlook",
 [{"sunny", 
   {:node, "humidity",
    [{"high", {:leaf, "bad"}}, {"normal", {:leaf, "good"}}]}},
  {"overcast", {:leaf, "good"}},
  {"rainy",
   {:node, "wind", [{"windy", {:leaf, "bad"}}, {"calm", {:leaf, "good"}}]}}]}
```
