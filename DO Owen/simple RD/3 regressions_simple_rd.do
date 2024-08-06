
/*
CHANGES TO REGRESSION:
-ONLY DISTRICTS WITH ONE CLOSE M-F ELECTION ARE INCLUDED
-POLYNOMIAL CONTROLS FOR MARGIN OF VICTORY FOR SINGLE CLOSE M-F ELECTION, ARE THESE CONSTRUCTED CORRECTLY???? SHOULD MARGIN BE ABSOLUTE MARGIN IN THESE CASES????
-IV IS INDICATOR FOR WHETHER THE CLOSE M-F ELECTION WAS ONE
-I STILL CONTROL FOR SHARE OF ELECTIONS THAT ARE CLOSE M-F, SHOULD I????

RESULTS:
-IV IS STILL VERY STRONG THOUGH NOT AS STRONG
-TABLE 1 RESULTS ARE NOT SIGNIFICANT
-RESULTS FOR YOUNG UNMARRIED MEN ARE NOT REALLY SIGNIFICANT
*/


*install outreg2 package
ssc install outreg2

***generate tables for male samples
cd "C:\Users\17819\Dropbox\capstone\individual male files"
use "districts-male_3_simple_rd.dta", clear


*generate globals used in regression
global margin1 marg
global margin2 marg marg2
global margin3 marg marg2 marg3 
global individual_controls age literate educyears hindu muslim christian sikh respondent_sc_st respondent_obc  //rural// //married//
global dist_controls f_perc f_literateTotal m_literateTotal sc_st_rateTotal //f_employmentTotal m_employmentTotal//
global se "cluster(district)"
global slvl "starlevels(* 0.10 ** 0.05 *** 0.01)"

***TABLE 1: FULL MALE SAMPLE

ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 state_*, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv1

ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 state_* $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv2

ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv3

estout iv1 iv2 iv3  using "output/table1_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear


eststo clear

*First-stage:
keep if male_decision_z!=.
foreach x in frac_f {
	reg `x' close_mf_winf frac_close $margin2 state_*, $se
	eststo ols1
  test close_mf_winf=0
  qui estadd scalar f_stat = r(F)
  qui: sum `x' if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)
	
	reg `x' close_mf_winf frac_close $margin2 state_* $dist_controls, $se
	eststo ols2
  test close_mf_winf=0
  qui estadd scalar f_stat = r(F)
  qui: sum `x' if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)
	
	reg `x' close_mf_winf frac_close $margin2 $individual_controls state_*  $dist_controls, $se
	eststo ols3
  test close_mf_winf=0
  qui estadd scalar f_stat = r(F)
  qui: sum `x' if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)


	estout ols1 ols2 ols3 using "output/table1_`x'_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(close_mf_winf "Fraction of female leaders in close elections") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(close_mf_winf) mlabels(, none) stats(N outcome_mean f_stat, fmt(%9.0gc %9.3fc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean" "\hspace{0.5 cm} First stage \$F\$-stat") ///
			layout(@)) $slvl 

  eststo clear
}


***TABLE 2: FULL MALE SAMPLE BY HOUSEHOLD DECISION
use "districts-male_3_simple_rd.dta", clear

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions  using "output/table2_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***TABLE 3: MARRIED
use "districts-male_3_simple_rd.dta", clear

keep if married == 1

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z  using "output/table3_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***TABLE 4: UNMARRIED
use "districts-male_3_simple_rd.dta", clear

keep if married == 0

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z  using "output/table4_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

***TABLE 5: YOUNG
use "districts-male_3_simple_rd.dta", clear

keep if age <= 32

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z   using "output/table5_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***TABLE 6: OLD
use "districts-male_3_simple_rd.dta", clear

keep if age > 32

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z   using "output/table6_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
***TABLE 7: YOUNG & UNMARRIED
use "districts-male_3_simple_rd.dta", clear

keep if age <= 32 & married == 0

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z  using "output/table7_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***TABLE 8: OLD & UNMARRIED
use "districts-male_3_simple_rd.dta", clear

keep if age > 32 & married == 0

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z   using "output/table8_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

  ***TABLE 9: YOUNG & MARRIED
use "districts-male_3_simple_rd.dta", clear

keep if age <= 32 & married == 1

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z   using "output/table9_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***TABLE 10: OLD & MARRIED
use "districts-male_3_simple_rd.dta", clear

keep if age > 32 & married == 1

