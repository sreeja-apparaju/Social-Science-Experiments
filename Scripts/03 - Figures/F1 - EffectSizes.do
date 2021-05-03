* **************************************************************************** *
* *** Figure 1: Relative/Normalized Effect Sizes ***                           *
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


forvalues i = 1 (1) $N {
	local   ref    = `i' + 15
	local   cr_`i' = `"{sup:`ref'}"'
	replace sref   = "`cr_`i''" if `i' == _n
}

#delimit ;
label define study  
	 1 "Ackerman et al. (2010)`cr_1', Science"
	 2 "Aviezer et al. (2012)`cr_2', Science"
	 3 "Balafoutas and Sutter (2012)`cr_3', Science"
	 4 "Derex et al. (2013)`cr_4', Nature"
	 5 "Duncan et al. (2012)`cr_5', Science"
	 6 "Gervais and Norenzayan (2012)`cr_6', Science"
	 7 "Gneezy et al. (2014)`cr_7', Science"
	 8 "Hauser et al. (2014)`cr_8', Nature"
	 9 "Janssen et al. (2010)`cr_9', Science"
	10 "Karpicke and Blunt (2011)`cr_10', Science"
	11 "Kidd and Castano (2013)`cr_11', Science"
	12 "Kovacs et al. (2010)`cr_12', Science"
	13 "Lee and Schwarz (2010)`cr_13', Science"
	14 "Morewedge et al. (2010)`cr_14', Science"
	15 "Nishi et al. (2015)`cr_15', Nature"
	16 "Pyc and Rawson (2010)`cr_16', Science"
	17 "Ramirez and Beilock (2011)`cr_17', Science"
	18 "Rand et al. (2012)`cr_18', Nature"
	19 "Shah et al. (2012)`cr_19', Science"
	20 "Sparrow et al. (2011)`cr_20', Science"
	21 "Wilson et al. (2014)`cr_21', Science",
	replace;
	
label values study study;
#delimit cr


* ---------------------------------------------------------------------------- *
* Panel A: Stage 1
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		gen rr_rs1_sig = .
		gen rr_rs1_ns  = .

		replace rr_rs1_sig = rr_rs1 if rep_sr_rs1 == 1
		replace rr_rs1_ns  = rr_rs1 if rep_sr_rs1 == 0

		#delimit ;
		twoway (
			rcap rr95l_rs1 rr95u_rs1 study,
				horizontal
				lwidth(vthin)
			) (
			scatter study rr_rs1_sig,
				msymbol(d)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin)
				msize(1.65)
			) (
			scatter study rr_rs1_ns,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(1.65)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Relative standardized effect size",
					size(2.25)
					margin(t=1.5 b=2)
				)
				xlabel(-1.00 (0.50) 2.00,
					labsize(2)
					labgap(vsmall)
					angle(45)
					format(%9.2f)
					grid gmin gmax
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
				)
				xline(0 1,
					lpattern(dash)
					lwidth(vthin)
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle(" ",
					size(zero)
				)
				yscale(reverse)
				ylabel(1 (1) $N,
					valuelabels 
					labsize(2)
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
			),
			title("{bf:a.} Stage 1 results",
				size(small)
				margin(2 0 2 0)
			)
			fxsize(100)
			name(panel_a, replace);
			window manage close graph;
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Panel B: Stage 2
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		gen rr_rp_sig = .
		gen rr_rp_ns  = .

		replace rr_rp_sig = rr_rp if rep_sr_rp == 1
		replace rr_rp_ns  = rr_rp if rep_sr_rp == 0

		#delimit ;
		twoway (
			rcap rr95l_rp rr95u_rp study,
				horizontal
				lwidth(vthin)
			) (
			scatter study rr_rp_sig,
				msymbol(d)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin)
				msize(1.65)
			) (
			scatter study rr_rp_ns,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(1.65)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Relative standardized effect size",
					size(2.25)
					margin(t=1.5 b=2)
				)
				xlabel(-1.00 (0.50) 2.00,
					labsize(2)
					labgap(vsmall)
					angle(45)
					format(%9.2f)
					grid gmin gmax
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
				)
				xline(0 1,
					lpattern(dash)
					lwidth(vthin)
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle(" ",
					size(zero)
				)
				yscale(reverse)
				ylabel(1 (1) $N, 
					labsize(0)
					labgap(0)
					labcolor(white)
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
			),
			title("{bf:b.} Stage 2 results",
				size(small)
				margin(2 0 2 0)
			)
			fxsize(50)
			name(panel_b, replace);
			window manage close graph;
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Panel C: Meta Result Pooled
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		gen rrm_rp_sig = .
		gen rrm_rp_ns  = .

		replace rrm_rp_sig = rrm_rp if rep_mr_rp == 1
		replace rrm_rp_ns  = rrm_rp if rep_mr_rp == 0

		#delimit ;
		twoway (
			rcap rrm95l_rp rrm95u_rp study,
				horizontal
				lwidth(vthin)
			) (
			scatter study rrm_rp_sig,
				msymbol(d)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(thin)
				msize(1.65)
			) (
			scatter study rrm_rp_ns,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(1.65)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Meta-analytic effect size",
					size(2.25)
					margin(t=1.5 b=2)
				)
				xlabel(-1.00 (0.50) 2.00,
					labsize(2)
					labgap(vsmall)
					angle(45)
					format(%9.2f)
					grid gmin gmax
					glwidth(vvvthin)
					glcolor(gs14)
					glpattern(solid)
				)
				xline(0 1,
					lpattern(dash)
					lwidth(vthin)
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle(" ",
					size(zero)
				)
				yscale(reverse)
				ylabel(1 (1) $N, 
					labsize(0)
					labgap(0)
					labcolor(white)
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
						1 "95% confidence interval"
						2 "Point estimate larger than zero ({it:p} < 0.05)"
						3 "Point estimate not different from zero ({it:p} > 0.05)"
					)
					symxsize(small)
					symysize(1)
					rows(3) cols(1)
					size(2)
					bmargin(1 1 1 1)
				)
			),
			title("{bf:c.} Meta-analysis",
				size(small)
				margin(2 0 2 0)
			)
			fxsize(50)
			name(panel_c, replace);
			window manage close graph;
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Combine Panels
* ---------------------------------------------------------------------------- *
quietly {
	#delimit ;
	grc1leg panel_a panel_b panel_c,
		xcommon row(1)
		iscale(1) xsize(10) ysize(7)
		name(combined, replace)
		legendfrom(panel_c);
		window manage close graph;
		
	graph display combined,	xsize(10) ysize(5.5);
	#delimit cr
}


* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/F1 - EffectSizes"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.ps",  replace
	graph export    "`file_path'.pdf", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}
