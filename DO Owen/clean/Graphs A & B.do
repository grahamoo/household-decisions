cd "C:\Users\graha\Dropbox\capstone"


*merge individual elections with relevant districts and years in DHS sample
use "individual woman file\districts-woman.dta", clear

keep state district year frac_f
duplicates drop

tempfile women
save "`women'"

use "Data Owen\Elections\ECI excel files\clean_elections.dta", clear
keep if mf == 1
replace marg = -1 * marg if win_f == 0 

merge m:1 state district year using "`women'"

keep if _merge == 3


*gen bins:
gen bin=.
local k=0.01
forvalues i=1/100{
replace bin=`i' if marg>=(0+(`i'-1)*(`k')) & marg<(0+(`i')*(`k'))
replace bin=-`i' if marg>(0-(`i')*(`k'))& marg<=(0-(`i'-1)*(`k'))
}
gen midbin=.
forvalues i=1/100{
replace midbin=((0+(`i'-1)*(`k'))+(0+(`i')*(`k')))/2 if bin==`i'
replace midbin=((0-(`i')*(`k'))+(0-(`i'-1)*(`k')))/2 if bin==-`i'
}

*gen observations=sample
sort midbin

collapse(mean) frac_f marg   , by(midbin)

#delimit cr
label var midbin "Margin of victory in male-female elections"

graph set window fontface "Georgia"
#delimit ;
twoway (scatter   frac_f midbin if  midbin >= -0.3 & midbin <= 0.3  , sort msize(small)xline(0) xlabel(-0.3(0.1)0.3) legend(off) ytitle("Fraction of seats won by female politicians"))
(lowess frac_f midbin if marg>0 & midbin >= -0.3 & midbin <= 0.3  , sort msymbol(none) clcolor(black) clpat(solid) clwidth(medium))
(lowess frac_f midbin if marg<0 & midbin >= -0.3 & midbin <= 0.3  , sort msymbol(none) clcolor(black) clpat(solid) clwidth(medium))


,scheme(s2mono) 
graphregion(color(white)) bgcolor(white)
saving("tables and graphs/figure1_A", replace)
title("Panel A. All elections between a male and a female politician", size(medium))
ylabel(, angle(horizontal))

;
#delimit cr

graph export "tables and graphs/figure1_A.pdf", replace
