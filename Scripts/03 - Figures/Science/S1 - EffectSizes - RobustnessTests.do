* **************************************************************************** *
* *** Figure 1: Relative/Normalized Effect Sizes ***                           *
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
				msize(medsmall)
			) (
			scatter study rr_rs1_ns,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(medsmall)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle(" ",
					size(zero)
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
			title("{bf:Panel A}",
				size(small)
				margin(2 0 2 0)
			)
			fxsize(97.5)
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
				msize(medsmall)
			) (
			scatter study rr_rp_ns,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(medsmall)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle(" ",
					size(zero)
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
			title("{bf:Panel B}",
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
				msize(medsmall)
			) (
			scatter study rrm_rp_ns,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(thin)
				msize(medsmall)
				// ::::::::::::::::::::::::::::::::::: //
				xtitle(" ",
					size(zero)
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
						2 "point estimate larger than zero ({it:p} < 0.05)"
						3 "point estimate not different from zero ({it:p} > 0.05)"
					)
					symxsize(small)
					symysize(1)
					rows(3) cols(1)
					size(2)
					bmargin(1 1 1 1)
				)
			),
			title("{bf:Panel C}",
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
		
	graph display combined,	xsize(10) ysize(5);
	#delimit cr
}


* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/S1 - EffectSizes - RobustnessTests"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}
