cd "C:\Users\graha\Dropbox\capstone\Data Owen\SHRUG"

use "shrug_ancillary.dta", clear


*merge name data with pc11 data
merge 1:1 shrid using "SHRUG pc11.dta"
drop _merge

/*
 Result                      Number of obs
    -----------------------------------------
    Not matched                            19
        from master                         0  (_merge==1)
        from using                         19  (_merge==2)

    Matched                           590,855  (_merge==3)
    -----------------------------------------
*/



*merge with shrug names last
merge 1:1 shrid using "shrug_names.dta"

/*
     Result                      Number of obs
    -----------------------------------------
    Not matched                        51,175
        from master                         0  (_merge==1)
        from using                     51,175  (_merge==2)

    Matched                           590,874  (_merge==3)
    -----------------------------------------
*/

*manipulate variables
rename state_name state
replace state = upper(state)
replace state = strtrim(state)
rename district_name district
replace district = upper(district)
replace district = strtrim(district)


*create aggregate variables by district: either mean or sum
*mean energy data, sum school data

sort state district
by state district: egen total_primary = total(pc11_vd_p_sch)
label var total_primary "No. of primary schools in district"

sort state district
by state district: egen total_middle = total(pc11_vd_m_sch)
label var total_middle "No. of middle schools in district"

sort state district
by state district: egen total_secondary = total(pc11_vd_s_sch)
label var total_secondary "No. of secondary schools in district"

sort state district
by state district: egen total_senior = total(pc11_vd_s_s_sch)
label var total_senior "No. of senior secondary schools in district"

sort state district
by state district: egen total_college = total(pc11_vd_college)
label var total_college "No. of colleges in district"

*paved roads
sort state district
by state district: egen paved_roads = mean(pc11_vd_tar_road)
label var paved_roads "Percent of places with paved roads"

*power supply

sort state district
by state district: egen power_summer = mean(pc11_vd_power_all_sum)
label var power_summer "avg. power supply (hrs/day) for summer in district"

sort state district
by state district: egen power_winter = mean(pc11_vd_power_all_win)
label var power_winter "avg. power supply (hrs/day) for winter in district"

sort state district
by state district: egen power_all = mean(pc11_vd_power_all)
label var power_all "Percentage of places with power supply in district"


*create individual observations for district
duplicates drop state district, force

*keep district level variables
keep state district total_primary total_middle total_secondary total_senior total_college paved_roads power_summer power_winter power_all

*state and district renaming
drop if state == "ANDAMAN NICOBAR ISLANDS" | state == "DADRA NAGAR HAVELI" | state == "DAMAN DIU" | state == "LAKSHADWEEP" | state == "ORISSA"

replace state = "DELHI" if state == "NCT OF DELHI"
replace state = "JAMMU & KASHMIR" if state == "JAMMU KASHMIR"

replace district = "Y.S.R." if state == "ANDHRA PRADESH" & district == "YSR KADAPA"

replace district = "PAPUMPARE" if state == "ARUNACHAL PRADESH" & district == "PAPUM PARE"

replace district = "KAIMUR (BHABUA)" if state == "BIHAR" & district == "KAIMUR BHABUA"

replace district = "JANJGIR - CHAMPA" if state == "CHHATTISGARH" & district == "JANJGIR CHAMPA"

replace district = "BANASKANTHA" if state == "GUJARAT" & district == "BANAS KANTHA"
replace district = "PANCHMAHAL" if state == "GUJARAT" & district == "PANCH MAHALS"
replace district = "SABARKANTHA" if state == "GUJARAT" & district == "SABAR KANTHA"
replace district = "SABARKANTHA" if state == "GUJARAT" & district == "SABAR KANTHA"

replace district = "LAHUL & SPITI" if state == "HIMACHAL PRADESH" & district == "LAHUL SPITI"

replace district = "LEH" if state == "JAMMU & KASHMIR" & district == "LEH LADAKH"

replace district = "KHANDWA (EAST NIMAR)" if state == "MADHYA PRADESH" & district == "EAST NIMAR"
replace district = "KHARGONE (WEST NIMAR)" if state == "MADHYA PRADESH" & district == "WEST NIMAR"

replace district = "NORTH  DISTRICT" if state == "SIKKIM" & district == "NORTH DISTRICT"

replace district = "SANT RAVIDAS NAGAR (BHADOHI)" if state == "UTTAR PRADESH" & district == "SANT RAVIDAS NAGAR BHADOHI"


save "SHRUG merge Owen.dta", replace