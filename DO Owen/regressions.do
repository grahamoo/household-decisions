cd "C:\Users\graha\Dropbox\capstone\Data Owen"

use "districts.dta", clear


*exlude children with illness at birth

**temporary sample conditions
*drop if age_ch < 6

gen election_gap = v007 - year
gen child_age_gap = age_ch/12

*keep if election_gap >= (child_age_gap)

*generate exposure variable
gen time_exposure = election_gap / child_age_gap
replace time_exposure = 1 if time_exposure > 1

*generate variables that measure overall malnourishment
gen z_malnourished = (underweight_ch + wasted_ch + stunted_ch)/4
gen z_severe_malnourished = (severe_underweight_ch + severe_wasted_ch + severe_stunted_ch)/4

*generate globals used in regression
global margin1 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10
global margin2 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102
global margin3 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102 marg13 marg23 marg33 marg43 marg53 marg63 marg73 marg83 marg93 marg103

global mother_controls children_living respondent_sc respondent_st respondent_obc literate educationyears_respondent   respondent_age underweight_respondent respondent_jobless

global child_controls age_ch birth_weight birth_order twin breastfeed_months pregnancy_duration antenatal_visit

global household_controls rural house_electricity husband_jobless hindu muslim christian sikh buddhist female_head v202 v203

global dist_controls tot_employmentTotal tot_agriculture_workerTotal f_household_workerTotal f_literateTotal tot_cultivatorsTotal

global wealth_dummies wealth_1 wealth_2 wealth_3 wealth_4 wealth_5

global se "cluster(district)"

gen year_1 = (age_ch >= 0 & age_ch <= 12)
gen year_2 = (age_ch >= 13 & age_ch <= 24)
gen year_3 = (age_ch >= 25 & age_ch <= 36)
gen year_4 = (age_ch >= 37 & age_ch <= 48)
gen year_5 = (age_ch >= 49 & age_ch <= 60)

**initial regressions

*do regressions by age groups

*local varlist "year_1 year_2 year_3 year_4 year_5"
drop state_code

ivreg2 female_ch (frac_f = frac_close_winf) frac_close $margin3 state_* $mother_controls $child_controls $household_controls $dist_controls $wealth_dummies if time_exposure >.75, $se

*possible endogenous variables: n_children5under wealth_dummies, appliance variables

*if time_exposure <=.25 & time_exposure >= 0
/*
reg underweight_ch frac_f children_ever children_living bmi_respondent respondent_sc respondent_st respondent_obc respondent_jobless literate educationlevel_respondent livingwithhusband multiple_wives female_ch age_ch birth_weight birth_order twin breastfeed_months birth_interval recent_diarrhea recent_fever current_fever_cough pregnancy_duration bcg_vaccine dpt_vaccine polio_vaccine measles_vaccine birth_iron antenatal_visit rural house_electricity refrigerator health_insurance bank_account mobile_phone husband_jobless husband_agriculture no_housewater flush_toilet landline news_read radio_listen tv_watch automotive hindu muslim christian sikh buddhist female_head wealth_index n_children5under household_size TOT_PTotal tot_employmentTotal f_employmentTotal tot_agriculture_workerTotal f_household_workerTotal f_literateTotal m_literateTotal tot_employmentRural frac_pop_rural frac_pop_urban f_percentage_districtTotal sc_st_rateTotal fm_ratio total_primary total_secondary total_college paved_roads power_all educationlevel_husband

*generate endogenous and iv variables
/*to do this, i need to figure out how to evaluate which initial variables
are relevant to create endogenous and iv variables from.*/

