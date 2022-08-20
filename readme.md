**ENDOGENEITY BIAS**

Endogeneity is a mahor problem in econometrics.It occurs when there is correlation between explanatory variables and the error term. Endogeneity bias is said to occur in a regression model if

![](https://latex.codecogs.com/gif.latex?E%28U%7CX_i%29%5Cneq%200)

There are three main sources of endogeneity:
* Omitted variables
* Measurement error
* Reverse causality

Endogeneity biases causes that the expected value of OLS estimator is no longer equals to true population parameter,

![](https://latex.codecogs.com/gif.latex?E%28%5Chat%7B%5Cbeta%7D_%7BOLS%7D%29%5Cneq%20%7B%5Cbeta%7D)

In other words, the OLS estimator is biased and inconsistent. Even if the sample size gets bigger, OLS estimator does not tend to true parameter:

![](https://latex.codecogs.com/gif.latex?%5Chat%7B%5Cbeta%7D_%7BOLS%7D%5Cnrightarrow%20%7B%5Cbeta%7D)
