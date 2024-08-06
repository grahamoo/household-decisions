cd "C:\Users\graha\Dropbox\capstone\Data Owen"

use "Elections/election_district.dta", clear

keep state district

tempfile elections
save "`elections'"

use "DHS/DHS.dta", clear

keep state district 
duplicates drop

tempfile DHS
save "`DHS'"

use "`elections'"

merge 1:1 state district using "`DHS'"

save "merge_test.dta", replace