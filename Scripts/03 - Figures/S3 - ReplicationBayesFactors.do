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
		gen     bfR0x   = .

		replace bfR0_rp = 300.00        if bfR0_rp > 300.00 & bfR0_rp != .
		replace bfR0_rp = 0.0033        if bfR0_rp < 0.0033 & bfR0_rp != .

		gen     bfR0_rp_rep  = bfR0_rp
		gen     bfR0_rp_nrep = bfR0_rp
		
		replace bfR0_rp_rep  = .  if bfR0_rp < 1
		replace bfR0_rp_nrep = .  if bfR0_rp > 1
		

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
			scatter study bfR0_rp_rep,
				msymbol(d)
				msize(1.5)
				mfcolor("$fc_m1")
				mlcolor("$lc_m1")
				mlwidth(vthin)
			) (
			scatter study bfR0_rp_nrep,
				msymbol(d)
				msize(1.5)
				mfcolor("$fc_c1")
				mlcolor("$lc_c1")
				mlwidth(vthin)
				// ::::::::::::::::::::::::::::::::::: //
				xaxis(1 2)
				xtitle("", axis(1))
				xtitle(
					"Replication Bayes Factor", 
					axis(2)
					size(2)
					margin(t=2.5 b=0.5)
				)
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
						2 "Replication Bayes factor < 1"
						1 "Replication Bayes factor > 1"
					)
					rows(1) cols(2)
					size(1.8)
					bmargin(1 1 1 3)
				)
				xsize(20)
				ysize(16.5)		
			);
		#delimit cr
	restore
}


* ---------------------------------------------------------------------------- *
* Export Figure
* ---------------------------------------------------------------------------- *
quietly {
	local file_path "../../Figures/S3 - ReplicationBayesFactors"
	graph save      "`file_path'.gph", replace
	graph export    "`file_path'.eps", replace
	graph export    "`file_path'.png", replace width(3000)

	window manage close graph
	clear all
}
