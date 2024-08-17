*Purpose: Clean 2011 Census data and define district-level covariates

*import district level file
import excel using "${raw}Census/DDW_PCA0000_2011_Indiastatedist", firstrow sheet("Sheet1") clear

*rename variables
rename State state_code
rename District district_code
replace Name = upper(Name)
replace Name = strtrim(Name)
rename Name district
replace district = strtrim(district)

*drop states that do not appear in DHS
drop if inlist(state_code, "00", "25", "26", "31", "35")

*drop state-level and rural/urban-level observations
keep if Level == "DISTRICT" & TRU == "Total"


***Generate district-level covariates***
*generate population shares by gender
gen f_percentage_district = TOT_F / TOT_P
gen m_percentage_district = TOT_M / TOT_P

*generate literacy rates by gender
gen f_literate = F_LIT / TOT_F
gen m_literate = M_LIT / TOT_M

label var f_literate "percentage of females that are literate"
label var m_literate "percentage of males that are literate"

*generate sc/st share of population
gen sc_rate = P_SC / TOT_P
gen st_rate = P_ST / TOT_P
gen sc_st_rate = sc_rate + st_rate

label var sc_st_rate "percentage of population that is SC/ST"


***Clean state and district names to match DHS data***
*generate state names
gen state = ""
replace state = "JAMMU & KASHMIR" if state_code == "01"
replace state = "HIMACHAL PRADESH" if state_code == "02"
replace state = "PUNJAB" if state_code == "03"
replace state = "CHANDIGARH" if state_code == "04"
replace state = "UTTARAKHAND" if state_code == "05"
replace state = "HARYANA" if state_code == "06"
replace state = "DELHI" if state_code == "07"
replace state = "RAJASTHAN" if state_code == "08"
replace state = "UTTAR PRADESH" if state_code == "09"
replace state = "BIHAR" if state_code == "10"
replace state = "SIKKIM" if state_code == "11"
replace state = "ARUNACHAL PRADESH" if state_code == "12"
replace state = "NAGALAND" if state_code == "13"
replace state = "MANIPUR" if state_code == "14"
replace state = "MIZORAM" if state_code == "15"
replace state = "TRIPURA" if state_code == "16"
replace state = "MEGHALAYA" if state_code == "17"
replace state = "ASSAM" if state_code == "18"
replace state = "WEST BENGAL" if state_code == "19"
replace state = "JHARKHAND" if state_code == "20"
replace state = "ODISHA" if state_code == "21"
replace state = "CHHATTISGARH" if state_code == "22"
replace state = "MADHYA PRADESH" if state_code == "23"
replace state = "GUJARAT" if state_code == "24"
replace state = "MAHARASHTRA" if state_code == "27"
replace state = "ANDHRA PRADESH" if state_code == "28"
replace state = "KARNATAKA" if state_code == "29"
replace state = "GOA" if state_code == "30"
replace state = "KERALA" if state_code == "32"
replace state = "TAMIL NADU" if state_code == "33"
replace state = "PUDUCHERRY" if state_code == "34"

*rename districts to match DHS
drop if state == "CHANDIGARH"

replace district = "PAPUMPARE" if state == "ARUNACHAL PRADESH" & district == "PAPUM PARE"

replace district = "BANASKANTHA" if state == "GUJARAT" & district == "BANAS KANTHA"
replace district = "PANCHMAHAL" if state == "GUJARAT" & district == "PANCH MAHALS"
replace district = "SABARKANTHA" if state == "GUJARAT" & district == "SABAR KANTHA"

replace district = "LEH" if state == "JAMMU & KASHMIR" & district == "LEH(LADAKH)"

replace district = "SARAIKELA KHARSAWAN" if state == "JHARKHAND" & district == "SARAIKELA-KHARSAWAN"

*keep necessary variables
keep state_code district_code state district TOT_P f_percentage_district m_percentage_district f_literate m_literate sc_rate st_rate sc_st_rate

duplicates report state district
assert r(unique_value) == _N

order state_code district_code state district
 
save "${intermediate}clean_census.dta", replace
