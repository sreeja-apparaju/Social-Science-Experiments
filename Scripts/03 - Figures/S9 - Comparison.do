* **************************************************************************** *
* *** Figure 7: Comparison of RPP, EERP, and SSRP ***                          *
* **************************************************************************** *
quietly {
	clear  all
	set    more   off
	set    scheme s1mono

	use    "../../Data/Data Processed/D7 - Comparison.dta"
	global N = _N
	
	* get colors
	do     "../00 - Programs/P0 - Colors.do"
}


* ---------------------------------------------------------------------------- *
* Create Figure
* ---------------------------------------------------------------------------- *
quietly {
	preserve

		sort order study
		drop if order > 2

		egen    xvar = group(order sid)
		replace xvar = xvar + 1 if xvar > 3

		gen lb = e - se
		gen ub = e + se
		
		#delimit ;
			eclplot e lb ub xvar,
			eplot(bar)
			supby(sid)
			estopts1(
				bcolor("$fc_m1")
				lcolor("$lc_m1")
				lwidth(vthin)
			)
			estopts2(
				bcolor("$fc_c1")
				lcolor("$lc_c1")
				lwidth(vthin)
			)
			estopts3(
				bcolor(gs8)
				lcolor(gs6)
				lwidth(vthin)
			)
			ciopts1(
				lcolor(gs4)
				lwidth(thin)
			)
			ciopts2(
				lcolor(gs4)
				lwidth(thin)
			)
			ciopts3(
				lcolor(gs4)
				lwidth(thin)
			)
			// ::::::::::::::::::::::::::::::::::: //
			xtitle("")
			xlabel(
				2  "Replicated {it:p} < 0.05"
				6  "Relative Effect Size",
				labsize(2.75)
				labgap(vsmall)
			)
			// ::::::::::::::::::::::::::::::::::: //
			ytitle("")
			ylabel(0.00 (0.20) 1.00,
				format(%9.2f)
				angle(45)
				labsize(2.75)
				labgap(vsmall)
				grid
				glpattern(solid)
				glwidth(vvthin)
				glcolor(gs14)
				gmin gmax
			)
			ymlabel(0.00 (0.10) 1.00,
				nolabel
				grid
				glpattern(solid)
				glwidth(vvvthin)
				glcolor(gs15)
			)
			// ::::::::::::::::::::::::::::::::::: //
			plotregion(
				lcolor(black)
				lwidth(thin)
				margin(5 5 0.5 5)
			)
			graphregion(
				margin(small)
			)
			xsize(10)
			ysize(10)
			// ::::::::::::::::::::::::::::::::::: //
			legend(
				order(
					1 "Social Sciences Replication Project"
					3 "Experimental Economics Replicaton Project"
					5 "Replication Project: Psychology"
				)
				ring(0)
				bplacement(nw)
				symxsize(2)
				symysize(2)
				rows(3) cols(1)
				size(2.75)
				bmargin(1 1 1 1)
			);
		#delimit cr
	restore
}
	

* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/S9 - Comparison"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}

