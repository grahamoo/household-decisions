
***Mens sample***
foreach h of numlist 2(0.5)4 {
	
use "${intermediate}DHS_men.dta", clear

*merge election data
merge m:1 state district using "${intermediate}clean_elections_district_`h'.dta"
/*
 Result                      Number of obs
    -----------------------------------------
    Not matched                            40
        from master                         0  (_merge==1)
        from using                         40  (_merge==2)

    Matched                           109,571  (_merge==3)
    -----------------------------------------
*/

rename _merge _merge_elections
assert _merge_elections != 1
drop if _merge_elections == 2



*merge census data
merge m:1 state district using "${intermediate}clean_census.dta"
/* Result                      Number of obs
    -----------------------------------------
    Not matched                            13
        from master                         0  (_merge==1)
        from using                         13  (_merge==2)

    Matched                           109,571  (_merge==3)
    -----------------------------------------
*/

rename _merge _merge_census
assert _merge_census != 1
drop if _merge_census == 2
drop state_code

save "${intermediate}for_analysis_men_`h'.dta", replace
}

********************************************************************************

***Womens sample***
foreach h of numlist 2(0.5)4 {
	
use "${intermediate}DHS_women.dta", clear

*merge election data
merge m:1 state district using "${intermediate}clean_elections_district_`h'.dta"
/*
 Result                      Number of obs
    -----------------------------------------
    Not matched                            40
        from master                         0  (_merge==1)
        from using                         40  (_merge==2)

    Matched                           685,303  (_merge==3)
    -----------------------------------------
*/

rename _merge _merge_elections
assert _merge_elections != 1
drop if _merge_elections == 2



*merge census data
merge m:1 state district using "${intermediate}clean_census.dta"
/* Result                      Number of obs
    -----------------------------------------
    Not matched                            13
        from master                         0  (_merge==1)
        from using                         13  (_merge==2)

    Matched                           685,303  (_merge==3)
    -----------------------------------------
*/

rename _merge _merge_census
assert _merge_census != 1
drop if _merge_census == 2
drop state_code

save "${intermediate}for_analysis_women_`h'.dta", replace
}