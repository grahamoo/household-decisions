cd "C:\Users\17819\Dropbox\capstone\Data Owen\Elections\ECI excel files"


*This file matches the district names from 2008 elections to the acs with missing district names from the December 2013 elections

*import 2008 elections
import excel using "${raw}ECI/AE_2008", firstrow sheet("cand_wise") clear
drop if POSITION != 1 & POSITION != 2
tempfile AE_2008
save `AE_2008'

import excel using "${raw}ECI/AE_2008", firstrow sheet("electors") clear
tempfile electors_2008
save `electors_2008'

use `electors_2008'
merge 1:m ST_CODE AC_NO using `AE_2008'
drop if _merge==1
drop P
destring TOTVOTPOLL, replace
destring CAND_AGE, replace
recast byte POSITION

*keep only relevant variables and observations
keep if ST_NAME == "Madhya Pradesh" | ST_NAME == "Chhattisgarh" | ST_NAME == "Delhi" | ST_NAME == "Rajasthan" | ST_NAME == "Mizoram"

replace ST_NAME = "NCT OF Delhi" if ST_NAME == "Delhi"

keep ST_NAME DIST_NAME AC_NO
duplicates drop ST_NAME DIST_NAME AC_NO, force

tempfile t_2008
save `t_2008'


*Import December 2013 elections
import excel using "${raw}ECI/December 2013 LA election", firstrow sheet("Candidates") clear
drop if POSITION != 1 & POSITION != 2
tempfile DEC_2013
save `DEC_2013'

import excel using "${raw}ECI/December 2013 LA election", firstrow sheet("Electors") clear
tempfile electors_DEC2013
save `electors_DEC2013'

use `electors_DEC2013'
merge 1:m ST_CODE AC_NO using `DEC_2013'
drop STATE
drop ASSEMBLYCONSTITUENCY
rename TOTALVOTESPOLLED TOT_VOTERS
rename TOTALELECTORS TOT_ELECTORS
rename POLLPERCENTAGE POLL_PERCENT
rename PARTYABBREviation PARTYABBRE
rename Totalvalidvotespolled TOTVOTPOLL
destring CAND_AGE, replace
drop _merge
tempfile t_DEC2013
save `t_DEC2013'

use `t_DEC2013'
merge m:1 ST_NAME AC_NO using `t_2008' 

save "${intermediate}t_DEC2013.dta", replace