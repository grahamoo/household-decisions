cd "C:\Users\17819\Dropbox\capstone\Data Owen\Elections\ECI excel files"


*import candidate files for each election file
import excel using "AE_2008", firstrow sheet("cand_wise") clear
drop if POSITION != 1 & POSITION != 2
tempfile AE_2008
save "`AE_2008'"

import excel using "AE2009_8913", cellrange(B1:P11549) firstrow sheet("cand_wise") clear
drop if POSITION != 1 & POSITION != 2
tempfile AE_2009
save "`AE_2009'"

import excel using "AE 2010", firstrow sheet("cand_wise") clear
drop if POSITION != 1 & POSITION != 2
tempfile AE_2010
save "`AE_2010'"

import excel using "AE2011", firstrow sheet("CAND_WISE") clear
drop if POSITION != 1 & POSITION != 2
tempfile AE_2011
save "`AE_2011'"

import excel using "AE2012_8913", firstrow sheet("cand_wise") clear

*sort candidates where ac is listed in two districts based on district-ac match in wikipedia
replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Bheem Nagar" & CAND_NAME == "AQEEL UR REHMAN KHAN"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Moradabad" & AC_NAME == "Asmoli"

replace POSITION = 1 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Moradabad" & CAND_NAME == "MHD.IRFAN"
replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Moradabad" & CAND_NAME == "LAKHAN SINGH SAINI"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Bheem Nagar" & AC_NAME == "Bilari"

replace POSITION = 1 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Bheem Nagar" & CAND_NAME == "LAXMI GAUTAM"
replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Bheem Nagar" & CAND_NAME == "GULAB DEVI"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Moradabad" & AC_NAME == "Chandausi"

replace POSITION = 1 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Ghaziabad" & CAND_NAME == "DHARMESH SINGH TOMAR"
replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Ghaziabad" & CAND_NAME == "ASLAM"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Panchsheel Nagar" & AC_NAME == "Dholana"

replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Panchsheel Nagar" & CAND_NAME == "FARHAT HASAN"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Ghaziabad" & AC_NAME == "Garhmukteshwar"

replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Bheem Nagar" & CAND_NAME == "AJIT KUMAR URF RAJU YADAV"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Budaun" & AC_NAME == "Gunnaur"

replace POSITION = 1 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Panchsheel Nagar" & CAND_NAME == "GAJRAJ SINGH"
replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Panchsheel Nagar" & CAND_NAME == "DHARAMPAL SINGH"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Ghaziabad" & AC_NAME == "Hapur"

replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Chhatrapati Shahuji Maharaj Na" & CAND_NAME == "VIJAY KUMAR" & AC_NAME == "Jagdishpur"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Sultanpur" & AC_NAME == "Jagdishpur"

replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Prabuddha Nagar" & CAND_NAME == "ANWAR HASAN" & AC_NAME == "Kairana"
replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Prabuddha Nagar" & CAND_NAME == "VIJAY KUMAR" & AC_NAME == "Kairana"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Muzaffarnagar" & AC_NAME == "Kairana"

replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Faizabad" & CAND_NAME == "ABBAS ALI ZAIDI ALIAS RUSHDI MIYAN" & AC_NAME == "Rudauli"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Barabanki" & AC_NAME == "Rudauli"

replace POSITION = 1 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Bheem Nagar" & AC_NAME == "Sambhal" & CAND_NAME == "IQBAL MEHMOOD"
replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Bheem Nagar" & AC_NAME == "Sambhal" & CAND_NAME == "RAJESH SINGHAL"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Moradabad" & AC_NAME == "Sambhal"

replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Prabuddha Nagar" & CAND_NAME == "VIRENDRA SINGH" & AC_NAME == "Shamli"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Muzaffarnagar" & AC_NAME == "Shamli"

replace POSITION = 2 if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Prabuddha Nagar" & CAND_NAME == "ASHRAF ALI KHAN" & AC_NAME == "Thana Bhawan"
drop if ST_NAME == "Uttar Pradesh" & DIST_NAME == "Muzaffarnagar" & AC_NAME == "Thana Bhawan"

drop if POSITION != 1 & POSITION != 2
tempfile AE_2012
save "`AE_2012'"

import excel using "LA 2013", firstrow sheet("Candidates") clear
drop if POSITION != 1 & POSITION != 2
tempfile LA_2013
save "`LA_2013'"

import excel using "MAY 2014 LA election", firstrow sheet("Candidates") clear

