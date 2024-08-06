cd "C:\Users\17819\Dropbox\capstone"

foreach h of numlist 1(0.5)4 {
	
use "individual male files/DHS.dta", clear

*merge election data
merge m:1 state district using "Data Owen/Elections/election_district_`h'_simple_rd.dta"
rename _merge _merge_elections
keep if _merge_elections == 3

*merge census data
merge m:1 state district using "Data Owen/Census/census.dta"
rename _merge _merge_census
assert _merge_census != 1
drop if _merge_census == 2

drop state_code

*Define additional marriage statuses
gen never_married = mv535 == 0
gen sep_divorce = mv535 == 1

*rename covariates to shorten
ren educationyears_respondent educyears
ren f_percentage_districtTotal f_perc
ren m_percentage_districtTotal m_perc

*rename dependent variables
rename sm701e fertility_decisions
rename sm701a largehousehold_decisions
rename sm701d womensincome_decisions
rename sm701b dailyhousehold_decisions
rename sm701c visitrelative_decisions



local varlist fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions
foreach var of local varlist {
	replace `var' = 0 if `var' != 1 & !mi(`var')
}

egen male_decision_z = weightave2(fertility_decisions largehousehold_decisions womensincome_decisions dailyhousehold_decisions visitrelative_decisions)

save "individual male files/districts-male_`h'_simple_rd.dta", replace
}