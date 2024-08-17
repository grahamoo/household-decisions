*Purpose: Create all tables for paper

*generate globals used in regression
global margin1 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10
global margin2 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 ///
marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102
global margin2_interact i.group#(i.dum1 i.dum2 i.dum3 i.dum4 i.dum5 i.dum6 i.dum7 i.dum8 ///
i.dum9 i.dum10 c.marg1 c.marg2 c.marg3 c.marg4 c.marg5 c.marg6 c.marg7 c.marg8 c.marg9 ///
c.marg10 c.marg12 c.marg22 c.marg32 c.marg42 c.marg52 c.marg62 c.marg72 c.marg82 c.marg92 c.marg102)

global individual_controls age literate years_educ hindu muslim christian sikh ///
respondent_sc_st respondent_obc
global individual_controls_interact i.group#(c.age i.literate c.years_educ ///
i.hindu i.muslim i.christian i.sikh i.respondent_sc_st i.respondent_obc)
global individual_controls_noeduc age hindu muslim christian sikh respondent_sc_st respondent_obc //removes years of education and literacy status

global dist_controls f_perc f_literate m_literate sc_st_rate
global dist_controls_interact i.group#(c.f_perc c.f_literate c.m_literate ///
c.sc_st_rate)

global outcomes fertility_decisions largehousehold_decisions wifesincome_decisions ///
dailyhousehold_decisions visitrelative_decisions
global outcomes_w_index  male_decision_z fertility_decisions largehousehold_decisions ///
wifesincome_decisions dailyhousehold_decisions visitrelative_decisions
global outcomes_iv ivfertility_decisions ivlargehousehold_decisions ivwifesincome_decisions ///
ivdailyhousehold_decisions ivvisitrelative_decisions
global outcomes_iv_w_index ivmale_decision_z ivfertility_decisions ivlargehousehold_decisions ///
ivwifesincome_decisions ivdailyhousehold_decisions ivvisitrelative_decisions
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
***Table 3: Married Women's Experience of Husband-dominant Decision-making Practices***
use "${intermediate}for_analysis_women_3.dta", clear

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

estout iv1 iv2 iv3  using "${tables}table3.tex", ///
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


	estout fs1 fs2 fs3 using "${tables}table3_first_stage.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_close_winf "Fraction of female leaders in close elections") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_close_winf) mlabels(, none) stats(N outcome_mean f_stat, fmt(%9.0gc %9.3fc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean" "\hspace{0.5 cm} First stage \$F\$-stat") ///
			layout(@)) $slvl 

  eststo clear
  
********************************************************************************
***Table 4: Married Women's Experience of Husband-dominant Decision-making by Decision Type***
use "${intermediate}for_analysis_women_3.dta", clear

foreach var in contraceptive_decisions largehousehold_decisions wifesincome_decisions ///
healthcare_decisions visitrelative_decisions{
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivcontraceptive_decisions ivlargehousehold_decisions ivwifesincome_decisions ivhealthcare_decisions ivvisitrelative_decisions  using "${tables}table4.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
********************************************************************************
***Table 5: Alternative Empowerment Outcomes for Married Women***
use "${intermediate}for_analysis_women_3.dta", clear

keep if !mi(male_decision_z)

foreach var in children_ever pregnant working has_money house_ownership land_ownership {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout ivchildren_ever ivpregnant ivworking ivhas_money ivhouse_ownership ivland_ownership  using "${tables}table5.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	

********************************************************************************
***TABLE 6: Men's Marriage Outcomes***
use "${intermediate}for_analysis_men_3.dta", clear

local varlist married never_married sep_divorce marriage_age
foreach var of local varlist {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bt`var'
}

estout btmarried btnever_married btsep_divorce btmarriage_age using "${tables}table6.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
*******************************************************************************
***TABLE 7: Men's Preference for Husband-dominant Decision-making by Marital Status and Age***

***Panel A: Unmarried***
use "${intermediate}for_analysis_men_3.dta", clear

keep if married == 0

foreach var in $outcomes_w_index {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_index  using "${tables}table7A.tex", ///
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

estout $outcomes_iv_w_index  using "${tables}table7B.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

  
***Panel C: Age less than or equal to 30*** 
use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)
egen age_med = median(age)
assert age_med == 30

use "${intermediate}for_analysis_men_3.dta", clear

keep if age <= 30

foreach var in $outcomes_w_index {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_index  using "${tables}table7C.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear	
  
  
***Panel D: Age greater than 30***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age > 30
foreach var in $outcomes_w_index {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_index   using "${tables}table7D.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
 
 
***Comparison of coefficients***

foreach group in 1 2 {
use "${intermediate}for_analysis_men_3.dta", clear

if `group' == 1{
	gen group = married
}

if `group' == 2 {
	gen group = age > 30
}

gen cons = 1

foreach var in $outcomes_w_index {
ivreg2 `var' (c.frac_f#i.group = c.frac_close_winf#i.group) c.cons#i.group ///
c.frac_close#i.group $margin2_interact $individual_controls_interact i.state_*#i.group  $dist_controls_interact, nocons $se
test 1.group#c.frac_f = 0.group#c.frac_f
mat ec`group'_`var'=(.)
			mat ec`group'_`var'[1,1]=r(p)
}
}
		
		
		matrix eqcoeff=(ec1_male_decision_z) , (ec1_fertility_decisions) ,  (ec1_largehousehold_decisions) , (ec1_wifesincome_decisions) , (ec1_dailyhousehold_decisions)  , (ec1_visitrelative_decisions) \ (ec2_male_decision_z) , (ec2_fertility_decisions) ,  (ec2_largehousehold_decisions) , (ec2_wifesincome_decisions) , (ec2_dailyhousehold_decisions)  , (ec2_visitrelative_decisions)
