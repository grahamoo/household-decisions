cd "C:\Users\17819\Dropbox\capstone"

use "Data Owen/Elections/ECI excel files/raw_elections.dta", clear

*rename and order variables
gen state = upper(ST_NAME)
replace state = strtrim(state)
drop ST_NAME
gen district = upper(DIST_NAME)
replace district = strtrim(district)
drop DIST_NAME
gen ac = upper(AC_NAME)
replace ac = strtrim(ac)
replace CAND_NAME = strtrim(CAND_NAME)
drop AC_NAME
drop _merge
rename POSITION rank
rename TOTVOTPOLL cand_vote
rename YEAR year
rename MONTH month
order state district ac year CAND_NAME

*drop data without voting and candidate information
drop if CAND_SEX == "NULL"
drop if cand_vote == 0
*look at ac="thanjavur" year="2016", and ac="ARAVAKURICHI" year="2016"

*renaming
replace district = "WEST SIANG" if state == "ARUNACHAL PRADESH" & (district == "WEST SIANG (ALONG)" | district == "WEST SIANG (MECHUKA)" | district == "WEST SIANG(MECHUKA)")

replace district = "BONGAIGAON" if state == "ASSAM" & district == "BOGAIGAON"
replace district = "MANGALDOI" if state == "ASSAM" & district == "MANGALDOI (DARRANG)"
replace district = "DIMA HASAO" if state == "ASSAM" & district == "N. C. HILLS"
replace district = "SIVASAGAR" if state == "ASSAM" & district == "SIBSAGAR"

replace district = "BUXAR" if state == "BIHAR" & district == "BUXOR"
replace district = "PURVI CHAMPARAN" if state == "BIHAR" & district == "EAST CHAMPARAN"
replace district = "JEHANABAD" if state == "BIHAR" & district == "JAHANABAD"
replace district = "KAIMUR (BHABUA)" if state == "BIHAR" & district == "KAIMUR (BHABHUA)"
replace district = "PURNIA" if state == "BIHAR" & district == "PURNEA"
replace district = "PASCHIM CHAMPARAN" if state == "BIHAR" & district == "WEST CHAMPARAN"

replace district = "KISHTWAR" if state == "JAMMU & KASHMIR" & district == "DODA" & ac == "INDERWAL"
replace district = "RAMBAN" if state == "JAMMU & KASHMIR" & district == "DODA" & ac == "RAMBAN"

replace state = "CHHATTISGARH" if state == "CHANDIGARH" 

replace state = "DELHI" if state == "NCT OF DELHI"
replace district = "CENTRAL" if state == "DELHI" & ac == "RAJINDER NAGAR"
replace ac = "SEELAMPUR" if state == "DELHI" & district == "NORTH EAST" & ac == "SEELAM PUR"
replace ac = "SEEMA PURI" if state == "DELHI" & district == "NORTH EAST" & ac == "SEEMAPURI"
replace ac = "SULTANPUR MAJRA" if state == "DELHI" & district == "NORTH WEST" & ac == "SULTAN PUR MAJRA"

drop if state == "JHARKHAND" & district == "SAHEBGANJ" & ac == "PAKUR"

replace district = "JAINTIA HILLS" if state == "MEGHALAYA" & (district == "EAST JAINTIA HILLS" | district == "WEST JAINTIA HILLS")

replace district = "MAYURBHANJ" if state == "ODISHA" & (district == "MAYRABHANJA" | district == "MAYURABHANJA" )

replace state = "ODISHA" if state == "ORISSA"
replace district = "EAST DISTRICT" if state == "SIKKIM" & district == "EAST"
replace district = "WEST DISTRICT" if state == "SIKKIM" & district == "WEST"
replace district = "NORTH DISTRICT" if state == "SIKKIM" & district == "NORTH"
replace district = "SOUTH DISTRICT" if state == "SIKKIM" & district == "SOUTH"
replace district = "WEST DISTRICT" if state == "SIKKIM" & district == "SOUTH DISTRICT" & ac == "SALGHARI-ZOOM"
replace district = "SOUTH DISTRICT" if state == "SIKKIM" & district == "EAST DISTRICT" & ac == "TUMEN-LINGI"
replace district = "NORTH DISTRICT" if state == "SIKKIM" & district == "EAST DISTRICT" & ac == "KABI LUNGCHUK"

replace district = subinstr(district, "CC - ", "", .) if state == "TRIPURA"

