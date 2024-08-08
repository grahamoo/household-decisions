
**This .do file was used to create the output tables for an individual research project
**Specifically, the objective of this project was to evaluate the effects of female political representation in Indian state legislature on male constituents' opinions about who, between husband and wife, should have greater say over various household decisions. In order to address possible endogeneity, the project exploits an instrumental variable strategy used by Bhalotra and Clots-Figueras (2014) and Clots-Figueras (2011), which utilizes close elections between male and female candidates. As done in these papers, the fraction of seats won by women in a given district is instrumented by the fraction of close elections between opposite-gender winners and runners-up that are won by women. This helps to identify the exogenous occurrence of female leadership in state legislature.
**The findings of this project reveal that exposure to female political representation leads to a significant decrease in the likelihood men express that husbands should have greater say of how many children to have and large household purchases. There is a significant increase in the likelihood men express that large household purchases should be decided upon equally between husband and wife. The effect is found to be heterogenous across male age cohorts, where younger men drive the change in attitudes.
**The .do file creates tables for the total male sample and the male samples by age quartile.






*generate globals used in regression
global margin1 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10
global margin2 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102
global individual_controls age literate years_educ hindu muslim christian sikh respondent_sc_st respondent_obc
global dist_controls f_perc f_literate m_literate sc_st_rate
global outcomes fertility_decisions largehousehold_decisions wifesincome_decisions dailyhousehold_decisions visitrelative_decisions
global outcomes_w_index  male_decision_z fertility_decisions largehousehold_decisions wifesincome_decisions dailyhousehold_decisions visitrelative_decisions
global outcomes_iv ivfertility_decisions ivlargehousehold_decisions ivwifesincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions
global outcomes_iv_w_index ivmale_decision_z ivfertility_decisions ivlargehousehold_decisions ivwifesincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions
global se "cluster(district)"
global slvl "starlevels(* 0.10 ** 0.05 *** 0.01)"

********************************************************************************
***TABLE 1: Men's Preference for Husband-dominant Decision-making***
use "${intermediate}for_analysis_men_3.dta", clear

ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv1

ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 state_* $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv2

ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv3

estout iv1 iv2 iv3  using "${tables}table1.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear


eststo clear

*First-stage:
keep if male_decision_z!=.
	reg frac_f frac_close_winf frac_close $margin2 state_*, $se
	eststo fs1
  test frac_close_winf=0
  qui estadd scalar f_stat = r(F)
  qui: sum frac_f if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)
	
	reg frac_f frac_close_winf frac_close $margin2 state_* $dist_controls, $se
	eststo fs2
  test frac_close_winf=0
  qui estadd scalar f_stat = r(F)
  qui: sum frac_f if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)
	
	reg frac_f frac_close_winf frac_close $margin2 $individual_controls state_*  $dist_controls, $se
	eststo fs3
  test frac_close_winf=0
  qui estadd scalar f_stat = r(F)
  qui: sum frac_f if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)


	estout fs1 fs2 fs3 using "${tables}table1_first_stage.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_close_winf "Fraction of female leaders in close elections") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_close_winf) mlabels(, none) stats(N outcome_mean f_stat, fmt(%9.0gc %9.3fc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean" "\hspace{0.5 cm} First stage \$F\$-stat") ///
			layout(@)) $slvl 

  eststo clear


********************************************************************************
***TABLE 2: Men's Preference for Husband-dominant Decision-making by Decision Type***
use "${intermediate}for_analysis_men_3.dta", clear

