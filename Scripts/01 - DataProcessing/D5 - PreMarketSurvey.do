* **************************************************************************** *
* *** Global Setting ***                                                       *
* **************************************************************************** *
quietly {
	clear all
	set more off

	* import raw (depersonalized) data file
	local   file_path "../../Data/Data Raw/Survey/"
	import  excel "`file_path'/Data - Depersonalized.xlsx", ///
			firstrow case(l)

	* create treatment dummy
	gen     treatment = ""
	replace treatment = "m3" if m2_s1p == .
	replace treatment = "m2" if m3_s1p_1 == .

	* number of studies
	global  N = 21
	
	* only keep complete responses
	keep if progress == 100
	drop    progress
	
	* drop demographics
	drop    d*
}


* **************************************************************************** *
* *** Rename and Re-Label Beliefs in 2-(m2) and 3-outcome (m3) Condition ***   *
* **************************************************************************** *
quietly {

	forvalues i = 1 (1) $N {
		replace   m2_s`i'p = m2_s`i'p/100
		rename    m2_s`i'p   m2_b_s`i'
		label var m2_b_s`i'  "[Survey] m2_s`i': Belief"
		
		forvalues j = 1 (1) 3 {
			replace   m3_s`i'p_`j' = m3_s`i'p_`j'/100
			rename    m3_s`i'p_`j'   m3_b`j'_s`i'
			label var m3_b`j'_s`i'   "[Survey] m3_s`i': Belief (Stage `j')"
		}
	}
	
}


* **************************************************************************** *
* *** Rename and Re-Label Confidence Ratings in m2- and m3-Condition ***       *
* **************************************************************************** *
quietly {

	forvalues i = 1 (1) $N {
		rename m2_s`i'c             m2_c_s`i'
		label  var m2_c_s`i'        "[Survey] m2_s`i': Confidence"
		rename m3_s`i'c             m3_c_s`i'
		label  var m3_c_s`i'        "[Survey] m3_s`i': Confidence"
	}
	
}


* **************************************************************************** *
* *** Data Preparation (wide) ***                                              *
* **************************************************************************** *
quietly {
	order    treatment m2* m3*
	sort     treatment
}


* **************************************************************************** *
* *** Merge User ID's ***                                                      *
* **************************************************************************** *
quietly {

	save     "SurveyData.dta", replace
	clear
	
	* determine active market participants
	use  "../../Data/Data Processed/D4 - MarketTransactions.dta"
	gen  active = 1
	collapse active, by(uid)
	save "ActiveInMarkets.dta", replace
	clear
	
	* participant id's
	local markets "m2 m3"
	foreach j of local markets {
		global 	path "../../Data/Data Raw/Prediction Markets"
		import 	delimited "$path/`j' - ParticipantIDs.txt", ///
				encoding(UTF-8)
		save   	"$path/`j' - ParticipantIDs.dta", replace
		clear  	all
	}
	
	use          "$path/m2 - ParticipantIDs.dta"
	append using "$path/m3 - ParticipantIDs.dta"
	save         "ParticipantIDs", replace
	
	
	merge  m:n pid using "SurveyData.dta", nogen
	merge  m:1 uid using "ActiveInMarkets.dta", nogen
	
	erase  "SurveyData.dta"
	erase  "ParticipantIDs.dta"
	erase  "ActiveInMarkets.dta"
	erase  "$path/m2 - ParticipantIDs.dta"
	erase  "$path/m3 - ParticipantIDs.dta"
	
}
					 

* **************************************************************************** *
* *** Reshape Data from Wide to Long Format ***                                *
* **************************************************************************** *
quietly {

	#delimit ;
		reshape long 
			m2_b_s m2_c_s 
			m3_b1_s m3_b2_s m3_b3_s m3_c_s, 
			i(pid) j(study);	

		merge  		m:n study using 
					"../../Data/Data Processed/D1 - OriginalStudies.dta", 
					keepusing(sref) nogen;
		order      	study sref treatment pid uid *;
		label drop 	_all;
	#delimit cr
	
}



* **************************************************************************** *
* *** Reorganized Study IDs ***                                                *
* **************************************************************************** *
quietly {

	gen      study_ao =  .
	replace  study_ao =  1        if study ==  5
	replace  study_ao =  2        if study ==  6
	replace  study_ao =  3        if study ==  7
	replace  study_ao =  4        if study ==  1
	replace  study_ao =  5        if study ==  8
	replace  study_ao =  6        if study ==  9
	replace  study_ao =  7        if study == 10
	replace  study_ao =  8        if study ==  2
	replace  study_ao =  9        if study == 11
	replace  study_ao = 10        if study == 12
	replace  study_ao = 11        if study == 13
	replace  study_ao = 12        if study == 14
	replace  study_ao = 13        if study == 15
	replace  study_ao = 14        if study == 16
	replace  study_ao = 15        if study ==  3
	replace  study_ao = 16        if study == 17
	replace  study_ao = 17        if study == 18
	replace  study_ao = 18        if study ==  4
	replace  study_ao = 19        if study == 19
	replace  study_ao = 20        if study == 20
	replace  study_ao = 21        if study == 21
	
	drop     study
	rename   study_ao study
	
}


* **************************************************************************** *
* *** Rename and Re-Label Variables ***                                        *
* **************************************************************************** *
quietly {

	rename *_s *

	label  var study              "[Survey] Study"
	label  var sref               "[Survey] Study Reference"
	label  var treatment          "[Survey] Treatment (m2 or m3)"
	label  var pid                "[Survey] Participant ID"
	label  var uid                "[Survey] User ID"
	label  var m2_b               "[Survey] m2: Belief"
	label  var m2_c               "[Survey] m2: Confidence"
	label  var m3_b1              "[Survey] m3: Belief (Stage 1)"
	label  var m3_b2              "[Survey] m3: Belief (Stage 2)"
	label  var m3_b3              "[Survey] m3: Belief (Stage 3)"
	label  var m3_c               "[Survey] m3: Confidence"
	label  var active             "[Survey] User Active in Markets"

	* references
	forvalues i = 1 (1) $N {
		local   ref = `i' + 35
		local   cr_`i' = `"(`ref')"'
	}
	
	* label values
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
	
	* format variables
	format    %9.2f     m2_b m3_b*
	
}


* **************************************************************************** *
* *** Prepare Data in Long Format ***                                          *
* **************************************************************************** *
quietly {
	order    study sref treatment pid uid m2* m3*
	sort     study sref treatment pid 
}


* **************************************************************************** *
* *** Save and Export in Long Format ***                                       *
* **************************************************************************** *
quietly {

	local file_path    "../../Data/Data Processed/D5 - PreMarketSurvey"
		
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace nolabel
	
	clear all
	
}

