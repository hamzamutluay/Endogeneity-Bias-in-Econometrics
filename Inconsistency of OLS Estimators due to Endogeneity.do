
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Purpose: A Monte Carlo simulation study to investigate the inconsistency of the 
			OLS estimators in the presence of endogeneity
		 

Created 8.22.2022


Hamza Mutluay

* * * * * * * ** * * * * * * ** * * * * * * ** * * * * * * ** * * * * * * * * */


cls
clear 		all
se mo 		off, perm


se se 		199006 // Set the seed to reproduce the same output of simulation




*- Sample Sizes ----------------------------

numlist 	"100(900)10000" // Sample sizes
loc 		numlist `r(numlist)'
loc 		numlist :  subinstr loc numlist " " ",", all
mat			n_all = (`numlist')
loc         dim_col = colsof(n_all)
loc         dim_row = rowsof(n_all)
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




