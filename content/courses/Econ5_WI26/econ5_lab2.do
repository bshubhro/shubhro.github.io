/* Lab-2 | Econ-5/ Poli 5D  <INSERT YOUR OWN TITLE>

Project: Opportunity Insights data on intergenerational mobility

Author(s): Opportunity Insights. 

Contact: <INSERT your email>

This do-file:
*Contains all exercises for Lab-2 quiz

*/


**************************************************************************************************


* Lab 2

* In this lab we will continue to explore the College Mobility Data 
* from the Researchers at Opportunity Insights 

* Where you see XX, you need to delete XX and replace with the relevant code

*********
* Part 1: Workflow 
*********

* If you have not done so, download the college_mobility.dta and place
* it somewhere on your computer. I recommend creating a folder hierarchy 
* along the lines of:
* Documents > EP5 > 02_week 
* and inside the 02_week folder place everything related to week 2

***** Folder structure in the lab:

* Desktop -> econ_5 -> lab_2 -> Three Subfolders: data -- do -- output (I will post a video tutorial of how to do this later)


* 1. change your working directory 
cd "/Users/shubhro/Desktop/UCSD SY 2025-26/WI 2026/Econ 5 TA/week-2/lab-2/"

* 2. load in the data 
use "data/college_mobility.dta" 

********
* Part 2: Summary Statistics 
********

* 1. What does the variable par_median represent? Write your answer as a comment below
sum par_median
describe par_median

* A: Median Parental Income


* 2. What is the average of par_median?

* A: 77742.79

* 3. What school has the minimum par_median? 

sum par_median
br name par_median if par_median == r(min)

//We need to browse the schook with the min parental income

* A: United Talmudical Seminary

* 4. What school has the maximum par_median?

sum par_median
br name par_median if par_median == r(max)

* A: Washington And Lee University

//We need to browse the school with the max parental income

********
* Part 3: Generating New Variables
********

* 1. Generate a binary indicator variable that is equal to one if 
* the average number of students in the school is less than or equal to 100


gen small_school = (count <= 100)
label var small_school "School has 100 or fewer students"


* 2. You can drop observations that meet certain restrictions. For example, 
* let's drop observations that have less than or equal to 100 students 

drop if count<= 100

//Alternative: drop if small_school==1 (Try it out)


* 3. You can also drop variables that you no longer need 
* Drop the variable that you created in 1

drop small_school //We do not need this variable anymore


*******
* Part 4: Histogram
*******

* 1. Create a histogram of par_median. Make sure your histogram has 
* (1) a title and (2) appropriate axes titles

histogram par_median, ///
    title("Distribution of Median Parental Income") ///
    xtitle("Median Parental Income") ///
    ytitle("Fraction of Observations")


//Alternative: represent y-axis in fractions

histogram par_median, frac ///
    title("Distribution of Median Parental Income") ///
    xtitle("Median Parental Income") ///
    ytitle("Fraction of Observations")
	
	
* 2. Write a sentence or two about the distribution of median parental income
* across colleges

* A: The distribution of median parental income across colleges is right-skewed. Most colleges have median parental incomes clustered around $50,000–$90,000, while a small number of colleges have much higher median parental incomes, creating a long right tail.



*******
* Part 5: Bonus/Optional 
*******

* We covered the histogram command in lecture
* Another popular data visualization technique is a scatter plot 
* type "help scatter" and use the help file to 
* figure out how to construct a scatter plot with 
* par_median on the vertical (y-axis) and k_median on the horizontal (x-axis)

scatter par_median k_median, ///
    title("Parental Income vs. Child Income Across Colleges") ///
    xtitle("Median Child Income") ///
    ytitle("Median Parental Income")

//Interpretation: The scatter plot shows a strong positive relationship between median parental income and median child income across colleges. Colleges that enroll students from higher-income families tend to have graduates with higher median earnings, although there is substantial dispersion, indicating that outcomes vary even among colleges serving similar parental income groups.