local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivfertility_decisions ivlargehousehold_decisions ivwomensincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions ivmale_decision_z   using "output/table10_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
/*
******TABLE 11: Balanced Covariates

*individual characteristics
use "districts-male_3_simple_rd.dta", clear
keep if male_decision_z!=.

foreach var in $individual_controls {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bti`var'
}

estout bti* using "output/table11_male_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

*district characteristics
use "districts-male_3_simple_rd.dta", clear
keep if male_decision_z!=.
collapse (mean) frac_f close_mf_winf frac_close $dist_controls $margin2, by(year state district)
egen state_group = group(state)

foreach x in $dist_controls {
	ivreg2 `x' (frac_f = close_mf_winf) frac_close $margin2 i.state_group, cluster(state)
	
  qui: sum `x' if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)
  eststo btd`x'
}

estout btd* using "output/table11_district_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
******TABLE 12: Robustness

**ALL Men
use "districts-male_3_simple_rd.dta", clear

*no polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p2

use "districts-male_2.dta", clear
*bw 2
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p3

use "districts-male_2.5.dta", clear
*bw 2.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p4

use "districts-male_3.5.dta", clear
*bw 3.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p5

use "districts-male_4.dta", clear
*bw 4
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p6


estout p1 p2 p3 p4 p5 p6 using "output/table12a_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Young Unmarried Men
use "districts-male_3_simple_rd.dta", clear
keep if age <= 32 & married == 0

*no polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b2

use "districts-male_2.dta", clear
keep if age <= 32 & married == 0
*bw 2
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b3

use "districts-male_2.5.dta", clear
keep if age <= 32 & married == 0
*bw 2.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b4

use "districts-male_3.5.dta", clear
keep if age <= 32 & married == 0
*bw 3.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b5

use "districts-male_4.dta", clear
keep if age <= 32 & married == 0
*bw 4
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b6


estout b1 b2 b3 b4 b5 b6 using "output/table12b_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Old Unmarried Men
use "districts-male_3_simple_rd.dta", clear
keep if age > 32 & married == 0

*no polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c2

use "districts-male_2.dta", clear
keep if age > 32 & married == 0
*bw 2
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c3

use "districts-male_2.5.dta", clear
keep if age > 32 & married == 0
*bw 2.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c4

use "districts-male_3.5.dta", clear
keep if age > 32 & married == 0
*bw 3.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c5

use "districts-male_4.dta", clear
keep if age > 32 & married == 0
*bw 4
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c6


estout c1 c2 c3 c4 c5 c6 using "output/table12c_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Young married Men
use "districts-male_3_simple_rd.dta", clear
keep if age <= 32 & married == 1

*no polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d2

use "districts-male_2.dta", clear
keep if age <= 32 & married == 1
*bw 2
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d3

use "districts-male_2.5.dta", clear
keep if age <= 32 & married == 1
*bw 2.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d4

use "districts-male_3.5.dta", clear
keep if age <= 32 & married == 1
*bw 3.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d5

use "districts-male_4.dta", clear
keep if age <= 32 & married == 1
*bw 4
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d6


estout d1 d2 d3 d4 d5 d6 using "output/table12d_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Old married Men
use "districts-male_3_simple_rd.dta", clear
keep if age > 32 & married == 1

*no polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e2

use "districts-male_2.dta", clear
keep if age > 32 & married == 1
*bw 2
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e3

use "districts-male_2.5.dta", clear
keep if age > 32 & married == 1
*bw 2.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e4

use "districts-male_3.5.dta", clear
keep if age > 32 & married == 1
*bw 3.5
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e5

use "districts-male_4.dta", clear
keep if age > 32 & married == 1
*bw 4
ivreg2 male_decision_z (frac_f = close_mf_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e6


estout e1 e2 e3 e4 e5 e6 using "output/table12e_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
  
******TABLE 13: Marriage outcomes
use "districts-male_3_simple_rd.dta", clear
keep if !mi(male_decision_z)
ren mv511 marriage_age

local varlist married never_married sep_divorce marriage_age
foreach var of local varlist {
	ivreg2 `var' (frac_f = close_mf_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bt`var'
}

estout btmarried btnever_married btsep_divorce btmarriage_age using "output/table13_simple_rd.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  

********** TABLE 14: SUMMARY STATISTICS

*Male main outcome variables

use "districts-male_3_simple_rd.dta", clear
keep if !mi(male_decision_z)

label var male_decision_z            "Household decision preference index"    
label var fertility_decisions        "Number of children to have"
label var largehousehold_decisions	 "Major household purchases"
label var womensincome_decisions     "What to do with wife's earnings"
label var dailyhousehold_decisions   "Daily household purchases"
label var visitrelative_decisions	"Visits to wife's relatives"

estpost summarize male_decision_z fertility_decisions largehousehold_decisions ///
womensincome_decisions dailyhousehold_decisions visitrelative_decisions

esttab . using  "output/table14a_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace

*Female main outcome variables
use "C:\Users\17819\Dropbox\capstone\individual woman file\districts-woman_3.dta", clear
keep if !mi(male_decision_z)

label var male_decision_z            "Household decision index"    
label var contraceptive_decisions     "Contraceptive use"
label var largehousehold_decisions	 "Major household purchases"
label var womensincome_decisions     "What to do with respondent's earnings"
label var healthcare_decisions   "Respondent's healthcare"
label var visitrelative_decisions	"Visits to respondent's relatives"

estpost summarize male_decision_z contraceptive_decisions largehousehold_decisions ///
womensincome_decisions healthcare_decisions visitrelative_decisions

esttab . using  "C:\Users\17819\Dropbox\capstone\individual male files\output\table14b_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace

 cd "C:\Users\17819\Dropbox\capstone\individual male files"
 
*Male control variables
use "districts-male_3_simple_rd.dta", clear
keep if !mi(male_decision_z)

label var age                        "Age"
label var literate					"Literate"
label var educyears                  "Years of education"
label var hindu                      "Hindu"
label var muslim                     "Muslim"
label var christian                  "Christian"
label var sikh                       "Sikh"
label var respondent_sc_st           "SC/ST"
label var  respondent_obc             "OBC"


estpost summarize $individual_controls

esttab . using  "output/table14c_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
*Female control variables
use "C:\Users\17819\Dropbox\capstone\individual woman file\districts-woman_3.dta", clear
keep if !mi(male_decision_z)

label var age                        "Age"
label var literate					"Literate"
label var educyears                  "Years of education"
label var hindu                      "Hindu"
label var muslim                     "Muslim"
label var christian                  "Christian"
label var sikh                       "Sikh"
label var respondent_sc_st           "SC/ST"
label var  respondent_obc             "OBC"


estpost summarize $individual_controls

esttab . using  "C:\Users\17819\Dropbox\capstone\individual male files\output\table14d_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
*District controls
cd "C:\Users\17819\Dropbox\capstone\individual male files"

use "districts-male_3_simple_rd.dta", clear
keep if !mi(male_decision_z)

bysort state district: keep if _n == 1
   
label var f_perc                     "Female share of population"
label var f_literateTotal			"Female literacy rate"
label var m_literateTotal            "Male literacy rate"
label var sc_st_rateTotal             "SC/ST share of population"


estpost summarize $dist_controls

esttab . using  "output/table14e_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
*Election outcomes
use "districts-male_3_simple_rd.dta", clear
keep if !mi(male_decision_z)

bysort state district: keep if _n == 1
gen has_female = frac_f > 0
gen has_close = frac_close > 0
gen has_close_winf = close_mf_winf >0
   
label var frac_f                 "Share of constituencies won by a female"
label var frac_close			"Share of constituencies with close male-female elections"
label var close_mf_winf		"Share of constituencies with close male-female elections won by a female"
label var has_female 			"Share of districts with at least one seat won by a female"
label var has_close				"Share of districts with at least one close male-female election"
label var has_close_winf		"Share of districts with at least one close male-female election won by a female"


estpost summarize frac_f frac_close close_mf_winf has_female has_close has_close_winf

esttab . using  "output/table14f_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
 *Men's marriage outcomes
use "districts-male_3_simple_rd.dta", clear
keep if !mi(male_decision_z)
ren mv511 marriage_age
 
label var married                 "Married"
label var never_married			"Never married"
label var sep_divorce		"Seperated or divorced"
label var marriage_age 			"Age of first marriage"


estpost summarize married never_married sep_divorce marriage_age

esttab . using  "output/table14g_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
 *Alternative empowerment outcomes for married women
 use "C:\Users\17819\Dropbox\capstone\individual woman file\districts-woman_3.dta", clear

keep if !mi(male_decision_z)

gen employed = 1 if respondent_jobless == 0
replace employed = 0 if respondent_jobless == 1

ren s927 has_money

ren v213 pregnant

label var children_ever                 "Total fertility"
label var pregnant			"Pregnant"
label var employed		"Employed"
label var has_money 			"Has personal savings"


estpost summarize children_ever pregnant employed has_money

esttab . using  "output/table14h_simple_rd.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace