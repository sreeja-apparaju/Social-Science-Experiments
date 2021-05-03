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
* *** Mean Market and Survey Data ***                                          *
* **************************************************************************** *
quietly {

	* market data
	use      	"../../Data/Data Processed/D4 - MarketTransactions.dta"
	keep     	study treatment mid hid tid price
	reshape  	wide price, i(tid) j(hid)
	collapse 	(last) price* mid, by(study treatment)
	
	rename   	(price1 price2 price3) ///
				(m3_p1  m3_p2  m3_p3)
	gen      	m2_p  = m3_p1  if treatment == "m2"
	replace  	m3_p1 = .      if treatment == "m2"
	gen      	m3_p  = m3_p1 + m3_p2

	order    	study mid treatment m2_p m3_p m3_p?
	save     	"MarketMeans.dta", replace
	clear

	* survey data
	use      	"../../Data/Data Processed/D5 - PreMarketSurvey.dta"
	drop if  	active == .
	collapse 	m2_b m3_b1 m3_b2 m3_b3, by(study treatment)
	gen      	m3_b = m3_b1 + m3_b2
	
	order    	study treatment m2_b m3_b m3_b?
	save     	"SurveyMeans.dta", replace
	clear

	* merge mean data
	#delimit ;
		use    	"MarketMeans.dta";
		merge  	1:1 study treatment using
				"SurveyMeans.dta", nogen;
		merge  	n:1 study using
				"../../Data/Data Processed/D3 - ReplicationResults.dta", nogen;
					 
		rm     	"MarketMeans.dta";
		rm     	"SurveyMeans.dta";
	#delimit cr
	
	* label variables
	label  var study              "[SSRP] Study"
	label  var sref               "[SSRP] Study Reference"
	label  var treatment          "[SSRP] Treatment"
	
	label  var m2_p               "[PM] m2: Mean Price"
	label  var m3_p               "[PM] m3: Mean Price"
	label  var m3_p1              "[PM] m3: Mean Price (Stage 1)"
	label  var m3_p2              "[PM] m3: Mean Price (Stage 2)"
	label  var m3_p3              "[PM] m3: Mean Price (No Rep.)"
	
	label  var m2_b               "[Survey] m2: Mean Belief"
	label  var m3_b               "[Survey] m3: Mean Belief"
	label  var m3_b1              "[Survey] m3: Mean Belief (Stage 1)"
	label  var m3_b2              "[Survey] m3: Mean Belief (Stage 2)"
	label  var m3_b3              "[Survey] m3: Mean Belief (No Rep.)"
	
	* data preparation
	order  study sref mid treatment m2_p m3_p m3_p? m2_b m3_b m3_b?
	sort   treatment study
	
	* format
	format %9.2f m?_*

	* export mean price/belief data
	local  file_path   "../../Data/Data Processed/D6 - MeanPeerBeliefs"
	
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace nolabel
	
	clear  all
}


* **************************************************************************** *
* *** Demographics ***                                                         *
* **************************************************************************** *
quietly {

	* import raw survey data
	local    file_path "../../Data/Data Raw/Survey/"
	import   excel "`file_path'/Data - Depersonalized.xlsx", ///
					 firstrow case(l)
	
	* only keep complete responses
	keep  if progress == 100
	drop     progress
	
	* only keep demographics
	keep     pid d_*
	
	* save temporary file
	save     "Demographics.dta"
	clear
	
	* use market holdings data and collapse
	use      "../../Data/Data Processed/D4 - MarketHoldings.dta"
	collapse (first) treatment (max) active, by(pid)
	
	merge    1:m pid using "Demographics.dta", nogen
	rm       "Demographics.dta"
	
	* rename and relabel variables
	rename   d_* *
	rename   position   position
	rename   since      since
	rename   gender     gender
	rename   residence  residence
	rename   research   research

	label    var pid               "[SSRP] Participant ID"
	label    var treatment         "[SSRP] Treatment"
	label    var active            "[SSRP] Active Market Participation"
	label    var position          "[Survey] Position"
	label    var since             "[Survey] Years in Academia"
	label    var gender            "[Survey] Gender"
	label    var residence         "[Survey] Country of Residence"
	label    var research          "[Survey] Core Fields of Research"
	
	* export demographics
	local  file_path   "../../Data/Data Processed/D6 - Demographics"
	
	save               "`file_path'.dta",  replace
	export delim using "`file_path'.csv",  replace nolabel
	
	clear  all
}
