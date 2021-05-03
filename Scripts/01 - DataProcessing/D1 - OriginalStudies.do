* **************************************************************************** *
* *** Global Setting ***                                                       *
* **************************************************************************** *
quietly {
	clear all
	set more off

	* number of studies
	global N = 21
	set obs $N
}


* **************************************************************************** *
* *** Generate Variables ***                                                   *
* **************************************************************************** *
quietly {
	#delimit ;
		gen    	study = _n;
		gen    	sref  = "";
		
		global 	varlist "
				type stat   n    in
				r    r95l   r95u 
				r33  rr33   p
				";
	#delimit cr
	
	foreach k of global varlist {
		if "`k'" == "type" {
			gen `k'_os = "" 
		}
		else {
			gen `k'_os = .  
		}
	}
}


* **************************************************************************** *
* *** Call Programms ***                                                       *
* **************************************************************************** *
quietly {
	do  "../00 - Programs/P1 - Programs.do"
}


* **************************************************************************** *
* *** Set Test Statistics ***                                                  *
* **************************************************************************** *
quietly {
	do  "D0 - SetTestStatistics.do"
}


* **************************************************************************** *
* *** References ***                                                           *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
		local   ref    = `i' + 35
		local   cr_`i' = `"(`ref')"'
		replace sref   = "`cr_`i''" if `i' == _n
	}
}


* **************************************************************************** *
* *** Assign Statistics to Variables ***                                       *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
		
		ParseInput ${s`i'_os}
		replace type_os = r(t)   if study == `i'
		replace stat_os = r(s)   if study == `i'
		replace n_os    = r(n)   if study == `i'
		replace in_os   = r(i)   if study == `i'
		
	}
}


* **************************************************************************** *
* *** Determine Standardized Effect Sizes, CIs, and p-values ***               *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {

		EffectSize ${s`i'_os}
		replace r_os = r(r)      if study == `i'
		
		ConfidenceInterval r_os[`i'] n_os[`i'] 0.05
		replace r95l_os = r(lb)  if study == `i'
		replace r95u_os = r(ub)  if study == `i'
		
		pValue ${s`i'_os}
		replace p_os = r(p)      if study == `i'
		
	}
}


* **************************************************************************** *
* *** Determine Small Effects (Small Telescope Approach) ***                   *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
		
		local pow  = 1/3
		SmallTelescope n_os[`i'] `pow' 0.05
		
		replace r33_os  = r(r_se) if study == `i'
		replace rr33_os = r33_os / r_os
		
	}
}


* **************************************************************************** *
* *** Data Preparation and Labeling ***                                        *
* **************************************************************************** *
quietly {
	#delimit ;
	label define study  
		 1 "Ackerman et al. (2010), Science `cr_1'"
		 2 "Aviezer et al. (2012), Science `cr_2'"
		 3 "Balafoutas and Sutter (2012), Science `cr_3'"
		 4 "Derex et al. (2013), Nature `cr_4'"
		 5 "Duncan et al. (2012), Science `cr_5'"
		 6 "Gervais and Norenzayan (2012), Science `cr_6'"
		 7 "Gneezy et al. (2014), Science `cr_7'"
		 8 "Hauser et al. (2014), Nature `cr_8'"
		 9 "Janssen et al. (2010), Science `cr_9'"
		10 "Karpicke and Blunt (2011), Science `cr_10'"
		11 "Kidd and Castano (2013), Science `cr_11'"
		12 "Kovacs et al. (2010), Science `cr_12'"
		13 "Lee and Schwarz (2010), Science `cr_13'"
		14 "Morewedge et al. (2010), Science `cr_14'"
		15 "Nishi et al. (2015), Nature `cr_15'"
		16 "Pyc and Rawson (2010), Science `cr_16'"
		17 "Ramirez and Beilock (2011), Science `cr_17'"
		18 "Rand et al. (2012), Nature `cr_18'"
		19 "Shah et al. (2012), Science `cr_19'"
		20 "Sparrow et al. (2011), Science `cr_20'"
		21 "Wilson et al. (2014), Science `cr_21'";
	label values study study;
	#delimit cr


	* label variables
	label var study     "[SSRP] Study"
	label var sref      "[SSRP] Study Reference"
	label var type_os   "[OS] Type of Test Statistic"
	label var stat_os   "[OS] Statistic"
	label var n_os      "[OS] Number of Observations"
	label var in_os     "[OS] Number of Individuals"
	label var r_os      "[OS] Stand. Effect Size (r)"
	label var r95l_os   "[OS] Lower Bound of 95% CI Around r"
	label var r95u_os   "[OS] Upper Bound of 95% CI Around r"
	label var r33_os    "[OS] Small Effect (r for 33.33% Power)"
	label var rr33_os   "[OS] Relative Small Effect (r for 33.33% Power)"
	label var p_os      "[OS] p-Value"

	
	* format variables
	format    %-40.0f   study
	format    %-10s     type*
	format    %9.3f     stat* p* r*
	format    %~4s      sref
}

	
* **************************************************************************** *
* *** Data Export ***                                                          *
* **************************************************************************** *
quietly {
	local file_path    "../../Data/Data Processed/D1 - OriginalStudies"
		
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace nolabel
	
	*clear all
}
