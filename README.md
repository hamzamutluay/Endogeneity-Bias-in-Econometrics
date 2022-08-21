**ENDOGENEITY BIAS**

Endogeneity is a major problem in econometrics.It occurs when there is a correlation between explanatory variables and the error term. Endogeneity bias is said to occur in a regression model if $E(U|X_{i})\neq0$

There are three main sources of endogeneity:
* Omitted variables
* Measurement error
* Reverse causality

Endogeneity bias causes that the expected value of OLS estimator is no longer equals to true population parameter: $E(\hat\beta_{OLS})\neq\beta$

In other words, the OLS estimator is biased and inconsistent. Even if the sample size gets bigger, OLS estimator does not converge in probability to the true value of the population parameter: $plim(\hat\beta_{OLS})\neq\beta$

The figure below shows the consistency of the OLS estimator in the presence or absence of endogeneity

<img width="785" alt="Combine1" src="https://user-images.githubusercontent.com/101017847/185812472-dc2a6e22-edcb-41ba-9058-2336022530b6.png">



