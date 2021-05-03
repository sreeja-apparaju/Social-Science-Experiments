* **************************************************************************** *
* *** Table S5: Prediction Market and Survey Beliefs ***                       *
* **************************************************************************** *
quietly {
	clear all
	set more off

	use "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	global   file_name "S5 - PeerBeliefs"
}


* ---------------------------------------------------------------------------- *
* Relabel Study Variable
* ---------------------------------------------------------------------------- *
quietly {
	label drop _all
	
	#delimit ;
	label define study  
		 1 "Ackerman et al. (2010), Science"
		 2 "Aviezer et al. (2012), Science"
		 3 "Balafoutas and Sutter (2012), Science"
		 4 "Derex et al. (2013), Nature"
		 5 "Duncan et al. (2012), Science"
		 6 "Gervais and Norenzayan (2012), Science"
		 7 "Gneezy et al. (2014), Science"
		 8 "Hauser et al. (2014), Nature"
		 9 "Janssen et al. (2010), Science"
		10 "Karpicke and Blunt (2011), Science"
		11 "Kidd and Castano (2013), Science"
		12 "Kovacs et al. (2010), Science"
		13 "Lee and Schwarz (2010), Science"
		14 "Morewedge et al. (2010), Science"
		15 "Nishi et al. (2015), Nature"
		16 "Pyc and Rawson (2010), Science"
		17 "Ramirez and Beilock (2011), Science"
		18 "Rand et al. (2012), Nature"
		19 "Shah et al. (2012), Science"
		20 "Sparrow et al. (2011), Science"
		21 "Wilson et al. (2014), Science";
	label values study study;
	#delimit cr
}



* ---------------------------------------------------------------------------- *
* Create Table
* ---------------------------------------------------------------------------- *
quietly {

	#delimit ;
		collapse 
			(mean)  m2_p  m2_b 
			        m3_p  m3_b 
			        m3_p1 m3_b1 
			        m3_p2 m3_b2
			        rep_sr_rs?,
			by(study);
	#delimit cr

	gen     space = .
	#delimit ;
	local   varlist "
			study space
			m2_p  m2_b  space
			m3_p1 m3_b1 
			m3_p2 m3_b2 
			m3_p  m3_b  space
			rep_sr_rs?
			";
	#delimit cr
	keep 	`varlist'
	order   `varlist'
	
	* replace replication indicators
	foreach j in "rs1" "rs2" {
		tostring rep_sr_`j', force replace
		replace  rep_sr_`j' = "yes" if rep_sr_`j' == "1"
		replace  rep_sr_`j' = "no"  if rep_sr_`j' == "0"
	}
}


* ---------------------------------------------------------------------------- *
* Export Table
* ---------------------------------------------------------------------------- *
quietly {
	#delimit ;
		* export table contents as .tex
		cap ssc  	install listtex;
		listtex  	`varlist' using "LaTeX/Content.tex", 
					begin("") delimiter("&") end(`"\\"') missnum("")
					replace;

		* create .tex table
		cap ssc  	install texdoc;
		texdoc   	do "LaTeX/$file_name - LaTeX.do";
	#delimit cr

	* call LaTeX, dvi2ps, and ps2pdf
	shell latex 		"$file_name.tex"
	shell dvips -P pdf 	"$file_name.dvi"
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
