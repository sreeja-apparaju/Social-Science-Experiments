* **************************************************************************** *
* *** Table S7: Correlation Matrix ***                                         *
* **************************************************************************** *
quietly {
	clear all
	set more off

	use     "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	merge   m:1 study using ///
			"../../Data/Data Processed/D3 - ReplicationResults.dta"
	global  file_name "S7 - CorrelationMatrix"
}


* ---------------------------------------------------------------------------- *
* Create Table
* ---------------------------------------------------------------------------- *
quietly {
	#delimit ;
	local cols "
		rep_sr_rp
		rep_mr_rp
		rep_st_rp
		rep_pi_rp
		rr_rp
		bfP0_rp
		bfR0_rp
		m2_p
		m3_p
		m2_b
		m3_b
		p_os 
		n_os
		in_os
	";
	#delimit cr

	collapse `cols', by(study)
	drop study

	* Spearman correlations
	spearman `cols', stats(rho p)
	matrix rho = r(Rho)
	matrix p   = r(P)

	* correlation coefficients
	clear
	svmat rho, names(col)
	tostring `cols', replace format(%6.4f) force

	gen   id = _n
	gen   index = 1
	save  "rho.dta", replace

	* p-values
	clear
	svmat p, names(col)
	tostring `cols', replace format(%6.4f) force

	foreach j of local cols {
		replace `j' = "(" + `j' + ")"
	}

	gen   id = _n
	gen   index = 2
	save  "p.dta", replace

	* merge coefficients and p-values
	clear
	use "rho.dta"
	append using "p.dta"

	* drop temporary files
	rm "rho.dta"
	rm "p.dta"

	* create variable with row names
	gen   var = ""
	local i = 1
	foreach j of local cols {
		replace var = "`j'" if id == `i'
		local i = `i' + 1
	}

	sort id index
	order var
	
	* label rows and columns
	label var rep_sr_rp "Replicated p < 0.05"
	label var rep_mr_rp "Meta Estimate p < 0.05"
	label var rep_st_rp "Small Telescope Approach"
	label var rep_pi_rp "Replication within 95\% PI"
	label var rr_rp     "Relative Effect Size"
	label var bfP0_rp   "Default Bayes Factor"
	label var bfR0_rp   "Replication Bayes Factor"
	label var m2_p      "Market Beliefs (Treatment 1)"
	label var m3_p      "Market Beliefs (Treatment 2)"
	label var m2_b      "Survey Beliefs (Treatment 1)"
	label var m3_p      "Market Beliefs (Treatment 2)"
	label var p_os      "Original p-Value"
	label var n_os      "Original No. of Observations"
	label var in_os     "Original No. of Participants"

	replace var = "Replicated \(p < 0.05\)"      if var == "rep_sr_rp" & index==1
	replace var = "Meta Estimate \(p < 0.05\)"   if var == "rep_mr_rp" & index==1
	replace var = "Small Telescope Approach"     if var == "rep_st_rp" & index==1
	replace var = "Replication within 95\% PI"   if var == "rep_pi_rp" & index==1
	replace var = "Relative Effect Size"         if var == "rr_rp"     & index==1
	replace var = "Default Bayes Factor"         if var == "bfP0_rp"   & index==1
	replace var = "Replication Bayes Factor"     if var == "bfR0_rp"   & index==1
	replace var = "Market Beliefs (Treatment 1)" if var == "m2_p"      & index==1
	replace var = "Market Beliefs (Treatment 2)" if var == "m3_p"      & index==1
	replace var = "Survey Beliefs (Treatment 1)" if var == "m2_b"      & index==1
	replace var = "Survey Beliefs (Treatment 2)" if var == "m3_b"      & index==1
	replace var = "Original \(p\)-Value"         if var == "p_os"      & index==1
	replace var = "Original No. of Observations" if var == "n_os"      & index==1
	replace var = "Original No. of Participants" if var == "in_os"     & index==1

	* transform to lower diagonal
	local k = 0
	foreach j of local cols {
		local k = `k' + 1
		local n : word count `cols'
		forvalues i = 1 (1) `n' {
			replace `j' = "" if `k' > `i' & id == `i'
		}
	}
	
	replace var = "" if index == 2
	gen end = ""
	replace end = `"\\"'               if index == 1
	replace end = `"\\ \addlinespace"' if index == 2
	drop index id
}


* ---------------------------------------------------------------------------- *
* Export Table
* ---------------------------------------------------------------------------- *
quietly {
	#delimit ;					
	* export table contents as .tex
	cap ssc  	install listtex;
	listtex  	`varlist' using "LaTeX/Content.tex", 
				begin("") delimiter("&") end("") missnum("")
				replace;

	* create .tex table
	cap ssc  	install texdoc;
	texdoc   	do "LaTeX/$file_name - LaTeX.do";
	#delimit cr

	* call LaTeX, dvi2ps, and ps2pdf
	shell latex 		"$file_name.tex"
	shell dvips -P pdf  "$file_name.dvi"
	shell ps2pdf 		"$file_name.ps"
	
	* confirm LaTeX has compiled properly
	cap confirm file   	"$file_name.dvi"
	if _rc != 0 {
		noi di _n
		noi di _col(40) "ERROR"
		noi di _col(15) _dup(55) "~"
		noi di _col(15) "The table has not been properly compiled using LaTeX."
		noi di _col(15) "Either there is no TeX distribution installed on your"
		noi di _col(15) "computer or the called .exe files are not part of the"
		noi di _col(15) "PATH environmental variable. Thus, the table was not" 
		noi di _col(15) "exported in .ps and .pdf format."
		noi di _col(15) _dup(55) "~"
		exit
	}

	* move compiled files to <Tables> folder
	copy  	"$file_name.ps" ///
			"../../Tables/$file_name.ps",  replace
	copy  	"$file_name.pdf" ///
			"../../Tables/$file_name.pdf", replace
	
	* drop temporary files
	local 	temp "aux dvi log pdf ps tex"
	erase 	"$file_name.aux"
	erase 	"$file_name.dvi"
	erase 	"$file_name.log"
	erase 	"$file_name.pdf"
	erase 	"$file_name.ps"
	erase 	"$file_name.tex"
	erase 	"LaTeX/Content.tex"
	
	clear
}
