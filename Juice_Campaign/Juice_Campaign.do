//                          OVERVIEW
//                  (descriptive statistics)

*   less important
**  important
*** very important
// juicers     -  those who drink juice
// exercisers  -  those who do exercises

sum if juice==1
sum if juice==0
*   st. dev-s are similar
**  70% of those who drink juice do exercises!
**  only 27% of those who do NOT drink juice do exercises!
*   average amounts of friends are similar: 54 vs 51.
**  ~ 931 is the average income of juice drinkers!
**  only ~ 557 is the average income of those who don't drink juice!
*** we see the impact of Healthy life style & Income !!!

sum if  exercise==1
sum if  exercise==0
***  exercisers earn (on average) 486 more

sort juice
scatter income friends, by(juice)
*  there is no strong relationship between friends and income
** most of juicers earn more than 500
** most of nonjuicers earn less than 1000
// Thus, let's create dummies for those who earn less than 500 and more than 1000
// and interact them with income
gen incless500=0
replace incless500=1 if income<500
gen incmore1000=0
replace incmore1000=1 if income>1000
sum incless500 incmore1000
* Our basis is those whos income is between 500 and 1000
** 25% earn less than 500 and 24% earn more than 1000, and others 51% have average income

**generate log(income) for better interpretation
gen linc=log(income)
gen il500=incless500*linc    //
gen im1000=incmore1000*linc // interactions for regressions


//                        LPM model

reg juice linc exercise friends il500 im1000
*  friends are not significant
** for the Average income person :
   // an increase in income by 10% leads to 1% increase in the probability to buy juice (on average, cet. par.)!
** for Poor people :
   // return on 10% increase in income is 0.2% lower in probability to buy juice (0.8%)
** for Rich people :
   // return on 10% increase in income is 0.2% higher in probability to buy juice (1.2%)
   ** exercisers have 19% higher probability to drink juice
hettest 
* there is no heteroskedasticity at 10% CONFIDANCE LEVEL
predict y
scatter y linc 
* fitted values are not completely in (0,1)

//                      Probit model 

probit juice linc exercise friends il500 im1000
mfx compute
// for the AVERAGE person:
*  Mr. Average : [6.37; 0.49; 52.5]
*  friends are NOT statistically significant
** for the Average Average Income person :
   // 10% increase in income leads to 1.8% increase in probability to buy juice
** for the Average Poor Income person
   // return on 10% increase of income is 0.17% lower in probability than for Average Average person
** for the Average Rich Income person
   // return on 10% increase of income is 0.25% higher in probability than for Average Average person
** exercisers have 20% higher probability to be juicers

mfx compute, at (mean exercise=1)
** results are VERY similar
mfx compute, at (mean exercise=0)
** results are VERY similar
hetprob juice linc exercise friends il500 im1000, het(exercise)  // heteroskedasticity
mfx compute
hetprob juice linc exercise friends il500 im1000, het(linc)     // heteroskedasticity
hetprob juice linc exercise friends il500 im1000, het(friends) // no


//                      Logit model 

logit juice linc exercise friends il500 im1000
mfx compute
// for the AVERAGE person:
*  Mr. Average : [6.37; 0.49; 52.5] - the same
*  friends are NOT statistically significant
** for the Average Income: 10% increase in income leads to 2.4% increase in probability to buy juice 
   // Average Poor : -0.1% (not significant) in prob-y
   // Average Rich : +0.2% in prob-y
** exercisers have 20% higher probability to be juicers

mfx compute, at (mean exercise=1)
mfx compute, at (mean exercise=0)
* results are similar


//                   Goodness of fit

/// LPM
* 1. R^2 is not realy high ~ 0.25
* 2. heteroskedasticity is not present 

/// Probit
probit juice linc exercise friends il500 im1000
mfx compute
* Pseudo-R^2 is 0.2, thus explicative variables do not explain a lot
lstat
* 71,54% correctly predicted
gen const=0
probit juice const
lstat // number of correctly predicted is about 50% which is lower


// Likelihood ratio test :
// H0: restricted model in favor of the alternative, unrestricted model
probit juice linc exercise friends il500 im1000
est store m1
probit juice linc exercise il500 im1000 // without friends
est store m2 
lrtest m1 m2
** P-value for LR statistics is 0.43, thus restricted model should be prefered

/// Logit
logit juice linc exercise friends il500 im1000
mfx compute
* Pseudo-R^2 is 0.2, thus explicative variables do not explain a lot
lstat
* 71.54% correctly predicted

// Likelihood ratio test :
logit juice linc exercise friends il500 im1000
est store m3
logit juice linc exercise il500 im1000 // without friends
est store m4 
lrtest m3 m4
** P-value for LR statistics is 0.37, thus restricted model should be preferred