mat rownames eqcoeff = "" "" //titles will be added in overleaf
estout matrix(eqcoeff, fmt(%9.3f)) using "${tables}table7E.tex", replace title("") style(tex) ///
	collabels(, none) mlabels(, none) nolabel ///


estimates clear


********************************************************************************
***TABLE 8: Men's Preference for Husband-dominant Decision-making by Marital Status and Age (Cont'd)***

***Panel A: Age less than or equal to 30 and unmarried***
use "${intermediate}for_analysis_men_3.dta", clear

keep if age <= 30 & married == 0

foreach var in $outcomes_w_index{
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv`var'
}

estout $outcomes_iv_w_index  using "${tables}table8A.tex", ///
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

estout $outcomes_iv_w_index   using "${tables}table8B.tex", ///
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

estout $outcomes_iv_w_index   using "${tables}table8C.tex", ///
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

estout $outcomes_iv_w_index   using "${tables}table8D.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

  
***Comparison of coefficients***

foreach group in 1 2 3 4 {
use "${intermediate}for_analysis_men_3.dta", clear

if `group' == 1{
	keep if age <= 30
	gen group = married
}

if `group' == 2 {
	keep if age > 30
	gen group = married
}

if `group' == 3 {
	keep if married == 0
	gen group = age <= 30
}

if `group' == 4 {
	keep if married == 1
	gen group = age <= 30
}

gen cons = 1

foreach var in $outcomes_w_index {
ivreg2 `var' (c.frac_f#i.group = c.frac_close_winf#i.group) c.cons#i.group ///
c.frac_close#i.group $margin2_interact $individual_controls_interact i.state_*#i.group  $dist_controls_interact, nocons $se
test 1.group#c.frac_f = 0.group#c.frac_f
mat ec`group'_`var'=(.)
			mat ec`group'_`var'[1,1]=r(p)
}
}
		
		
		matrix eqcoeff=(ec1_male_decision_z) , (ec1_fertility_decisions) ,  (ec1_largehousehold_decisions) , (ec1_wifesincome_decisions) , (ec1_dailyhousehold_decisions)  , (ec1_visitrelative_decisions) \ (ec2_male_decision_z) , (ec2_fertility_decisions) ,  (ec2_largehousehold_decisions) , (ec2_wifesincome_decisions) , (ec2_dailyhousehold_decisions)  , (ec2_visitrelative_decisions) \ (ec3_male_decision_z) , (ec3_fertility_decisions) ,  (ec3_largehousehold_decisions) , (ec3_wifesincome_decisions) , (ec3_dailyhousehold_decisions)  , (ec3_visitrelative_decisions) \ (ec4_male_decision_z) , (ec4_fertility_decisions) ,  (ec4_largehousehold_decisions) , (ec4_wifesincome_decisions) , (ec4_dailyhousehold_decisions)  , (ec4_visitrelative_decisions)
