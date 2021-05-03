clear

set obs 23


/* Studies
---------------------------------*/
gen int study=_n

label def studies ///
1 "Ackerman et al." ///
2 "Aviezer et al." ///
3 "Balafoutas and Sutter" ///
4 "Derex et al." ///
5 "Duncan et al." ///
6 "Gervais and Norenzayan" ///
7 "Gneezy et al." ///
8 "Hauser et al." ///
9 "Janssen et al." ///
10 "Karpicke and Blunt" ///
11 "Kidd and Castano" ///
12 "Kovacs et al." ///
13 "Lee and Schwarz" ///
14 "Mani et al." ///
15 "Morewedge et al. (30 vs. Control)" ///
16 "Nishi et al." ///
17 "Pyc and Rawson" ///
18 "Ramirez and Beilock" ///
19 "Rand et al." ///
20 "Shah et al." ///
21 "Sparrow et al." ///
22 "Wilson et al." ///
23 "Morewedge et al. (30 vs. 3)"

label val study studies


/* Journals
---------------------------------*/
gen int journal=.

label def journals 1 "Nature" 2 "Science"
label val journal journals

replace journal = 1 if study==4 | study==8 | study==16 | study==19
replace journal = 2 if journal==.


/* Test statistics
---------------------------------*/
gen double ncporig = .
gen statorig = ""
gen int norig = .
gen int noriggrouped = .
gen int norigexcluded = .
gen int df1orig = .
gen int df2orig = .

// Ackerman et al.
replace ncporig = 4.08 if study==1
replace statorig = "F" if study==1
replace norig = 54 if study==1 // After exclusions
replace norigexcluded = 1 if study==1
replace df1orig = 1 if study==1
replace df2orig = 52 if study==1

// Aviezer et al.
replace ncporig = 13.07 if study==2
replace statorig = "t" if study==2
replace norig = 15 if study==2
replace df2orig = 14 if study==2

// Balafoutas and Sutter
replace ncporig = 5.62 if study==3
replace statorig = "chi2" if study==3
replace norig = 144 if study==3
replace df2orig = 1 if study==3

// Derex et al.
replace ncporig = 16.3 if study==4
replace statorig = "chi2" if study==4
replace norig = 51 if study==4 // Clustered??
replace noriggrouped = 1 if study==4
replace df2orig = 1 if study==4

// Duncan et al.
replace ncporig = 3.41 if study==5
replace statorig = "t" if study==5
replace norig = 15 if study==5 // After exclusions
replace norigexcluded = 1 if study==5
replace df2orig = 14 if study==5

// Gervais and Norenzayan
replace ncporig = 2.24 if study==6
replace statorig = "t" if study==6
replace norig = 57 if study==6 // After exclusions
replace norigexcluded = 1 if study==6
replace df2orig = 55 if study==6

// Gneezy et al.
replace ncporig = 3.00 if study==7
replace statorig = "Z" if study==7
replace norig = 180 if study==7

// Hauser et al.
replace ncporig = 8.696 if study==8
replace statorig = "t" if study==8
replace norig = 40 if study==8 // Clustered??
replace noriggrouped = 1 if study==8
replace df2orig = 38 if study==8

// Janssen et al.
replace ncporig = 5.761 if study==9
replace statorig = "Z" if study==9
replace norig = 63 if study==9
replace noriggrouped = 1 if study==9

// Karpicke and Blunt
replace ncporig = 21.63 if study==10
replace statorig = "F" if study==10
replace norig = 40 if study==10
replace df1orig = 1 if study==10
replace df2orig = 38 if study==10

// Kidd and Castano
replace ncporig = 6.40 if study==11
replace statorig = "F" if study==11
replace norig = 86 if study==11 // After exclusions
replace norigexcluded = 1 if study==11
replace df1orig = 1 if study==11
replace df2orig = 82 if study==11

// Kovacs et al.
replace ncporig = 2.42 if study==12
replace statorig = "t" if study==12
replace norig = 24 if study==12
replace df2orig = 23 if study==12

// Lee and Schwarz
replace ncporig = 6.74 if study==13
replace statorig = "F" if study==13
replace norig = 40 if study==13
replace df1orig = 1 if study==13
replace df2orig = 38 if study==13

// Mani et al.
replace ncporig = 7.86 if study==14 // Stats for Raven's Matricies DOUBLE CHECK
replace statorig = "F" if study==14
replace norig = 101 if study==14
replace df1orig = 1 if study==14
replace df2orig = 97 if study==14

// Morewedge et al. (30 vs. Control)
/*replace ncporig = 4.50 if study==15
replace statorig = "F" if study==15
replace norig = 49 if study==15 // After exlusions
replace norigexcluded = 1 if study==15
replace df1orig = 1 if study==15
replace df2orig = 46 if study==15*/
* T-test version:
replace ncporig = 2.7839 if study==15
replace statorig = "t" if study==15
replace norig = 32 if study==15 // After exlusions
replace norigexcluded = 1 if study==15
replace df2orig = 30 if study==15

// Morewedge et al. (30 vs. 3)
replace ncporig = 5.81 if study==23
replace statorig = "F" if study==23
replace norig = 49 if study==23 // After exlusions
replace norigexcluded = 1 if study==23
replace df1orig = 1 if study==23
replace df2orig = 46 if study==23

// Nishi et al.
replace ncporig = 2.881 if study==16
replace statorig = "t" if study==16
replace norig = 200 if study==16 // Clustered??
replace noriggrouped = 1 if study==16
replace df2orig = 198 if study==16

