cd "C:\Users\graha\Dropbox\capstone\Data Owen"

use "DHS/Children DHS/IAKR74FL.dta", clear

**rename key variables for ease

*bio variables
rename hw2 weight_ch
rename hw3 height_ch
rename hw1 age_ch
gen age_ch_sq = age_ch^2
label var age_ch_sq "Age of child squared"
rename b4 sex_ch
rename hw56 hemo_ch
gen twin = (b0 == 1 | b0 == 2 | b0 == 3)
gen recent_diarrhea = (h11 == 1)
gen current_diarrhea = (h44c == 1)
gen recent_fever = (h22 == 1)
gen current_fever_cough = (ml11 == 1)

*respondent characteristics
rename v024 state
rename v130 religion
rename v133 educationyears_respondent
rename v155 literacy
rename v201 children_ever
rename v207 dead_daughters
rename v206 dead_sons
rename v218 children_living
gen married = (v501 == 1)
rename v605 child_desire
rename v627 ideal_boys
replace ideal_boys = . if ideal_boys == 96
rename v628 ideal_girls
replace ideal_girls = . if ideal_girls == 96
rename v447a respondent_age
gen respondent_age_sq = respondent_age^2
rename v137 n_children5under
rename v149 educationlevel_respondent

*birth variables
rename m4 breastfeed_status
gen still_breastfeed = (breastfeed_status == 95)
replace breastfeed_status = 0  if breastfeed_status == 94
rename breastfeed_status breastfeed_status1
gen breastfeed_status = breastfeed_status1 if breastfeed_status1 != 95 & breastfeed_status1 != 96
rename m5 breastfeed_months
replace breastfeed_months = 0 if breastfeed_months == 94
rename s220a pregnancy_duration
rename m19 birth_weight
rename s220b ultrasound
rename b11 birth_interval

*nutrition variables
rename v414a poultry_ch
rename v414j greens_ch
rename v414h meat_ch
rename v414p dairy_ch
rename v414k vitafruit_ch
rename v414n fish_ch
rename v414o legumes_ch

*household variables
gen house_electricity = (v119 == 1)
gen refrigerator = (v122 == 1)
rename bord birth_order
rename s930 mobile_phone
rename s929 bank_account
rename v136 household_size
rename v701 educationlevel_husband
rename v481 health_insurance
rename v005 sample_weight
rename v730 husband_age


**manipulate variables as needed
replace weight_ch = weight_ch / 10
replace height_ch = height_ch / 10

replace birth_weight = birth_weight / 1000


**generate new variables needed
decode sdistri, generate(district)
replace district = upper(district)
replace district = strtrim(district)
decode state, generate(state1)
drop state
rename state1 state
replace state = upper(state)
replace state = strtrim(state)

*using cdc equation for bmi = kg / m^2
gen bmi_ch = weight_ch / (height_ch / 100)^2
gen bmi_respondent = v445 / 100

*generate dummy variables
gen respondent_sc = (s116 == 1)
label var respondent_sc "respondent belongs to scheduled caste"
gen respondent_st = (s116 == 2)
label var respondent_sc "respondent belongs to scheduled tribe"
gen respondent_obc = (s116 == 3)
label var respondent_obc "respondent belongs to other backwards caste"

gen husband_jobless = (v705 == 0)
gen respondent_jobless = (v717 == 0)

gen husband_agriculture = (v705 == 5)
gen respondent_agriculture = (v717 == 5 )

gen female_ch = (sex_ch == 2)

gen rural = (v025 == 2)
gen urban = (v025 == 1)

gen no_housewater = 0
replace no_housewater = 1 if v115 != 996 & v115 != 0
label var no_housewater "respondent has to travel to access water"

gen flush_toilet = 0
replace flush_toilet = 1 if v116 == 11 | v116 == 12 | v116 == 13 | v116 == 14 | v116 == 15 
label var flush_toilet "respondent has flush toilet in house" 

gen automotive = 0
replace automotive = 1 if v124 == 1 | v125 == 1
label var automotive "household has car, truck, motorcycle, or scooter"

gen landline = (v153 == 1)
label var landline "household has landline" 

gen hindu = (religion == 1)
gen muslim = (religion == 2)
gen christian = (religion == 3)
gen sikh = (religion == 4)
gen buddhist = (religion == 5)

gen female_head = (v151 == 2)
label var female_head "head of household is female"

