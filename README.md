This GitHub repository creates the tables and graphs used in my writing sample for PhD applications. To reproduce the tables and graphs on your own device, see the instructions below for downloading data and customizing do-files.


### Data:

- **DHS:** I do not have the rights to publicly share the 2015-2016 NFHS-4 India DHS survey data, but it can be freely downloaded through the [DHS website](https://dhsprogram.com/data/dataset/India_Standard-DHS_2015.cfm?flag=0) once an account is created.
The women's survey data is under "Individual Recode" and the men's survey data is under "Men's recode". The downloaded women's data should be [saved here](https://github.com/grahamoo/household-decisions/tree/main/Data/Raw/DHS/Womens%20DHS) and the downloaded men's data should be [saved here](https://github.com/grahamoo/household-decisions/tree/main/Data/Raw/DHS/Mens%20DHS).
	
- **ECI election data:** raw state election files in the raw [ECI data folder](https://github.com/grahamoo/household-decisions/tree/main/Data/Raw/ECI) are downloaded through the [ECI website](https://www.eci.gov.in/statistical-reports).

- **2011 Census of India:** Raw Census data in the raw [Census data folder](https://github.com/grahamoo/household-decisions/tree/main/Data/Raw/Census) is downloaded from the [Indian Census website](https://censusindia.gov.in/census.website/data/census-tables) and is under the title "PCA-TOT: Primary Census Abstract Total".

### Do-files:

After downloading the DHS data, the full codebase can be run from [_master.do_](https://github.com/grahamoo/household-decisions/blob/main/Do/master.do). The global for the ["repo" directory](https://github.com/grahamoo/household-decisions/blob/c2ba14e91d063102fed4738c4ea904324a5f64e6/Do/master.do#L3) at the top of [_master.do_](https://github.com/grahamoo/household-decisions/blob/main/Do/master.do) needs to be customized to the folder path on your personal device. 
