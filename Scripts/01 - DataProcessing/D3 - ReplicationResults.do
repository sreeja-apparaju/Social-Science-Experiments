* **************************************************************************** *
* *** Global Setting ***                                                       *
* **************************************************************************** *
quietly {
	clear all
	set more off
	
	* number of studies
	global N = 21

	* assignment rates
	#delimit ;
		import 	delimited using
				"../../Data/Data Raw/Bayesian Analyses/AssignmentRates.csv";
		save   	"../../Data/Data Raw/Bayesian Analyses/AssignmentRates.dta", 
				replace;
	#delimit cr
	clear
	
	* Bayes factors
	#delimit ;
		import 	delimited using
				"../../Data/Data Raw/Bayesian Analyses/BayesFactors.csv", 
				case(preserve);
		save   	"../../Data/Data Raw/Bayesian Analyses/BayesFactors.dta", 
				replace;
	#delimit cr
	clear
	
}


* **************************************************************************** *
* *** Generate Variables ***                                                   *
* **************************************************************************** *
quietly {
	use     "../../Data/Data Processed/D1 - OriginalStudies.dta"
	
	global  stages  "rs1 rs2"
	global  results "rs1 rs2 rp"
	
	#delimit ;
	global  varlist "
			type   	stat   
			n      	in
			r      	r95l   	r95u
					r90l   	r90u
			rr     	rr95l  	rr95u
					rr90l  	rr90u
			rm 		rm95l  	rm95u
			rrm   	rrm95l 	rrm95u
					rp95l  	rp95u
					rrp95l 	rrp95u
			bfP0   	bfR0   	ar
			p      	pm     	pow    
			rep_sr 	rep_mr 	rep_st 
			rep_pi 	rep_bf
			";
	#delimit cr
	
	foreach j of global results {
		foreach k of global varlist {
			if "`k'" == "type" {
				gen `k'_`j' = "" 
			}
			else {
				gen `k'_`j' = .  
			}
		}
	}
}


* **************************************************************************** *
* *** Call Programms ***                                                       *
* **************************************************************************** *
quietly {
	do "../00 - Programs/P1 - Programs.do"
}


* **************************************************************************** *
* *** Set Test Statistics ***                                                  *
* **************************************************************************** *
quietly {	
	do  "D0 - SetTestStatistics.do"
}
	
	
* **************************************************************************** *
* *** Assign Statistics to Variables ***                                       *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
		foreach j of global stages {
			
			ParseInput ${s`i'_`j'}
			replace type_`j' = r(t)     if study == `i'
			replace stat_`j' = r(s)     if study == `i'
			replace n_`j'    = r(n)     if study == `i'
			replace in_`j'   = r(i)     if study == `i'
			
		}
	}
}
	


