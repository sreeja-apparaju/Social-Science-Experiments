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
* *** Market Holdings Data ***                                                 *
* **************************************************************************** *
quietly {

	local markets "m2 m3"
	foreach j of local markets {
	
		* set path as global
		global 	path "../../Data/Data Raw/Prediction Markets"
		
		* holdings data
		import 	delimited "$path/`j' - Holdings.txt", ///
				encoding(UTF-8)
		save   	"$path/`j' - Holdings.dta", replace
		clear  	all
					 
		* participant id's
		import 	delimited "$path/`j' - ParticipantIDs.txt", ///
				encoding(UTF-8)
		save   	"$path/`j' - ParticipantIDs.dta", replace
		clear  	all

		* merge holdings data and id's
		#delimit ;
		use    	"$path/`j' - Holdings.dta";
		merge  	m:n uid using
				"$path/`j' - ParticipantIDs.dta", nogen;	
		#delimit cr
		
		* drop temporary files
		erase  	"$path/`j' - Holdings.dta"
		erase  	"$path/`j' - ParticipantIDs.dta"
		
		* create study id
		egen   	study = group(mid)
		
		* treatment
		gen    	treatment = "`j'"
		
		* hypothesis id
		if "`j'" == "m3" {
			egen     m = group(mid)
			egen     h = group(hid) 
			replace  h = h-(m-1)* 3 
			replace  hid = h
			drop     h m
		}
		
		* active participation
		#delimit ;
			bysort pid: 
				egen    active = mean(numshares);
				replace active = 1 if active != 0;
		#delimit cr

		* reorganized study id's
		gen     study_ao =  .
		replace study_ao =  1        if study ==  5
		replace study_ao =  2        if study ==  6
		replace study_ao =  3        if study ==  7
		replace study_ao =  4        if study ==  1
		replace study_ao =  5        if study ==  8
		replace study_ao =  6        if study ==  9
		replace study_ao =  7        if study == 10
		replace study_ao =  8        if study ==  2
		replace study_ao =  9        if study == 11
		replace study_ao = 10        if study == 12
		replace study_ao = 11        if study == 13
		replace study_ao = 12        if study == 14
		replace study_ao = 13        if study == 15
		replace study_ao = 14        if study == 16
		replace study_ao = 15        if study ==  3
		replace study_ao = 16        if study == 17
		replace study_ao = 17        if study == 18
		replace study_ao = 18        if study ==  4
		replace study_ao = 19        if study == 19
		replace study_ao = 20        if study == 20
		replace study_ao = 21        if study == 21
		
		drop    study
		rename  study_ao study
		
		* clean-up data set
		#delimit ;
			keep	study treatment
					mid hid uid pid active
					numshares;
			order 	study treatment
					mid hid uid pid active
					numshares;
			
			sort  	pid study;
		#delimit cr
		
		* save
		save    "$path/`j' - PM Holdings.dta", replace
		clear   all
		
	}
}


* **************************************************************************** *
* *** Append m2 and m3 Holdings Data ***                                       *
* **************************************************************************** *
quietly {

	use          	"$path/m2 - PM Holdings.dta"
	append using 	"$path/m3 - PM Holdings.dta"
	
	erase        	"$path/m2 - PM Holdings.dta"
	erase        	"$path/m3 - PM Holdings.dta"
	
	#delimit ;
		merge  		m:n study using 
					"../../Data/Data Processed/D1 - OriginalStudies.dta", 
					keepusing(sref) nogen;
		order      	study sref *;
		label drop 	_all;
	#delimit cr
	
}


* **************************************************************************** *
* *** Rename and Re-Label Variables ***                                        *
* **************************************************************************** *
quietly {

	label  var study        "[PM] Study"
	label  var sref         "[PM] Study Reference"
	label  var treatment    "[PM] Treatment"
	label  var mid          "[PM] Market ID"
	label  var hid          "[PM] Hypothesis ID"
	label  var uid          "[PM] User/Trader ID"
	label  var pid          "[PM] Participant ID"
	label  var active       "[PM] Active Participation"
	label  var numshares    "[PM] Number of Shares"
	
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
			
		label define hid
			 1 "Replicates in Stage 1"
			 2 "Replicates in Stage 2"
			 3 "Does Not Replicate";
			 
		label values study study;
		label values hid   hid;
	#delimit cr
	
	* format variables
	format  %-40.0f   study
	format  %9.2f     numshares 
	
	* sort
	sort    study treatment uid
	
}


* **************************************************************************** *
* *** Save and Export Holdings Data ***                                        *
* **************************************************************************** *
quietly {
	local  path        "../../Data/Data Processed/D4 - MarketHoldings"
		
	save               "`path'.dta",  replace
	export delim using "`path'.csv",  replace nolabel
	
	clear  all
}


