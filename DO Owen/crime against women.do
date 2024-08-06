cd "C:\Users\graha\Dropbox\capstone"



*import 2014 NCRB excel file
import excel using "Data Owen/NCRB/5 District-wise Crimes committed against Women_2014", sheet("District Data Report") cellrange(A2) firstrow clear

*create state names for each district
generate state_loc = strpos(SL, "State: ")

foreach _n in _N {
	replace SL = SL[_n - 1] if state_loc == 0
}

replace SL = subinstr(SL, "State: ", "",.)
drop state_loc

*create state, district, year variables
rename SL state
rename District district
rename YEAR year
replace state = upper(state)
replace district = upper(district)
replace state = strtrim(state)
replace district = strtrim(district)

*drop 'total' row for each state
drop if district == "TOTAL DISTRICT(S)"

*drop rows for state name
drop if district == ""

*2019 miscarriage variable includes sec. 313 and sec. 314 of IPC
*for 2014, this is split into two seperate variables
gen Miscarriage = Deathscausedwithintenttocau + Causingmiscarriagewithoutcons


*rename variables
rename DowryDeaths Dowry_deaths
rename AbetmentofSuicidesofWomen Abetment_suicide
rename AttempttocommitRape Attempt_rape
rename KidnappingAbduction_Total Kidnapping_abduction
rename AssaultonWomenwithintentto Assault_to_outrage_modesty
rename InsulttotheModestyofWomen_T Insult_modesty
rename CrueltybyHusbandorhisRelati Cruelty_husband_relat
rename DowryProhibitionAct1961 Dowry_prohibition
rename IndecentRepresentationofWomen Indecent_representation
rename ProtectionofWomenfromDomesti Protect_against_dv
rename ImmoralTrafficPreventionAct Immoral_traffic_prevention
rename Acidattack Acid_attack
rename AttempttoAcidAttack Attempt_acid_attack
rename HumanTrafficking Human_trafficking
rename TotalCrimesinwhichWomenwas Total_crimes

*keep variables that are included in 2014, 2015, 2016, and 2019 datasets
keep state district year Rape Dowry_deaths Abetment_suicide Attempt_rape Kidnapping_abduction Assault_to_outrage_modesty Insult_modesty Cruelty_husband_relat Dowry_prohibition Indecent_representation Protect_against_dv Immoral_traffic_prevention Acid_attack Attempt_acid_attack Miscarriage Human_trafficking Total_crimes


tempfile file_2014
save "`file_2014'"

*import 2015 NCRB excel file
import excel using "Data Owen/NCRB/5 District-wise Crimes committed against Women_2015", sheet("District Data Report") cellrange(A2) firstrow clear

*create state names for each district
generate state_id = strpos(SL, "State: ")

foreach _n in _N {
	replace SL = SL[_n - 1] if state_id == 0
}

replace SL = subinstr(SL, "State: ", "",.)
drop state_id

*create state, district, year variables
rename SL state
rename District district
rename YEAR year
replace state = upper(state)
replace district = upper(district)
replace state = strtrim(state)
replace district = strtrim(district)

*drop 'total' row for each state
drop if district == "TOTAL DISTRICT(S)"

*drop rows for state name
drop if district == ""

*2019 miscarriage variable includes sec. 313 and sec. 314 of IPC
*for 2015, this is split into two seperate variables
gen Miscarriage = Deathscausedwithintenttocau + Causingmiscarriagewithoutcons

*rename variables
rename DowryDeaths Dowry_deaths
rename AbetmentofSuicidesofWomen Abetment_suicide
rename AttempttocommitRape Attempt_rape
rename KidnappingAbduction_Total Kidnapping_abduction
rename AssaultonWomenwithintentto Assault_to_outrage_modesty
rename InsulttotheModestyofWomen_T Insult_modesty
rename CrueltybyHusbandorhisRelati Cruelty_husband_relat
rename DowryProhibitionAct1961 Dowry_prohibition
rename IndecentRepresentationofWomen Indecent_representation
rename ProtectionofWomenfromDomesti Protect_against_dv
rename ImmoralTrafficPreventionAct Immoral_traffic_prevention
rename Acidattack Acid_attack
rename AttempttoAcidAttack Attempt_acid_attack
rename HumanTrafficking Human_trafficking
rename TotalCrimesinwhichWomenwas Total_crimes

*keep variables that are included in 2014, 2015, 2016, and 2019 datasets
keep state district year Rape Dowry_deaths Abetment_suicide Attempt_rape Kidnapping_abduction Assault_to_outrage_modesty Insult_modesty Cruelty_husband_relat Dowry_prohibition Indecent_representation Protect_against_dv Immoral_traffic_prevention Acid_attack Attempt_acid_attack Miscarriage Human_trafficking Total_crimes

