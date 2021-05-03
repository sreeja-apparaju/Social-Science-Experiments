* **************************************************************************** *
* *** Figure 4: Prediction Markets and Survey Beliefs ***                      *
* **************************************************************************** *
quietly {
	clear  all
	set    more   off
	set    scheme s1mono

	use    "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	global N = 21
	
	* get colors
	do     "../00 - Programs/P0 - Colors.do"
}


* ---------------------------------------------------------------------------- *
* Create Figure
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		keep  if treatment == "m3"
		
		gen   p_rep  = m3_p if rep_sr_rp == 1
		gen   p_nrep = m3_p if rep_sr_rp == 0
		gen   b_rep  = m3_b if rep_sr_rp == 1
		gen   b_nrep = m3_b if rep_sr_rp == 0

		sort  m3_p
		gen   sid = _n
		gen   order = study

		forvalues j = 1 (1) $N {
			local sl = order[`j']
			local lab : label study `sl'
			dis "`lab'"
			
			label define ordered `j' `"`lab'"', add
			label list ordered
		}
		label values sid ordered


		gen leg_pm   = .
		gen leg_s    = .
		gen leg_rep  = .
		gen leg_nrep = .

		#delimit ;
		twoway (
			scatter sid b_rep,
				msymbol(o)
				msize(1.5)
				mfcolor("$fc_m2")
				mlcolor("$lc_m2")
				mlwidth(thin)
			)(
			scatter sid b_nrep,
				msymbol(o)
				msize(1.5)
				mfcolor("$fc_c2")
				mlcolor("$lc_c2")
				mlwidth(thin)
			)(
			scatter sid p_rep,
				msymbol(d)
				msize(1.5)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin)
			)(
			scatter sid p_nrep,
				msymbol(d)
				msize(1.5)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Prediction Market and Survey Beliefs",
					margin(0 0 0 3.5)
					size(2.5)
				)
				xlabel(0.00 (0.10) 1.00,
					labsize(2)
					labgap(vsmall)
					angle(45)
					format(%9.2f)
					grid gmin gmax
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
				)
				xmlabel(0.0 (0.05) 1.00,
					nolabel
					grid
					glpattern(solid)
					glwidth(vvvthin)
					glcolor(gs16)
				)
				xline(0.50,
					lpattern(shortdash)
					lcolor(gs4)
					lwidth(medthin)			
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle(" ")
				ylabel(1 (1) $N,
					valuelabels 
					labsize(2.2)
					labgap(vsmall)
					angle(0)
					grid
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
					noticks
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
						3 "market belief (replicated, {it:p} < 0.05)"
						4 "market belief (not replicated, {it:p} > 0.05)"
						1 "survey belief (replicated, {it:p} < 0.05)"
						2 "survey belief (not replicated, {it:p} > 0.05)"
					)
					ring(0)
					bplacement(nw)
					symxsize(small)
					symysize(1)
					rows(4) cols(1)
					size(2.0)
				)
				// ::::::::::::::::::::::::::::::::::: //
				xsize(10)
				ysize(7.5)
			);
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/F4 - PeerBeliefs"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}