gen literate = (literacy == 2)
gen semi_literate = (literacy == 1)

gen bcg_vaccine = (h2 == 1 | h2 == 2)
gen dpt_vaccine = (h3 == 1 | h3 == 2)
gen polio_vaccine = (h4 == 1 | h4 == 2)
gen measles_vaccine = (h9 == 1 | h9 == 2)

gen stool_notdisposed = (v465 == 9)
label var stool_notdisposed "child's stool is left out when not using toilet"

gen news_read = (v157 != 0)
label var news_read "respondent reads newspaper or magazines"

gen radio_listen = (v158 != 0)
label var radio_listen "respondent listens to radio"

gen tv_watch = (v159 != 0)
label var tv_watch "respondent watches tv"

gen livingwithhusband = (v504 == 1)
label var livingwithhusband "respondent lives with husband"

gen multiple_wives = (v505 != 0)
label var multiple_wives "respondent's partner has additional wives"

gen antenatal_visit = (m14 != 0)
label var antenatal_visit "respondent has at least one antenatal visit"

gen birth_iron = (m45 == 1)
label var birth_iron "respondent was given or bought iron during pregnancy"

*generate extra weight and height variables
gen heightage_ch = hw4 / 10000
gen weightage_ch = hw7 / 10000
gen weightheight = hw10 / 10000


*check out what this variable means. Is it standard deviations?
gen wealth_index = v191 / 100000
gen wealth_index_urban = s191u / 100000
gen wealth_index_rural = s191r / 100000

**using WHO definitions
**child variables

*drop flagged variables
drop if hw70 == 9996 | hw70 == 9997 | hw70 == 9998


gen stunted_ch = (hw70 < -200)
gen underweight_ch = (hw71 < -200)
gen wasted_ch = (hw72 < -200)
gen severe_stunted_ch = (hw70 < -300)
gen severe_underweight_ch = (hw71 < -300)
gen severe_wasted_ch = (hw72 < -300)

*respondent variables
gen stunted_respondent = (v440 < -200)
gen underweight_respondent = (bmi_respondent < 18.5)
gen wasted_respondent = (v444a < -200)
gen severe_stunted_respondent = (v440 < -300)
gen severe_wasted_respondent = (v444a < -300)

*generate variable for whether the respondent was told about family planning

*generate wealth dummies
tab v190, gen (wealth_)
foreach num of numlist 1(1)5{
	label var wealth_`num' "Wealth dummies"
}


tempfile child
save "`child'"

use "DHS/Individuals DHS/IAIR74FL.dta", clear

*some of these are already in "`child'" file
keep caseid v190 v191 v701 v702 v704 v705 v714 v714a v715 v716 v717 v719 v721 v729 v730 v731 v732 v739 v740 v741 v743a v743b v743c v743d v743e v743f v744a v744b v744c v744d v744e v745a v745b v746 v766a v766b

*add variables for beating and benefits received during breastfeeding

tempfile individual
save "`individual'"

*merge "`child'" and "`individual'" files
use "`individual'"

merg 1:m caseid using "`child'"

drop if _merge == 1
drop _merge


*state and district cleaning
drop if state == "DADRA AND NAGAR HAVELI" | state == "DAMAN AND DIU" | state == "ANDAMAN AND NICOBAR ISLANDS" | state == "TELANGANA" | state == "LAKSHADWEEP" | state == "CHANDIGARH"

replace state = "JAMMU & KASHMIR" if state == "JAMMU AND KASHMIR"

replace district = "BARPETA" if state == "ASSAM" & district == "BAKSA"

replace district = "KABEERDHAM" if state == "CHHATTISGARH" & district == "KABIRDHAM"
replace district = "KORIYA" if state == "CHHATTISGARH" & district == "KOREA (KORIYA)"

replace district = "LAHUL & SPITI" if state == "HIMACHAL PRADESH" & district == "LAHUL AND SPITI"

replace district = "SENAPATI" if state == "MANIPUR" & district == "SENAPATI (EXCLUDING 3 SUB-DIVISIONS)"

replace district = "PUDUCHERRY" if state == "PUDUCHERRY" & (district == "MAHE" | district == "YANAM")

replace district = "SIDDHARTHNAGAR" if state == "UTTAR PRADESH" & district == "SIDDHARTH NAGAR"

tab state, gen(state_)

save "DHS/DHS.dta", replace