* **************************************************************************** *
* *** 2- and 3-Outcome Market ***                                              *
* **************************************************************************** *
quietly {

	local markets "m2 m3"
	foreach j of local markets {
		* set path as global
		global 	path "../../Data/Data Raw/Prediction Markets"
		
		* transaction data
		import 	delimited "$path/`j' - Transactions.txt", ///
				encoding(UTF-8)
		save   	"$path/`j' - Transactions.dta", replace
		clear  	all
		
		* user's transactions data
		import 	delimited "$path/`j' - UserTransactions.txt", ///
				encoding(UTF-8)
		save   	"$path/`j' - UserTransactions.dta", replace
		clear  	all
		
		* price data
		import 	delimited "$path/`j' - Prices.txt", ///
				encoding(UTF-8)
		save   	"$path/`j' - Prices.dta", replace
		clear	all
		
		* merge transactions and prices
		#delimit ;
		use    	"$path/`j' - Transactions.dta";
		merge  	1:m tid using 
				"$path/`j' - UserTransactions.dta", 
				keepusing(uid) nogen;
		merge  	1:m tid using 
				"$path/`j' - Prices.dta", 
				nogen;
		drop   	if hid == .;
		#delimit cr
		
		* drop temporary files
		erase  	"$path/`j' - Transactions.dta"
		erase  	"$path/`j' - UserTransactions.dta"
		erase  	"$path/`j' - Prices.dta"
		
		* create study id
		egen   	study = group(mid)
		
		* treatment
		gen    	treatment = "`j'"
		
		* timestamp
		gen str    time = substr(timestamped, 1, 23)
		gen double ts   = clock(time, "YMD hms")
		format     ts %tcCCYYmonDD_HH:MM:SS.sss
		drop       timestamped time
		
		* hypothesis id
		if "`j'" == "m3" {
			egen     m = group(mid)
			egen     h = group(hid) 
			replace  h = h-(m-1)* 3 
			replace  hid = h
			drop     h m
		}

		* reorganized study id's
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
		
		* clean-up data set
		#delimit ;
		order 	study treatment
				mid hid ts tid uid
				pointsspent boughtorsold 
				netsales longs shorts 
				numshares averageprice price;
		keep  	study treatment
				mid hid ts tid uid
				pointsspent boughtorsold 
				netsales longs shorts 
				numshares averageprice price;
					
		sort  	study treatment hid ts;
		#delimit cr
		
		* save
		save    "$path/`j' - Data.dta", replace
		clear   all
		
	}
}


* **************************************************************************** *
* *** Append m2 and m3 Data ***                                                *
* **************************************************************************** *
quietly {

	use          	"$path/m2 - Data.dta"
	append using 	"$path/m3 - Data.dta"
	
	erase        	"$path/m2 - Data.dta"
	erase        	"$path/m3 - Data.dta"
	
	#delimit ;
		merge  		m:n study using 
					"../../Data/Data Processed/D1 - OriginalStudies.dta", 
					keepusing(sref) nogen;
		order   	study sref *;
		label drop 	_all;
	#delimit cr
	
}


* **************************************************************************** *
* *** Rename and Re-Label Variables ***                                        *
* **************************************************************************** *
quietly {

	rename boughtorsold     ttype
	rename pointsspent      investment
	rename averageprice     mprice

	label  var study        "[PM] Study"
	label  var sref         "[PM] Study Reference"
	label  var treatment    "[PM] Treatment"
	label  var mid          "[PM] Market ID"
	label  var hid          "[PM] Hypothesis ID"
	label  var ts           "[PM] Timestamp"
	label  var tid          "[PM] Transaction ID"
	label  var uid          "[PM] User/Trader ID"
	label  var ttype        "[PM] Transaction Type"
	label  var investment   "[PM] Points Invested"
	label  var netsales     "[PM] Net Sales"
	label  var longs        "[PM] Long Positions"
	label  var shorts       "[PM] Short Positions"
	label  var numshares    "[PM] Number of Shares"
	label  var mprice       "[PM] Average Price"
	label  var price        "[PM] Price"
	
	* references
	forvalues i = 1 (1) $N {
		local  ref = `i' + 35
		local  cr_`i' = `"(`ref')"'
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
			
		label define hid
			 1 "Replicates in Stage 1"
			 2 "Replicates in Stage 2"
			 3 "Does Not Replicate";
		
		label define ttype
			 1 "Buy"
			-1 "Sell";
			
		label values study study;
		label values hid   hid;
		label values ttype ttype;
	#delimit cr
	
	* format variables
	format  %-40.0f   study
	format  %9.2f     investment numshares netsales longs shorts 
	format  %9.3f     mprice price
	
	* sort data
	sort    study treatment mid tid
}


* **************************************************************************** *
* *** Save and Export Market Data ***                                          *
* **************************************************************************** *
quietly {
	local  path        "../../Data/Data Processed/D4 - MarketTransactions"
		
	save               "`path'.dta",  replace
	export delim using "`path'.csv",  replace nolabel
	
	clear all
}
