* **************************************************************************** *
* *** Data Processing ***                                                      *
* **************************************************************************** *
quietly {

	* create study details of original data
	noi di _newline(0)
	noi di "  # processing: study details for original studies ..."
	do  "D1 - OriginalStudies.do"
	noi di "  * done!"
	
	* determine replication sample sizes
	noi di _newline(0)
	noi di "  # processing: sample sizes for replication studies ..."
	do "D2 - ReplicationSampleSizes.do"
	noi di "  * done!"
	
	* determine replication results and indicators
	noi di _newline(0)
	noi di "  # processing: replication results ..."
	do  "D3 - ReplicationResults.do"
	noi di "  * done!"
	
	* process prediction market data
	noi di _newline(0)
	noi di "  # processing: prediction markets ..."
	do  "D4 - PredictionMarkets.do"
	noi di "  * done!"
	
	* process pre-market survey data
	noi di _newline(0)
	noi di "  # processing: pre-market survey ..."
	do  "D5 - PreMarketSurvey.do"
	noi di "  * done!"
	
	* generate mean survey and market data
	noi di _newline(0)
	noi di "  # processing: market and survey means ..."
	do  "D6 - MarketsAndSurvey.do"
	noi di "  * done!"
	
	* comparison of ssrp, eerp, rpp
	noi di _newline(0)
	noi di "  # processing: data for comparison ..."
	do  "D7 - Comparison.do"
	noi di "  * done!"
	
	* robustness tests
	noi di _newline(0)
	noi di "  # processing: robustness tests ..."
	do  "D8 - RobustnessTests.do"
	noi di "  * done!"
	
	
	* info
	noi di _newline(1)
	noi di "  # INFO"
	noi di "  * data has been successfully created in the folder <Data>"
	
}
