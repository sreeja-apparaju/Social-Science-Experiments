* **************************************************************************** *
* *** Figure S6: Correlation Between Peer Beliefs and Effect Sizes ***         *
* **************************************************************************** *
quietly {
	clear  all
	set    more   off
	set    scheme s1mono

	#delimit ;
	use    "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta";
	merge  m:1 study using 
				 "../../Data/Data Processed/D3 - ReplicationResults.dta";
	global N = _N;
	#delimit cr
	
	* get colors
	do     "../00 - Programs/P0 - Colors.do"
}


* ---------------------------------------------------------------------------- *
* Panel A: Treatment m2
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		drop if treatment == "m3"
		
		gen m2_b_rep  = m2_b if rep_sr_rp == 1
		gen m2_b_nrep = m2_b if rep_sr_rp == 0
		
		gen m2_p_rep  = m2_p if rep_sr_rp == 1
		gen m2_p_nrep = m2_p if rep_sr_rp == 0

		#delimit ;
		twoway (
			scatter rr_rp m2_b_rep,
				msymbol(o o)
				msize(2 2)
				mfcolor("$fc_m2")
				mlcolor("$lc_m2")
				mlwidth(thin thin)
			)(
			scatter rr_rp m2_b_nrep,
				msymbol(o o)
				msize(2 2)
				mfcolor("$fc_c2")
				mlcolor("$lc_c2")
				mlwidth(thin thin)
			)(
			scatter rr_rp m2_p_rep,
				msymbol(d d)
				msize(2 2)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin thin)
			)(
			scatter rr_rp m2_p_nrep,
				msymbol(d d)
				msize(2 2)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin thin)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Prediction Market and Survey Beliefs",
					margin(0 0 0 2)
					size(2.75)
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
				xline(0.50,
					lpattern(shortdash)
					lcolor(gs4)
					lwidth(medthin)			
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle("Relative Standardized Effect Size",
					margin(0 2 0 0)
					size(2.75)
				)
				ylabel(-0.50 (0.25) 1.50,
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
				// ::::::::::::::::::::::::::::::::::: //
				plotregion(
					lcolor(black)
					lwidth(thin)
				)
				graphregion(
					margin(medium)
				)
			),
			title("{bf:Panel A}",
				size(small)
				margin(2 0 2 0)
			)
			name(panel_a, replace);
			window manage close graph;
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Panel B: Treatment m3
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		drop if treatment == "m2"
		
		gen m3_b_rep  = m3_b if rep_sr_rp == 1
		gen m3_b_nrep = m3_b if rep_sr_rp == 0
		
		gen m3_p_rep  = m3_p if rep_sr_rp == 1
		gen m3_p_nrep = m3_p if rep_sr_rp == 0
		
		#delimit ;
		twoway (
			scatter rr_rp m3_b_rep,
				msymbol(o o)
				msize(2 2)
				mfcolor("$fc_m2")
				mlcolor("$lc_m2")
				mlwidth(thin thin)
			)(
			scatter rr_rp m3_b_nrep,
				msymbol(o o)
				msize(2 2)
				mfcolor("$fc_c2")
				mlcolor("$lc_c2")
				mlwidth(thin thin)
			)(
			scatter rr_rp m3_p_rep,
				msymbol(d d)
				msize(2 2)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin thin)
			)(
			scatter rr_rp m3_p_nrep,
				msymbol(d d)
				msize(2 2)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin thin)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Prediction Market and Survey Beliefs",
					margin(0 0 0 2)
					size(2.75)
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
				xline(0.50,
					lpattern(shortdash)
					lcolor(gs4)
					lwidth(medthin)			
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle("Relative Standardized Effect Size",
					margin(0 2 0 0)
					size(2.75)
				)
				ylabel(-0.50 (0.25) 1.50,
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
				// ::::::::::::::::::::::::::::::::::: //
				plotregion(
					lcolor(black)
					lwidth(thin)
				)
				graphregion(
					margin(medium)
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
					symxsize(4)
					symysize(1)
					rows(2) cols(3)
					size(2.5)
					bmargin(1 1 1 1)
				)
			),
			title("{bf:Panel B}",
				size(small)
				margin(2 0 2 0)
			)

			name(panel_b, replace);
			window manage close graph;
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Combine Panels
* ---------------------------------------------------------------------------- *
quietly {
	#delimit ;
	grc1leg panel_a panel_b,
		xcommon row(1)
		iscale(1)
		name(combined, replace)
		legendfrom(panel_b);
		window manage close graph;
		
	graph display combined,	xsize(10) ysize(6);
	#delimit cr
}
	

* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/S8 - PeerBeliefsEffectSize"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}

