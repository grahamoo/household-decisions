*Purpose: Clean Men's 2015-2016 DHS sample. Define individual covariates and outcome variables
use "${raw}DHS\Mens DHS\IAMR74FL.DTA", clear


**clean and generate individual covariates***
rename mv024 state
decode smdistri, generate(district)
replace district = upper(district)
replace district = strtrim(district)
decode state, generate(state1)
drop state
rename state1 state
replace state = upper(state)
replace state = strtrim(state)

rename mv130 religion
assert !mi(religion)
la var religion "respondent's religion"
gen hindu = (religion == 1)
gen muslim = (religion == 2)
gen christian = (religion == 3)
gen sikh = (religion == 4)
gen buddhist = (religion == 5)

rename mv155 literacy
assert !mi(literacy)
gen literate = (literacy == 2)
la var literate "respondent is able to read whole sentence"
gen semi_literate = (literacy == 1)
la var semi_literate "respondent is able to read only parts of sentence"

assert !mi(mv157) & !mi(mv158) & !mi(mv159)
gen daily_media = mv157 == 3 | mv158 == 3 | mv159 == 3
la var daily_media "respondent reads newspaper, watches tv, or listents to radion daily" 

rename mv012 age
la var age "respondent's age in years"
rename mv133 years_educ
la var years_educ "respodent's years of education"

gen schooling_age = age <= 21 //Note: minimum age is 15
la var schooling_age "Respondent is schooling age"

assert !mi(mv501)
gen married = (mv501 == 1)
la var married "respondent is married"
ren mv511 marriage_age
la var marriage_age "respodent's age at the time of first marriage"

assert !mi(mv535) if married == 0
gen never_married = mv535 == 0
la var never_married "respondent has never been married"
gen sep_divorce = mv535 == 1
la var sep_divorce "respondent is separated or divorced"

gen respondent_sc_st = (sm118 == 1 | sm118 == 2 )
replace respondent_sc_st = . if mi(sm118)
label var respondent_sc "respondent belongs to scheduled caste or scheduled tribe"
gen respondent_obc = (sm118 == 3)
replace respondent_obc = . if mi(sm118)
label var respondent_obc "respondent belongs to other backwards caste"


***Clean and generate outcome variables***
rename sm701e fertility_decisions
rename sm701a largehousehold_decisions
rename sm701d wifesincome_decisions
rename sm701b dailyhousehold_decisions
rename sm701c visitrelative_decisions

*create indicators for household decisions that take on 1 if the respondent responds with "Husband"
foreach var in fertility_decisions largehousehold_decisions wifesincome_decisions ///
dailyhousehold_decisions visitrelative_decisions {
	replace `var' = 0 if `var' != 1 & !mi(`var')
}

la var fertility_decisions "respodent prefers husbands make fertility decisions"
la var largehousehold_decisions "respondent prefers husbands make large household decisions"
la var wifesincome_decisions "respondent prefers husbands make decisions about what to do with wife's income"
la var dailyhousehold_decisions "respondent prefers husbands make decisions about daily household purchases"
la var visitrelative_decisions "respondent prefers husbands make decisions about when to visit wife's relatives"

*create decision-making index
egen male_decision_z = weightave2(fertility_decisions largehousehold_decisions wifesincome_decisions dailyhousehold_decisions visitrelative_decisions)
la var male_decision_z "household decision-making index"


***State and district cleaning***
*Drop territories that are not in election data
/*Note: The following areas are union territories that do not have state-level
legislative assemblies. Individuals in these territories account for <1% of total 
observations.*/
drop if state == "DADRA & NAGAR HAVELI" | state == "DAMAN & DIU" | state == "ANDAMAN & NICOBAR ISLANDS" ///
| state == "LAKSHADWEEP" | state == "CHANDIGARH"

*clean state and district names
replace state = "ANDHRA PRADESH" if state == "TELANGANA"
replace state = "JAMMU & KASHMIR" if state == "JAMMU AND KASHMIR"

replace district = "BARPETA" if state == "ASSAM" & district == "BAKSA"

replace district = "KABEERDHAM" if state == "CHHATTISGARH" & district == "KABIRDHAM"
replace district = "KORIYA" if state == "CHHATTISGARH" & district == "KOREA (KORIYA)"

replace district = "LAHUL & SPITI" if state == "HIMACHAL PRADESH" & district == "LAHUL AND SPITI"

replace district = "SENAPATI" if state == "MANIPUR" & district == "SENAPATI (EXCLUDING 3 SUB-DIVISIONS)"

replace district = "PUDUCHERRY" if state == "PUDUCHERRY" & (district == "MAHE" | district == "YANAM")

replace district = "SIDDHARTHNAGAR" if state == "UTTAR PRADESH" & district == "SIDDHARTH NAGAR"

*create state dummies
tab state, gen(state_)

sort mcaseid //stable sort

save "${intermediate}DHS_men.dta", replace