* **************************************************************************** *
* *** Effect Sizes, CIs, Meta Effects, Prediction Intervals, and Power ***     *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
		foreach j of global stages {
		
			* standardized effect sizes (r)
			EffectSize ${s`i'_`j'}
			replace r_`j'      = r(r)        if study == `i'

			* 95% confidence intervals around r
			ConfidenceInterval r_`j'[`i'] n_`j'[`i'] 0.05
			replace r95l_`j'   = r(lb)       if study == `i'
			replace r95u_`j'   = r(ub)       if study == `i'
			
			* 90% confidence intervals around r
			ConfidenceInterval r_`j'[`i'] n_`j'[`i'] 0.10
			replace r90l_`j'   = r(lb)       if study == `i'
			replace r90u_`j'   = r(ub)       if study == `i'
			
			* relative effect size (rr)
			replace rr_`j'     = r_`j' / r_os
			
			* 95% confidence intervals around rr
			replace rr95l_`j'  = r95l_`j' / r_os
			replace rr95u_`j'  = r95u_`j' / r_os
			
			* 90% confidence intervals around rr
			replace rr90l_`j'  = r90l_`j' / r_os
			replace rr90u_`j'  = r90u_`j' / r_os
			
			* meta effect size (rm)
			MetaEffect r_os[`i'] n_os[`i'] r_`j'[`i'] n_`j'[`i']
			replace rm_`j'     = r(r_meta)   if study == `i'
			replace pm_`j'     = r(p_meta)   if study == `i'
			
			* 95% confidence intervals around rm
			ConfidenceInterval r(r_meta) r(n_meta) 0.05
			replace rm95l_`j'  = r(lb)       if study == `i'
			replace rm95u_`j'  = r(ub)       if study == `i'
			
			* relative meta effect sizes (rrm)
			replace rrm_`j'    = rm_`j' / r_os
			
			* 95% confidence intervals around rrm
			replace rrm95l_`j' = rm95l_`j' / r_os
			replace rrm95u_`j' = rm95u_`j' / r_os
			
			* prediction intervals (pi)
			PredictionInterval r_os[`i'] n_os[`i'] n_`j'[`i'] 0.05
			replace rp95l_`j'  = r(lb)       if study == `i'
			replace rp95u_`j'  = r(ub)       if study == `i'
			replace rrp95l_`j' = rp95l_`j' / r_os
			replace rrp95u_`j' = rp95u_`j' / r_os
						
			* p-values (p)
			pValue ${s`i'_`j'}
			replace p_`j'      = r(p)        if study == `i'
			
			* statistical power of replication (pow)
			local e_rs1 = 75
			local e_rs2 = 50
			ReplicationPower ${s`i'_os} n_`j'[`i'] `e_`j''
			replace pow_`j'    = r(pow)      if study == `i'
			
			
			* export temporary file
			#delimit ;
			export 	delimited using 
					"../../Data/Data Processed/D3 - ReplicationResults.csv", 
					replace;
			#delimit cr
		}
	}
}


* **************************************************************************** *
* *** Replication Indicators ***                                               *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
		foreach j of global stages {

			* significant effect in same direction as original study
			replace rep_sr_`j'  = 1    if study == `i' & p_`j'[`i'] < 0.05
			replace rep_sr_`j'  = 0    if study == `i' & p_`j'[`i'] > 0.05
			replace rep_sr_`j'  = .    if study == `i' & p_`j'[`i'] == .
			
			* meta effect estimate significantly different from zero
			replace rep_mr_`j'  = 1    if study == `i' & rm95l_`j'[`i'] > 0
			replace rep_mr_`j'  = 0    if study == `i' & rm95l_`j'[`i'] < 0
			replace rep_mr_`j'  = .    if study == `i' & rm95l_`j'[`i'] == .
																		
			* replication effect not significantly smaller than small effect
			replace rep_st_`j'  = 1    if study == `i'                &   ///
										  r90u_`j'[`i'] > r33_os[`i'] 
			replace rep_st_`j'  = 0    if study == `i'                &   ///
										  r90u_`j'[`i'] < r33_os[`i'] 
			replace rep_st_`j'  = .    if study == `i'                &   ///
										  r_`j'[`i'] == .
																		
			* replication effect size within 95% prediction interval
			replace rep_pi_`j'  = 1    if study == `i'                &   ///
										  r_`j'[`i'] > rp95l_`j'[`i'] &   ///
										  r_`j'[`i'] < rp95u_`j'[`i']
			replace rep_pi_`j'  = 0    if study == `i'                & ( ///
										  r_`j'[`i'] < rp95l_`j'[`i'] |   ///
										  r_`j'[`i'] > rp95u_`j'[`i']   )
			replace rep_pi_`j'  = .    if study == `i'                &   ///
										  r_`j'[`i'] == .
																		
		}
	}
}


* **************************************************************************** *
* *** Determine Pooled Results ***                                             *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
		global varlist: subinstr global varlist "ar" ""
		global varlist: subinstr global varlist "bfP0" ""
		global varlist: subinstr global varlist "bfR0" ""
		
		foreach k of global varlist {
			if r_rs2[`i'] == . {
				replace `k'_rp = `k'_rs1  if study == `i'
			}
			else {
				replace `k'_rp = `k'_rs2  if study == `i'
			}
		}
	}
}


* **************************************************************************** *
* *** Determine Bayes Factors and Merge with Results Data ***                  *
* **************************************************************************** *
quietly {

	* merge/update
	#delimit ;
		merge	1:1 study using  
				"../../Data/Data Raw/Bayesian Analyses/BayesFactors.dta",  
				nogen update;
					 
		merge  	1:1 study using  
				"../../Data/Data Raw/Bayesian Analyses/AssignmentRates.dta",  
				nogen update;
					 
		drop   	bfP0_os;
	#delimit cr	
	
	* one-sided default Bayes factor > 1
	replace rep_bf_rp = 1  if bfP0_rp > 1
	replace rep_bf_rp = 0  if bfP0_rp < 1
	replace rep_bf_rp = .  if bfP0_rp == .
	
}


* **************************************************************************** *
* *** Data Preparation and Labeling ***                                        *
* **************************************************************************** *
quietly {
	foreach j of global results{
		if "`j'" == "rs1" {
			local i = "R-S1"
		}
		if "`j'" == "rs2" {
			local i = "R-S2"
		}
		if "`j'" == "rp" {
			local i = "RP"
		}
	
		* label variables
		label var type_`j'   "[`i'] Type of Test Statistic"
		label var stat_`j'   "[`i'] Statistic"
		label var n_`j'      "[`i'] Number of Observations"
		label var in_`j'     "[`i'] Number of Individuals"
		
		label var r_`j'      "[`i'] Stand. Effect Size (r)"
		label var r95l_`j'   "[`i'] Lower Bound of 95% CI Around r"
		label var r95u_`j'   "[`i'] Upper Bound of 95% CI Around r"
		label var r90l_`j'   "[`i'] Lower Bound of 90% CI Around r"
		label var r90u_`j'   "[`i'] Upper Bound of 90% CI Around r"
		
		label var rr_`j'     "[`i'] Relative Stand. Effect Size"
		label var rr95l_`j'  "[`i'] Lower Bound of 95% CI Around Relative r"
		label var rr95u_`j'  "[`i'] Upper Bound of 95% CI Around Relative r"
		label var rr90l_`j'  "[`i'] Lower Bound of 90% CI Around Relative r"
		label var rr90u_`j'  "[`i'] Upper Bound of 90% CI Around Relative r"
		
		label var rm_`j'     "[`i'] Meta Effect Size"
		label var rm95l_`j'  "[`i'] Lower Bound of 95% CI Around Meta r"
		label var rm95u_`j'  "[`i'] Upper Bound of 95% CI Around Meta r"
		
		label var rrm_`j'    "[`i'] Relative Meta Effect Size"
		label var rrm95l_`j' "[`i'] Lower Bound of 95% CI Around Relative Meta r"
		label var rrm95u_`j' "[`i'] Upper Bound of 95% CI Around Relative Meta r"
		
		label var rp95l_`j'  "[`i'] Lower Bound of 95% Prediction Interval"
		label var rp95u_`j'  "[`i'] Upper Bound of 95% Prediction Interval"
		label var rrp95l_`j' "[`i'] Lower Bound of 95% Relative Prediction Interval"
		label var rrp95u_`j' "[`i'] Upper Bound of 95% Relative Prediction Interval"
		
		label var bfP0_`j'   "[`i'] One-Sided Bayes Factor"
		label var bfR0_`j'   "[`i'] Replication Bayes Factor"
		label var ar_`j'     "[`i'] Posterior Assignment Rate"
		
		label var p_`j'      "[`i'] p-Value"
		label var pm_`j'     "[`i'] p-Value of Meta Effect"
		label var pow_`j'    "[`i'] Statistical Power"
		
		label var rep_sr_`j' "[`i'] Sign. Effect in Same Direction"
		label var rep_mr_`j' "[`i'] Meta Effect Sign. Different from Zero"
		label var rep_st_`j' "[`i'] Effect Size > Small Effect (Small Telescope)"
		label var rep_pi_`j' "[`i'] Effect Size Within Prediction Interval"
		label var rep_bf_`j' "[`i'] Replication Bayes Factor > 1"
		
	}
	
	* drop variables
	drop bfP0_rs* bfR0_rs* ar_rs* rep_bf_rs*
	
	* format variables
	format    %-10s      type_*
	format    %9.3f      stat_* p* r*
	format    %9.2f      bf* ar*
	format    %9.0f      rep*
}


* **************************************************************************** *
* *** Data Export ***                                                          *
* **************************************************************************** *
quietly {

	local file_path    "../../Data/Data Processed/D3 - ReplicationResults"
		
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace nolabel
	
	clear all
	
}
