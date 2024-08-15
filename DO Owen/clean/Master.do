
***Define globals***
global raw "C:\Users\17819\Dropbox\capstone\household-decisions\Data\Raw\\"
global intermediate "C:\Users\17819\Dropbox\capstone\household-decisions\Data\Intermediate\\"
global dofiles "C:\Users\17819\Dropbox\capstone\household-decisions\DO Owen\"
global tables "C:\Users\17819\Dropbox\capstone\household-decisions\Outputs\Tables\\"
global figures "C:\Users\17819\Dropbox\capstone\household-decisions\Outputs\Figures\\"

cd "${intermediate}"

*install outreg2 package
ssc install outreg2