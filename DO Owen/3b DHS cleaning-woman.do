
use v024 sdistri v130 v155 v157 v158 v159 v012 v133 v501 s116 v201 v106 ///
v714 v745a v745b v213 s927 v743a v743b v743d v632 v739 using "${raw}DHS\Womens DHS\IAIR74FL.dta", clear

**clean and generate individual covariates***
rename v024 state
decode sdistri, generate(district)
replace district = upper(district)
replace district = strtrim(district)
decode state, generate(state1)
drop state
rename state1 state
replace state = upper(state)
replace state = strtrim(state)

rename v130 religion
assert !mi(religion)
la var religion "respondent's religion"
gen hindu = religion == 1
gen muslim = religion == 2
gen christian = religion == 3
gen sikh = religion == 4
gen buddhist = religion == 5

rename v155 literacy
assert !mi(literacy)
gen literate = literacy == 2
la var literate "respondent is able to read whole sentence"
gen semi_literate = literacy == 1
la var semi_literate "respondent is able to read only parts of sentence"

assert !mi(v157) & !mi(v158) & !mi(v159)
gen news_read = v157 != 0
label var news_read "respondent reads newspaper or magazines at least once a week"
gen radio_listen = v158 != 0
label var radio_listen "respondent listens to radio at least once a week"
gen tv_watch = v159 != 0
label var tv_watch "respondent watches tv at least once a week"

rename v012 age
la var age "respondent's age in years"

rename v133 years_educ
la var years_educ "respodent's years of education"
gen has_secondary = v106 >= 2
replace has_secondary = . if mi(v106)
la var has_secondary "respondent has at least secondary school educ attainment"

assert !mi(v501)
gen married = (v501 == 1)
la var married "respondent is married"

gen respondent_sc_st = (s116 == 1 | s116 == 2 )
replace respondent_sc_st = . if mi(s116)
label var respondent_sc_st "respondent belongs to scheduled caste or scheduled tribe"
gen respondent_obc = (s116 == 3)
replace respondent_obc = . if mi(s116)
label var respondent_obc "respondent belongs to other backwards caste"

ren v714 working
la var working "respondent is currently working"

rename v201 children_ever
la var children_ever "respondent's total number of children ever born"
ren v213 pregnant
la var pregnant "respondent is currently pregnant"

gen house_ownership = 0 if v745a == 0
replace house_ownership = 1 if v745a > 0 & !mi(v745a)
la var house_ownership "respondent owns house alone or jointly"
gen land_ownership = 0 if v745b == 0
replace land_ownership = 1 if v745b > 0 & !mi(v745b)
la var land_ownership "respondent owns land alone or jointly"
ren s927 has_money
la var has_money "respondent has money that they alone can decide what to do with"

*rename dependent variables
rename v743a healthcare_decisions
rename v632 contraceptive_decisions
rename v743b largehousehold_decisions
rename v739 wifesincome_decisions
rename v743d visitrelative_decisions

*turn dependent variables into indicators that take on 1 if the respondent responds with "Husband"
replace contraceptive_decisions = 0 if contraceptive_decisions != 2 & !mi(contraceptive_decisions)
replace contraceptive_decisions = 1 if contraceptive_decisions == 2

foreach var in healthcare_decisions largehousehold_decisions wifesincome_decisions visitrelative_decisions {
	replace `var' = 0 if `var' != 4 & !mi(`var')
	replace `var' = 1 if `var' == 4
	label define `var' 0 "Other" 1 "Husband"
}
la var healthcare_decisions "respondent's husband primarily makes healthcare decisions"
la var contraceptive_decisions "respondent's husband primarily makes contraceptive decisions"
la var largehousehold_decisions "respondent's husband primarily makes large household purchase decisions"
la var wifesincome_decisions "respondent's husband primarily decides what to do with respondent's income"
la var visitrelative_decisions "respondent's husband primarily decides when they visit respondent's relatives"

egen male_decision_z = weightave2(healthcare_decisions contraceptive_decisions largehousehold_decisions wifesincome_decisions visitrelative_decisions)
la var male_decision_z "household decision-making index"


***State and district cleaning***
*drop states without election data
drop if state == "DADRA AND NAGAR HAVELI" | state == "DAMAN AND DIU" | state == "ANDAMAN AND NICOBAR ISLANDS" ///
| state == "TELANGANA" | state == "LAKSHADWEEP" | state == "CHANDIGARH"

*clean state and district names
replace state = "JAMMU & KASHMIR" if state == "JAMMU AND KASHMIR"

replace district = "BARPETA" if state == "ASSAM" & district == "BAKSA"

replace district = "KABEERDHAM" if state == "CHHATTISGARH" & district == "KABIRDHAM"
replace district = "KORIYA" if state == "CHHATTISGARH" & district == "KOREA (KORIYA)"

replace district = "LAHUL & SPITI" if state == "HIMACHAL PRADESH" & district == "LAHUL AND SPITI"

replace district = "SENAPATI" if state == "MANIPUR" & district == "SENAPATI (EXCLUDING 3 SUB-DIVISIONS)"

replace district = "PUDUCHERRY" if state == "PUDUCHERRY" & (district == "MAHE" | district == "YANAM")

replace district = "SIDDHARTHNAGAR" if state == "UTTAR PRADESH" & district == "SIDDHARTH NAGAR"

tab state, gen(state_)

save "${intermediate}DHS_women", replace