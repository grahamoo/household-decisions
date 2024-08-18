*Purpose: This doe file downloads the necessary packages for the codebase

***Create ado folder***

sysdir set PLUS "${ado}\plus"
sysdir set PERSONAL "${ado}\personal"
net set ado "${ado}\plus"


***Install ado files***
ssc install ranktest
ssc install ivreg2
ssc install estout