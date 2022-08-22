
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Purpose: A Monte Carlo simulation study to investigate the bias of the OLS 
		 estimators in the presence of endogeneity
		 

Created 8.22.2022


Hamza Mutluay

* * * * * * * * * * * * * * * ** * * * * * * ** * * * * * * ** * * * * * * * * */


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




