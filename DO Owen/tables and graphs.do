cd "C:\Users\graha"

ssc install estout, replace


*globals for men

use "Dropbox\capstone\individual male files\districts-male.dta", clear
global margin1 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10
global margin2 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102
global margin3 dum1-dum10 marg1 marg2 marg3 marg4 marg5 marg6 marg7 marg8 marg9 marg10 marg12 marg22 marg32 marg42 marg52 marg62 marg72 marg82 marg92 marg102 marg13 marg23 marg33 marg43 marg53 marg63 marg73 marg83 marg93 marg103

global individual_controls respondent_obc literate educationyears_respondent age hindu muslim christian sikh working household_size

global dist_controls TOT_PTotal f_literateTotal m_literateTotal

global wealth_dummies wealth_1 wealth_2 wealth_3 wealth_4 wealth_5

global se "cluster(district)"

global slvl "starlevels(* 0.10 ** 0.05 *** 0.01)"

****generate variables of interest
gen test_var = (sm701a == 1)
****Table 1


	ivreg2 test_var (frac_f = frac_close_winf) frac_close $margin2 $individual_controls state_* $wealth_dummies $dist_controls, $se
	eststo iv1
  qui: sum test_var if e(sample) == 1
  qui estadd scalar outcome_mean = r(mean)

	esttab iv1 using "Downloads/test_table.pdf", ///
			replace style(tex) collabels(, none) label varlabels(frac_f "Fraction of female leaders") cells(b(star fmt(%9.3f)) se(par))  ///
			keep(frac_f) mlabels(, none) stats(N outcome_mean, fmt(%9.0gc %9.3fc) ///
			labels("\hspace{0.5 cm} Observations" "\hspace{0.5 cm} Outcome mean") ///
			layout(@ @)) $slvl

  eststo clear





