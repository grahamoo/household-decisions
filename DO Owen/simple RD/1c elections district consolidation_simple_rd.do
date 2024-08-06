cd "C:\Users\17819\Dropbox\capstone"

foreach h of numlist 1(0.5)4 {
	
use "Data Owen/Elections/ECI excel files/clean_elections_`h'.dta", clear

*keep elections closest to interview
keep if year == 2010 | year == 2011 | year == 2012 | year == 2013 | year == 2014

bysort state (year): gen diff_year = year[1] != year[_N]
assert diff_year == 0
drop diff_year

*make margin negative when woman loses
replace marg = -1 * marg if win_f == 0 & mf == 1

*keep one observation per election
duplicates drop year state district ac, force

*generate variable for total female winners by district election year
sort state district year
by state district year: egen total_f = total(win_f)
label var total_f "total female winners in district"

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

*Keep close m-f elections
keep if close_mf == 1

*keep districts with one close m-f election
keep if total_close == 1
duplicates report year state district
assert r(unique_value) == _N

*drop individual variables 
drop CAND_NAME ac TOT_ELECTORS TOT_VOTERS POLL_PERCENT AC_TYPE CAND_SEX CAND_CATEGORY CAND_AGE PARTYABBRE cand_vote rank match_var female ff mm mf win_f winner_vote runnerup_vote abs_marg close close_mf duplic AC_NO


local varlist "marg"

foreach var of local varlist {
	replace `var' = 0 if `var' == .
	gen `var'2 = `var'^2
	gen `var'3 = `var'^3
}



save "Data Owen/Elections/election_district_`h'_simple_rd.dta", replace
}