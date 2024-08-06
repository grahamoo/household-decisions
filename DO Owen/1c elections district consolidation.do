cd "C:\Users\17819\Dropbox\capstone"

foreach h of numlist 2(0.5)4 {
	
use "Data Owen/Elections/ECI excel files/clean_elections_`h'.dta", clear

*keep elections closest to interview
keep if year == 2010 | year == 2011 | year == 2012 | year == 2013 | year == 2014

bysort state (year): gen diff_year = year[1] != year[_N]
assert diff_year == 0
drop diff_year

tempfile main
save "`main'"


*generate temp file that has constituencies
*this file will generate the margins for each district

duplicates drop state district ac, force
keep if mf == 1

replace marg = -1 * marg if win_f == 0 

keep state district marg

sort state district
by state district: gen cid = _n
tab cid

reshape wide marg, i(state district) j(cid)

tempfile margins
save "`margins'"


*create tempfile with one observation per district
use "`main'"
duplicates drop state district ac, force

*generate variable for total female winners by district election year
sort state district year
by state district year: egen total_f = total(win_f)
label var total_f "total female winners in district"

*remove uncontested elections

*generate variable for female winners / total seats by district election year
gen frac_f = total_f / totseats_dist
label var frac_f "fraction of seats won by females"

*generate variable for number of male_female elections
sort state district year
by state district year: egen total_mf = total(mf)
label var total_mf "total number of male-female elections by district"

*generate variable for total close m-f elections by district election year
sort state district year
by state district year: egen total_close = total(close_mf)
label var total_close "number of close male-female elections by district"

gen frac_close = total_close / totseats_dist
label var frac_close "fraction of elections that were close male-female elections"

*generate variable for total close elections won by females

sort state district year
by state district year: egen total_close_winf = total(close_mf_winf)
label var total_close_winf "number of close male-female elections won by females"

gen frac_close_winf = total_close_winf / totseats_dist
label var frac_close_winf "fraction of elections that were close mf won by f"


*drop individual variables 
drop CAND_NAME ac TOT_ELECTORS TOT_VOTERS POLL_PERCENT AC_TYPE CAND_SEX CAND_CATEGORY CAND_AGE PARTYABBRE cand_vote rank match_var female ff mm mf win_f winner_vote runnerup_vote abs_marg marg close close_mf close_mf_winf duplic AC_NO

*drop duplicates
duplicates drop state district, force

*merge with margins
*original had 658 districts

merge 1:1 state district using "`margins'"

/*
 Result                      Number of obs
    -----------------------------------------
    Not matched                           299
        from master                       299  (_merge==1)
        from using                          0  (_merge==2)

    Matched                               359  (_merge==3)
    -----------------------------------------
*/
gen dist_had_mf = 0
replace dist_had_mf = 1 if _merge == 3
drop _merge

*generate dummies for margins

gen dum1 = 0
replace dum1 = 1 if marg1 != .
gen dum2 = 0
replace dum2 = 1 if marg2 != .
gen dum3 = 0
replace dum3 = 1 if marg3 != .
gen dum4 = 0
replace dum4 = 1 if marg4 != .
gen dum5 = 0
replace dum5 = 1 if marg5 != .
gen dum6 = 0
replace dum6 = 1 if marg6 != .
gen dum7 = 0
replace dum7 = 1 if marg7 != .
gen dum8 = 0
replace dum8 = 1 if marg8 != .
gen dum9 = 0
replace dum9 = 1 if marg9 != .
gen dum10 = 0
replace dum10 = 1 if marg10 != .

local varlist "marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10"

foreach var of local varlist {
	replace `var' = 0 if `var' == .
	gen `var'2 = `var'^2
	gen `var'3 = `var'^3
}



save "Data Owen/Elections/election_district_`h'.dta", replace
}