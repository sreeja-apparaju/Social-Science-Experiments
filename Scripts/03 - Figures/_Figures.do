* **************************************************************************** *
* *** Figures ***                                                              *
* **************************************************************************** *
quietly {

	* F1: standardized effect sizes and meta results
	noi di _newline(0)
	noi di "  # processing: figure - standardized effect sizes ..."
	do  "F1 - EffectSizes.do"
	noi di "  * done!"
	
	* F2: small telescope approach and prediction intervals (standardized)
	noi di _newline(0)
	noi di "  # processing: figure - PIs and small telescope approach ..."
	do  "F2 - PI_SmallTelescope.do"
	noi di "  * done!"
	
	* F3: Bayes factors
	noi di _newline(0)
	noi di "  # processing: figure - default Bayes factors ..."
	do  "F3 - DefaultBayesFactors.do"
	noi di "  * done!"
	
	* F4: market/survey beliefs (treatment m3)
	noi di _newline(0)
	noi di "  # processing: figure - market/survey beliefs ..."
	do  "F4 - PeerBeliefs.do"
	noi di "  * done!"
	
	* S1: non-standardized effect sizes and meta results
	noi di _newline(0)
	noi di "  # processing: figure - non-standardized effect sizes ..."
	do  "S1 - EffectSizes - RobustnessTests.do"
	noi di "  * done!"
	
	* S2: small telescope approach and prediction intervals (non-standardized)
	noi di _newline(0)
	noi di "  # processing: figure - PIs and small telescope approach ..."
	do  "S2 - PI_SmallTelescope - RobustnessTests.do"
	noi di "  * done!"
	
	* S3: Bayes factors
	noi di _newline(0)
	noi di "  # processing: figure - replication Bayes factors ..."
	do  "S3 - ReplicationBayesFactors.do"
	noi di "  * done!"
	
	* S4: correlation between original and replication effect sizes
	noi di _newline(0)
	noi di "  # processing: figure - correlation effect sizes ..."
	do  "S4 - CorrelationEffectSizes.do"
	noi di "  * done!"
	
	* S5: Bayesian analyses - posterior distributions
	noi di _newline(0)
	noi di "  # processing: figure - posterior distributions ..."
	do "S5 - PosteriorDistributions.do"
	noi di "  * done!"
	
	* S7: market/survey beliefs (treatment m2)
	noi di _newline(0)
	noi di "  # processing: figure - market/survey beliefs (stage 1) ..."
	do "S7 - PeerBeliefs.do"
	noi di "  * done!"
	
	* S8: correlation between market/survey beliefs and effect sizes
	noi di _newline(0)
	noi di "  # processing: figure - correlation beliefs effect sizes ..."
	do  "S8 - PeerBeliefsEffectSize.do"
	noi di "  * done!"
	
	* S9: comparison of replication projects
	noi di _newline(0)
	noi di "  # processing: figure - comparison of replicability projects ..."
	do  "S9 - Comparison.do"
	noi di "  * done!"
	
	
	* info
	noi di _newline(1)
	noi di "  # INFO"
	noi di "  * figures have been successfully created in the folder <Figures>"
}	