tempfile file_2015
save "`file_2015'"


*import 2016 NCRB excel file
import excel using "Data Owen/NCRB/District-wise Crimes committed against Women_2016", sheet("District Data Report") cellrange(A2) firstrow clear

*create state names for each district
generate state_id = strpos(SL, "State: ")

foreach _n in _N {
	replace SL = SL[_n - 1] if state_id == 0
}

replace SL = subinstr(SL, "State: ", "",.)
drop state_id

*create state, district, year variables
rename SL state
rename District district
rename YEAR year
replace state = upper(state)
replace district = upper(district)
replace state = strtrim(state)
replace district = strtrim(district)

*drop 'total' row for each state
drop if district == "TOTAL DISTRICT(S)"

*drop rows for state name
drop if district == ""

*2019 miscarriage variable includes sec. 313 and sec. 314 of IPC
*for 2016, this is split into two seperate variables
gen Miscarriage = Deathscausedwithintenttocau + Causingmiscarriagewithoutcons 

*rename variables
rename DowryDeaths Dowry_deaths
rename AbetmentofSuicidesofWomen Abetment_suicide
rename AttempttocommitRape Attempt_rape
rename KidnappingAbduction_Total Kidnapping_abduction
rename AssaultonWomenwithintentto Assault_to_outrage_modesty
rename InsulttotheModestyofWomen_T Insult_modesty
rename CrueltybyHusbandorhisRelati Cruelty_husband_relat
rename DowryProhibitionAct1961 Dowry_prohibition
rename IndecentRepresentationofWomen Indecent_representation
rename ProtectionofWomenfromDomesti Protect_against_dv
rename ImmoralTrafficPreventionAct Immoral_traffic_prevention
rename Acidattack Acid_attack
rename AttempttoAcidAttack Attempt_acid_attack
rename HumanTrafficking Human_trafficking
rename TotalCrimesagainstWomen Total_crimes

*keep variables that are included in 2014, 2015, 2016, and 2019 datasets
keep state district year Rape Dowry_deaths Abetment_suicide Attempt_rape Kidnapping_abduction Assault_to_outrage_modesty Insult_modesty Cruelty_husband_relat Dowry_prohibition Indecent_representation Protect_against_dv Immoral_traffic_prevention Acid_attack Attempt_acid_attack Miscarriage Human_trafficking Total_crimes

tempfile file_2016
save "`file_2016'" 


*append tempfiles
use "`file_2014'"
append using "`file_2015'"
append using "`file_2016'"



*create average variable across 2014, 2015, 2016

foreach x in Rape Dowry_deaths Abetment_suicide Attempt_rape Kidnapping_abduction Assault_to_outrage_modesty Insult_modesty Cruelty_husband_relat Dowry_prohibition Indecent_representation Protect_against_dv Immoral_traffic_prevention Acid_attack Attempt_acid_attack Miscarriage Human_trafficking Total_crimes {
sort state district
by state district: egen `x'_avg = mean(`x')
drop `x'
rename `x'_avg `x'
} 

*create one observation for each district
duplicates drop state district, force
drop year

*label variables
label var Rape "Total cases of rape against women"
label var Dowry_deaths "Total cases of dowry deaths"
label var Abetment_suicide "Total cases of abetment of suice of women"
label var Attempt_rape "Total cases of attempt to commit rape against women"
label var Kidnapping_abduction "Total cases of kidnapping & abduction against women"
label var Assault_to_outrage_modesty "Total cases of assault on Women with intent to outrage her modesty against women"
label var Insult_modesty "Total cases of insulting the modesty of women"
label var Cruelty_husband_relat "Total cases of cruelty by husband or his relatives"
label var Dowry_prohibition "Total cases: Dowry Prohibition Act, 1961"
label var Indecent_representation "Total cases of indecent representation of women"
label var Protect_against_dv "Total cases: Protection of Women from Domestic Violence Act"
label var Immoral_traffic_prevention "Total cases: Immoral Traffic (Prevention) Act 1956 (Women Victims cases only)"
label var Acid_attack "Total cases of acid attack against women"
label var Attempt_acid_attack "Total cases of attempted acid attack against women"
label var Miscarriage "Total cases of miscarriage crimes (Sec. 313 & 314 IPC)"
label var Human_trafficking "Total cases of human trafficking of women"
label var Total_crimes "Total crimes against women" 

save "Data Owen/NCRB/District-wise crimes against women.dta", replace