mat rownames eqcoeff = "" "" //titles will be added in overleaf
estout matrix(eqcoeff, fmt(%9.3f)) using "${tables}table8E.tex", replace title("") style(tex) ///
	collabels(, none) mlabels(, none) nolabel ///


estimates clear

*********************************************************************************
***TABLE A1: Summary Statistics***

***Panel A: Men's preference for husband-dominant decision-making***
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

esttab . using  "${tables}tableA1A.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace

  
***Panel B: Married women's experience of husband-dominant decision-making***
use "${intermediate}for_analysis_women_3.dta", clear
keep if !mi(male_decision_z)

label var male_decision_z            "Household decision index"    
label var contraceptive_decisions     "Contraceptive use"
label var largehousehold_decisions	 "Major household purchases"
label var wifesincome_decisions     "What to do with respondent's earnings"
label var healthcare_decisions   "Respondent's healthcare"
label var visitrelative_decisions	"Visits to respondent's relatives"

estpost summarize male_decision_z contraceptive_decisions largehousehold_decisions ///
wifesincome_decisions healthcare_decisions visitrelative_decisions

esttab . using  "${tables}tableA1B.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace

 
***Individual controls: Men's sample***
use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)

label var age                        "Age"
label var literate					"Literate"
label var years_educ                  "Years of education"
label var hindu                      "Hindu"
label var muslim                     "Muslim"
label var christian                  "Christian"
label var sikh                       "Sikh"
label var respondent_sc_st           "SC/ST"
label var  respondent_obc             "OBC"


estpost summarize $individual_controls

esttab . using  "${tables}tableA1C1.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
  
***Individual controls: Married women's sample***
use "${intermediate}for_analysis_women_3.dta", clear
keep if !mi(male_decision_z)

label var age                        "Age"
label var literate					"Literate"
label var years_educ                  "Years of education"
label var hindu                      "Hindu"
label var muslim                     "Muslim"
label var christian                  "Christian"
label var sikh                       "Sikh"
label var respondent_sc_st           "SC/ST"
label var  respondent_obc             "OBC"


estpost summarize $individual_controls

esttab . using  "${tables}tableA1C2.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
  
***District controls***
use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)

bysort state district: keep if _n == 1
   
label var f_perc                     "Female share of population"
label var f_literate				 "Female literacy rate"
label var m_literate	             "Male literacy rate"
label var sc_st_rate	             "SC/ST share of population"


estpost summarize $dist_controls

esttab . using  "${tables}tableA1D.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
  
***Election outcomes***
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

esttab . using  "${tables}tableA1E.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
  
***Men's marriage outcomes***
use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)
 
label var married                 "Married"
label var never_married			  "Never married"
label var sep_divorce			  "Seperated or divorced"
label var marriage_age 			  "Age at first marriage"


estpost summarize married never_married sep_divorce marriage_age

esttab . using  "${tables}tableA1F.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
  
 ***Alternative empowerment outcomes for married women***
 use "${intermediate}for_analysis_women_3.dta", clear

keep if !mi(male_decision_z)

label var children_ever                 "Total fertility"
label var pregnant						"Pregnant"
label var working						"Working"
label var has_money 					"Has personal savings"
label var house_ownership 				"Individual or joint house ownership"
label var land_ownership				"Individual or joint land ownership"


estpost summarize children_ever pregnant working has_money house_ownership land_ownership

esttab . using  "${tables}tableA1G.tex", ///
  mlabels(,none) collabels(,none) ///
  cells("count(fmt(%9.0gc)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc))") ///
  nolines ///
  nomtitle ///
  label ///
  nonumber ///
  noobs ///
  fragment ///
  replace
  
*********************************************************************************
***TABLE A2: Balance Checks***

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

  
***Panel A (2): Married women's sample***
use "${intermediate}for_analysis_women_3.dta", clear
keep if male_decision_z!=.

foreach var in $individual_controls {
	ivreg2 `var' (frac_f = frac_close_winf) frac_close $margin2 state_*, $se
qui: sum `var' if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo bti`var'
}

estout bti* using "${tables}tableA2A2.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
  
