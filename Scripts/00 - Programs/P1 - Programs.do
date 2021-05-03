program drop _all


* ############################################################################ *
* ### Concatenate Type of Test Statistics ###                                  *
* ############################################################################ *

quietly {
	program ParseInput, rclass
		
		* Program Arguments
		* ------------------------------------------------------------------------ *
		args stat ttype df1 df2 n in
		
		* stat  > test statistic
		* ttype > type of test statistic (1 = z, 2 = t, 3 = F, 4 = chi2)
		* df1   > degrees of freedom 1 (only for F-statistics)
		* df2   > degrees of freedom 2 (for t, F, and chi2-statistics)
		* n     > number of observations
		* in    > number of individuals

		
		* Concatenate Type of Test Statistics
		* ------------------------------------------------------------------------ *
		if `ttype' == . {
			local t "n/a"
		}
		if `ttype' == 1 {
			local t "z"
		}
		if `ttype' == 2 {
			local t "t(`df2')"
		}
		if `ttype' == 3 {
			local t "F(`df1',`df2')"
		}
		if `ttype' == 4 {
			local t "Chi2(`df2')"
		}
		
		* Return
		* ------------------------------------------------------------------------ *
		return local  t    `t'
		return scalar s  = `stat'
		return scalar n  = `n'
		return scalar i  = `in'
		
	end
}





* ############################################################################ *
* ### Determine Standardized Effect Size based on Test Statistics ###          *
* ############################################################################ *

quietly {
	program EffectSize, rclass

		* Program Arguments
		* ------------------------------------------------------------------------ *
		args stat ttype df1 df2 n in
		
		* stat  > test statistic
		* ttype > type of test statistic (1 = z, 2 = t, 3 = F, 4 = chi2)
		* df1   > degrees of freedom 1 (only for F-statistics)
		* df2   > degrees of freedom 2 (for t, F, and chi2-statistics)
		* n     > number of observations
		* in    > number of individuals

		
		* Convert Test statistics
		* ------------------------------------------------------------------------ *
		
		* F(1, df2) >>> t(df)
		if `ttype' == 3 {
			local stat  = sqrt(abs(`stat'))*sign(`stat')
			local ttype = 2
		}
		
		* Chi2(1) >>> Z
		if `ttype' == 4 {
			local stat  = sqrt(abs(`stat'))*sign(`stat')
			local ttype = 1
		}
		
		
		* Calculate Standardized Effect Size (r)
		* ------------------------------------------------------------------------ *
		if `ttype' == . {
			local r = .
		}
		if `ttype' == 1 {
			local r = tanh(abs(`stat')*sqrt(1/(`n'-3)))*sign(`stat')
		}
		
		if `ttype' == 2 {
			local r = sqrt(abs(`stat')^2/(`stat'^2+`df2'))*sign(`stat')
		}
		
		
		* Return 
		* ------------------------------------------------------------------------ *
		return scalar r         = `r'
		return scalar ttype_con = `ttype'  // Converted Type
		return scalar stat_con  = `stat'   // Converted Test Statistic
		
	end
}





* ############################################################################ *
* ### Determine Confidence Intervals around `r' ###                            *
* ############################################################################ *

