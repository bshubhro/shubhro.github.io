
/**************************************************************************************************
* FILE:        lab3_open_policing.do
* PURPOSE:     Lab 3 — Explore and analyze the Stanford Open Policing Project data
*
* COURSE:      Econ 5 / Poli 5D — Winter 2026 (UC San Diego)
* AUTHOR:      <YOUR NAME>
* EMAIL:       <YOUR EMAIL>
* DATE:        <YYYY-MM-DD>
*
* PROJECT:     Stanford Open Policing Project (SOPP) — Lab 3
* DATA:        <e.g., sopp_state_ca.dta OR sopp_traffic_stops.csv>
* SOURCE:      Stanford Open Policing Project (SOPP)
*

* THIS DO-FILE:
*   (1) Sets paths + log
*   (2) Imports + Merges datasets
*   (3) Cleans + labels key variables
*   (4) Produces summary tables + basic visualizations
*   (5) Saves cleaned data + outputs
*
* REPRODUCIBILITY NOTES:
*   - Run top-to-bottom (no manual clicks)
*   - Do not hard-code file paths
*
* STUDENT INSTRUCTIONS:
*   - Anywhere you see "XX", replace it with the correct code
*   - Do not delete section headers; write your code under them
**************************************************************************************************/


*********
* Part 1: Workflow 
*********

* 1. change working directory to location of data 
cd "/Users/shubhro/Desktop/econ5/lab_3/"

********
* Part 2: Merging Data
********

* Our data comes in two separate files 
* File 1: stops_driver_chars.dta contains characteristics of drivers that are stopped
* File 2: stops_searches.dta contains information about searches. In some traffic
* stops officers decide to search the vehicle or person for contraband. This 
* file contains information on whether a search was conducted, and if so, whether
* contraband was found 

* 1. Load in stops_driver_chars.dta

use "data/stops_driver_chars.dta" , clear

* 2. describe the data and look through the variables (we will eventually need to choose a variable to merge the data)

describe

//Notes: None of the variables have a label
//stop_id seems like a good candidate to merge the data

* 3. Load in stops_searches.dta

use "data/stops_searches.dta" , clear


* 4. describe the data and take note of the variables

describe

//stop_id is the variable which also repeats in this dataset

* 5. Based on the variables in the dataset, what variable do you think you should
* merge the two datasets together?

* A: stop_id should be used, since it is repeating in both the datasets

* Next we will merge the two datasets together

* 6. load in one of the two datasets

use "data/stops_searches.dta" , clear


* 7. use the merge command to combine the datasets

merge 1:1 stop_id using "data/stops_driver_chars.dta"


//What do you see? Do the variables match?

/* Here is the merge report

 Result                      Number of obs
    -----------------------------------------
    Not matched                         1,131
        from master                        99  (_merge==1)
        from using                      1,032  (_merge==2)

    Matched                            26,901  (_merge==3)
    -----------------------------------------
*/


*******
* Part 3: Building the Analysis datasets
*******

* 1. We only want stops that are in both the driver characteristics data 
* and the searches data. Keep only stops that are in both datasets

keep if _merge==3

*Alternatively: 
* drop if _merge==2 & _merge==3 //It is okay to use whichever you feel like

* 2. Drop any new variables that were created in the merge command, given 
* we will not need them anymore 

drop _merge

* 3. Generate a variable that is equal to 1 if search_conducted 
* is equal to TRUE and 0 if search_conducted is equal to FALSE


//3.1. Generate a new variable with missing values

gen true_search=.  

la var true_search "Whether search is conducted or not"

//3.2 Replace the variable based on the question

replace true_search=1 if search_conducted=="TRUE"
replace true_search=0 if search_conducted=="FALSE"


* 4. What fraction of stops end in search overall 

tab search_conducted

//4.37%

********
* Part 4: Bar Graph 
********

ssc install blindschemes
set scheme plotplainblind

* 1. Create  bar graph that shows search rates by race 

* Bar graph: search rates by race (rate = mean of 0/1 indicator true_search)

graph bar (mean) true_search, over(subject_race) ///
	title("Search rates by race") ///
	ytitle("Search rate")
	

*If you want to display in percentages:

gen true_search_pct = 100*true_search
graph bar (mean) true_search_pct, over(subject_race) ///
	title("Search rates by race") ///
	ytitle("Search rate (%)")


********
* Part 5: Bonus/Optional
********

* 1. Restrict data only to stops in which a search was conducted

keep if search_conducted=="TRUE"

* 2. Create a bar graph that shows the fraction of searches that
* resulted in contraband found (by the race of the driver). 


* Create 0/1 indicator for contraband found
gen contraband_true=.
replace contraband_true=1 if contraband_found=="TRUE"
replace contraband_true=0 if contraband_found=="FALSE"


graph bar (mean) contraband_true , over(subject_race) ///
    title("Contraband hit rate by race (conditional on search)") ///
    ytitle("Fraction with contraband found")
