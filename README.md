# Constant Product Automated Market Maker

CPAMMs are the best option to swap coins in a decentralised way. This Automated Market Makers use a constant product invariant as an algorithm to set the prices, we will explain it using Uniswap as an example.

## Math behind
![alt text](https://github.com/XabierOterino/CPAMM/blob/main/img/1_nMZk7O7ANA1G2VOcsYs6Qw.png)

The graphic above shows Uniswap's reserve curve. The more we ignore the constant product the bigger the slippage is to mantain it constant. Let's analyze the most symple equation : (x) reserves times (y) reserves equals a constant (k).

```shell
x * y = k
```

Let's say our market maker has 1000 tokens (x) and 3000 tokens (y). We won't apply any fees for this example. Therefore, k is equal to 3000000.  What would a trader get for 400x? Lets fill the equation with the information : 

```shell
(1000 + 400) * y = 3000000
y = 3000000 / 1400
y = 2142.85
```

We've got 2142.5 y tokens as a result, but that is not what the trader is going to get, that is the (y) amount needed to fulfill the constant product. Then what the trader gets is the difference between the (y) amount we have and the amount that we should have(2142.5):

```shell
dy = 3000 - 2142.5
dy = 857
```
The trader gets 857 tokens.