quietly {
	program ConfidenceInterval, rclass

		* Program Arguments
		* ------------------------------------------------------------------------ *
		args r n p
		
		* r     > correlation coefficient r
		* n     > number of observations
		* p     > probability; (1-p)% CIs

		
		* Calculate Lower and Upper Bound of CI
		* ------------------------------------------------------------------------ *
		if `r' == . {
			local lb = .
			local ub = .
		}
		else {
			local lb = tanh(atanh(`r') - invnormal(1-(`p'/2)) * sqrt(1/(`n'-3)))
			local ub = tanh(atanh(`r') + invnormal(1-(`p'/2)) * sqrt(1/(`n'-3)))
		}
	
		
		* Return Confidence Interval
		* ------------------------------------------------------------------------ *
		return scalar lb = `lb'
		return scalar ub = `ub'
		
	end
}





* ############################################################################ *
* ### Determine p-Values ###                                                   *
* ############################################################################ *

quietly {
	program pValue, rclass

		* Program Arguments
		* ------------------------------------------------------------------------ *
		args stat ttype df1 df2 n in
		
		* stat  > test statistic
		* ttype > type of test statistic (1 = z, 2 = t, 3 = F, 4 = chi2)
		* df1   > degrees of freedom 1 (only for F-statistics)
		* df2   > degrees of freedom 2 (for t, F, and chi2-statistics)
		* n     > number of observations
		* in    > number of individuals

		
		* Convert Test statistics
		* ------------------------------------------------------------------------ *
		
		* F(1, df2) >>> t(df)
		if `ttype' == 3 {
			local stat  = sqrt(abs(`stat'))*sign(`stat')
			local ttype = 2
		}
		
		* Chi2(1) >>> Z
		if `ttype' == 4 {
			local stat  = sqrt(abs(`stat'))*sign(`stat')
			local ttype = 1
		}
		
		
		* Calculate Standardized Effect Size (r)
		* ------------------------------------------------------------------------ *
		if `ttype' == . {
			local p = .
		}
		if `ttype' == 1 {
			local p = normal(-abs(`stat')) * 2
		}
		
		if `ttype' == 2 {
			local p = t(`df2', -abs(`stat')) * 2
		}
		
		
		* Return p-Value
		* ------------------------------------------------------------------------ *
		return scalar p = `p'
		
	end
}





* ############################################################################ *
* ### Prediction Intervals Around r ###                                        *
* ############################################################################ *

quietly {
	program PredictionInterval, rclass

		* Program Arguments
		* ------------------------------------------------------------------------ *
		args r_os n_os n_rs p
		
		* r_os  > correlation coefficient r of original study
		* n_os  > number of observations of original study
		* n_rs  > number of observations of replication study
		* p     > probability; (1-p)% PIs
		
		
		* Calculate Fisher's z and Variance of z
		* ------------------------------------------------------------------------ *
		local z_os    = atanh(`r_os')
		local zvar_os = 1/(`n_os'-3)
		local zvar_rs = 1/(`n_rs'-3)

		
		* Calculate Lower and Upper Bound of Prediction Interval
		* ------------------------------------------------------------------------ *
		if `n_rs' == . {
			local lb = .
			local ub = .
		}
		else {
			local lb = tanh(`z_os' - invnormal(1-(`p'/2)) * sqrt(`zvar_os'+`zvar_rs'))
			local ub = tanh(`z_os' + invnormal(1-(`p'/2)) * sqrt(`zvar_os'+`zvar_rs'))
		}
		
	
		* Return Prediction Interval
		* ------------------------------------------------------------------------ *
		return scalar lb = `lb'
		return scalar ub = `ub'

	end
}





* ############################################################################ *
* ### Fixed-Effects Weighted Meta Result ###                                   *
* ############################################################################ *

quietly {
	program MetaEffect, rclass
	
		* Program Arguments
		* ------------------------------------------------------------------------ *
		args r_os n_os r_rs n_rs
		
		* r_os  > correlation coefficient r of original study
		* n_os  > number of observations of original study
		* r_rs  > correlation coefficient r of replication study
		* n_rs  > number of observations of replication study

		
		* Determine Weights
		* ------------------------------------------------------------------------ *
		local w_os = `n_os'-3
		local w_rs = `n_rs'-3
		
		
		* Transform Correlation Coefficients to Fisher's z
		* ------------------------------------------------------------------------ *
		local z_os = atanh(`r_os')
		local z_rs = atanh(`r_rs')
		
		
		* Compute Weighted Fisher's z and Transform to Correlation Coefficient
		* ------------------------------------------------------------------------ *
		local z_meta = (`w_os'*`z_os' + `w_rs'*`z_rs') / (`w_os' + `w_rs')
		local r_meta = tanh(`z_meta')
		
		local n_meta = `n_os' + `n_rs' - 3
		
		
		* Determine p-Value of Meta Effect Size
		* ------------------------------------------------------------------------
		local t_meta = `r_meta' / sqrt((1 - `r_meta'^2) / (`n_meta' - 2))
		local p_meta = 2 * ttail(`n_meta' - 2, `t_meta')
	
		* Return Meta-Effect
		* ------------------------------------------------------------------------ *
		return scalar r_meta = `r_meta'
		return scalar n_meta = `n_meta'
		return scalar p_meta = `p_meta'

	end
}





* ############################################################################ *
* ### Small Telescope Approach ###                                   *
* ############################################################################ *

quietly {	
	program TempPow, rclass
	
		* Program Arguments
		* ------------------------------------------------------------------------ *
		args r n p
		
		local ttt = invt(`n'-2, 1-`p'/2)
		local r   = abs(`r')
		local rc  = sqrt(`ttt'^2 / (`ttt'^2 + `n' - 2))
		local zrc = atanh(`rc')
		local zr  = atanh(`r') + `r' / (2 * (`n'-1))
		
		* Temporary Power for Iteration
		* ------------------------------------------------------------------------ *
		local pow = normal((`zr'-`zrc') * sqrt(`n'-3)) + ///
								normal((-`zr'-`zrc') * sqrt(`n'-3))
		
		* Return Temporary Power Estimate
		* ------------------------------------------------------------------------ *
		return scalar temp_pow = `pow'
		
	end


	program SmallTelescope, rclass
	
		* Program Arguments
		* ------------------------------------------------------------------------ *
		args n_os pow p
		
		* n_os  > sample size of original study
		* pow   > power for small effects (1/3)
		* p     > probability level

		
		* Iteratively Determine Effect Size for 'pow'% Power
		* ------------------------------------------------------------------------ *
		local temp_r = 0
		local temp_pow = 0
		
		while abs(`pow' - `temp_pow') >= 0.001 & `temp_r' < 1 {
			TempPow `temp_r' `n_os' `p'
			local temp_pow = r(temp_pow)
			local temp_r   = `temp_r' + 0.0001
			dis "temporary power: `temp_pow'"
			dis "temporary r:     `temp_r'"
		}
		
		local r_se = `temp_r'
	
	
		* Return Effect Size for Small Effect
		* ------------------------------------------------------------------------ *
		return scalar r_se = `r_se'

	end
}





