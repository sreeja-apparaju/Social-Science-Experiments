* **************************************************************************** *
* *** Figure 2: Original vs. Repication Effect Sizes ***                       *
* **************************************************************************** *
quietly {
	clear  all
	set    more   off
	set    scheme s1mono

	use    "../../Data/Data Processed/D3 - ReplicationResults.dta"
	global N = _N
	
	* get colors
	do     "../00 - Programs/P0 - Colors.do"
}


* ---------------------------------------------------------------------------- *
* Create Figure
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		gen r_rep  = r_rp if rep_sr_rp == 1
		gen r_nrep = r_rp if rep_sr_rp == 0

		#delimit ;
		twoway (
			function y=x,
				range(0 1)
				lpattern(solid)
				lwidth(vthin)
				lcolor(gs8)
			)(
			scatter r_rep r_nrep r_os,
				msymbol(d d)
				msize(1.5 1.5)
				mfcolor("$fc_m1" "$fc_c1")
				mlcolor("$lc_m1" "$lc_c1")
				mlwidth(thin thin)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Original Effect Size ({it:r})",
					margin(0 0 0 3.5)
					size(3)
				)
				xlabel(0.00 (0.20) 1.00,
					format(%9.2f)
					angle(45)
					labsize(2.5)
					labgap(vsmall)
					grid
					glpattern(solid)
					glwidth(vvthin)
					glcolor(gs14)
				)
				xmlabel(0.00 (0.10) 1.00,
					nolabel
					grid
					glpattern(solid)
					glwidth(vvvthin)
					glcolor(gs15)
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle("Replication Effect Size ({it:r})",
					margin(0 3.5 0 0)
					size(3)
				)
				ylabel(-0.20 (0.20) 1.00,
					format(%9.2f)
					angle(45)
					labsize(2.5)
					labgap(vsmall)
					grid
					glpattern(solid)
					glwidth(vvthin)
					glcolor(gs14)
					gmin gmax
				)
				ymlabel(-0.20 (0.10) 1.00,
					nolabel
					grid
					glpattern(solid)
					glwidth(vvvthin)
					glcolor(gs15)
				)
				yline(0,
					lpattern(dash)
					lcolor(gs8)
					lwidth(vthin)
				)
				// ::::::::::::::::::::::::::::::::::: //
				plotregion(
					lcolor(black)
					lwidth(thin)
				)
				graphregion(
					margin(small)
				)
				// ::::::::::::::::::::::::::::::::::: //
				legend(
					order(
						2 "replicated ({it:p} < 0.05)"
						3 "not replicated ({it:p} > 0.05)"
						1 "45° line"
					)
					ring(0)
					bplacement(nw)
					symxsize(small)
					symysize(1)
					rows(4) cols(1)
					size(2.5)
					bmargin(1 1 1 1)
				)
				// ::::::::::::::::::::::::::::::::::: //
				xsize(10)
				ysize(10)
			);
		#delimit cr
	restore
}
	

* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/S4 - CorrelationEffectSizes"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(2000)

	window manage close graph
	clear all
}

