quietly {
	clear all
	set more off
	global N = 21
	
	* create log
	log using "../../Results/Analysis - Main Text", replace name(text) text
	log using "../../Results/Analysis - Main Text", replace name(smcl) smcl

	
	* -------------------------------------------------------------------------- *
	* Significant Effect in Same Direction as in Original Study
	* -------------------------------------------------------------------------- *
	use       "../../Data/Data Processed/D3 - ReplicationResults.dta"
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Significant Effect in Same Direction as in Original Study:"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	local stage "rs1 rs2 rp"
	foreach j of local stage {
		* count and percentage
		count  if rep_sr_`j' == 1
		local  rep_`j'  = r(N)
		local  repp_`j' = r(N) / $N * 100
		
		* confidence intervals
		mean   rep_sr_`j'
		matrix m_`j' = r(table)
		local  cil_`j' = m_`j'[5,1] * 100
		local  ciu_`j' = m_`j'[6,1] * 100
	}

	#delimit ;
		noi di 	_column(4)  "Replicated in Stage 1:" 
						_column(40) %2.0f `rep_rs1'  " ("
									%4.1f `repp_rs1' "%)"
						_column(55) "CI = ["
									%5.1f `cil_rs1'  "%,"
									%5.1f `ciu_rs1'  "%]";
												
		noi di 	_column(4)  "Replicated in Stage 2:" 
						_column(40) %2.0f `rep_rs2'  " ("
									%4.1f `repp_rs2' "%)"
						_column(55) "CI = ["
									%5.1f `cil_rs2'  "%,"
									%5.1f `ciu_rs2'  "%]";
												
		noi di 	_column(4)  "Replication Rate Pooled:" 
						_column(40) %2.0f `rep_rp'  " ("
									%4.1f `repp_rp' "%)"
						_column(55) "CI = ["
									%5.1f `cil_rp'  "%,"
									%5.1f `ciu_rp'  "%]";
	#delimit cr
	
	clear
	


	* -------------------------------------------------------------------------- *
	* Mean Standardized Effect Size
	* -------------------------------------------------------------------------- *
	use       "../../Data/Data Processed/D3 - ReplicationResults.dta"
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Mean Standardized Effect Size:"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	local results "rp os"
	foreach j of local results {
		* mean standardized effect size
		sum   r_`j'
		local r_`j' = r(mean)
	
		* confidence intervals
		mean   r_`j'
		matrix m_`j' = r(table)
		local  cil_`j' = m_`j'[5,1]
		local  ciu_`j' = m_`j'[6,1]
	}
	
	#delimit ;
		noi di 	_column(4)  "Replication Studies:" 
						_column(45) %5.3f `r_rp'
						_column(55) "CI = ["
									%6.3f `cil_rp'  ","
									%6.3f `ciu_rp'  "]";
						
		noi di  _column(4)  "Original Studies:" 
						_column(45) %5.3f `r_os'
						_column(55) "CI = ["
									%6.3f `cil_os'  ","
									%6.3f `ciu_os'  "]";
	#delimit cr
	
	* signed-rank test
	signrank r_os = r_rp
	local z = abs(r(z))
	local p = 2 * (1 - normal(`z'))
	
	#delimit ;
		noi di  _newline(0);
		noi di 	_column(4)  "Wilcoxon Signed-Ranks Test:" _newline
						_column(4)	"---------------------------";
		
		noi di  _column(7) "|z|-Value:" 
						_column(45) %5.3f `z';
		noi di  _column(7) "p-Value:" 
						_column(45) %5.3f `p';
	#delimit cr
	
	clear
	
	
	
	* -------------------------------------------------------------------------- *
	* Mean Relative Effect Size
	* -------------------------------------------------------------------------- *
	use       "../../Data/Data Processed/D3 - ReplicationResults.dta"
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Mean Relative Effect Size:"
	noi di    _dup(80) "~"
	noi di    _newline(0)	
	
	* mean relative effect size and CIs (all studies)
	mean   rr_rp
	matrix m_rp    = r(table)
	local  rr_all  = m_rp[1,1] * 100
	local  cil_all = m_rp[5,1] * 100
	local  ciu_all = m_rp[6,1] * 100
	
	* mean relative effect size and CIs (replicted)
	mean   rr_rp   if rep_sr_rp == 1
	matrix m_rp    = r(table)
	local  rr_rep  = m_rp[1,1] * 100
	local  cil_rep = m_rp[5,1] * 100
	local  ciu_rep = m_rp[6,1] * 100
	
	* mean relative effect size and CIs (not replicated)
	mean   rr_rp   if rep_sr_rp == 0
	matrix m_rp    = r(table)
	local  rr_nr   = m_rp[1,1] * 100
	local  cil_nr  = m_rp[5,1] * 100
	local  ciu_nr  = m_rp[6,1] * 100
	
	#delimit ;
		noi di 	_column(4)  "of all studies:" 
						_column(45) %4.1f `rr_all'   "%"
						_column(55) "CI = ["
									%5.1f `cil_all'  "%,"
									%5.1f `ciu_all'  "%]";
												
		noi di 	_column(4)  "of those replicated:" 
						_column(45) %4.1f `rr_rep'   "%"
						_column(55) "CI = ["
									%5.1f `cil_rep'  "%,"
									%5.1f `ciu_rep'  "%]";
												
		noi di 	_column(4)  "of those not replicated:" 
						_column(45) %4.1f `rr_nr'    "%"
						_column(55) "CI = ["
									%5.1f `cil_nr'   "%,"
									%5.1f `ciu_nr'   "%]";
	#delimit cr
	
	clear
	
	
	
	* -------------------------------------------------------------------------- *
	* Replication Indicators
	* -------------------------------------------------------------------------- *
	use       "../../Data/Data Processed/D3 - ReplicationResults.dta"
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Number of studies considered being replicated according to ..."
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	local ind "sr mr pi st bf"
	foreach k of local ind {
		* count and percentage
		count  if rep_`k'_rp == 1
		local  rep_`k'  = r(N)
		local  repp_`k' = r(N) / $N * 100
		
		* confidence intervals
		mean   rep_`k'_rp
		matrix m_`k' = r(table)
		local  cil_`k' = m_`k'[5,1] * 100
		local  ciu_`k' = m_`k'[6,1] * 100
	}
	
	#delimit ;
		noi di 	_column(4)  "Significant Effect:" 
						_column(40) %2.0f `rep_sr'  " ("
									%4.1f `repp_sr' "%)"
						_column(55) "CI = ["
									%5.1f `cil_sr'  "%,"
									%5.1f `ciu_sr'  "%]";
												
		noi di 	_column(4)  "Meta Analysis:" 
						_column(40) %2.0f `rep_mr'  " ("
									%4.1f `repp_mr' "%)"
						_column(55) "CI = ["
									%5.1f `cil_mr'  "%,"
									%5.1f `ciu_mr'  "%]";
												
		noi di 	_column(4)  "95% Prediction Intervals:" 
						_column(40) %2.0f `rep_pi'  " ("
									%4.1f `repp_pi' "%)"
						_column(55) "CI = ["
									%5.1f `cil_pi'  "%,"
									%5.1f `ciu_pi'  "%]";
												
		noi di 	_column(4)  "Small Telescopes Approach:" 
						_column(40) %2.0f `rep_st'  " ("
									%4.1f `repp_st' "%)"
						_column(55) "CI = ["
									%5.1f `cil_st'  "%,"
									%5.1f `ciu_st'  "%]";
	
		noi di 	_column(4)  "One-sided Default Bayes Factor:"
						_column(40) %2.0f `rep_bf'  " ("
									%4.1f `repp_bf' "%)"
						_column(55) "CI = ["
									%5.1f `cil_bf'  "%,"
									%5.1f `ciu_bf'  "%]";
	#delimit cr
	
	clear
	
	
	
	* -------------------------------------------------------------------------- *
	* Survey and Prediction Markets
	* -------------------------------------------------------------------------- *
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Survey and Prediction Markets:"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	cap ssc   install unique
	local     sign_ups = 397 
	
	* market participants (active)
	use       "../../Data/Data Processed/D4 - MarketHoldings.dta"
	local markets "m2 m3"
	foreach j of local markets {
		preserve
			drop       if active == 0
			unique pid if treatment == "`j'"
			local  m_`j'  = r(unique)
		restore
	}
	clear
	
	* mean market beliefs
	use       "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	drop  if treatment == "m2"
	
	sum    m3_p
	local  avg_m3p = r(mean) * 100
	local  min_m3p = r(min) * 100
	local  max_m3p = r(max) * 100
	mean   m3_p
	matrix m = r(table)
	local  lb_m3p  = m[5,1] * 100
	local  ub_m3p  = m[6,1] * 100
	
	sum    m3_b
	local  avg_m3b = r(mean)* 100
	local  min_m3b = r(min) * 100
	local  max_m3b = r(max) * 100
	mean   m3_b
	matrix m = r(table)
	local  lb_m3b  = m[5,1] * 100
	local  ub_m3b  = m[6,1] * 100
	
	cap ssc install corrci
	
	spearman m3_p m3_b
	local cms = r(rho)
	local pms = r(p)
	preserve 
		egen   m3p_i = rank(m3_p)
		egen   m3b_i = rank(m3_b)
		corrci m3p_i m3b_i
		mat    cms_lb = r(lb)
		local  cms_lb = cms_lb[2,1] * 100
		mat    cms_ub = r(ub)
		local  cms_ub = cms_ub[2,1] * 100
	restore
	
	spearman m3_p rep_sr_rp
	local cmr = r(rho)
	local pmr = r(p)
	preserve 
		egen   m3p_i = rank(m3_p)
		egen   rep_i = rank(rep_sr_rp)
		corrci m3p_i rep_i
		mat    cmr_lb = r(lb)
		local  cmr_lb = cmr_lb[2,1] * 100
		mat    cmr_ub = r(ub)
		local  cmr_ub = cmr_ub[2,1] * 100
	restore
	
	spearman m3_b rep_sr_rp
	local csr = r(rho)
	local psr = r(p)
	preserve 
		egen   m3b_i = rank(m3_b)
		egen   rep_i = rank(rep_sr_rp)
		corrci m3b_i rep_i
		mat    csr_lb = r(lb)
		local  csr_lb = csr_lb[2,1] * 100
		mat    csr_ub = r(ub)
		local  csr_ub = csr_ub[2,1] * 100
	restore
	
	clear
	
	
	#delimit ;
		noi di 	_column(3)  "Number of Participants:";
		noi di 	_column(3)  "----------------------------------";
		
		noi di 	_column(4)  "Two-Outcome Market"
						_column(39) %3.0f `m_m2';
		noi di 	_column(4)  "Three-Outcome Market"
						_column(39) %3.0f `m_m3';
		
		noi di              "";
		noi di 	_column(3)  "Mean Market/Survey Beliefs:";
		noi di 	_column(3)  "----------------------------------";
		noi di 	_column(4)  "Markets in T2"
						_column(40) %4.1f `avg_m3p' "%"
						_column(47) "[min, max] = ["
									%5.1f `min_m3p' "%,"
									%5.1f `max_m3p' "%]";
		noi di	_column(55) "CI = ["
									%5.1f `lb_m3p'  "%,"
									%5.1f `ub_m3p'  "%]";
												
		noi di 	_column(4)  "Survey in T2"
						_column(40) %4.1f `avg_m3b' "%"
						_column(47) "[min, max] = ["
									%5.1f `min_m3b' "%,"
									%5.1f `max_m3b' "%]";
		noi di	_column(55) "CI = ["
									%5.1f `lb_m3b'  "%,"
									%5.1f `ub_m3b'  "%]";
		
		noi di              "";
		noi di 	_column(3)  "Spearman Correlations:";
		noi di 	_column(3)  "----------------------------------";
		noi di 	_column(4)  "Markets - Survey"
						_column(40) %6.3f `cms'
						_column(55) "CI = ["
									%5.1f `cms_lb'  "%,"
									%5.1f `cms_ub'  "%]";
		noi di	_column(56) "p = "
									%6.3f `pms';
												
		noi di  _column(4)	"Markets - Replication Outcomes"
						_column(40) %6.3f `cmr'
						_column(55) "CI = ["
									%5.1f `cmr_lb'  "%,"
									%5.1f `cmr_ub'  "%]";
		noi di	_column(56) "p = "
									%6.3f `pmr';
												
		noi di  _column(4)	"Survey - Replication Outcomes"
						_column(40) %6.3f `csr'
						_column(55) "CI = ["
									%5.1f `csr_lb'  "%,"
									%5.1f `csr_ub'  "%]";
		noi di	_column(56) "p = "
									%6.3f `psr';
	#delimit cr

	* close log
	log close _all
}
