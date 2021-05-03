* **************************************************************************** *
* *** Global Setting ***                                                       *
* **************************************************************************** *
quietly {
	clear all
	set more off

	* number of studies
	global  N = 21
	
	* run programs
	do  "../00 - Programs/P1 - Programs.do"
	
	use "../../Data/Data Processed/D3 - ReplicationResults.dta"
	drop bf* ar_* pow_*
}


* ******************************************************************************
* Update Results Based on t-Tests (for Studies Using z-Statistics)
* ******************************************************************************

* Balafoutas and Sutter
* ------------------------------------------------------------------------------
quietly {

	* Original Study
	global n1 = 36
	global m1 = 11/36
	global s1 = sqrt(11/35 * 25/36)

	global n2 = 36
	global m2 = 21/36
	global s2 = sqrt(21/35 * 15/36)

	ttesti $n1 $m1 $s1 $n2 $m2 $s2,
	
	replace stat_os = abs(r(t))   if study == 3
	replace type_os = "t(70)"     if study == 3
	replace p_os    = r(p)        if study == 3	

	* Relication
	global n1 = 120
	global m1 = 44/120
	global s1 = sqrt(44/119 * 76/120)

	global n2 = 123
	global m2 = 63/123
	global s2 = sqrt(63/122 * 60/123)

	ttesti $n1 $m1 $s1 $n2 $m2 $s2
	
	replace stat_rs1 = abs(r(t))  if study == 3
	replace type_rs1 = "t(70)"    if study == 3
	replace p_rs1    = r(p)       if study == 3

}