***Panel A (3): Men: Age less than or equal to 30 and unmarried***
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
  
  
***Panel A (4): Men: Age less than or equal to 30 and married***
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
  
  
***Panel A (5): Men: Age greater than 30 and unmarried***
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
  
  
***Panel A (6): Men: Age greater than 30 and married***
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
***TABLE A3: Mechanism: Educational Attainment for All Women by Marital Status and Age***
use "${intermediate}for_analysis_women_3.dta", clear
egen med_age = median(age)
assert med_age == 29

***Age less than or equal to 29 and unmarried***
use "${intermediate}for_analysis_women_3.dta", clear

keep if age <= 29 & married == 0

ivreg2 has_secondary (frac_f = frac_close_winf) frac_close $margin2 $individual_controls_noeduc state_*  $dist_controls, $se
qui: sum has_secondary if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv_educ1

***Age less than or equal to 29 and married***
use "${intermediate}for_analysis_women_3.dta", clear

keep if age <= 29 & married == 1

ivreg2 has_secondary (frac_f = frac_close_winf) frac_close $margin2 $individual_controls_noeduc state_*  $dist_controls, $se
qui: sum has_secondary if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv_educ2

***Age greater than 29 and unmarried***
use "${intermediate}for_analysis_women_3.dta", clear

keep if age > 29 & married == 0

ivreg2 has_secondary (frac_f = frac_close_winf) frac_close $margin2 $individual_controls_noeduc state_*  $dist_controls, $se
qui: sum has_secondary if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv_educ3

***Age greater than 29 and married***
use "${intermediate}for_analysis_women_3.dta", clear

keep if age > 29 & married == 1

ivreg2 has_secondary (frac_f = frac_close_winf) frac_close $margin2 $individual_controls_noeduc state_*  $dist_controls, $se
qui: sum has_secondary if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo iv_educ4


estout iv_educ1 iv_educ2 iv_educ3 iv_educ4 using "${tables}tableA3.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear

********************************************************************************
***TABLE A4: Robustness***

***Panel A: Full men's sample***
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


estout p1 p2 p3 p4 p5 p6 using "${tables}tableA4A.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
  
***Panel B: Married Women's Sample***
use "${intermediate}for_analysis_women_3.dta", clear

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

use "${intermediate}for_analysis_women_2.dta", clear
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p3

use "${intermediate}for_analysis_women_2.5.dta", clear
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p4

use "${intermediate}for_analysis_women_3.5.dta", clear
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p5

use "${intermediate}for_analysis_women_4.dta", clear
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo p6


estout p1 p2 p3 p4 p5 p6 using "${tables}tableA4B.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
  
***Panel C: Men: Age less than or equal to 30 and unmarried***
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


estout b1 b2 b3 b4 b5 b6 using "${tables}tableA4C.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
  
***Panel D: Men: Age less than or equal to 30 and married***
use "${intermediate}for_analysis_men_3.dta", clear
keep if age <= 30 & married == 1

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
keep if age <= 30 & married == 1
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c3

use "${intermediate}for_analysis_men_2.5.dta", clear
keep if age <= 30 & married == 1
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c4

use "${intermediate}for_analysis_men_3.5.dta", clear
keep if age <= 30 & married == 1
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c5

use "${intermediate}for_analysis_men_4.dta", clear
keep if age <= 30 & married == 1
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo c6


estout c1 c2 c3 c4 c5 c6 using "${tables}tableA4D.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
  
***Panel E: Men: Age greater than 30 and unmarried***
use "${intermediate}for_analysis_men_3.dta", clear
keep if age > 30 & married == 0

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
keep if age > 30 & married == 0
*bw 2
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d3

use "${intermediate}for_analysis_men_2.5.dta", clear
keep if age > 30 & married == 0
*bw 2.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d4

use "${intermediate}for_analysis_men_3.5.dta", clear
keep if age > 30 & married == 0
*bw 3.5
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d5

use "${intermediate}for_analysis_men_4.dta", clear
keep if age > 30 & married == 0
*bw 4
ivreg2 male_decision_z (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_*  $dist_controls, $se
qui: sum male_decision_z if e(sample) == 1
qui estadd scalar outcome_mean = r(mean)
eststo d6


estout d1 d2 d3 d4 d5 d6 using "${tables}tableA4E.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  
  
***Panel F: Men: Age greater than 30 and unmarried***
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


estout e1 e2 e3 e4 e5 e6 using "${tables}tableA4F.tex", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear
  