drop if state == "UTTAR PRADESH" & district == "GHAZIABAD" & ac == "HAPUR"
drop if state == "UTTAR PRADESH" & district == "SULTANPUR" & ac == "JAGDISHPUR"
drop if state == "UTTAR PRADESH" & district == "MORADABAD" & ac == "CHANDAUSI"

replace district = "KOLKATA SOUTH" if state == "WEST BENGAL" & district == "KOLKATTA SOUTH"

replace district = "MALDA" if state == "WEST BENGAL" & district == "MALDAHA"


*seat reserved for Buddhist monastic society
drop if ac == "SANGHA" & state == "SIKKIM"
*look at SIKKIM acs where candidates are added in multiple districts

*state district renaming to match DHS
replace district = "Y.S.R." if state == "ANDHRA PRADESH" & district == "KADAPA"
replace district = "SRI POTTI SRIRAMULU NELLORE" if state == "ANDHRA PRADESH" & district == "NELLORE"

replace district = "PAPUMPARE" if state == "ARUNACHAL PRADESH" & district == "PAPUM PARE"

replace district = "CACHAR" if state == "ASSAM" & district == "SILCHAR"
replace district = "CHIRANG" if state=="ASSAM" & district=="BIJNI"
replace district = "DARRANG" if state == "ASSAM" & district == "MANGALDOI"
replace district = "KAMRUP METROPOLITAN" if state == "ASSAM" & district == "KAMRUP METRO"
replace district = "KARBI ANGLONG" if state == "ASSAM" & district == "DIPHU"
replace district = "SONITPUR" if state == "ASSAM" & district == "TEZPUR"

replace district = "PASHCHIM CHAMPARAN" if state == "BIHAR" & district == "PASCHIM CHAMPARAN"
replace district = "PURBA CHAMPARAN" if state == "BIHAR" & district == "PURVI CHAMPARAN"

replace district = "DAKSHIN BASTAR DANTEWADA" if state == "CHHATTISGARH" & district == "DANTEWADA"
replace district = "JANJGIR - CHAMPA" if state == "CHHATTISGARH" & district == "JANJGIR-CHAMPA"
replace district = "KABEERDHAM" if state == "CHHATTISGARH" & district == "KABIRDHAM"
replace district = "UTTAR BASTAR KANKER" if state == "CHHATTISGARH" & district == "KANKER"

replace district = "AHMADABAD" if state == "GUJARAT" & district == "AHMEDABAD"
replace district = "DOHAD" if state == "GUJARAT" & district == "DAHOD"
replace district = "THE DANGS" if state == "GUJARAT" & district == "DANGS"

replace district = "LAHUL & SPITI" if state == "HIMACHAL PRADESH" & district == "LAHAUL & SPITI"
replace district = "SIRMAUR" if state == "HIMACHAL PRADESH" & district == "SIRMOUR"

replace district = "BADGAM" if state == "JAMMU & KASHMIR" & district == "BUDGAM"
replace district = "BANDIPORE" if state == "JAMMU & KASHMIR" & district == "BANDIPUR"
replace district = "BARAMULA" if state == "JAMMU & KASHMIR" & district == "BARAMULLA"
replace district = "PUNCH" if state == "JAMMU & KASHMIR" & district == "POONCH"
replace district = "RAJOURI" if state == "JAMMU & KASHMIR" & district == "RAJAURI"
replace district = "SHUPIYAN" if state == "JAMMU & KASHMIR" & district == "SHOPIAN"

replace district = "PASHCHIMI SINGHBHUM" if state == "JHARKHAND" & district == "WEST SINGHBHUM"
replace district = "PURBI SINGHBHUM" if state == "JHARKHAND" & district == "EAST SINGHBHUM"
replace district = "SAHIBGANJ" if state == "JHARKHAND" & district == "SAHEBGANJ"
replace district = "SARAIKELA KHARSAWAN" if state == "JHARKHAND" & district == "SARAIKELA- KHARSWAN"

replace district = "BANGALORE" if state == "KARNATAKA" & (district == "B.B.M.P(CENTRAL)" | district == "B.B.M.P(NORTH)" | district == "B.B.M.P(SOUTH)" | district == "BANGALORE URBAN")
replace district = "CHAMARAJANAGAR" if state == "KARNATAKA" & district == "CHAMARAJNAGAR"
replace district = "CHIKKABALLAPURA" if state == "KARNATAKA" & district == "CHIKKABALLAPUR"
replace district = "DAVANAGERE" if state == "KARNATAKA" & district == "DAVANGERE"
replace district = "RAMANAGARA" if state == "KARNATAKA" & district == "RAMANAGARAM"