* ############################################################################ *
* ### Statistical Power of Replication Study ###                               *
* ############################################################################ *

quietly {
	program ReplicationPower, rclass
	
		* Program Arguments
		* ------------------------------------------------------------------------ *
		args stat ttype df1 df2 n in n_rs e
		
		* stat  > test statistic of original study
		* ttype > type of test statistic (1 = z, 2 = t, 3 = F, 4 = chi2)
		* df1   > degrees of freedom 1 (only for F-statistics)
		* df2   > degrees of freedom 2 (for t, F, and chi2-statistics)
		* n     > number of observations of original study
		* in    > number of individuals
		* n_rs  > number of observations of replication study
		* e     > percentage of original effect size
				
		
		* Run <EffectSize> Program to Determine `r'
		* ------------------------------------------------------------------------ *
		EffectSize `stat' `ttype' `df1' `df2' `n'
		local r     = r(r)
		local ttype = r(ttype_con)
		local stat  = r(stat_con)
		
		
		* Calculate Effect Size for `e'% of Original Effect Size
		* ------------------------------------------------------------------------ *
		if `ttype' == 1 {
			local r`e' = atanh(`e'/100*`r')*sqrt(`n'-3)
		}
		
		if `ttype' == 2 {
			local r`e' = sign(`e'/100*`r')*((1/(`e'/100*`r')^2-1)/`df2')^(-0.5)
		}
		
		
		* Calculate Power for Replication Result
		* ------------------------------------------------------------------------ *
		if `ttype' == . {
			local pow = .
		}
		
		* Z-Statistics (incl. converted Chi2-statistics)
		if `ttype' == 1 {
			local pow = 1 - normal(invnormal(0.975) -            ///
									`r`e''/sqrt(`n') * sqrt(`n_rs'))
		}
		
		* t-Statistics (incl. converted F-statistics)
		if `ttype' == 2 {
			local pow = 1 - t(`n_rs'-2, invt(`n_rs'-2, 0.975) -  ///
									`r`e''/sqrt(`n') * sqrt(`n_rs'))
		}
		
		
		* Return Power of Replication Result
		* ------------------------------------------------------------------------ *
		return scalar pow = `pow'

	end
}





* ############################################################################ *
* ### Replication Sample Sizes to Detect p% of Original Effect Size ###        *
* ############################################################################ *

quietly {
	program ReplicationSampleSize, rclass

		* Program Arguments
		* ------------------------------------------------------------------------ *
		args stat ttype df1 df2 n in pow e p
		
		* stat  > test statistic
		* ttype > type of test statistic (1 = z, 2 = t, 3 = F, 4 = chi2)
		* df1   > degrees of freedom 1 (only for F-statistics)
		* df2   > degrees of freedom 2 (for t, F, and chi2-statistics)
		* n     > number of observations
		* in    > number of individuals
		* pow   > statistical power to detect p
		* e     > percentage of original effect size
		* p     > significance level
		
		
		* Run <EffectSize> Program to Determine `r'
		* ------------------------------------------------------------------------ *
		EffectSize `stat' `ttype' `df1' `df2' `n'
		local r     = r(r)
		local ttype = r(ttype_con)
		local stat  = r(stat_con)
		
		
		* Calculate Effect Size for `e'% of Original Effect Size
		* ------------------------------------------------------------------------ *
		if `ttype' == 1 {
			local r`e' = atanh(`e'/100*`r')*sqrt(`n'-3)
		}
		
		if `ttype' == 2 {
			local r`e' = sign(`e'/100*`r')*((1/(`e'/100*`r')^2-1)/`df2')^(-0.5)
		}
		
		
		* `n' for `pow'% Power to Detect `e'% of `r' at `p'% significance level
		* ------------------------------------------------------------------------ *
		if `ttype' == . {
			local n_e = .
		}
		
		
		* Z-Statistics (incl. converted Chi2-statistics)
		* ------------------------------------------------------------------------ *
		if `ttype' == 1 {
			local n_e = ceil(((invnormal(1-`p'/2)-  ///
									invnormal(1-`pow'/100))*    ///
									sqrt(`n')/`r`e'')^2)
		}
		
		* Approximation for t-Statistics (incl. converted F-statistics)
		* ------------------------------------------------------------------------ *
		if `ttype' == 2 {
			local pi = 0
			local ne = 10
			
			while `pi' < `pow'/100 {
				local pi = 1-t(`ne'-2,invt(`ne'-2,1-`p'/2)-  ///
									 `r`e''/sqrt(`n')*sqrt(`ne'))
									 
				local `++ne'
			}
			local n_e = `ne'
		}

		
		* Return Sample Size for `pow'% Power to detect `e'% of `r'
		* ------------------------------------------------------------------------ *
		return scalar n`e' = `n_e'

	end
}

