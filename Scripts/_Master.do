quietly {

	* data processing
	cd  "01 - DataProcessing"
	noi do "_DataProcessing.do"
	noi di _newline(3)
	cd  ".."

	* analysis
	cd  "02 - Analysis"
	noi do "_Analysis.do"
	noi di _newline(3)
	cd  ".."
	
	* figures
	cd  "03 - Figures"
	noi do "_Figures.do"
	noi di _newline(3)
	cd  ".."
	
	* tables
	cd  "04 - Tables"
	noi do "_Tables.do"
	noi di _newline(3)
	cd  ".."
	
}