replace district = "ASHOKNAGAR" if state == "MADHYA PRADESH" & district == "ASHOK NAGAR"
replace district = "BARWANI" if state == "MADHYA PRADESH" & district == "BADWANI"
replace district = "KHANDWA (EAST NIMAR)" if state == "MADHYA PRADESH" & district == "KHANDWA"
replace district = "KHARGONE (WEST NIMAR)" if state == "MADHYA PRADESH" & district == "KHARGONE"
replace district = "MANDSAUR" if state == "MADHYA PRADESH" & district == "MANDSOUR"
replace district = "NARSIMHAPUR" if state == "MADHYA PRADESH" & district == "NARSINGPUR"

replace district = "AHMADNAGAR" if state == "MAHARASHTRA" & district == "AHMEDNAGAR"
replace district = "BID" if state == "MAHARASHTRA" & district == "BEED"
replace district = "BULDANA" if state == "MAHARASHTRA" & district == "BULDHANA"
replace district = "MUMBAI" if state == "MAHARASHTRA" & district == "MUMBAI CITY"
replace district = "NANDURBAR" if state == "MAHARASHTRA" & district == "NANDURABAR"
replace district = "RAIGARH" if state == "MAHARASHTRA" & district == "RAIGAD"
replace district = "THANE" if state == "MAHARASHTRA" & district == "PALGHAR"

replace district = "RIBHOI" if state == "MEGHALAYA" & district == "RI BHOI"

replace district = "ANUGUL" if state == "ODISHA" & district == "ANGUL"
replace district = "BALANGIR" if state == "ODISHA" & district == "BOLANGIR"
replace district = "BALESHWAR" if state == "ODISHA" & district == "BALASORE"
replace district = "BARGARH" if state == "ODISHA" & district == "BARAGARH"
replace district = "BAUDH" if state == "ODISHA" & district == "BOUDH"
replace district = "DEBAGARH" if state == "ODISHA"& district == "DEOGARH"
replace district = "JAGATSINGHAPUR" if state == "ODISHA" & district == "JAGATSINGHPUR"
replace district = "JAJAPUR" if state == "ODISHA" & district == "JAJPUR"
replace district = "KENDRAPARA" if state == "ODISHA" & district == "KENDARAPARA"
replace district = "KENDUJHAR" if state == "ODISHA" & district == "KEONJHAR"
replace district = "KHORDHA" if state == "ODISHA" & district == "KHURDA"
replace district = "NABARANGAPUR" if state == "ODISHA" & district == "NOWRANGPUR"
replace district = "SUBARNAPUR" if state == "ODISHA" & district == "SUBARANAPUR"

replace district = "GURDASPUR" if state == "PUNJAB" & district == "PATHANKOT"
replace district = "FIROZPUR" if state == "PUNJAB" & district == "FAZILKA"
replace district = "SAHIBZADA AJIT SINGH NAGAR" if state == "PUNJAB" & district == "SHAHIBZADA AJIT SINGH NAGAR"
replace district = "TARN TARAN" if state == "PUNJAB" & district == "TARNTARAN"

replace district = "CHITTAURGARH" if state == "RAJASTHAN" & district == "CHITTORGARH"
replace district = "DHAULPUR" if state == "RAJASTHAN" & district == "DHOLPUR"
replace district = "JALOR" if state == "RAJASTHAN" & district == "JALORE"
replace district = "JHUNJHUNUN" if state == "RAJASTHAN" & district == "JHUNJHUNU"

replace district = "NORTH  DISTRICT" if state == "SIKKIM" & district == "NORTH DISTRICT"

replace district = "THIRUVALLUR" if state == "TAMIL NADU" & district == "TIRUVALLUR"
replace district = "THOOTHUKKUDI" if state == "TAMIL NADU" & district == "THOOTHUKUDI"
replace district = "VILUPPURAM" if state == "TAMIL NADU" & district == "VILLUPURAM"

replace district = "SOUTH TRIPURA" if state=="TRIPURA" & district=="GOMATI"
replace district = "WEST TRIPURA" if state=="TRIPURA" & district=="KHOWAI"
replace district = "WEST TRIPURA" if state=="TRIPURA" & district=="SEPAHIJALA"
replace district = "NORTH TRIPURA" if state=="TRIPURA" & district=="UNAKOTI"