replace POSITION = 1 if ST_NAME == "Sikkim" & DIST_NAME == "NORTH DISTRICT" & CAND_NAME == "UGEN NEDUP BHUTIA"
replace POSITION = 2 if ST_NAME == "Sikkim" & DIST_NAME == "NORTH DISTRICT" & CAND_NAME == "THENLAY TSHERING BHUTIA"
drop if ST_NAME == "Sikkim" & DIST_NAME == "EAST DISTRICT" & AC_NAME == "Kabi lungchuk"

replace POSITION = 1 if ST_NAME == "Sikkim" & DIST_NAME == "WEST DISTRICT" & CAND_NAME == "ARJUN KUMAR GHATANI"
replace POSITION = 2 if ST_NAME == "Sikkim" & DIST_NAME == "WEST DISTRICT" & CAND_NAME == "BHANU PRATAP RASAILY"
drop if ST_NAME == "Sikkim" & DIST_NAME == "SOUTH DISTRICT" & AC_NAME == "Salghari-zoom"

replace POSITION = 2 if ST_NAME == "Sikkim" & DIST_NAME == "SOUTH DISTRICT" & CAND_NAME == "NIDUP TSHERING LEPCHA"
drop if ST_NAME == "Sikkim" & DIST_NAME == "EAST DISTRICT" & AC_NAME == "Tumen-lingi"


drop if POSITION != 1 & POSITION != 2
tempfile MAY_2014
save "`MAY_2014'"

import excel using "OCTOBER 2014 LA election", firstrow sheet("Candidates") clear
drop if POSITION != 1 & POSITION != 2
tempfile OCT_2014
save "`OCT_2014'"

import excel using "DECEMBER 2014 LA election", firstrow sheet("Candidates") clear

*sort candidates where ac is listed in two districts based on district-ac match in wikipedia

replace POSITION = 1 if ST_NAME == "Jammu & Kashmir" & DIST_NAME == "KISHTWAR" & CAND_NAME == "NEELAM KUMAR LANGEH"
replace POSITION = 2 if ST_NAME == "Jammu & Kashmir" & DIST_NAME == "KISHTWAR" & CAND_NAME == "DR. CHAMAN LAL"
drop if ST_NAME == "Jammu & Kashmir" & DIST_NAME == "DODA" & AC_NAME == "Inderwal"

replace POSITION = 1 if ST_NAME == "Jammu & Kashmir" & DIST_NAME == "RAMBAN" & CAND_NAME == "GHULAM MOHD SAROORI"
replace POSITION = 2 if ST_NAME == "Jammu & Kashmir" & DIST_NAME == "RAMBAN" & CAND_NAME == "TARIQ HUSSAIN KEEN"
drop if ST_NAME == "Jammu & Kashmir" & DIST_NAME == "DODA" & AC_NAME == "Ramban"


replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Giridih" & CAND_NAME == "LALCHAND MAHTO"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Bokaro" & AC_NAME == "Dumri"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Giridih" & CAND_NAME == "NAGENDRA MAHTO"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Giridih" & CAND_NAME == "VINOD KUMAR SINGH"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Hazaribagh" & AC_NAME == "Bagodar"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Sahebganj" & CAND_NAME == "HEMLAL MURMU"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Godda" & AC_NAME == "Barhait"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Sahebganj" & CAND_NAME == "LOBIN HEMBROM"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Godda" & AC_NAME == "Borio"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Ramgarh" & CAND_NAME == "NIRMALA DEVI"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Ramgarh" & CAND_NAME == "ROSHAN LAL CHAUDHARY"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Hazaribagh" & AC_NAME == "Barkagaon"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Hazaribagh" & CAND_NAME == "KUMAR MAHESH SINGH"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Ramgarh" & AC_NAME == "Mandu"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Hazaribagh" & CAND_NAME == "MANOJ KUMAR YADAV"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Hazaribagh" & CAND_NAME == "UMASHANKAR AKELA"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Kodarma" & AC_NAME == "Barhi"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Hazaribagh" & CAND_NAME == "JANKI PRASAD YADAV"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Hazaribagh" & CAND_NAME == "AMIT KUMAR YADAV"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Kodarma" & AC_NAME == "Barkatha"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Palamu" & CAND_NAME == "ANJU SINGH"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Garhwa" & AC_NAME == "Bishrampur"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Gumla" & CAND_NAME == "SAMIR ORAON"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Lohardaga" & AC_NAME == "Bishunpur"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Dumka" & CAND_NAME == "HARI NARAYAN RAY"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Deoghar" & AC_NAME == "Jarmundi"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Saraikela- Kharswan" & CAND_NAME == "ARJUN MUNDA"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "West Singhbhum" & AC_NAME == "Kharasawan"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Pakur" & CAND_NAME == "SIMON MARANDI"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Dumka" & AC_NAME == "Littipara"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Latehar" & CAND_NAME == "RAMCHANDRA SINGH"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Palamu" & AC_NAME == "Manika"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Pakur" & CAND_NAME == "ALAMGIR ALAM"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Pakur" & CAND_NAME == "AKIL AKHTAR"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Sahebganj" & AC_NAME == "Pakur"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Godda" & CAND_NAME == "PRADIP YADAV"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Godda" & CAND_NAME == "DEVENDRANATH SINGH"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Dumka" & AC_NAME == "Poreyahat"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Deoghar" & CAND_NAME == "RANDHIR KUMAR SINGH"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Deoghar" & CAND_NAME == "UDAY SHANKAR SINGH"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Jamtara" & AC_NAME == "Sarath"

