* **************************************************************************** *
* *** Tables ***                                                               *
* **************************************************************************** *
quietly {

	* S1: hypotheses
	noi di _newline(0)
	noi di "  # processing: table - hypotheses ..."
	do  "S1 - Hypotheses.do"
	noi di "  * done!"
	
	* S2: stage 1 replication results
	noi di _newline(0)
	noi di "  # processing: table - replication results (stage 1) ..."
	do  "S2 - ReplicationResultsS1.do"
	noi di "  * done!"
	
	* S3: stage 2 replication results
	noi di _newline(0)
	noi di "  # processing: table - replication results (stage 2) ..."
	do  "S3 - ReplicationResultsS2.do"
	noi di "  * done!"
	
	* S4: market/survey beliefs 
	noi di _newline(0)
	noi di "  # processing: table - market/survey beliefs ..."
	do  "S4 - PeerBeliefs.do"
	noi di "  * done!"
	
	* S5: prediction market details
	noi di _newline(0)
	noi di "  # processing: table - prediction market details ..."
	do  "S5 - MarketDetails.do"
	noi di "  * done!"
	
	* S6: correlations
	noi di _newline(0)
	noi di "  # processing: table - correlation matrix ..."
	do  "S6 - CorrelationMatrix.do"
	noi di "  * done!"
	
	
	* info
	noi di _newline(1)
	noi di "  # INFO"
	noi di "  * tables have been successfully created in the folder <Tables>"
}	
