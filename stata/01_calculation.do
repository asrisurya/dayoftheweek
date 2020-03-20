*   Version_2: Output
*	edit	: 18 19 2019
*	 author	: Asri Surya
*	 email	: asri.surya@mail.ugm.ac.id
/*
NOTES: 
1.(20190928) edited estimation period
2.(20191001) change to raw return,w/ 1st and 99th
3.(20191004)return not multiple by 100-canceled

4. back to datav02, without outliers and (*return1*100)
5. fixed estimation time
6. (20191118) include wed and revisit equation
*/
quietly {
cls
capture log close
clear
set more off

global path "C:\Users\k3162\Dropbox\Publication\stata"

*Define sub directories
global logfiles "$path\logfiles"
global dofiles "$path\do"
global datafiles "$path\datafiles"

* Go to the main directory 
cd $path

*Setup up logfile
capture log close
log using "$logfiles/dotw_v06", text replace

*Import datafiles
use "$datafiles/datasetv08-20200129", clear
}
gen L1=return1[_n-1] //generate (1)lag value of return	
gen yr=year(date)

// Estimation period
tset date
/*
local period1 "01jan2000,01dec2004"
local period2 "01jan2005,31dec2009"
local period3 "01jan2010,31dec2014"
local period4 "01jan2015,31oct2019"
*/

local period1 "01jan2010,01dec2017"
local period2 "01jan2003,31dec2019"

cls //clear screen

global varlist "return1 mon tue thu fri L1" //main equation(s)

set more off
//++++++++++++++++++++++++++++++Estimation result++++++++++++++++++++++++++++++++++//
foreach x of numlist 2/2{
//quietly{
	macro list _period`x'

		//modified-GARCH(1,1)
	arch $varlist, arch(1) garch(1) het(mon tue thu fri) nolog, if tin(`period`x'')
		estimates store mg_`x'	
//}
}
set more off
//================================================================================			
	
	estimates table mg_1 mg_2 mg_3 mg_4,  b star stats(chi2 ll N)	
		estimates table mg_2 mg_3, b se varlabel style(noline) equations(1)
