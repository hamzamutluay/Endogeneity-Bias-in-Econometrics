**ENDOGENEITY BIAS**

Endogeneity is a major problem in econometrics.It occurs when there is correlation between explanatory variables and the error term. Endogeneity bias is said to occur in a regression model if $E(U|X_{i})\neq0$

There are three main sources of endogeneity:
* Omitted variables
* Measurement error
* Reverse causality

Endogeneity biase causes that the expected value of OLS estimator is no longer equals to true population parameter: $E(\hat\beta_{OLS})\neq\beta$

In other words, the OLS estimator is biased and inconsistent. Even if the sample size gets bigger, OLS estimator does not tend to true parameter: $plim(\hat\beta_{OLS})\neq\beta$

The figure below shows the sampling distribution of the estimator in case of weak and strong endogeneity

<img src="https://user-images.githubusercontent.com/101017847/185761039-758b383e-55fc-44bc-81d7-1c083829d86a.png" width="800" height="800">


