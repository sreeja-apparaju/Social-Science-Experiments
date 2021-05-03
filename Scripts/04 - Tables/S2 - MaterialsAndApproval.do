* **************************************************************************** *
* *** Table S2: Materials and Approval ***                                     *
* **************************************************************************** *
quietly {
	clear all
	set more off

	use      "../../Data/Data Processed/D1 - OriginalStudies.dta"
	global   file_name "S2 - MaterialsAndApproval"
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
	keep  study
	gen   materials = 1
	gen   software  = 1
	gen   approval  = 1
	
	* Ackerman et al.
	replace software  = 2		if study == 1
	* Aviezer et al.
	replace software  = 0		if study == 2
	* Karpicke and Blunt
	replace software  = 0		if study == 10
	* Kovacs et al.
	replace software  = 0		if study == 12
	* Lee and Schwartz
	replace software  = 2		if study == 13
	* Morewedge et al.
	replace software  = 0		if study == 14
	* Nishi et al
	replace software  = 0		if study == 15
	* Ramirez and Beilock
	replace software  = 0		if study == 17
	replace approval  = 0		if study == 17
	* Rand et al.
	replace software  = 0		if study == 18
	* Sparrow et al.
	replace materials = 0		if study == 20
	replace software  = 0		if study == 20
	replace approval  = -99		if study == 20
	
	label var materials "[SSRP] Authors Provided Materials"
	label var software  "[SSRP] Replication Used Original Software"
	label var approval  "[SSRP] Authors Approved Replication Plan"

	#delimit ;
		label 	define indicators 
					0 	"\no" 
					1 	"\yes" 
					2 	"\na"
					-99 "\ \no$^\ast$";
		label 	values materials indicators;
		label	values software	 indicators;
		label   values approval  indicators;
	#delimit cr
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
