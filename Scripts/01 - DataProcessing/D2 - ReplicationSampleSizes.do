* **************************************************************************** *
* *** Global Setting ***                                                       *
* **************************************************************************** *
quietly {
	clear all
	set more off
	
	* use original studies data
	use "../../Data/Data Processed/D1 - OriginalStudies.dta"

	* number of studies
	global N = 21
	set obs $N
	
	* generate variables
	gen n75 = .
	gen n50 = .
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
* *** Determine Replication Sample Sizes ***                                   *
* **************************************************************************** *
quietly {
	forvalues i = 1 (1) $N {
	
		local pow = 90.0
		local p   = 0.05
		
		foreach e in 75 50 {
			ReplicationSampleSize ${s`i'_os} `pow' `e' `p'
			replace n`e' = r(n`e') if study == `i'
		}
	}
}


* **************************************************************************** *
* *** Data Preparation and Labeling ***                                        *
* **************************************************************************** *
quietly {

	label var n75      "[R-S1] Sample Size to Detect 75% of r"
	label var n50      "[R-S2] Sampel Size to Detect 50% of r"
	
}


* **************************************************************************** *
* *** Data Export ***                                                          *
* **************************************************************************** *
quietly {

	local file_path    "../../Data/Data Processed/D2 - ReplicationSampleSizes"
		
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace nolabel
	
	clear all
	
}
