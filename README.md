# **ENDOGENEITY BIAS**

Endogeneity is a major problem in econometrics.It occurs when there is a correlation between explanatory variables and the error term. Endogeneity bias is said to occur in a regression model if $E(U|X_{i})\neq0$

There are three main sources of endogeneity:
* Omitted variables
* Measurement error
* Reverse causality

In the presence of endogeneity, the expected value of the OLS estimator is no longer equal to true population parameter.
In other words, the OLS estimator is biased. Even if the sample size gets bigger, OLS estimator does not converge in probability to the true value of the population parameter. 

## Simulation-Inconsistency of the OLS estimator
This do file below produces a Monte Carlo simulation of the inconsistent OLS estimator due to Endogeneity.

---
```stata
cls
clear 		all
se mo 		off, perm


se se 		199006 // Set the seed to reproduce the same output of simulation




*- Sample Sizes ----------------------------

numlist 	"100(900)10000" // Sample sizes
loc 		numlist `r(numlist)'
loc 		numlist :  subinstr loc numlist " " ",", all
mat			n_all = (`numlist')
loc     dim_col = colsof(n_all)
loc     dim_row = rowsof(n_all)
mat 		li n_all

*-------------------------------------------



*- Define the population parameters -------------------

loc 		beta0 = 10   
loc 		beta1 = 1    
loc 		beta2 = 1.5

*-------------------------------------------


loc 		rep = 5000 // Number of replications


*-------------------------------------------

*- Parameters of the variance-covariance matrix --------
*  of jointly distributed random variables 

loc 		sigma12 = 0   // Cov(x1,x2) = 0
loc 		sigma13 = 0   // Cov(x1,u) = 0
loc 		sigma23 = 0.5 // Cov(x2,u) = 0.5

*-------------------------------------------


loc 		epsilon = 0.05 // Any arbitrarily small positive number


*- Store the estimated beta in a matrix ----------------------

mat 		coef_matrix  = J(`dim_col',4,.)
di  		`dim_row' ,`dim_col'

*-------------------------------------------


forv 		t = 1/`dim_col' {

se 			obs `=n_all[`dim_row',`t']'
loc 		n = _N
	
mat 		betahat = J(`rep',3,.)


forv 		tt = 1/`rep' {
	
mat 		vector_mean = (0.5,0.5,0)
mat 		Covmatrix = (1,`sigma12',`sigma13' \ `sigma12',1, `sigma23' \ `sigma13',`sigma23',1)

drawnorm 	x1 x2 u, n(`n') cov(Covmatrix) m(vector_mean)


** Data Generating Process

g 			y = `beta0' + `beta1'*x1 + `beta2'*x2 + u


** Estimated Model

reg 		y x1 x2 

mat 		betahat[`tt',1] = r(table)[1,3]	// Constant
mat 		betahat[`tt',2] = r(table)[1,1]	// Beta1
mat 		betahat[`tt',3] = r(table)[1,2] // Beta2

drop 		y x1 x2 u
mat drop 	vector_mean Covmatrix

	
}

sca 		sum_betahat0 = 0
sca 		sum_betahat1 = 0 
sca 		sum_betahat2 = 0

forv 		i = 1/`rep' {

sca 		sum_betahat0 = sum_betahat0 + (abs(betahat[`i',1] - `beta0') < `epsilon')
sca 		sum_betahat1 = sum_betahat1 + (abs(betahat[`i',2] - `beta1') < `epsilon')
sca 		sum_betahat2 = sum_betahat2 + (abs(betahat[`i',3] - `beta2') < `epsilon')
}

mat 		coef_matrix[`t',1] = sum_betahat0/`rep'
mat 		coef_matrix[`t',2] = sum_betahat1/`rep'
mat 		coef_matrix[`t',3] = sum_betahat2/`rep'
mat 		coef_matrix[`t',4] = n_all[`dim_row',`t']	

}

mat			colname coef_matrix = betahat0 betahat1 betahat2 samplesize
mat li 		coef_matrix


svmat       coef_matrix, names(col)


scatter     betahat2 samplesize,  /*
			*/ title("Inconsistency of the OLS Estimator in the Presence of Endogeneity", size(*0.8)) /*
			*/ subtitle("X{subscript:j} is endogenous",height(3) size(*0.9)) /*
			*/ ylabel(0(0.20)1,nogrid) xlabel(100(900)10000) /*
			*/ ytitle("Probability", size(*0.9) height(8)) /*
			*/ xtitle("Sample size", size(*0.9) height(8)) /*
			*/ graphregion(col(white) lcolor(black) )  plotregion(col(white))

```
---
The figure below from the simulation study shows that the OLS estimator is inconsistent in the presence of Endogeneity.

<img width="785" alt="Combine1" src="https://user-images.githubusercontent.com/101017847/185812472-dc2a6e22-edcb-41ba-9058-2336022530b6.png">

## Simulation-Biased OLS estimator
This do file below produces a Monte Carlo simulation of the biased OLS estimator due to Endogeneity.

---
```stata
cls
clear 		all
se mo 		off,perm

se se 		19900612 // Set the seed to reproduce the same output of simulation



*- Sample size  ------

se obs 		100
loc 		n = _N
*----------------------

*- Define the population parameters -------

loc 		beta0 = 10
loc 		beta1 = 1
loc 		beta2 = 1.5
*-------------------------------------------

loc 		rep = 5000 // Number of replications


*-------------------------------------------

*- Parameters of the variance-covariance matrix 
*  of jointly distributed random variables 

loc 		sigma12 = 0   // Cov(x1,x2) = 0
loc 		sigma13 = 0   // Cov(x1,u) = 0
loc 		sigma23 = 0.5 // Cov(x2,u) = 0.5


*- Store the estimated beta in a matrix ----------------------

mat 		betahat = J(`rep',3,.)

*-------------------------------------------


forv 		t = 1/ `rep' {
	
mat 		vector_mean = (0.5,0.5,0)
mat 		Covmatrix = (1,`sigma12',`sigma13' \ `sigma12',1, `sigma23' \ `sigma13',`sigma23',1)

drawnorm 	x1 x2 u, n(`n') cov(Covmatrix) m(vector_mean)


** Data Generating Process

g 			y = `beta0' + `beta1'*x1 + `beta2'*x2 + u


** Estimated Model

reg 		y x1 x2

mat 		betahat[`t',1] = r(table)[1,3]	// Constant
mat 		betahat[`t',2] = r(table)[1,1]	// Beta1
mat 		betahat[`t',3] = r(table)[1,2] // Beta2

drop 		 y	x1 x2 u
mat drop 	vector_mean Covmatrix
 
}

sca 		sum_betahat0 = 0
sca 		sum_betahat1 = 0
sca 		sum_betahat2 = 0



forv 		i = 1 / `rep' {

sca 		sum_betahat0 = sum_betahat0 + betahat[`i',1]
sca 		sum_betahat1 = sum_betahat1 + betahat[`i',2]
sca 		sum_betahat2 = sum_betahat2 + betahat[`i',3]

}



sca 		bias_betahat0  = ((sum_betahat0/`rep') - `beta0')*100
sca 		bias_betahat1  = ((sum_betahat1/`rep') - `beta1')*100
sca 		bias_betahat2  = ((sum_betahat2/`rep') - `beta2')*100


di 			" Bias of betahat0 = " bias_betahat0
di 			" Bias of betahat1 = " bias_betahat1
di 			" Bias of betahat2 = " bias_betahat2
```
---
