cd "C:\Users\graha\Dropbox\capstone\Data Owen"

use "DHS/DHS.dta", clear

*merge election data
merge m:1 state district using "Elections/election_district.dta"

rename _merge _merge_elections

drop if _merge_elections == 2 

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






*preliminary regression model
/*
logit underweight female_ch age_ch rural TOT_PTotal tot_employmentTotal f_employmentTotal tot_agriculture_workerTotal f_household_workerTotal f_literateTotal m_literateTotal tot_employmentRural frac_pop_rural f_percentage_districtTotal sc_st_rateTotal fm_ratio v730 v012 children_ever children_living breastfeed_months house_electricity refrigerator birth_weight health_insurance bank_account mobile_phone bmi_respondent respondent_sc respondent_st respondent_obc husband_jobless husband_agriculture respondent_jobless no_housewater flush_toilet landline news_read radio_listen tv_watch automotive hindu muslim christian sikh buddhist literate female_head wealth_index twin n_children5under birth_order household_size birth_interval recent_diarrhea recent_fever current_fever_cough educationlevel_respondent educationlevel_husband pregnancy_duration bcg_vaccine dpt_vaccine polio_vaccine measles_vaccine livingwithhusband multiple_wives birth_iron antenatal_visit stool_notdisposed total_primary total_secondary total_college paved_roads power_all
*/


save "districts.dta", replace