replace POSITION = 1 if ST_NAME == "Jharkhand" & DIST_NAME == "Simdega" & CAND_NAME == "VIMLA PRADHAN"
replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Simdega" & CAND_NAME == "MENON EKKA"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Gumla" & AC_NAME == "Simdega"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Ranchi" & CAND_NAME == "GOPAL KRISHNA PATAR"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Khunti" & AC_NAME == "Tamar"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Khunti" & CAND_NAME == "KOCHE MUNDA"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Simdega" & AC_NAME == "Torpa"

replace POSITION = 2 if ST_NAME == "Jharkhand" & DIST_NAME == "Palamu" & CAND_NAME == "KRISHNA NAND TRIPATHI"
drop if ST_NAME == "Jharkhand" & DIST_NAME == "Garhwa" & AC_NAME == "Daltonganj"


drop if POSITION != 1 & POSITION != 2
tempfile DEC_2014
save "`DEC_2014'"

import excel using "FEBRUARY- 2015 LA election", firstrow sheet("Candidates") clear
drop if POSITION != 1 & POSITION != 2
tempfile FEB_2015
save "`FEB_2015'"

import excel using "LA (Nov) 2015", firstrow sheet("CANDIDATES") clear
drop if POSITION != 1 & POSITION != 2
tempfile NOV_2015
save "`NOV_2015'"

import excel using "LA 2016", firstrow sheet("Candidates") clear
drop if POSITION != 1 & POSITION != 2
tempfile LA_2016
save "`LA_2016'"

*import elector files for each election file
import excel using "AE_2008", firstrow sheet("electors") clear
tempfile electors_2008
save "`electors_2008'"

import excel using "AE2009_8913", firstrow sheet("electors") clear
tempfile electors_2009
save "`electors_2009'"

import excel using "AE 2010", firstrow sheet("electors") clear
tempfile electors_2010
save "`electors_2010'"

import excel using "AE2011", firstrow sheet("ELECTORS") clear
tempfile electors_2011
save "`electors_2011'"

import excel using "AE2012_8913", firstrow sheet("electors") clear
tempfile electors_2012
save "`electors_2012'"

import excel using "LA 2013", firstrow sheet("Elelctors") clear
tempfile electors_2013
save "`electors_2013'"

import excel using "MAY 2014 LA election", cellrange(A1:I534) firstrow sheet("Electors") clear
tempfile electors_MAY2014
save "`electors_MAY2014'"

import excel using "OCTOBER 2014 LA election", firstrow sheet("Electors") clear
tempfile electors_OCT2014
save "`electors_OCT2014'"

import excel using "DECEMBER 2014 LA election", firstrow sheet("Electors") clear
tempfile electors_DEC2014
save "`electors_DEC2014'"

import excel using "FEBRUARY- 2015 LA election", firstrow sheet("Electors") clear
tempfile electors_FEB2015
save "`electors_FEB2015'"

import excel using "LA (Nov) 2015", cellrange(A1:I244) firstrow sheet("ELECTORS") clear
tempfile electors_NOV2015
save "`electors_NOV2015'"

import excel using "LA 2016", firstrow sheet("Electors") clear
tempfile electors_2016
save "`electors_2016'"



*merge candidate and elector files
use "`electors_2008'"
merge 1:m ST_CODE AC_NO using "`AE_2008'"
drop if _merge==1
drop P
destring TOTVOTPOLL, replace
destring CAND_AGE, replace
recast byte POSITION
tempfile t_2008
save "`t_2008'"

