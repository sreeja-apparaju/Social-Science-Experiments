* **************************************************************************** *
* *** Table S1: Relication Results (Stage 1) ***                               *
* **************************************************************************** *
quietly {
	clear all
	set more off

	use      "../../Data/Data Processed/D3 - ReplicationResults.dta"
	global   file_name "S1 - Hypotheses"
}


* ---------------------------------------------------------------------------- *
* Relabel Study Variable
* ---------------------------------------------------------------------------- *
quietly {
	label drop _all
	
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
		13 "Lee and Schwartz (2010), Science"
		14 "Morewedge et al. (2010), Science"
		15 "Nishi et al. (2015), Nature"
		16 "Pyc and Rawson (2010), Science"
		17 "Ramirez and Beilock (2011), Science"
		18 "Rand et al. (2012), Nature"
		19 "Shah et al. (2012), Science"
		20 "Sparrow et al. (2011), Science"
		21 "Wilson et al. (2014), Science";
	label values study study;
	#delimit cr
}


* ---------------------------------------------------------------------------- *
* Create Table
* ---------------------------------------------------------------------------- *
quietly {
	keep  study sref
	gen   hypothesis = ""
	label var hypothesis "[SSRP] Hypothesis"

	* set hypothesis
	local h1  "Participants that evaluate a resume while using a heavier clipboard will rate the resume as better overall compared to the participants that evaluate the resume while using a lighter clipboard. The original study used \(F\)-test for a two condition comparison, \(p < 0.05\). Original test statistics: Heavy Condition: \(N = 26\), \(M = 5.80\), \(SD = 0.76\); Light Condition: \(N = 28\), \(M = 5.38\), \(SD = 0.79\). \(F(1, 52) = 4.08\), \(p = 0.049\). If there were no covariates in the model, we will convert the \(F\) to \(t\) for comparison with the replication tests."
	local h2  "The body context is diagnostic for the affective valence of the situation during peak intensity moments (tests the hypothesis of a higher mean valence rating of winning bodies versus losing bodies in the 'body treatment' in Experiment~1; within subjects variation, paired \(t\)-test, \(t(14) = 13.07\), \(p < 0.0001\), p.~1226 and Fig.~1c)."
	local h3  "With preferential treatment of women -- i.e., each woman's performance is automatically increased by one unit in the competition -- more women will choose to compete (a comparison of the fraction of women who chose the tournament scheme rather than the piece rate scheme in the 'preferential treatment one (\textsc{pt1})' versus the 'control treatment (\textsc{ctr})'; \(\chi^2(1) = 5.62\), \(p = 0.018\), p.~580). (This hypothesis was picked by lottery instead of comparing \textsc{pt2} to \textsc{ctr}; \(\chi^2(1) = 10.89\), \(p = 0.001\), p.~580)."
	local h4  "The probability of maintaining cultural diversity (that is, observing both tasks in the group) increases with group size; \(\chi^2(1) = 16.3\), the \(p\)-value \(< 0.0001\) (exact \(0.000054\)) (p.~389; measured at the group level with group sizes, 2, 4, 8, and 16)."
	local h5  "Similar objects are more accurately identified as being similar if they are preceded by new objects than if they are preceded by old objects (a comparison of the fraction of objects rated as similar in trials where they are preceded by new objects compared to trials where they are preceded by old objects in Study 1b (within-subject variation), \(t(14) = 3.41\), \(p = 0.0042\), p.~486)."
	local h6  "Priming analytic thinking via images of 'The Thinker' increases religious disbelief compared to viewing control images of a visually similar artwork; a \(t\)-test, \(p < 0.05\) using a two-tailed test. Original test statistics: \(N = 57\) (31 in Control condition, 26 in Disbelief condition); Control belief in god (100-pt scale): \(M = 61.55\), \(SD = 35.68\); Disbelief: \(M = 41.42\), \(SD = 31.47\); \(t(55) = 2.24\); \(p = 0.029\) (reported as \(p = 0.03\))."
	local h7  "The likelihood of choosing a charity is higher when potential donors know that the overhead is already paid for, than when the donors pay for overhead themselves (a comparison of the fraction choosing to donate to '\textit{charity: water}' between the '50\% overhead, covered treatment' and the '50\% overhead treatment', \(z = 3.00\), \(p < 0.01\) (exact \(p = 0.0027\)), p.~633). (This hypothesis was picked by lottery instead of comparing the 'no overhead treatment' and the '50\% overhead treatment', \(z = 3.27\), \(p < 0.01\), p.~633.)"
	local h8  "Choosing an extraction level for all group members using median voting leads to a higher degree of sustainability of a common pool than allowing each individual to choose their own extraction amount. That is, a comparison of the average probability that the common pool was sustained by the first generation between the voting treatment and the unregulated treatment (in both treatments there is an 80\% probability that a new generation occurs and an extraction threshold of 50\%). To evaluate this hypothesis, a linear probability model with a treatment dummy variable is used; see the 1\textsuperscript{st} generation regression equation in Table~S1; \(p = 1.427e^{-10}\) (reported as \(p < 0.001\)) in a \(t\)-test (\(t(38) = 8.696\)) of the treatment dummy variable coefficient."
	local h9  "Communication increases average earnings in a common-pool resource game with spatial and temporal resource dynamics. A comparison of net earnings between the \textit{NCP} condition and the \textit{C} condition in periods 1 to 3 showed \(p\)-value \(< 0.001\) with the Mann-Whitney test (\(z = 5.761\) and \(p = 8.362e^{-9}\))."
	local h10 "In a memory test one week after learning, Retrieval Practice leads to participants recalling more correct information than Concept-Mapping. A \(t\)-test, \(p < 0.05\) using a two-tailed test, comparing the Retrieval Practice and Concept Mapping conditions. Original test statistics: \(N = 40\) (20 in each condition); Mean performance\( = 0.67\) in the Retrieval Practice condition and 0.45 in the Concept Mapping condition. The comparison between Retrieval Practice and Concept Mapping was reported as \(F(1,38) = 21.63\); \(p = 0.000039\)."
	local h11 "Reading literary fiction improves affective Theory of Mind (a comparison of the mean Reading the Mind in the Eyes Test (RMET) score between the literary fiction treatment and the nonfiction treatment in experiment~1; ANOVA test, \(F(1,82) = 6.40\) and \(p = 0.0133\) (reported as \(p = 0.01\), p.~378)."
	local h12 "Participants automatically project agents' beliefs and store them in a way similar to that of their own representation about the environment. A comparison of the mean reaction time between the 'P-A- treatment' and the 'P-A+ treatment' in Study~1 (within subject variation), shows that reaction time is shorter in the P-A+ treatment; results show that \(t(23) = 2.42\), \(p\)-value \(= 0.02\) (exact \(p = 0.0238\))."
	local h13 "Hand washing will significantly reduce the need to justify one's choice by increasing the perceived difference between alternatives. Specifically, the mean difference between the rankings of the chosen and rejected albums before and after making the choice will be greater for the soap examining condition compared to the soap hand washing condition. \(F\)-test assessing the interaction between before-after and hand-washing condition, \(p < 0.05\). Original test statistics: (i) \textit{Soap examining condition:} Mean difference between chosen and rejected, before making choice: \(M = 0.14\), \(SD = 1.01\). Mean difference between chosen and rejected, after making choice: \(M = 2.05\), \(SD = 1.96\). (ii) \textit{Soap hand washing condition:} Mean difference between chosen and rejected, before making choice: \(M = 0.68\), \(SD = 0.75\). Mean difference between chosen and rejected, after making choice: \(M = 1.00\), \(SD = 1.41\). Interaction of before-after and hand-washing: \(F(1, 38) = 6.74\), \(p = 0.0133\) (reported as \(p = 0.01\))."
	local h14 "Repeatedly imagining eating a food subsequently reduces the actual consumption of that food (a comparison of the 30-repetition treatment and the control treatment in experiment~1; independent samples \(t\)-test, \(t(30) = 2.78\), \(p = 0.0092\), provided by the original authors. The analysis in the original study pools the variance across the 30-repetition, the 3-repetition, and the control condition and reports an ANOVA result of \(F(1,46) = 4.50\), \(p = 0.0393\), p.~1531.) (This hypothesis was picked by lottery instead of comparing the mean consumption of M\&M's between the 30-repetition treatment and the 3-repetition treatment; \(F(1,46) = 5.81\), \(p < 0.05\), p.~1531)."
	local h15 "In initially unequal situations, wealth visibility leads to greater inequality than when wealth is invisible (a comparison of the mean Gini coefficient between the visible and high initial inequality treatment and the invisible and high initial inequality treatment; OLS regression of the session/round Gini coefficient as the dependent variable and multiway clustering of standard errors at the session and round level; regression equation~(5) in Table~S2, \(p = 0.0044\) of a \(t\)-test of the treatment dummy variable coefficient, \(t(198) = 2.881\))."
	local h16 "Retrieval of mediators is greater with test-restudy practice than with restudy practice; a comparison of mean mediator retrieval between the test-restudy and the restudy treatments within the \textsc{cmr} treatment, p.~335, \(t(34) = 2.37\) and \(p\)-value \(= 0.02\), \(t\)-value and \(p\)-value from authors). Note that a successful retrieval in each of the final test questions is defined as correctly recalling any of the keyword mediators that had been generated during session~1."
	local h17 "In a high-pressure in-lab math test, those writing for 10 minutes about their deepest thoughts and feelings regarding the upcoming test improve more on that test compared to simply sitting quietly; an \(F\)-test, \(p < 0.05\) using a two-tailed test. Original test statistics: \(N = 20\) (10 in each condition); Expressive writing M\(_{pre} = 0.86\) (\(SD = 0.09\)), M\(_{post} = 0.91\) (\(SD = 0.05\)), Control M\(_{pre} = 0.82\) (\(SD = 0.09\)), M\(_{post} = 0.70\) (\(SD = 0.11\)); \(F(1,18) = 30.53\); \(p = 0.00003\) (reported as \(p < 0.01\), p.~S11)."
	local h18 "Priming intuition increases cooperation in a public goods game compared to priming reflection (a comparison of the mean contribution in a public goods game between the 'intuition-good'/'reflection-bad' treatments and the 'intuition-bad'/'reflection-good' treatments; a Tobit regression (with robust standard errors) with a treatment dummy variable, regression equation~(1) in Table~S11; \(z = 2.617\), \(p = 0.0089\) in a \(z\)-test of the treatment dummy variable coefficient)."
	local h19 "Low-wealth subjects, that are given fewer chances to win in repeated 'Wheel of Fortune' type word puzzle games, perform worse in a subsequent attention task (Dots-Mixed task) than do high-wealth individuals (a comparison of the mean performance on the Dots-Mixed task between the 'poor treatment' and the 'rich treatment'; ANOVA test, \(F(1,54) = 4.16\) and \(p = 0.046\), p.~683)."
	local h20 "Computer terms are more accessible than general words after answering a block of hard trivia questions; measured as longer color-naming reaction times in a Modified Stroop Task after priming with computer terms compared to priming with non-computer terms (paired \(t\)-test, within subject variation; \(t(45) = 3.26\), \(p = 0.0021\), study~1, p.~776, and Fig.~1)."
	local h21 "An external activity from a list (e.g. watching television or reading a book) for 12 minutes is rated as being more enjoyable than a 12 minute 'thinking period' entertaining themselves with their thoughts (a higher average self-rated enjoyment (the mean of three nine-point scale items) in the 'external activities' treatment than in the 'standard thought instructions' treatment in Study~8, \(t(28) = 4.83\), \(p = 0.000044\), p.~76)."

	
	
	
	* assign hypothesis to studies
	forvalues j = 1 (1) 21 {
		replace hypothesis = "`h`j''" if study == `j'
	}
	
	* keep variable for table
	keep 	 study sref hypothesis
}


* ---------------------------------------------------------------------------- *
* Export Table
* ---------------------------------------------------------------------------- *
quietly {
	#delimit ;
		* export table contents as .tex
		cap ssc  install listtex;
		listtex  `varlist' using "LaTeX/Content.tex", 
						 begin("") delimiter("&") end(`"\\"') missnum("")
						 replace;

		* create .tex table
		cap ssc  install texdoc;
		texdoc   do "LaTeX/$file_name - LaTeX.do";
	#delimit cr

	* call LaTeX, dvi2ps, and ps2pdf
	shell latex 			 "$file_name.tex"
	shell dvips -P pdf "$file_name.dvi"
	shell ps2pdf 			 "$file_name.ps"
	
	* confirm LaTeX has compiled properly
	cap confirm file   "$file_name.dvi"
	if _rc != 0 {
		noi di _n
		noi di _col(40) "ERROR"
		noi di _col(15) _dup(55) "~"
		noi di _col(15) "The table has not been properly compiled using LaTeX."
		noi di _col(15) "Either there is no TeX distribution installed on your"
		noi di _col(15) "computer or the called .exe files are not part of the"
		noi di _col(15) "PATH environmental variable. Thus, the table was not" 
		noi di _col(15) "exported in .ps and .pdf format."
		noi di _col(15) _dup(55) "~"
		exit
	}

	* move compiled files to <Tables> folder
	copy  "$file_name.ps" ///
				"../../Tables/$file_name.ps",  replace
	copy  "$file_name.pdf" ///
				"../../Tables/$file_name.pdf", replace
	
	* drop temporary files
	local temp "aux dvi log pdf ps tex"
	erase "$file_name.aux"
	erase "$file_name.dvi"
	erase "$file_name.log"
	erase "$file_name.pdf"
	erase "$file_name.ps"
	erase "$file_name.tex"
	erase "LaTeX/Content.tex"
	
	clear
}
