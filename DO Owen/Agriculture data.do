cd "C:\Users\graha\Dropbox\capstone\Data Owen"

*import files
import excel using "ICRISTAT agriculture\District Level GDP Per Capita", firstrow clear



rename DistName district
rename StateName state
rename Year year
replace district = upper(district)
replace district = strtrim(district)
replace state = upper(state)
replace state = strtrim(state)

*keep years for each state that corresponds with elections
keep if year >=2008

*state and district renaming
replace state = "ODISHA" if state == "ORISSA"

replace district = "ANANTAPUR" if state == "ANDHRA PRADESH" & district == "ANANTHAPUR"

*merge with election data
gen year_gdp = year
drop year

merge m:1 state district using "Elections/election_district.dta"

keep if _merge == 3
drop _merge
drop if year_gdp < year

sort state district
by state district: egen mean_gdp_percap = mean(PERCAPITACURRENTPRICES1000)

drop PERCAPITACURRENTPRICES1000 year_gdp

duplicates drop

*merge with census data

merge 1:1 state district using "Census\census.dta"

drop if _merge == 2


*create controls
global dist_controls tot_employmentTotal tot_agriculture_workerTotal  tot_cultivatorsTotal TOT_PTotal frac_pop_rural f_literateTotal m_literateTotal sc_st_rateTotal

global se "cluster(district)"

*regression
ivreg2 mean_gdp_percap (frac_f = frac_close_winf) frac_close $margin3 $dist_controls
