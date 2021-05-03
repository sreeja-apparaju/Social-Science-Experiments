* **************************************************************************** *
* *** Figure S5: Prediction Markets and Survey Beliefs ***                     *
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
	21 "Wilson et al. (2014), Science",
	replace;
	
label values study study;
#delimit cr


* ---------------------------------------------------------------------------- *
* Create Figure
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		keep  if treatment == "m2"
		
		gen   p_rep  = m2_p if rep_sr_rp == 1
		gen   p_nrep = m2_p if rep_sr_rp == 0
		gen   b_rep  = m2_b if rep_sr_rp == 1
		gen   b_nrep = m2_b if rep_sr_rp == 0

		sort  m2_p
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
				msize(2)
				mfcolor("$fc_m2")
				mlcolor("$lc_m2")
				mlwidth(thin)
			)(
			scatter sid b_nrep,
				msymbol(o)
				msize(2)
				mfcolor("$fc_c2")
				mlcolor("$lc_c2")
				mlwidth(thin)
			)(
			scatter sid p_rep,
				msymbol(d)
				msize(2)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin)
			)(
			scatter sid p_nrep,
				msymbol(d)
				msize(2)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Prediction market and survey beliefs",
					margin(0 0 0 3)
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
						3 "Market belief (replicated, {it:p} < 0.05)"
						4 "Market belief (not replicated, {it:p} > 0.05)"
						1 "Survey belief (replicated, {it:p} < 0.05)"
						2 "Survey belief (not replicated, {it:p} > 0.05)"
					)
					ring(0)
					bplacement(nw)
					symxsize(small)
					symysize(1)
					rows(4) cols(1)
					size(2.0)
					bmargin(1 1 1 1)
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
	local file_path "../../Figures/S7 - PeerBeliefs"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}