foreach var in $outcomes {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv  using "${tables}table2.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	

********************************************************************************
***TABLE 5: Marriage outcomes***
use "${intermediate}for_analysis_men_3.dta", clear

local varlist married never_married sep_divorce marriage_age
foreach var of local varlist {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bt`var'
}

estout btmarried btnever_married btsep_divorce btmarriage_age using "${tables}table5.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
*******************************************************************************
***TABLE 6: Men's Preference for Husband-dominant Decision-making by Marital Status and Age

***Panel A: Unmarried***
use "${intermediate}for_analysis_men_3.dta", clear

keep if married == 0

foreach var in $outcomes_w_index {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_index  using "${tables}table6a.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***Panel B: Married***
use "${intermediate}for_analysis_men_3.dta", clear

keep if married == 1

foreach var in $outcomes_w_index {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_index  using "${tables}table6b.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

***Panel C: Age less than or equal to 30***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age <= 30

foreach var in $outcomes_w_index {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_indexvmale_decision_z   using "${tables}table6c.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***Panel D: Age greater than 30***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age > 30

local varlist fertility_decisions largehousehold_decisions wifesincome_decisions dailyhousehold_decisions visitrelative_decisions male_decision_z
foreach var of local varlist {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_indexvmale_decision_z   using "${tables}table6d.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
 

********************************************************************************
***TABLE 7: Men's Preference for Husband-dominant Decision-making by Marital Status and Age (Cont'd)

***Panel A: Age less than or equal to 30 and unmarried***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age <= 30 & married == 0

foreach var in $outcomes_w_index{
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_indexvmale_decision_z  using "${tables}table7a.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***Panel B: Age less than or equal to 30 and married***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age <= 30 & married == 1

foreach var in $outcomes_w_index{
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_indexvmale_decision_z   using "${tables}table7b.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

***Panel C: Age greater than 30 and unmarried***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age > 30 & married == 0

foreach var in $outcomes_w_index{
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_indexvmale_decision_z   using "${tables}table7c.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
***Panel D: Age greater than 30 and married***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age > 30 & married == 1

foreach var in $outcomes_w_index{
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_indexvmale_decision_z   using "${tables}table7d.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  

*********************************************************************************
******TABLE A2: Balance Checks

***Panel A (1): Full men's sample***
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.

foreach var in $individual_controls {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bti`var'
}

estout bti* using "${tables}tableA2A1.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
***Panel A (3): Age less than or equal to 30 and unmarried***
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.
keep if age <= 30 & married == 0

foreach var in $individual_controls {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bti`var'
}

estout bti* using "${tables}tableA2A3.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
***Panel A (4): Age less than or equal to 30 and married***
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.
keep if age <= 30 & married == 1

foreach var in $individual_controls {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bti`var'
}

estout bti* using "${tables}tableA2A4.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
***Panel A (5): Age greater than 30 and unmarried***
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.
keep if age > 30 & married == 0

foreach var in $individual_controls {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bti`var'
}

estout bti* using "${tables}tableA2A5.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
***Panel A (6): Age greater than 30 and married***
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.
keep if age > 30 & married == 1

foreach var in $individual_controls {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bti`var'
}

estout bti* using "${tables}tableA2A6.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

***Panel B: District characteristics***
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.
collapse (mean) frac_f frac_close_winf frac_close $dist_controls $margin2, by(year state district)
egen state_group = group(state)

foreach x in $dist_controls {
	ivreg2 `x' (frac_f = frac_close_winf) frac_close $margin2 i.state_group, cluster(state)
	
  qui: sum `x' if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)
  eststo btd`x'
}

estout btd* using "${tables}tableA2B.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

********************************************************************************
******TABLE 12: Robustness

**ALL Men
use "${intermediate}for_analysis_men_3.dta", clear

*no polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p2

use "${intermediate}for_analysis_men_2.dta", clear
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p3

use "${intermediate}for_analysis_men_2.5.dta", clear
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p4

use "${intermediate}for_analysis_men_3.5.dta", clear
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p5

use "${intermediate}for_analysis_men_4.dta", clear
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p6


estout p1 p2 p3 p4 p5 p6 using "${tables}table12a.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Young Unmarried Men
use "${intermediate}for_analysis_men_3.dta", clear
keep if age <= 30 & married == 0

*no polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b2

use "${intermediate}for_analysis_men_2.dta", clear
keep if age <= 30 & married == 0
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b3

use "${intermediate}for_analysis_men_2.5.dta", clear
keep if age <= 30 & married == 0
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b4

use "${intermediate}for_analysis_men_3.5.dta", clear
keep if age <= 30 & married == 0
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b5

use "${intermediate}for_analysis_men_4.dta", clear
keep if age <= 30 & married == 0
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo b6


estout b1 b2 b3 b4 b5 b6 using "${tables}table12b.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Old Unmarried Men
use "${intermediate}for_analysis_men_3.dta", clear
keep if age > 30 & married == 0

*no polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c2

use "${intermediate}for_analysis_men_2.dta", clear
keep if age > 30 & married == 0
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c3

use "${intermediate}for_analysis_men_2.5.dta", clear
keep if age > 30 & married == 0
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c4

use "${intermediate}for_analysis_men_3.5.dta", clear
keep if age > 30 & married == 0
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c5

use "${intermediate}for_analysis_men_4.dta", clear
keep if age > 30 & married == 0
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c6


estout c1 c2 c3 c4 c5 c6 using "${tables}table12c.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Young married Men
use "${intermediate}for_analysis_men_3.dta", clear
keep if age <= 30 & married == 1

*no polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d2

use "${intermediate}for_analysis_men_2.dta", clear
keep if age <= 30 & married == 1
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d3

use "${intermediate}for_analysis_men_2.5.dta", clear
keep if age <= 30 & married == 1
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d4

use "${intermediate}for_analysis_men_3.5.dta", clear
keep if age <= 30 & married == 1
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d5

use "${intermediate}for_analysis_men_4.dta", clear
keep if age <= 30 & married == 1
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d6


estout d1 d2 d3 d4 d5 d6 using "${tables}table12d.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
**Old married Men
use "${intermediate}for_analysis_men_3.dta", clear
keep if age > 30 & married == 1

*no polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e1

*1st degree polynomial
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin1 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e2

use "${intermediate}for_analysis_men_2.dta", clear
keep if age > 30 & married == 1
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e3

use "${intermediate}for_analysis_men_2.5.dta", clear
keep if age > 30 & married == 1
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e4

use "${intermediate}for_analysis_men_3.5.dta", clear
keep if age > 30 & married == 1
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e5

use "${intermediate}for_analysis_men_4.dta", clear
keep if age > 30 & married == 1
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo e6


estout e1 e2 e3 e4 e5 e6 using "${tables}table12e.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  

********** TABLE 14: SUMMARY STATISTICS

*Male main outcome variables

use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)

label var male_decision_z            "Household decision preference index"    
label var fertility_decisions        "Number of children to have"
label var largehousehold_decisions	 "Major household purchases"
label var wifesincome_decisions     "What to do with wife's earnings"
label var dailyhousehold_decisions   "Daily household purchases"
label var visitrelative_decisions	"Visits to wife's relatives"

estpost summarize male_decision_z fertility_decisions largehousehold_decisions ///
wifesincome_decisions dailyhousehold_decisions visitrelative_decisions

esttab . using  "${tables}table14a.tex", ///
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
label var wifesincome_decisions     "What to do with respondent's earnings"
label var healthcare_decisions   "Respondent's healthcare"
label var visitrelative_decisions	"Visits to respondent's relatives"

estpost summarize male_decision_z contraceptive_decisions largehousehold_decisions ///
wifesincome_decisions healthcare_decisions visitrelative_decisions

esttab . using  "C:\Users\17819\Dropbox\capstone\individual male files\output\table14b.tex", ///
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
use "${intermediate}for_analysis_men_3.dta", clear
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

esttab . using  "${tables}table14c.tex", ///
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

esttab . using  "C:\Users\17819\Dropbox\capstone\individual male files\output\table14d.tex", ///
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

use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)

bysort state district: keep if _n == 1
   
label var f_perc                     "Female share of population"
label var f_literateTotal			"Female literacy rate"
label var m_literateTotal            "Male literacy rate"
label var sc_st_rateTotal             "SC/ST share of population"


estpost summarize $dist_controls

esttab . using  "${tables}table14e.tex", ///
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
use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)

bysort state district: keep if _n == 1
gen has_female = frac_f > 0
gen has_close = frac_close > 0
gen has_close_winf = frac_close_winf >0
   
label var frac_f                 "Share of constituencies won by a female"
label var frac_close			"Share of constituencies with close male-female elections"
label var frac_close_winf		"Share of constituencies with close male-female elections won by a female"
label var has_female 			"Share of districts with at least one seat won by a female"
label var has_close				"Share of districts with at least one close male-female election"
label var has_close_winf		"Share of districts with at least one close male-female election won by a female"


estpost summarize frac_f frac_close frac_close_winf has_female has_close has_close_winf

esttab . using  "${tables}table14f.tex", ///
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
use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)
ren mv511 marriage_age
 
label var married                 "Married"
label var never_married			"Never married"
label var sep_divorce		"Seperated or divorced"
label var marriage_age 			"Age of first marriage"


estpost summarize married never_married sep_divorce marriage_age

esttab . using  "${tables}table14g.tex", ///
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
label var house_ownership "Individual or joint house ownership"
label var land_ownership	"Individual or joint land ownership"


estpost summarize children_ever pregnant employed has_money house_ownership land_ownership

esttab . using  "${tables}table14h.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace