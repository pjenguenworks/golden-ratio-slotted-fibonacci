# Golden Ratio - Slotted Fibonacci Growth


"We call “Fibonacci-Like” sequences, algorithmically-defined sequences formed using patterns of the following type: F_n = a_n-1 * F_n-1 + a_n-2 * F_n-2 + … + a_n-k * F_n-k. However, we noticed that we could also create “Slotted Fibonacci-Like” sequences where instead of picking previous values from the sequences in our recursive definition, we add (potentially multiples of) a selection of values (which we call a ‘scoop’) from a fixed set of registers. The registers are put into an array from which we study the patterns of growth of the distinct numbers we obtain. We further study related equations, alternate interpretations, and behaviors (including their bases of growth) of our sequences."


Pluto.jl Notebooks for "Base of Growth in Slotted Fibonacci Sequence, implemented in Julia Programming Language" by Ryan D. Holm, Apeiron lecture April 2023 at Washburn University.


```jl

import Pluto
Pluto.run()

```