* Derex et al
* ------------------------------------------------------------------------------
quietly {
	
	* Original Study
	preserve
		clear
		set obs 51
		gen id = _n
		
		gen groupsize = .	
		replace groupsize = 2  if id <= 15
		replace groupsize = 4  if id <= 27 & id > 15
		replace groupsize = 8  if id <= 39 & id > 27
		replace groupsize = 16 if id <= 51 & id > 39
		
		gen bothtasks = 0
		replace bothtasks = 1  if id <= 3            & groupsize == 2
		replace bothtasks = 1  if id <= 19 & id > 15 & groupsize == 4
		replace bothtasks = 1  if id <= 37 & id > 27 & groupsize == 8
		replace bothtasks = 1  if id <= 50 & id > 39 & groupsize == 16

		reg bothtasks groupsize
		local t = _b[groupsize] / _se[groupsize]
		local p = 2 * ttail(e(df_r), abs(`t'))
	restore
	
	replace stat_os = abs(`t')   if study == 4
	replace type_os = "t(49)"    if study == 4
	replace p_os    = `p'        if study == 4
	
	* Replication
	preserve
		clear
		set obs 65
		gen id = _n

		gen groupsize = .	
		replace groupsize = 2  if id <= 17
		replace groupsize = 4  if id <= 33 & id > 17
		replace groupsize = 8  if id <= 49 & id > 33
		replace groupsize = 16 if id <= 65 & id > 49

		gen bothtasks = 0
		replace bothtasks = 1  if id <= 5            & groupsize == 2
		replace bothtasks = 1  if id <= 27 & id > 17 & groupsize == 4
		replace bothtasks = 1  if id <= 48 & id > 33 & groupsize == 8
		replace bothtasks = 1  if id <= 63 & id > 49 & groupsize == 16

		reg bothtasks groupsize
		local t = _b[groupsize] / _se[groupsize]
		local p = 2 * ttail(e(df_r), abs(`t'))
	restore
	
	replace stat_rs1 = abs(`t')  if study == 4
	replace type_rs1 = "t(63)"   if study == 4
	replace p_rs1    = `p'       if study == 4
	
}

* Gneezy et al
* ------------------------------------------------------------------------------
quietly {

	* Original Study
	global n1 = 87
	global m1 = 43/87
	global s1 = sqrt(43/86 * 44/87)

	global n2 = 91
	global m2 = 65/91
	global s2 = sqrt(65/90 * 26/91)

	ttesti $n1 $m1 $s1 $n2 $m2 $s2,
	
	replace stat_os = abs(r(t))   if study == 7
	replace type_os = "t(176)"    if study == 7
	replace p_os    = r(p)        if study == 7

	* Relication
	global n1 = 205
	global m1 = 113/205
	global s1 = sqrt(113/204 * 92/205)

	global n2 = 202
	global m2 = 147/202
	global s2 = sqrt(147/201 * 55/202)

	ttesti $n1 $m1 $s1 $n2 $m2 $s2
	
	replace stat_rs1 = abs(r(t))  if study == 7
	replace type_rs1 = "t(405)"   if study == 7
	replace p_rs1    = r(p)       if study == 7
	
}

* Janssen et al
* ------------------------------------------------------------------------------
quietly {

	* Original Study
	global n1 = 15
	global m1 = 441.3333
	global s1 =  51.9789

	global n2 = 48
	global m2 = 278.2917
	global s2 =  30.3903

	ttesti $n1 $m1 $s1 $n2 $m2 $s2,
	
	replace stat_os = abs(r(t))   if study == 9
	replace type_os = "t(61)"     if study == 9
	replace p_os    = r(p)        if study == 9

	* Relication
	global n1 = 9
	global m1 = 403.0000
	global s1 =  46.5537

	global n2 = 33
	global m2 = 360.1515
	global s2 =  47.3822

	ttesti $n1 $m1 $s1 $n2 $m2 $s2
	
	replace stat_rs1 = abs(r(t))  if study == 9
	replace type_rs1 = "t(40)"    if study == 9
	replace p_rs1    = r(p)       if study == 9
	
}

* Rand et al
* ------------------------------------------------------------------------------
quietly {

	* Original Study
	global n1 = 175
	global m1 = 25.65
	global s1 = 15.60

	global n2 = 168
	global m2 = 21.43
	global s2 = 16.35

	ttesti $n1 $m1 $s1 $n2 $m2 $s2
	
	replace stat_os = abs(r(t))   if study == 18
	replace type_os = "t(341)"    if study == 18
	replace p_os    = r(p)        if study == 18

	* Relication
	global n1 = 496
	global m1 = 21.77
	global s1 = 17.31

	global n2 = 518
	global m2 = 21.02
	global s2 = 17.13

	ttesti $n1 $m1 $s1 $n2 $m2 $s2
	
	replace stat_rs1 = abs(r(t))  if study == 18
	replace type_rs1 = "t(1012)"  if study == 18
	replace p_rs1    = r(p)       if study == 18
	
	
	global n1 = 1058
	global m1 = 23.61
	global s1 = 16.93

	global n2 = 1078
	global m2 = 22.87
	global s2 = 17.07

	ttesti $n1 $m1 $s1 $n2 $m2 $s2
	
	replace stat_rs2 = abs(r(t))  if study == 18
	replace type_rs2 = "t(2134)"  if study == 18
	replace p_rs2    = r(p)       if study == 18
	
}


* **************************************************************************** *
* *** Replace Effect Sizes, CIs, and p-values of Original Studes ***           *
* **************************************************************************** *
quietly {
	local ttstudies "3 4 7 9 18"
	
	foreach i of local ttstudies {

		EffectSize stat_os[`i'] 2 . n_os[`i']-2 n_os[`i'] .
		replace r_os = r(r)      if study == `i'
		
		ConfidenceInterval r_os[`i'] n_os[`i'] 0.05
		replace r95l_os = r(lb)  if study == `i'
		replace r95u_os = r(ub)  if study == `i'
		
		pValue stat_os[`i'] 2 . n_os[`i']-2 n_os[`i'] .
		replace p_os = r(p)      if study == `i'
		
	}
}


* **************************************************************************** *
* *** Effect Sizes, CIs, Meta Effects, Prediction Intervals, and Power ***     *
* **************************************************************************** *
quietly {
	local ttstudies "3 4 7 9 18"
	local stages    "rs1 rs2"
	
	foreach i of local ttstudies {
		foreach j of local stages {
		
			* standardized effect sizes (r)
			EffectSize stat_`j'[`i'] 2 . n_`j'[`i']-2 n_`j'[`i'] .
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
			pValue stat_`j'[`i'] 2 . n_`j'[`i']-2 n_`j'[`i'] .
			replace p_`j'      = r(p)        if study == `i'

		}
	}
}


* **************************************************************************** *
* *** Replication Indicators ***                                               *
* **************************************************************************** *
quietly {
	local ttstudies "3 4 7 9 18"
	local stages    "rs1 rs2"
	
	foreach i of local ttstudies {
		foreach j of local stages {

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
	#delimit ;
	global  varlist "
			type	stat   
			n      	in     
			p      	pm
			r      	r95l   	r95u
				    r90l   	r90u
			rr     	rr95l  	rr95u
					rr90l  	rr90u
			rm     	rm95l  	rm95u
			rrm    	rrm95l 	rrm95u
				    rp95l  	rp95u
					rrp95l 	rrp95u
			rep_sr 	rep_mr 
			rep_st 	rep_pi 
			";
	#delimit cr
	
	forvalues i = 1 (1) $N {
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
* *** Data Export ***                                                          *
* **************************************************************************** *
quietly {
	local  file_path   "../../Data/Data Processed/D8 - RobustnessTests"
		
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace nolabel
	
	clear all
}
		
