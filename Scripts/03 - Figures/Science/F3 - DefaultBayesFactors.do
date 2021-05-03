* **************************************************************************** *
* *** Figure S3: Bayes Factors ***                                             *
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
		gen     bfP0x   = .

		replace bfP0_rp = 300.00        if bfP0_rp > 300.00 & bfP0_rp != .
		replace bfP0_rp = 0.0033        if bfP0_rp < 0.0033 & bfP0_rp != .
		
		gen     bfP0_rp_rep  = bfP0_rp
		gen     bfP0_rp_nrep = bfP0_rp

		replace bfP0_rp_rep  = .  if bfP0_rp < 1
		replace bfP0_rp_nrep = .  if bfP0_rp > 1

		#delimit ;
		local categories "
			0.005774  "{it:extreme H{subscript:0}}" 
			0.018257  "{it:very strong H{subscript:0}}"
			0.057735  "{it:strong H{subscript:0}}"
			0.182574  "{it:moderate H{subscript:0}}"
			0.577350  "{it:anectodal H{subscript:0}}"
			1.732051  "{it:anectodal H{subscript:1}}"
			5.477226  "{it:moderate H{subscript:1}}"
			17.32051  "{it:strong H{subscript:1}}"
			54.77226  "{it:very strong H{subscript:1}}"
			173.2051  "{it:extreme H{subscript:1}}"
		";

		local scale "
			0.0033 "{&le}1/300"
			0.0100 "1/100" 
			0.0333 "1/30"
			0.1000 "1/10"
			0.3333 "1/3"
			1.0000 "1"
			3.0000 "3"
			10.000 "10"
			30.000 "30" 
			100.00 "100"
			300.00 "{&ge}300"
		";
		
		twoway (
			scatter study bfP0_rp_rep,
				msymbol(d)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(vthin)
			) (
			scatter study bfP0_rp_nrep,
				msymbol(d)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(vthin)
				// ::::::::::::::::::::::::::::::::::: //
				xaxis(1 2)
				xtitle("", axis(1))
				xtitle("", axis(2))
				xscale(
					range(0.002 500) 
					log
				)
				xlabel(`categories',
					axis(1)
					angle(90)
					labsize(2)
					labgap(vsmall)
					noticks
					grid
					glwidth(vvvthin)
					glcolor(gs15)
					glpattern(solid)
					nogmin nogmax
				)
				xlabel(`scale',
					axis(2)
					labsize(1.8)
					grid
					glwidth(vvthin)
					glcolor(gs13)
					glpattern(solid)
					nogmin nogmax
					tlength(1)
					tlwidth(vthin)
					tlcolor(gs4)
				)
				xline(1,
					lpattern(solid)
					lwidth(vthin)
				)
				xline(300,
					lpattern(dash)
					lwidth(vthin)
				)
				xline(0.0033,
					lpattern(dash)
					lwidth(vthin)
				)
				// ::::::::::::::::::::::::::::::::::: //
				ytitle("")
				yscale(
					reverse
				)
				ylabel(1 (1) $N,
					valuelabels 
					labsize(1.8)
					labgap(vsmall)
					angle(0)
					grid
					glwidth(vvthin)
					glcolor(gs14)
					glpattern(solid)
					noticks
				)
				// ::::::::::::::::::::::::::::::::::: //
				plotregion(
					margin(0 0 2 2)
					lcolor(black)
					lwidth(thin)
				)
				legend(
					order(
						2 "one-sided default Bayes factor < 1"
						1 "one-sided default Bayes factor > 1"
					)
					rows(1) cols(2)
					size(1.8)
					bmargin(1 1 1 3)
				)
				xsize(20)
				ysize(16)		
			);
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/F3 - DefaultBayesFactors"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}
