* **************************************************************************** *
* *** Global Setting ***                                                       *
* **************************************************************************** *
quietly {
	clear all
	set more off

	* number of studies
	global  N = 21
}


* **************************************************************************** *
* *** Comparison ***                                                           *
* **************************************************************************** *
quietly {

	* get comparison data and save temporarily
	insheet using "../../Data/Data Raw/Comparison/Comparison.csv"
	save    "eerp_rpp.dta", replace
	clear   all

	* use results summary data
	use     "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	drop    if treatment == "m2"

	* get mean indicators and standard errors
	tabstat rep_sr_rp rr_rp m3_p m3_b, stats(mean sem) save
	matrix  stats = r(StatTotal)

	* save matrix to data file
	clear
	svmat   stats, names(col)

	* prepare data
	xpose,  varname clear
	rename  (_varname v1 v2) (measure e se)
	
	gen     order = _n
	gen     study = "ssrp"
	
	replace measure = "replicated p < 0.05"  if order == 1
	replace measure = "relative effect size" if order == 2
	replace measure = "market beliefs"       if order == 3
	replace measure = "survey beliefs"       if order == 4
	
	* append EERP and RPP data
	append  using "eerp_rpp.dta"
	erase   "eerp_rpp.dta"
	
	* prepare dataset
	gen     sid = .
	replace sid = 1 if study == "ssrp"
	replace sid = 2 if study == "eerp"
	replace sid = 3 if study == "rpp"
	
	order   sid study measure e se
	format  %9.3f e se
	
	
	* export comparison data
	local  file_path   "../../Data/Data Processed/D7 - Comparison"
	
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace
	
	clear  all
}
