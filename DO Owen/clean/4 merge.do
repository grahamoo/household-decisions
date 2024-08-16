
***Mens sample***
foreach h of numlist 2(0.5)4 {
	
use "${intermediate}DHS_men.dta", clear

*merge election data
merge m:1 state district using "${intermediate}clean_elections_district_`h'.dta"
rename _merge _merge_elections
assert _merge_elections != 1
drop if _merge_elections == 2

*merge census data
merge m:1 state district using "${intermediate}clean_census.dta"
rename _merge _merge_census
assert _merge_census != 1
drop if _merge_census == 2
drop state_code

sort mcaseid
save "${intermediate}for_analysis_men_`h'.dta", replace
}

********************************************************************************

***Womens sample***
foreach h of numlist 2(0.5)4 {
	
use "${intermediate}DHS_women.dta", clear

*merge election data
merge m:1 state district using "${intermediate}clean_elections_district_`h'.dta"
rename _merge _merge_elections
assert _merge_elections != 1
drop if _merge_elections == 2



*merge census data
merge m:1 state district using "${intermediate}clean_census.dta"
rename _merge _merge_census
assert _merge_census != 1
drop if _merge_census == 2
drop state_code

sort caseid
save "${intermediate}for_analysis_women_`h'.dta", replace
}