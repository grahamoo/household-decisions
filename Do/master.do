
***Define globals***
global repo "C:\Users\17819\Dropbox\capstone\household-decisions\\"
global raw "${repo}Data\Raw\\"
global intermediate "${repo}Data\Intermediate\\"
global dofiles "${repo}Do\"
global tables "${repo}Outputs\Tables\\"
global figures "${repo}Outputs\Figures\\"
global ado	   "${repo}Ado\\"

*create intermediate data file if it does not exist
mata: st_numscalar("exists", direxists("${intermediate}"))
if scalar(exists) == 0 mkdir "${intermediate}"

cd "${intermediate}"

*create switches

local makefile				1
local clean_elections		1
local clean_census			1
local clean_dhs				1
local merge					1
local tables				1
local figures				1

********************************************************************************
***Install ado files***

if `makefile' == 1 {
	
	do "${dofiles}makefile.do"
}
********************************************************************************
***Clean election data***
/*Note: Imports ECI state election data for 2010-2014 state elections.
Defines election characteristics and collapses election data to district level for 
merge to DHS data.*/

if `clean_elections' == 1 {
	
	*import and append election data
	do "${dofiles}clean\1a election import.do"
	
	*clean election data and define election characteristics
	do "${dofiles}clean\1b election clean.do"
	
	*collapse election data to district level
	do "${dofiles}clean\1c election district collapse.do"
}

********************************************************************************
***Clean Census data***
*Note: Cleans 2011 Census data. Defines district-level covariates.

if `clean_census' == 1 {
	
	do "${dofiles}clean\2 census clean.do"
	
}

********************************************************************************
***Clean DHS data***
/*Note: Cleans men's and women's DHS datasets. Defines outcome variables and individual
controls.*/

if `clean_dhs' == 1 {
	
	*men's sample
	do "${dofiles}clean\3a DHS clean_men.do"
	
	*clean election data and define election characteristics
	do "${dofiles}clean\3b DHS clean_women.do"
	
}

********************************************************************************
***Merge***
*Note: Merges election and Census data into men's and women's DHS data.

if `merge' == 1 {
	
	do "${dofiles}clean\4 merge.do"
}

********************************************************************************
***Tables***
*Note: create all tables in paper

if `tables' == 1 {
	
	do "${dofiles}analysis\tables.do"
	
}

********************************************************************************
***Figures***
*Note: create all figures in paper

if `figures' == 1 {
	
	do "${dofiles}analysis\figures.do"
	
}