* **************************************************************************** *
* *** Figure 2: Original vs. Repication Effect Sizes ***                       *
* **************************************************************************** *
quietly {
	clear  	all
	set    	more   off
	set    	scheme s1mono

	#delimit ;
	import 	delimited using
			"../../Data/Data Raw/Bayesian Analyses/PosteriorAlpha.csv", delimiter(";");
	save   	"../../Data/Data Raw/Bayesian Analyses/PosteriorAlpha.dta", replace;
	#delimit cr
	clear
	
	#delimit ;
	import 	delimited using
			"../../Data/Data Raw/Bayesian Analyses/PosteriorPhi.csv", delimiter(";");
	save   	"../../Data/Data Raw/Bayesian Analyses/PosteriorPhi.dta", replace;				 
	#delimit cr
	clear
	
	global 	N = _N
	
	* get colors
	do     	"../00 - Programs/P0 - Colors.do"
}


* ---------------------------------------------------------------------------- *
* Posterior Phi
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		use "../../Data/Data Raw/Bayesian Analyses/PosteriorPhi.dta"
		
		gen hdi_l = .
		gen hdi_u = .
		gen loc   = 3.75     if _n == 1
		gen mean  = 0.673    if _n == 1
		gen dens  = 3.05     if _n == 1
		
		replace hdi_l = 0.43 if _n == 1
		replace hdi_u = 0.92 if _n == 1
		
		local hdi_l : di %3.2f hdi_l[1]
		local hdi_u : di %3.2f hdi_u[1]
		local text = (`hdi_l' + `hdi_u') / 2
		local mean = mean[1]

		#delimit ;
		twoway (
			area phi x,
				lpattern(solid)
				lwidth(thin)
				lcolor("$lc_m2")
				fcolor("$fc_m2")
			) (
			rcap hdi_l hdi_u loc,
				horizontal
				lwidth(thin)
				msize(large)
				lcolor(gs6)
			) (
			scatter dens mean,
				msymbol(o)
				msize(3)
				mlcolor("$lc_m1")
				mfcolor("$fc_m1")
				// ::::::::::::::::::::::::::::::::::: //
				text(3.95 `hdi_l' "`hdi_l'", place(c) size(2.5))
				text(3.95 `hdi_u' "`hdi_u'", place(c) size(2.5))
				text(3.60 `text' "95% HDI", place(c) size(2.5))
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("True positive rate {&Phi}",
					margin(0 0 0 3)
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
				ytitle("Density",
					margin(0 3 0 0)
					size(3)
				)
				ylabel(0.00 (0.50) 4.00,
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
				ymlabel(0.00 (0.25) 4.00,
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
				)
				graphregion(
					margin(medium)
				)
				// ::::::::::::::::::::::::::::::::::: //
				legend(
					order(
						3 "mean = 0.673"
					)
					ring(0)
					bplacement(nw)
					symxsize(small)
					symysize(1)
					rows(1) cols(1)
					size(2.5)
					bmargin(1 1 1 1)
				)
			),
			title("{bf:a.} True positive rate",
				size(medsmall)
				margin(2 0 2 0)
			)
			name(panel_a, replace);
			window manage close graph;
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Posterior Alpha
* ---------------------------------------------------------------------------- *
quietly {
	preserve
		use "../../Data/Data Raw/Bayesian Analyses/PosteriorAlpha.dta"
		
		gen hdi_l = .
		gen hdi_u = .
		gen loc   = 7.5      if _n == 1
		gen mean  = 0.708    if _n == 1
		gen dens  = 6.7      if _n == 1
		
		replace hdi_l = 0.58 if _n == 1
		replace hdi_u = 0.83 if _n == 1
		
		local hdi_l : di %3.2f hdi_l[1]
		local hdi_u : di %3.2f hdi_u[1]
		local text = (`hdi_l' + `hdi_u') / 2
		local mean = mean[1]

		#delimit ;
		twoway (
			area alpha x,
				lpattern(solid)
				lwidth(thin)
				lcolor("$lc_m2")
				fcolor("$fc_m2")
			) (
			rcap hdi_l hdi_u loc,
				horizontal
				lwidth(thin)
				msize(large)
				lcolor(gs6)
			) (
			scatter dens mean,
				msymbol(o)
				msize(3)
				mlcolor("$lc_m1")
				mfcolor("$fc_m1")
				// ::::::::::::::::::::::::::::::::::: //
				text(7.9 `hdi_l' "`hdi_l'", place(c) size(2.5))
				text(7.9 `hdi_u' "`hdi_u'", place(c) size(2.5))
				text(7.2 `text' "95% HDI", place(c) size(2.5))
				// ::::::::::::::::::::::::::::::::::: //
				xtitle("Replication deflation factor {&alpha}",
					margin(0 0 0 3)
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
				ytitle("Density",
					margin(0 3 0 0)
					size(3)
				)
				ylabel(0.00 (1.00) 8.00,
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
				ymlabel(0.00 (0.50) 8.00,
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
				)
				graphregion(
					margin(medium)
				)
				// ::::::::::::::::::::::::::::::::::: //
				legend(
					order(
						3 "mean = 0.708"
					)
					ring(0)
					bplacement(nw)
					symxsize(small)
					symysize(1)
					rows(1) cols(1)
					size(2.5)
					bmargin(1 1 1 1)
				)
			),
			title("{bf:b.} Replication deflation factor",
				size(medsmall)
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
	graph combine panel_a panel_b,
		row(1) iscale(1.05)
		xsize(10) ysize(7)
		name(combined, replace);
		window manage close graph;
		
	graph display combined,	xsize(10) ysize(5);
	#delimit cr
}
	

* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/S5 - PosteriorDistributions"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(2000)

	window manage close graph
	clear all
}