// Pyc and Rawson (values from authors)
replace ncporig = 2.37 if study==17
replace statorig = "t" if study==17
replace norig = 36 if study==17 // Inferred from t-test
replace df2orig = 34 if study==17

// Ramirez and Beilock
replace ncporig = 5.55 if study==18
replace statorig = "t" if study==18
replace norig = 20 if study==18
replace df2orig = 18 if study==18

// Rand et al.
replace ncporig = 2.617 if study==19
replace statorig = "Z" if study==19
replace norig = 343 if study==19

// Shah et al.
replace ncporig = 4.16 if study==20
replace statorig = "F" if study==20
replace norig = 56 if study==20 // After exlusions
replace norigexcluded = 1 if study==20
replace df1orig = 1 if study==20
replace df2orig = 54 if study==20

// Sparrow et al.
replace ncporig = 3.26 if study==21
replace statorig = "t" if study==21
replace norig = 46 if study==21  // DOES NOT CORRESPOND TO DF IN TEST
replace df2orig = 45 if study==21

// Wilson et al.
replace ncporig = 4.83 if study==22
replace statorig = "t" if study==22
replace norig = 30 if study==22
replace df2orig = 28 if study==22

// Cleanup
replace norigexcluded = 0 if norigexcluded==.
replace noriggrouped = 0 if noriggrouped==.

label def yn 0 "No" 1 "Yes"
foreach var in norigexcluded noriggrouped{
	label val `var' yn
}

/* Converted test statistics
---------------------------------*/
gen double ncporig_con = .
gen statorig_con = ""

// Use relationship: t^2=F(1, df2)
replace statorig_con = "t" if statorig=="F" & df1orig==1
replace ncporig_con = sqrt(ncporig) if statorig=="F" & df1orig==1

// Use relationship: Z^2=chi2(1)
replace statorig_con = "Z" if statorig=="chi2" & df2orig==1
replace ncporig_con = sqrt(ncporig) if statorig=="chi2" & df2orig==1

// Replace the other statistics
replace statorig_con = statorig if statorig_con==""
replace ncporig_con = ncporig if ncporig_con==.


/* P-values
---------------------------------*/
gen double porig = .

// Note: All conversions assume double sided tests

// Z statistics
replace porig = normal(-abs(ncporig_con))*2 if statorig_con=="Z"

// t statistics
replace porig = t(df2orig, -abs(ncporig_con))*2 if statorig_con=="t"


/* Convert to correlation coefficient (r)
------------------------------------------------*/
gen double eorig=.

// Z statistics
replace eorig = tanh(ncporig_con * sqrt(1/(norig-3))) if statorig_con=="Z"

// t statistics
replace eorig = sign(ncporig_con) * sqrt(ncporig_con^2/(ncporig_con^2 + df2orig)) if statorig_con=="t"


/*	Calculate test statistics for which the
	calculated correlation coefficient would
	have been 75% and 50% of original
------------------------------------------------*/
foreach rele in 50 75{
	gen double ncporig_con_e`rele' = .
	replace ncporig_con_e`rele' = atanh(`rele'/100*eorig) * sqrt(norig-3) if statorig_con=="Z"
	replace ncporig_con_e`rele' = sign(`rele'/100*eorig)*((1/(`rele'/100*eorig)^2 - 1)/df2orig)^-0.5 if statorig_con=="t"
}


/*	Calculate N needed to achieve 90% power
	for an effect that 75% and 50% of original
------------------------------------------------*/ 

foreach rele in 50 75{
	gen double nrep_pow90_e`rele' = .
	
	// Z statistics and approximations for t statistics
	replace nrep_pow90_e`rele' = ((invnormal(0.975)-invnormal(1 - 0.9))*sqrt(norig)/ncporig_con_e`rele')^2 if statorig_con=="Z"
	replace nrep_pow90_e`rele' = ceil(nrep_pow90_e`rele')
}

sort study
foreach rele in 50 75{
	forval s=1/23{
		local n = 10
		local i = 0
		local power = 0
		if statorig_con[`s']=="t"{
			while `power' < 0.9 & `i'<10000{
				local power = 1 - t(`n'-2, invt(`n'-2, 0.975)-ncporig_con_e`rele'[`s']/sqrt(norig[`s']) * sqrt(`n'))
				local `++n'
				local `++i'
			}
			replace nrep_pow90_e`rele' = `n' if study==`s'
		}
	}
}

	
/*
// Check that calculations were correct:
gen power = .
replace power = 1 - normal(invnormal(0.975)-ncporig_con_e75/sqrt(norig) * sqrt(nrep_pow90_e75)) if statorig_con=="Z"
replace power = 1 - t(nrep_pow90_e75-2, invt(nrep_pow90_e75-2, 0.975)-ncporig_con_e75/sqrt(norig) * sqrt(nrep_pow90_e75)) if statorig_con=="t"


*/


/*	P value for standardised effect size
------------------------------------------------*/
gen fishz = atanh(eorig)
gen fishvar = 1/(norig-3)
gen normstat = abs(fishz/sqrt(fishvar))
gen porig_e = normal(-abs(normstat))*2


/*	Export for Magnus
------------------------------------------------*/
preserve
	gen ncporig_con_mult75 = ncporig_con*0.75
	gen ncporig_con_mult50 = ncporig_con*0.50	
	export delimited study statorig_con eorig ncporig_con ncporig_con_e75 ncporig_con_mult75 nrep_pow90_e75 ncporig_con_e50 ncporig_con_mult50 nrep_pow90_e50 using "/Users/es.3386/Dropbox/Plugg/Doktorand/Projekt/SNRP/Stata/samplesizes.csv", replace
restore
