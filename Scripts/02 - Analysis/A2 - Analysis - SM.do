quietly {
	clear all
	set more off
	global N = 21
	
	* create log
	log using "../../Results/Analysis - SM", replace name(text) text
	log using "../../Results/Analysis - SM", replace name(smcl) smcl
	
	
	* -------------------------------------------------------------------------- *
	* Mean Standardized Effect Size (Robustness Tests)
	* -------------------------------------------------------------------------- *
	use       "../../Data/Data Processed/D8 - RobustnessTests.dta"
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Mean Standardized Effect Size (Robustness Tests):"
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
	clear
	
	
	
	* -------------------------------------------------------------------------- *
	* Mean Relative Effect Size - Robustness Tests
	* -------------------------------------------------------------------------- *
	use       "../../Data/Data Processed/D8 - RobustnessTests.dta"
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Mean Relative Effect Size (Robustness Tests):"
	noi di    _dup(80) "~"
	noi di    _newline(0)	
	
	* mean relative effect size and CIs (all studies)
	mean   rr_rp
	matrix m_rp    = r(table)
	local  rr_all  = m_rp[1,1] * 100
	local  cil_all = m_rp[5,1] * 100
	local  ciu_all = m_rp[6,1] * 100
	
	* mean relative effect size and CIs (replicated)
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
	* Survey and Prediction Markets
	* -------------------------------------------------------------------------- *
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Survey and Prediction Markets:"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	cap ssc   install unique
	local     sign_ups = 397 
	
	* survey participants
	use       "../../Data/Data Processed/D5 - PreMarketSurvey.dta"
	local markets "m2 m3"
	foreach j of local markets {
		unique pid if treatment == "`j'"
		local  s_`j'  = r(unique)
		local  sp_`j' = `s_`j'' / `sign_ups' * 100
	}
	clear
	
	* market participants (active)
	use       "../../Data/Data Processed/D4 - MarketTransactions.dta"
	local markets "m2 m3"
	foreach j of local markets {
		preserve
			unique uid if treatment == "`j'"
			local  m_`j'  = r(unique)
			local  mp_`j' = `m_`j'' / `s_`j'' * 100
		restore
	}
	clear
	
	* active traders per market
	use       "../../Data/Data Processed/D4 - MarketTransactions.dta"
	local markets "m2 m3"
	foreach j of local markets {
		preserve
			drop  if treatment != "`j'"
			duplicates drop  uid study, force
			collapse (count) uid, by(study)
			
			sum   uid 
			local min_`j' = r(min)
			local max_`j' = r(max)
		restore
	}
	clear
	
	
	#delimit ;
		noi di  _column(3)  "Initial Sign-Ups:"
						_column(39) %3.0f `sign_ups';
		
		noi di              "";
		noi di 	_column(3)  "Two-Outcome Treatment:";
		noi di 	_column(3)  "------------------------";
		
		noi di 	_column(4)  "Participants Survey"
						_column(39) %3.0f `s_m2'  " ("
									%4.1f `sp_m2' "% of initial sign-ups)";
		noi di 	_column(4)  "Participants Markets"
						_column(39) %3.0f `m_m2'  " ("
									%4.1f `mp_m2' "% of survey participants)";
		noi di 	_column(4)  "Active Traders in Each Market"
						_column(39) "[min,max] = ["
									%2.0f `min_m2' ","
									%2.0f `max_m2' "]";
		
		noi di              "";
		noi di 	_column(3)  "Three-Outcome Treatment:";
		noi di 	_column(3)  "------------------------";
		
		noi di 	_column(4)  "Participants Survey"
						_column(39) %3.0f `s_m3'  " ("
									%4.1f `sp_m3' "% of initial sign-ups)";
		noi di 	_column(4)  "Participants Markets"
						_column(39) %3.0f `m_m3'  " ("
									%4.1f `mp_m3' "% of survey participants)";
		noi di 	_column(4)  "Active Traders in Each Market"
						_column(39) "[min,max] = ["
									%2.0f `min_m3' ","
									%2.0f `max_m3' "]";
	#delimit cr
	
	
	
	* -------------------------------------------------------------------------- *
	* Prediction Markets: Demographics
	* -------------------------------------------------------------------------- *
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Demographics of Survey/Market Participants:"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	use       "../../Data/Data Processed/D6 - Demographics.dta"
	
	drop   if active == 0
	local  tot = _N
	
	* position
	#delimit ;
	replace   position =  "p1" if 
						position == "Professor";
	replace   position =  "p2" if 
						position == "Associate Professor" |
						position == "Lecturer";
	replace   position =  "p3" if 
						position == "PostDoc" | 
						position == "Assistant Professor";
	replace   position =  "p4" if 
						position == "PhD Candidate";
	replace   position =  "p5" if 
						position == "Professional with PhD";
	#delimit cr
	
	count if  position == "p1"
	local p1  = r(N)
	local p1p = `p1'/`tot'*100
	count if  position == "p2"
	local p2  = r(N)
	local p2p = `p2'/`tot'*100
	count if  position == "p3"
	local p3  = r(N)
	local p3p = `p3'/`tot'*100
	count if  position == "p4"
	local p4  = r(N)
	local p4p = `p4'/`tot'*100
	count if  position == "p5"
	local p5  = r(N)
	local p5p = `p5'/`tot'*100
	
	* gender
	count if  gender == "Female"
	local gf  = r(N)
	local gfp = `gf'/`tot'*100
	count if  gender == "Male"
	local gm  = r(N)
	local gmp = `gm'/`tot'*100
	count if  gender == "Other"
	local go  = r(N)
	local gop = `go'/`tot'*100
	
	* residence
	count if  residence == "Northern America"
	local aa  = r(N)
	local aap = `aa'/`tot'*100
	count if  residence == "Europe"
	local ae  = r(N)
	local aep = `ae'/`tot'*100
	
	* research
	count if  research == "Psychology"
	local rp  = r(N)
	local rpp = `rp'/`tot'*100
	count if  research == "Economics"
	local re  = r(N)
	local rep = `re'/`tot'*100
	
	clear
	
	
	#delimit ;
		noi di 	_column(3)  "Position:";
		noi di 	_column(3)  "----------";
		
		noi di 	_column(4)  "Full Professor"
						_column(39) %3.0f `p1'  " ("
									%4.1f `p1p' "%)";
		noi di 	_column(4)  "Assoc. Prof./Lecturer"
						_column(39) %3.0f `p2'  " ("
									%4.1f `p2p' "%)";
		noi di 	_column(4)  "Post-Doc/Assist. Prof."
						_column(39) %3.0f `p3'  " ("
									%4.1f `p3p' "%)";
		noi di 	_column(4)  "PhD Student"
						_column(39) %3.0f `p4'  " ("
									%4.1f `p4p' "%)";
		noi di 	_column(4)  "Professional (with PhD)"
						_column(39) %3.0f `p5'  " ("
									%4.1f `p5p' "%)";
												
		noi di              "";
		noi di 	_column(3)  "Gender:";
		noi di 	_column(3)  "----------";
		
		noi di 	_column(4)  "Female"
						_column(39) %3.0f `gf'  " ("
									%4.1f `gfp' "%)";
		noi di 	_column(4)  "Male"
						_column(39) %3.0f `gm'  " ("
									%4.1f `gmp' "%)";
		noi di 	_column(4)  "Other"
						_column(39) %3.0f `go'  " ("
									%4.1f `gop' "%)";
												
		noi di              "";
		noi di 	_column(3)  "Residence:";
		noi di 	_column(3)  "----------";
		
		noi di 	_column(4)  "Nothern America"
						_column(39) %3.0f `aa'  " ("
									%4.1f `aap' "%)";
		noi di 	_column(4)  "Europe"
						_column(39) %3.0f `ae'  " ("
									%4.1f `aep' "%)";
												
		noi di              "";
		noi di 	_column(3)  "Research:";
		noi di 	_column(3)  "----------";
		
		noi di 	_column(4)  "Psychology"
						_column(39) %3.0f `rp'  " ("
									%4.1f `rpp' "%)";
		noi di 	_column(4)  "Economics"
						_column(39) %3.0f `re'  " ("
									%4.1f `rep' "%)";
	#delimit cr

	
	
	* -------------------------------------------------------------------------- *
	* Prediction Markets/Surveys: Treatment 1 - Analysis
	* -------------------------------------------------------------------------- *
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Prediction Markets/Surveys: Treatment 1 - Analysis"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	use       "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	
	* summary statistics
	sum   m2_p, det
	local avg_m2p = r(mean)*100
	local mdn_m2p = r(p50)*100
	local min_m2p = r(min)*100
	local max_m2p = r(max)*100
	
	sum   m2_b, det
	local avg_m2b = r(mean)*100
	local mdn_m2b = r(p50)*100
	local min_m2b = r(min)*100
	local max_m2b = r(max)*100
	
	* market beliefs # survey beliefs
	spearman    m2_p   m2_b
	local cc_m2p_m2b = r(rho)
	local cp_m2p_m2b = r(p)
	
	signrank    m2_p = m2_b
	local tz_m2p_m2b = abs(r(z))
	local tp_m2p_m2b = 2 * (1 - normal(`tz_m2p_m2b'))
	
	* market beliefs # replication outcome (stage 1)
	spearman    m2_p   rep_sr_rs1
	local cc_m2p_rs1 = r(rho)
	local cp_m2p_rs1 = r(p)
	
	signrank    m2_p = rep_sr_rs1
	local tz_m2p_rs1 = abs(r(z))
	local tp_m2p_rs1 = 2 * (1 - normal(`tz_m2p_rs1'))
	
	* survey beliefs # replication outcome (stage 1)
	spearman    m2_b   rep_sr_rs1
	local cc_m2b_rs1 = r(rho)
	local cp_m2b_rs1 = r(p)
	
	signrank    m2_b = rep_sr_rs1
	local tz_m2b_rs1 = abs(r(z))
	local tp_m2b_rs1 = 2 * (1 - normal(`tz_m2b_rs1'))
	
	* market beliefs # replication outcome (stage 2)
	spearman    m2_p   rep_sr_rp
	local cc_m2p_rp  = r(rho)
	local cp_m2p_rp  = r(p)
	
	* survey beliefs # replication outcome (stage 2)
	spearman    m2_b   rep_sr_rp
	local cc_m2b_rp  = r(rho)
	local cp_m2b_rp  = r(p)
	
	* market beliefs # relative effect sizes
	spearman    m2_p   rr_rp
	local cc_m2p_rr  = r(rho)
	local cp_m2p_rr  = r(p)
	
	* survey beliefs # relative effect sizes
	spearman    m2_b   rr_rp
	local cc_m2b_rr  = r(rho)
	local cp_m2b_rr  = r(p)
	
	* absolute prediction error market beliefs
	gen   p_error = abs(m2_p - rep_sr_rs1)
	sum   p_error
	local p_error = r(mean)*100
	
	* absolute prediction error survey beliefs
	gen   b_error = abs(m2_b - rep_sr_rs1)
	sum   b_error
	local b_error = r(mean)*100
	
	* prediction error market ## prediction error survey
	signrank p_error = b_error
	local tz_error   = abs(r(z))
	local tp_error   = 2 * (1 - normal(`tz_error'))
	
	clear all
	
	
	#delimit ;
		noi di  _column(3)  "Prediction Market Beliefs:"
		        _column(40) %4.1f `avg_m2p' "% (mdn = "
						    %4.1f `mdn_m2p' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m2p' "%,"
							%4.1f `max_m2p' "%]";

		noi di  _newline(0);
		noi di  _column(3)  "Survey Beliefs:"
		        _column(40) %4.1f `avg_m2b' "% (mdn = "
						    %4.1f `mdn_m2b' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m2b' "%,"
							%4.1f `max_m2b' "%]";
	
		noi di  _newline(1);
		noi di 	_column(3)  "Market Beliefs ## Survey Beliefs";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2p_m2b' " ("
							%5.3f `cp_m2p_m2b' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m2p_m2b' " ("
							%5.3f `tp_m2p_m2b' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs ## Replication Outcome (S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2p_rs1' " ("
							%5.3f `cp_m2p_rs1' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m2p_rs1' " ("
							%5.3f `tp_m2p_rs1' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs ## Replication Outcome (S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2b_rs1' " ("
							%5.3f `cp_m2b_rs1' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m2b_rs1' " ("
							%5.3f `tp_m2b_rs1' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs ## Replication Outcome (S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2p_rp' " ("
							%5.3f `cp_m2p_rp' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs ## Replication Outcome (S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2b_rp' " ("
							%5.3f `cp_m2b_rp' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs ## Relative Effect Size";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2p_rr' " ("
							%5.3f `cp_m2p_rr' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs ## Relative Effect Size";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2b_rr' " ("
							%5.3f `cp_m2b_rr' ") ";
												
		noi di  _newline(1);
		noi di 	_column(3)  "Prediction Error";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Market Beliefs:"
				_column(40) %4.1f `p_error' " pp";
		noi di 	_column(4)  "Survey Beliefs:"
				_column(40) %4.1f `b_error' " pp";
		
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_error' " ("
							%5.3f `tp_error' ") ";
	
	#delimit cr
	
	
	
	* -------------------------------------------------------------------------- *
	* Prediction Markets/Surveys: Treatment 2 - Analysis
	* -------------------------------------------------------------------------- *
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Prediction Markets/Surveys: Treatment 2 - Analysis"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	use       "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	
	* summary statistics
	sum   m3_p1, det
	local avg_m3p1 = r(mean)*100
	local mdn_m3p1 = r(p50)*100
	local min_m3p1 = r(min)*100
	local max_m3p1 = r(max)*100
	
	sum   m3_b1, det
	local avg_m3b1 = r(mean)*100
	local mdn_m3b1 = r(p50)*100
	local min_m3b1 = r(min)*100
	local max_m3b1 = r(max)*100
	
	sum   m3_p2, det
	local avg_m3p2 = r(mean)*100
	local mdn_m3p2 = r(p50)*100
	local min_m3p2 = r(min)*100
	local max_m3p2 = r(max)*100
	
	sum   m3_b2, det
	local avg_m3b2 = r(mean)*100
	local mdn_m3b2 = r(p50)*100
	local min_m3b2 = r(min)*100
	local max_m3b2 = r(max)*100
	
	sum   m3_p, det
	local avg_m3p = r(mean)*100
	local mdn_m3p = r(p50)*100
	local min_m3p = r(min)*100
	local max_m3p = r(max)*100
	
	sum   m3_b, det
	local avg_m3b = r(mean)*100
	local mdn_m3b = r(p50)*100
	local min_m3b = r(min)*100
	local max_m3b = r(max)*100
	
	
	* market beliefs (s1) # survey beliefs (s1)
	spearman     m3_p1   m3_b1
	local cc_m3p1_m3b1 = r(rho)
	local cp_m3p1_m3b1 = r(p)
	
	signrank     m3_p1 = m3_b1
	local tz_m3p1_m3b1 = abs(r(z))
	local tp_m3p1_m3b1 = 2 * (1 - normal(`tz_m3p1_m3b1'))
	
	* market beliefs (s2) # survey beliefs (s2)
	spearman     m3_p2   m3_b2
	local cc_m3p2_m3b2 = r(rho)
	local cp_m3p2_m3b2 = r(p)
	
	signrank     m3_p2 = m3_b2
	local tz_m3p2_m3b2 = abs(r(z))
	local tp_m3p2_m3b2 = 2 * (1 - normal(`tz_m3p2_m3b2'))
	
	* market beliefs (s1+s2) # survey beliefs (s1+s2)
	spearman      m3_p   m3_b
	local cc_m3p_m3b   = r(rho)
	local cp_m3p_m3b   = r(p)
	
	signrank      m3_p = m3_b
	local tz_m3p_m3b   = abs(r(z))
	local tp_m3p_m3b   = 2 * (1 - normal(`tz_m3p_m3b'))
	
	* market beliefs (s1) # replication outcome (s1)
	spearman     m3_p1   rep_sr_rs1
	local cc_m3p1_rs1  = r(rho)
	local cp_m3p1_rs1  = r(p)
	
	signrank     m3_p1 = rep_sr_rs1
	local tz_m3p1_rs1  = abs(r(z))
	local tp_m3p1_rs1  = 2 * (1 - normal(`tz_m3p1_rs1'))
	
	* survey beliefs (s1) # replication outcome (s1)
	spearman     m3_b1   rep_sr_rs1
	local cc_m3b1_rs1  = r(rho)
	local cp_m3b1_rs1  = r(p)
	
	signrank     m3_b1 = rep_sr_rs1
	local tz_m3b1_rs1  = abs(r(z))
	local tp_m3b1_rs1  = 2 * (1 - normal(`tz_m3b1_rs1'))
	
	* market beliefs (s2) # replication outcome (s2)
	spearman     m3_p2   rep_sr_rs2
	local cc_m3p2_rs2  = r(rho)
	local cp_m3p2_rs2  = r(p)
	
	signrank     m3_p2 = rep_sr_rs2
	local tz_m3p2_rs2  = abs(r(z))
	local tp_m3p2_rs2  = 2 * (1 - normal(`tz_m3p2_rs2'))
	
	* survey beliefs (s2) # replication outcome (s2)
	spearman     m3_b2   rep_sr_rs2
	local cc_m3b2_rs2  = r(rho)
	local cp_m3b2_rs2  = r(p)
	
	signrank     m3_b2 = rep_sr_rs2
	local tz_m3b2_rs2  = abs(r(z))
	local tp_m3b2_rs2  = 2 * (1 - normal(`tz_m3b2_rs2'))
	
	* market beliefs (s1+s2) # replication outcome (s1+s2)
	spearman     m3_p    rep_sr_rp
	local cc_m3p_rp    = r(rho)
	local cp_m3p_rp    = r(p)
	
	signrank     m3_p  = rep_sr_rp
	local tz_m3p_rp    = abs(r(z))
	local tp_m3p_rp    = 2 * (1 - normal(`tz_m3p_rp'))
	
	* survey beliefs (s1+s2) # replication outcome (s1+s2)
	spearman     m3_b    rep_sr_rp
	local cc_m3b_rp    = r(rho)
	local cp_m3b_rp    = r(p)
	
	signrank     m3_b  = rep_sr_rp
	local tz_m3b_rp    = abs(r(z))
	local tp_m3b_rp    = 2 * (1 - normal(`tz_m3b_rp'))
	
	* absolute prediction error market beliefs (s1)
	gen   p_e_rs1      = abs(m3_p1 - rep_sr_rs1)
	sum   p_e_rs1
	local p_e_rs1      = r(mean)*100
	
	* absolute prediction error survey beliefs (s1)
	gen   b_e_rs1      = abs(m3_b1 - rep_sr_rs1)
	sum   b_e_rs1
	local b_e_rs1      = r(mean)*100
	
	* prediction error market (s1) ## prediction error survey (s1)
	signrank   p_e_rs1 = b_e_rs1
	local tz_e_rs1     = abs(r(z))
	local tp_e_rs1     = 2 * (1 - normal(`tz_e_rs1'))
	
	* absolute prediction error market beliefs (s1)
	gen   p_e_rp       = abs(m3_p - rep_sr_rp)
	sum   p_e_rp 
	local p_e_rp       = r(mean)*100
	
	* absolute prediction error survey beliefs (s1)
	gen   b_e_rp       = abs(m3_b - rep_sr_rp)
	sum   b_e_rp
	local b_e_rp       = r(mean)*100
	
	* prediction error market (s1) ## prediction error survey (s1)
	signrank    p_e_rp = b_e_rp
	local tz_e_rp      = abs(r(z))
	local tp_e_rp      = 2 * (1 - normal(`tz_e_rp'))
	
	clear
	
	
	#delimit ;
		noi di  _column(3)  "Prediction Market Beliefs (S1):"
		        _column(40) %4.1f `avg_m3p1' "% (mdn = "
						    %4.1f `mdn_m3p1' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m3p1' "%,"
							%4.1f `max_m3p1' "%]";
		
		noi di  _newline(0);
		noi di  _column(3)  "Prediction Market Beliefs (S2):"
		        _column(40) %4.1f `avg_m3p2' "% (mdn = "
						    %4.1f `mdn_m3p2' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m3p2' "%,"
							%4.1f `max_m3p2' "%]";
												
		noi di  _newline(0);
		noi di  _column(3)  "Prediction Market Beliefs (S1+S2):"
		        _column(40) %4.1f `avg_m3p' "% (mdn = "
						    %4.1f `mdn_m3p' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m3p' "%,"
							%4.1f `max_m3p' "%]";
		
		noi di  _newline(0);
		noi di  _column(3)  "Survey Beliefs (S1):"
		        _column(40) %4.1f `avg_m3b1' "% (mdn = "
						    %4.1f `mdn_m3b1' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m3b1' "%,"
							%4.1f `max_m3b1' "%]";
												
		noi di  _newline(0);
		noi di  _column(3)  "Survey Beliefs (S2):"
		        _column(40) %4.1f `avg_m3b2' "% (mdn = "
						    %4.1f `mdn_m3b2' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m3b2' "%,"
							%4.1f `max_m3b2' "%]";
												
		noi di  _newline(0);
		noi di  _column(3)  "Survey Beliefs (S1+S2):"
		        _column(40) %4.1f `avg_m3b' "% (mdn = "
						    %4.1f `mdn_m3b' "%) ";
		noi di	_column(40) "[min, max] = ["
							%4.1f `min_m3b' "%,"
							%4.1f `max_m3b' "%]";
	
		noi di  _newline(1);
		noi di 	_column(3)  "Market Beliefs (S1) ## Survey Beliefs (S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3p1_m3b1' " ("
							%5.3f `cp_m3p1_m3b1' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3p1_m3b1' " ("
							%5.3f `tp_m3p1_m3b1' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs (S2) ## Survey Beliefs (S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3p2_m3b2' " ("
							%5.3f `cp_m3p2_m3b2' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3p2_m3b2' " ("
							%5.3f `tp_m3p2_m3b2' ") ";										
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs (S1+S2) ## Survey Beliefs (S1+S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3p_m3b' " ("
							%5.3f `cp_m3p_m3b' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3p_m3b' " ("
							%5.3f `tp_m3p_m3b' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs (S1) ## Replication Outcome (S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3p1_rs1' " ("
							%5.3f `cp_m3p1_rs1' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3p1_rs1' " ("
							%5.3f `tp_m3p1_rs1' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs (S1) ## Replication Outcome (S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3b1_rs1' " ("
							%5.3f `cp_m3b1_rs1' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3b1_rs1' " ("
							%5.3f `tp_m3b1_rs1' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs (S2) ## Replication Outcome (S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3p2_rs2' " ("
							%5.3f `cp_m3p2_rs2' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3p2_rs2' " ("
							%5.3f `tp_m3p2_rs2' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs (S2) ## Replication Outcome (S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3b2_rs2' " ("
							%5.3f `cp_m3b2_rs2' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3b2_rs2' " ("
							%5.3f `tp_m3b2_rs2' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Market Beliefs (S1+S2) ## Replication Outcome (S1+S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3p_rp' " ("
							%5.3f `cp_m3p_rp' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3p_rp' " ("
							%5.3f `tp_m3p_rp' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs (S1+S2) ## Replication Outcome (S1+S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m3b_rp' " ("
							%5.3f `cp_m3b_rp' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m3b_rp' " ("
							%5.3f `tp_m3b_rp' ") ";
												
		noi di  _newline(1);
		noi di 	_column(3)  "Prediction Error (S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Market Beliefs (S1):"
				_column(40) %4.1f `p_e_rs1' " pp";
		noi di 	_column(4)  "Survey Beliefs (S1):"
				_column(40) %4.1f `b_e_rs1' " pp";
		
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_e_rs1' " ("
							%5.3f `tp_e_rs1' ") ";
												
		noi di  			"";
		noi di 	_column(3)  "Prediction Error (S1+S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Market Beliefs (S1+S2):"
				_column(40) %4.1f `p_e_rp' " pp";
		noi di 	_column(4)  "Survey Beliefs (S1+S2):"
				_column(40) %4.1f `b_e_rp' " pp";
		
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_e_rp' " ("
							%5.3f `tp_e_rp' ") ";
		
	#delimit cr
	
	
	* -------------------------------------------------------------------------- *
	* Prediction Markets/Surveys: Treatment 1 vs. Treatment 2
	* -------------------------------------------------------------------------- *
	
	noi di    _newline(2)
	noi di    _dup(80) "~"
	noi di    "Prediction Markets/Surveys: Treatment 1 vs. Treatment 2"
	noi di    _dup(80) "~"
	noi di    _newline(0)
	
	use       "../../Data/Data Processed/D6 - MeanPeerBeliefs.dta"
	collapse  m* rep*, by(study)
	
	
	* market beliefs (s1-t1) # market beliefs (s1-t2)
	spearman      m2_p   m3_p1
	local cc_m2p_m3p1  = r(rho)
	local cp_m2p_m3p1  = r(p)
	
	signrank      m2_p = m3_p1
	local tz_m2p_m3p1  = abs(r(z))
	local tp_m2p_m3p1  = 2 * (1 - normal(`tz_m2p_m3p1'))
	
	* survey beliefs (s1-t1) # survey beliefs (s1-t2)
	spearman      m2_b   m3_b1
	local cc_m2b_m3b1  = r(rho)
	local cp_m2b_m3b1  = r(p)
	
	signrank      m2_b = m3_b1
	local tz_m2b_m3b1  = abs(r(z))
	local tp_m2b_m3b1  = 2 * (1 - normal(`tz_m2b_m3b1'))
	
	* market beliefs (s1-t1) # market beliefs (s2-t2)
	spearman      m2_p   m3_p
	local cc_m2p_m3p   = r(rho)
	local cp_m2p_m3p   = r(p)
	
	* survey beliefs (s1-t1) # survey beliefs (s2-t2)
	spearman      m2_b   m3_b
	local cc_m2b_m3b   = r(rho)
	local cp_m2b_m3b   = r(p)
	
	clear
	
	
	#delimit ;
		noi di 	_column(3)  "Market Beliefs (T1|S1) ## Market Beliefs (T2|S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2p_m3p1' " ("
							%5.3f `cp_m2p_m3p1' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m2p_m3p1' " ("
							%5.3f `tp_m2p_m3p1' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs (T1|S1) ## Survey Beliefs (T2|S1)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2b_m3b1' " ("
							%5.3f `cp_m2b_m3b1' ") ";
		noi di  _column(4)  "Wilcoxon test (p-value):" 
				_column(40) %5.3f `tz_m2b_m3b1' " ("
							%5.3f `tp_m2b_m3b1' ") ";
		
		noi di              "";
		noi di 	_column(3)  "Market Beliefs (T1|S1) ## Market Beliefs (T2|S1+S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2p_m3p' " ("
							%5.3f `cp_m2p_m3p' ") ";
												
		noi di              "";
		noi di 	_column(3)  "Survey Beliefs (T1|S1) ## Survey Beliefs (T2|S1+S2)";
		noi di 	_column(3)  "-----------------------------------------------------";
		noi di 	_column(4)  "Spearman's rho (p-value):"
				_column(40) %5.3f `cc_m2b_m3b' " ("
							%5.3f `cp_m2b_m3b' ") ";
												
	#delimit cr
	
	* close log
	log close _all
}
