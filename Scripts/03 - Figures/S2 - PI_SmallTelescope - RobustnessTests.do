* **************************************************************************** *
* *** Figure S3: Small Telescope Approach ***                                  *
* **************************************************************************** *
quietly {
	clear  all
	set    more   off
	set    scheme s1mono

	use    "../../Data/Data Processed/D8 - RobustnessTests.dta"
	global N = _N
	
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
* Panel A: Prediction Intervals
* ---------------------------------------------------------------------------- *
quietly {
	preserve

	gen rr_rep  = rr_rp       if rep_pi_rp == 1
	gen rr_nrep = rr_rp       if rep_pi_rp == 0

	#delimit ;
		twoway (
			rcap rrp95l_rp rrp95u_rp study,
				horizontal
				lwidth(vthin)
			) (
			scatter study rr_rep,
				msymbol(d)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin)
				msize(1.75)
			) (
			scatter study rr_nrep,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(1.75)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Relative standardized effect size",
					size(2.25)
					margin(t=1.5 b=2.5)
				)
				xlabel(-0.5 (0.25) 2.00,
					labsize(2.0)
					labgap(vsmall)
					angle(45)
					format(%9.2f)
					grid
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
					gmin gmax
				)
				xline(0 1,
					lpattern(dash)
					lwidth(thin)
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle(" ")
				yscale(reverse)
				ylabel(1 (1) $N,
					valuelabels 
					labsize(2.25)
					labgap(vsmall)
					angle(0)
					grid
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
					gmin gmax
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
						1 "95% prediction interval"
						2 "Point estimate within prediction interval"
						3 "Point estimate below prediction interval"
					)
					symxsize(small)
					symysize(1)
					rows(4) cols(1)
					size(2.0)
					bmargin(1 1 4.5 1)
				)
			),
			title("{bf:a.} Prediction intervals",
				size(small)
				margin(2 0 2 0)
			)
			fxsize(99)
			name(panel_a, replace);
			window manage close graph;
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Panel B: Small Telescope Approach
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		gen     rr_sm = .
		replace rr33_ = .     if rr_rp == .

		replace rr_sm = rr_rp if rr90u_rp < rr33_os
		replace rr_rp = .     if rr90u_rp < rr33_os

		#delimit ;
		twoway (
			rcap rr90l_rp rr90u_rp study,
				horizontal
				lcolor(gs2)
				lwidth(vthin)
			) (
			scatter study rr33_os,
				msymbol(x)
				mcolor(gs2)
				mlwidth(thin)
				msize(2)
			) (
			scatter study rr_sm,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(1.75)
			) (
			scatter study rr_rp,
				msymbol(d)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin)
				msize(1.75)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Relative standardized effect size",
					size(2.25)
					margin(t=1.5 b=2.5)
				)
				xlabel(-0.5 (0.25) 2.00,
					labsize(2.0)
					labgap(vsmall)
					angle(45)
					format(%9.2f)
					grid
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
					gmin gmax
				)
				xline(0 1,
					lpattern(dash)
					lwidth(thin)
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle(" ")
				yscale(reverse)
				ylabel(1 (1) $N, 
					labsize(0)
					labgap(0)
					labcolor(white)
					grid
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
					gmin gmax
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
						2 "Small effect in Small Telescopes approach"
						1 "90% confidence interval" 
						4 "Point estimate larger or not different from small effect"
						3 "Point estimate smaller than small effect ({it:p} < 0.05 one-sided)"
					)
					symxsize(small)
					symysize(1)
					rows(4) cols(1)
					size(2.0)
					bmargin(1 1 1 1)
				)
			),
			title("{bf:b.} Small Telescopes approach",
				size(small)
				margin(2 0 2 0)
			)
			fxsize(60)
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
	graph combine panel_a panel_b,
		iscale(0.85)
		name(combined, replace);
		window manage close graph;
		
	graph display combined,	xsize(10) ysize(6);
	#delimit cr
}


* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/S2 - PI_SmallTelescope - RobustnessTests"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}