replace district = "BAHRAICH" if state == "UTTAR PRADESH" & district == "BAHARAICH"
replace district = "BARA BANKI" if state == "UTTAR PRADESH" & district == "BARABANKI"
replace district = "BULANDSHAHR" if state == "UTTAR PRADESH" & district == "BULANDSAHAR"
replace district = "KANPUR DEHAT" if state == "UTTAR PRADESH" & district == "RAMABAI NAGAR"
replace district = "MAHRAJGANJ" if state == "UTTAR PRADESH" & district == "MAHARAJGANJ"
replace district = "MAINPURI" if state == "UTTAR PRADESH" & district == "MANPURI"
replace district = "SANT RAVIDAS NAGAR (BHADOHI)" if state == "UTTAR PRADESH" & district == "SANT RAVIDAS NAGAR"

replace district = "GARHWAL" if state == "UTTARAKHAND" & district == "PAURI GARHWAL"
replace district = "UDHAM SINGH NAGAR" if state == "UTTARAKHAND" & district == "UDHAMSINGH NAGAR"

replace district = "BARDDHAMAN" if state == "WEST BENGAL" & district == "BARDHAMAN"
replace district = "DARJILING" if state == "WEST BENGAL" & district == "DARJEELING"
replace district = "HAORA" if state == "WEST BENGAL" & district == "HOWRAH"
replace district = "HUGLI" if state == "WEST BENGAL" & district == "HOOGHLY"
replace district = "KOCH BIHAR" if state == "WEST BENGAL" & district == "COOCHBEHAR"
replace district = "KOLKATA" if state == "WEST BENGAL" & (district == "KOLKATA SOUTH" | district == "KOLKATA NORTH")
replace district = "MALDAH" if state == "WEST BENGAL" & district == "MALDA"
replace district = "NORTH TWENTY FOUR PARGANAS" if state == "WEST BENGAL" & district == "NORTH 24-PARGANAS"
replace district = "PASCHIM MEDINIPUR" if state == "WEST BENGAL" & district == "PASHCHIM MEDINIPUR"
replace district = "PURBA MEDINIPUR" if state == "WEST BENGAL" & district == "PURBO MEDINIPUR"
replace district = "PURULIYA" if state == "WEST BENGAL" & district == "PURULIA"
replace district = "SOUTH TWENTY FOUR PARGANAS" if state == "WEST BENGAL" & district == "SOUTH 24-PARGANAS"

*generate match variable
duplicates tag state district ac, gen(match_var)

*generate candidate gender variables 
gen female = (CAND_SEX == "F")
sort state district ac year month
by state district ac year month: egen x = total(female)
tab x

gen ff=(x==2)
gen mm=(x==0)
gen mf=(x==1)

drop x

label var ff "both winner and runnerup female"
label var mm "both winner and runnerup male"
label var mf "mix gender winner and runner up"

gen x = 0
replace x = 1 if female == 1 & rank == 1
sort state district ac year month
by state district ac year month: egen win_f = total(x)

drop x
label var win_f "female winner"

*generate number of seats per district
gen x=(rank==1)
sort state district year
by state district year: egen totseats_dist = total(x)
drop x
label var totseats_dist "total number of seats for district in election year"

*generate variables for margin of victory, need to decide numeric value
*Clots-Figueras (2011) uses .035 or below

sort state district ac year month
by state district ac year month: egen winner_vote = max(cand_vote)
label var winner_vote "no. of votes for winner"

sort state district ac year month
by state district ac year month: egen runnerup_vote = min(cand_vote)
label var runnerup_vote "no. of votes for runner up"

gen abs_marg = winner_vote-runnerup_vote
gen marg = abs_marg/TOT_VOTERS
label var marg "margin of victory"

tempfile main
save `main'

***Save file for each bandwidth
foreach h of numlist 1(0.5)4 {
use `main', clear

*generate close election conditions (need to figure out how to find the optimal margin)
gen bandwidth = `h' / 100
gen close=(marg<=bandwidth)
gen close_mf=(close==1 & mf==1)
gen close_mf_winf=(close==1 & mf==1 & win_f==1)

label var close "margin of victor `h'% or less"
label var close_mf "margin of victor `h'% or less in m-f election"
label var close_mf_winf "margin of victor `h'% or less in m-f election where f wins"

duplicates tag state ac year CAND_NAME, generate(duplic)


save "Data Owen/Elections/ECI excel files/clean_elections_`h'.dta", replace
}