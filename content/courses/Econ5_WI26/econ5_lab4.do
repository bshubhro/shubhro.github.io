/**************************************************************************************************
* FILE:        lab4_mindspark_gdp_le.do
* PURPOSE:     Lab 4 — Mindspark (Muralidharan, Singh & Ganimian 2019)
*
* COURSE:      Econ 5 / Poli 5D — Winter 2026 (UC San Diego)
* AUTHOR:      <YOUR NAME>
* CONTACT:     <YOUR EMAIL>
* DATE:        `c(current_date)'
*
* PROJECT:     Lab 4 — Education RCT 

* INPUT DATA:  mindspark_data.dta (Muralidharan, Singh, Ganimian 2019)
*
* THIS DO-FILE DOES:
*   1) Sets paths + basic settings (clean start, scheme, log)
*   2) Loads Mindspark data and produces descriptives + graphs
*   3) Runs core regressions and interprets coefficients
*   4) (Optional) Runs conditional regressions by gender and age groups
*
* REPRODUCIBILITY / BEST PRACTICES:
*   - Run top-to-bottom (no manual clicking)
*   - Do not edit raw data; save cleaned versions if needed
*   - Replace all "XX" placeholders with working code
*   - Write answers directly in the do-file as comments (A:)
**************************************************************************************************/

*********
* Part 1: Workflow 
*********

* 1. change working directory to location of data 

cd "/Users/shubhro/Desktop/econ5/lab_4/"

* 2. load mindspark_data

use "data/mindspark_data.dta"

**********
* Part 2: Average Test Scores
**********

* 0. run the lines of code below to set scheme to plotplainblind
* This will change the overall look of your figures

ssc install blindschemes
set scheme plotplainblind

* 1. Create a bar graph that shows the average baseline 
* math score for treated and control students 
* make sure to have proper titles/labels

* Average baseline math score by treatment status
graph bar (mean) per_math1, over(treat) ///
    title("Average Baseline Math Score: Treated vs Control") ///
    ytitle("Baseline math score (% correct)") ///
    blabel(bar, format(%4.2f))
	

* 2. Create a bar graph that shows the average endline 
* math score for treated and control students 
* make sure to have proper titles/labels

* Average endline math score by treatment status

graph bar (mean) per_math2, over(treat) ///
    title("Average Endline Math Score: Treated vs Control") ///
    ytitle("Endline math score (% correct)") ///
    blabel(bar, format(%4.2f))

	
*********
* Part 3: Regression 
*********

* 1. Estimate a regression in which the Y-variable (dependent variable/outcome)
* is math score at baseline while the X-variable (independent variable/explanatory) is ses_index

* Regression: baseline math score on SES index
reg per_math1 ses_index


* 2. Report and Interpret the slope coefficient below

display "Slope (beta on ses_index) = " _b[ses_index]

* A 1-unit increase in ses_index is associated with a 0.01224 increase in per_math1.
*    Since per_math1 is percent-correct (0 to 1), this is about a 1.224 percentage-point
*    higher baseline math score, on average.

* 3. What is the predicted test score for an individual with ses index = 0.5

di _b[_cons] + _b[ses_index]*0.5


* A: Predicted per_math1 at ses_index = 0.5 is 0.32386732 (≈ 32.39% correct).


* 4. What is the difference in predicted test scores for an individual with 
* ses index =0.5 vs. ses index =-0.5?

* Difference in predicted scores: ses_index=0.5 vs -0.5
di _b[ses_index]*(0.5 - (-0.5))


* A: An individual with ses_index = 0.5 is predicted to score 0.01224 higher on baseline math than an individual with ses_index = -0.5 (about 1.22 percentage points).

* 5. Construct a single figure that shows both (1) a scatter plot of the relationship between score at baseline and ses index and (2) the linear regression line of best fit

* Scatter + fitted regression line: baseline math vs SES

la var per_math1 "Math Test (%)"


twoway (scatter per_math1 ses_index) ///
       (lfit per_math1 ses_index, lcolor(red)), ///
    title("Baseline Math Score vs SES Index") ///
    xtitle("SES index") ///
    ytitle("Baseline math score (% correct)")



	
*********
* Part 4: Bonus/Optional: Conditional Regressions
*********

* Run conditional regressions to see if the relationship 
* between baseline math scores and ses index varies for male vs. female students
* and by above-median age vs. below median age students.

* female vs. male


*-----------------------------*
* Conditional regressions: Female vs Male
*-----------------------------*

reg per_math1 ses_index if st_female1==1      // females
reg per_math1 ses_index if st_female1==0      // males



* by age (this will take a few steps) 


*-----------------------------*
* Conditional regressions: Above-median vs Below-median age
*-----------------------------*
summ st_age1, detail
gen above_med_age = (st_age1 > r(p50))

reg per_math1 ses_index if above_med_age==1   // above-median age
reg per_math1 ses_index if above_med_age==0   // below/equal median age



	
	