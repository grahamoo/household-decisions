cd "C:\Users\graha\Dropbox\capstone\Data Owen"

use "districts.dta", clear


*create dataset of just district level variables

use "Elections/election_district.dta", clear

*merge SHRUG data
merge m:1 state district using "SHRUG/SHRUG merge Owen.dta"

rename _merge _merge_SHRUG

drop if _merge_SHRUG == 2


*merge NCRB data
merge m:1 state district using "NCRB/District-wise crimes against women.dta"

rename _merge _merge_NCRB
drop if _merge_NCRB == 2

*merge census data
merge m:1 state district using "Census/census.dta"
rename _merge _merge_census

drop if _merge_census == 2

keep if year <= 2014

*generate globals used in regression
global margin1 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10
global margin2 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102
global margin3 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102 marg13 marg23 marg33 marg43 marg53 marg63 marg73 marg83 marg93 marg103

global dist_controls tot_employmentTotal tot_agriculture_workerTotal f_household_workerTotal f_literateTotal  frac_pop_rural f_percentage_districtTotal fm_ratio tot_cultivatorsTotal

global se "cluster(district)"

ivreg2 Dowry_deaths (frac_f = frac_close_winf) frac_close $margin3 $dist_controls