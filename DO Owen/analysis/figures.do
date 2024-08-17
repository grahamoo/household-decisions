*Purpose: Create all figures for paper

********************************************************************************
***Figure 1: First Stage Illustration***

***Figure 1A: All elections between a male and a female politician***
*keep one obs per district that appears in the men's sample
use "${intermediate}for_analysis_men_3.dta", clear
keep if !mi(male_decision_z)
bysort year state district: keep if _n == 1
keep year state district frac_f

tempfile dhs_non_missing
save `dhs_non_missing'

*merge elections to each district in the men's sample
use "${intermediate}clean_elections_3.dta", clear

*Keep latest elections prior to 2015-2016 DHS
/*Note: state elections occur every 5 years but states are
on different 5 year cycles. All states have one election between
2010-2014*/
keep if year >= 2010 & year <= 2014

merge m:1 year state district using `dhs_non_missing'
keep if _merge == 3

*make margin negative if female candidate loses
replace marg = -marg if mf == 1 & win_f == 0

*keep male-female elections
drop if mf == 0

*keep one observation per election
duplicates drop state district ac year, force

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

collapse(mean) frac_f marg, by(midbin)

*output figure
#delimit cr
label var midbin "Margin of victory in male-female elections"

graph set window fontface "Georgia"
#delimit ;
twoway (scatter   frac_f midbin if  midbin >= -0.3 & midbin <= 0.3  , sort msize(small)xline(0) xlabel(-0.3(0.1)0.3) legend(off) ytitle("Fraction of seats won by female politicians"))
(lowess frac_f midbin if marg>0 & midbin >= -0.3 & midbin <= 0.3  , sort msymbol(none) clcolor(black) clpat(solid) clwidth(medium))
(lowess frac_f midbin if marg<0 & midbin >= -0.3 & midbin <= 0.3  , sort msymbol(none) clcolor(black) clpat(solid) clwidth(medium))

,scheme(s2mono) 
graphregion(color(white)) bgcolor(white)
saving("${figures}figure1A", replace)
title("Panel A. All male-female elections", size(medium))
ylabel(, angle(horizontal))

;
#delimit cr

graph export "${figures}figure1A.pdf", replace


***Figure 1B: Male-female elections in districts with a single male-female election***
*keep one observation per district in the men's sample
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.
bysort year state district: keep if _n == 1
keep year state district frac_f
tempfile dhs_non_missing
save `dhs_non_missing'

*merge elections to districts in men's sample
use "${intermediate}clean_elections_3.dta", clear

*Keep latest elections prior to 2015-2016 DHS
/*Note: state elections occur every 5 years but states are
on different 5 year cycles. All states have one election between
2010-2014*/
keep if year >= 2010 & year <= 2014

merge m:1 year state district using `dhs_non_missing'
keep if _merge == 3

*make margin negative if female candidate loses
replace marg = -marg if mf == 1 & win_f == 0

*keep one observation per election
duplicates drop state district ac year, force 

*keep elections in districts with exactly one m-f election 
sort state district year
by state district year: egen total_mf=total(mf)
drop if total_mf != 1

*keep m-f elections
drop if mf == 0

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

collapse(mean) frac_f marg, by(midbin)

*output figure
#delimit cr
label var midbin "Margin of victory in male-female elections"

graph set window fontface "Georgia"
#delimit ;
twoway (scatter   frac_f midbin if midbin >= -0.3 & midbin <= 0.3 , sort msize(small)xline(0) xlabel(-0.3(0.1)0.3)  legend(off) ytitle("Fraction of seats won by female politicians"))
(lowess frac_f midbin if marg>0 & midbin >= -0.3 & midbin <= 0.3 , sort msymbol(none) clcolor(black) clpat(solid) clwidth(medium))
(lowess frac_f midbin if marg<0 & midbin >= -0.3 & midbin <= 0.3 , sort msymbol(none) clcolor(black) clpat(solid) clwidth(medium))


,scheme(s2mono) 
graphregion(color(white)) bgcolor(white)
saving("${figures}figure1B", replace)
title("Panel B. Male-female elections in districts with a single male-female election", size(medium))
ylabel(, angle(horizontal))

;
#delimit cr

graph export "${figures}figure1B.pdf", replace

gr combine "${figures}figure1A.gph" "${figures}figure1B.gph", col(1) iscale(0.70) xsize(3) scheme(s2mono) graphregion(color(white))
graph export "${figures}figure1.pdf", replace

********************************************************************************
***Figure A1: McCrary Test***
*keep one obs per district that appears in the men's sample
use "${intermediate}for_analysis_men_3.dta", clear
keep if male_decision_z!=.
bysort year state district: keep if _n == 1
keep year state district frac_f
tempfile dhs_non_missing
save `dhs_non_missing'

*merge elections to districts in men's sample
use "${intermediate}clean_elections_3.dta", clear

*Keep latest elections prior to 2015-2016 DHS
/*Note: state elections occur every 5 years but states are
on different 5 year cycles. All states have one election between
2010-2014*/
keep if year >= 2010 & year <= 2014

merge m:1 year state district using `dhs_non_missing'
keep if _merge == 3

*make margin negative if female candidate loses
replace marg = -marg if mf == 1 & win_f == 0

*keep male-female elections
drop if mf == 0

*output figure
graph set window fontface "Georgia"
set scheme s1color
cap drop  Yj Xj r0 fhat se_fhat
DCdensity_format marg if marg >= -.3 & marg <= .3 , breakpoint(0) generate(Xj Yj r0 fhat se_fhat) b(0.01)
graph export "${figures}mccrary_test.pdf", replace

********************************************************************************
***Figure A2: Media Consumption***
use "${intermediate}for_analysis_men_3.dta", clear

keep if male_decision_z!=.

*generate a variable for subsamples
gen subsample = 0 if married == 0 & age <= 30
replace subsample = 1 if married == 1 & age <= 30
replace subsample = 2 if married == 0 & age > 30
replace subsample = 3 if married == 1 & age > 30

*collapse daily media consumption rate by subsample
collapse (mean) mean_v= daily_media (sd) sd_v=daily_media (count) n=daily_media, by(subsample)

*generate standard deviation tails
generate hi = mean_v + invttail(n-1,0.025)*(sd_v/ sqrt(n))
generate low = mean_v - invttail(n-1,0.025)*(sd_v / sqrt(n))

*output figure
graph set window fontface "Georgia"
set scheme s1mono

twoway (bar mean_v subsample, legend(off) ytitle("Fraction that consume media daily") xtitle("") xlabel(0 "Unmarried & Age {&le} 30" 1 "Married & Age {&le} 30" 2 "Unmarried & Age {&gt} 30" 3 "Married & Age {&gt} 30", labsize(small))) (rcap hi low subsample)
graph export "${figures}figureA2.pdf", replace

*source for graph format: https://stats.oarc.ucla.edu/stata/faq/how-can-i-make-a-bar-graph-with-error-bars/