use "`electors_2009'"
merge 1:m ST_CODE AC_NO using "`AE_2009'"
destring CAND_AGE, replace
tempfile t_2009
save "`t_2009'"

use "`electors_2010'"
merge 1:m AC_NO using "`AE_2010'"
tempfile t_2010
save "`t_2010'"

use "`electors_2011'"
merge 1:m ST_CODE AC_NO using "`AE_2011'"
drop STATE
drop ACNAME
rename TOTELECTORS TOT_ELECTORS
rename TOTVOTERS TOT_VOTERS
rename POLLPERCENT POLL_PERCENT
tempfile t_2011
save "`t_2011'"

use "`electors_2012'"
merge 1:m ST_CODE AC_NO using "`AE_2012'"
tempfile t_2012
save "`t_2012'"

use "`electors_2013'"
merge 1:m ST_CODE AC_NO using "`LA_2013'"
drop STATE
drop ASSEMBLYCONSTITUENCY
rename TOTALVOTESPOLLED TOT_VOTERS
rename TOTALELECTORS TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename PARTYAbbreviation PARTYABBRE
rename Totalvalidvotespolled TOTVOTPOLL
tempfile t_2013
save "`t_2013'"

use "`electors_MAY2014'"
merge 1:m ST_CODE AC_NO using "`MAY_2014'"
drop STATE
drop ASSEMBLYCONSTITUENCY
rename TOTALVOTESPOLLED TOT_VOTERS
rename TOTALELECTORS TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename TVTSPOL_IC TOTVOTPOLL
destring CAND_AGE, replace force
tempfile t_MAY2014
save "`t_MAY2014'"

use "`electors_OCT2014'"
merge 1:m ST_CODE AC_NO using "`OCT_2014'"
drop STATE
drop ASSEMBLYCONSTITUENCY
rename TOTALVOTESPOLLED TOT_VOTERS
rename TOTALELECTORS TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename TVTSPOL_IC TOTVOTPOLL
destring CAND_AGE, replace
tempfile t_OCT2014
save "`t_OCT2014'"

use "`electors_DEC2014'"
merge 1:m ST_CODE AC_NO using "`DEC_2014'"
drop STATE
drop ASSEMBLYCONSTITUENCY
rename TOTALVOTESPOLLED TOT_VOTERS
rename TOTALELECTORS TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename TVTSPOL_IC TOTVOTPOLL
destring CAND_AGE, replace
tempfile t_DEC2014
save "`t_DEC2014'"

use "`electors_FEB2015'"
merge 1:m ST_CODE AC_NO using "`FEB_2015'"
drop STATE
drop ASSEMBLYCONSTITUENCY
drop P
drop Q
drop R
drop S
drop T
drop U
drop V
drop W
rename TOTALVOTESPOLLED TOT_VOTERS
rename TOTALELECTORS TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename TVTSPOL_IC TOTVOTPOLL
destring CAND_AGE, replace
tempfile t_FEB2015
save "`t_FEB2015'"

use "`electors_NOV2015'"
merge 1:m ST_CODE AC_NO using "`NOV_2015'"
rename TOTALVOTESPOLLED TOT_VOTERS
rename TotalElectors TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename TOTALVALIDVOTESPOLLED TOTVOTPOLL
destring CAND_AGE, replace
tempfile t_NOV2015
save "`t_NOV2015'"

use "`electors_2016'"
merge 1:m ST_CODE AC_NO using "`LA_2016'"
rename TOTALVOTESPOLLED TOT_VOTERS
rename TotalElectors TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename TOTALVALIDVOTESPOLLED TOTVOTPOLL
destring TOT_VOTERS, replace force
destring TOT_ELECTORS, replace force
destring POLL_PERCENT, replace force
destring CAND_AGE, replace
destring TOTVOTPOLL, replace force
tempfile t_2016
save "`t_2016'"


*append tempfiles
use "`t_2008'"
append using "`t_2009'", force
append using "`t_2010'", force
append using "`t_2011'", force
append using "`t_2012'", force
append using "`t_2013'", force
*December 2013 .dta file is created in "missing district names.do"
append using "t_DEC2013.dta", force
append using "`t_MAY2014'", force
append using "`t_OCT2014'", force
append using "`t_DEC2014'", force
append using "`t_FEB2015'", force
append using "`t_NOV2015'", force
append using "`t_2016'", force

order ST_NAME DIST_NAME AC_NAME YEAR

save "raw_elections.dta", replace



