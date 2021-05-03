* **************************************************************************** *
* *** Tables ***                                                               *
* **************************************************************************** *
quietly {

	* S1: hypotheses
	noi di _newline(0)
	noi di "  # processing: table - hypotheses ..."
	do  "S1 - Hypotheses.do"
	noi di "  * done!"
	
	* S2: materials and approval
	noi di _newline(0)
	noi di "  # processing: table - materials and approval ..."
	do  "S2 - MaterialsAndApproval.do"
	noi di "  * done!"
	
	* S3: stage 1 replication results
	noi di _newline(0)
	noi di "  # processing: table - replication results (stage 1) ..."
	do  "S3 - ReplicationResultsS1.do"
	noi di "  * done!"
	
	* S4: stage 2 replication results
	noi di _newline(0)
	noi di "  # processing: table - replication results (stage 2) ..."
	do  "S4 - ReplicationResultsS2.do"
	noi di "  * done!"
	
	* S5: market/survey beliefs 
	noi di _newline(0)
	noi di "  # processing: table - market/survey beliefs ..."
	do  "S5 - PeerBeliefs.do"
	noi di "  * done!"
	
	* S6: prediction market details
	noi di _newline(0)
	noi di "  # processing: table - prediction market details ..."
	do  "S6 - MarketDetails.do"
	noi di "  * done!"
	
	* S7: correlations
	noi di _newline(0)
	noi di "  # processing: table - correlation matrix ..."
	do  "S7 - CorrelationMatrix.do"
	noi di "  * done!"
	
	
	* info
	noi di _newline(1)
	noi di "  # INFO"
	noi di "  * tables have been successfully created in the folder <Tables>"
}	
