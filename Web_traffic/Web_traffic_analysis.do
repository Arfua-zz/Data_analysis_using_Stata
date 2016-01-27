**                            OVERVIEW
**                      (descriptive statistics)

*   less important
**  important
*** very important

* general sites - gens, news sites - news, sports sites - sports



sum
* myvisitors is in the range from 0 to 35
** myvisitors st. dev. is about 2 times higher then mean, thus variance is even 4 times higher
* about 20,5% of the sites were advertised
* we have 3 different groups and most of the sources are 'sports'

** Let's look on the overall impact of theme
scatter myv advertisingintensity, by(theme)
* we see that there a relation - sports sites visitors are more sensitive to intensive ads

** Let's look whether advertising & theme are related somehow...
by theme, sort: sum  advertising

* about 19,5% of gens and news were advertised
* while about 20,5% of sports were advertised
* number of observations in the 3d group about 2 times higher than for groups 1 & 2

by theme, sort: sum  advertisingintensity

* the average intensity is higher for 3rd group

** Let's create DUMMIES for theme to catch the impact of different groups
gen gens = theme == 1
gen news = theme == 2
gen sports = theme == 3


**                                 Poisson model
ren advertisingint inte
ren source src
gen lsv = log(src)
gen intexgens = inte * gens
gen intexnews = inte * news
gen intexspor = inte * spor


** Actually 
poisson  myvisitors lsv advertising inte gens news
* we see that advertising is really insignificant. Let's try without advertising and control for per-theme effect of advertisement
poisson  myvisitors  lsv gens news sports intexgens intexnews intexspo, noconst
* the results are very similar, thus let's omit adv. variable
** 1% increase in source-vis -> 3.9% increase in number of visitors (on av., cet. par.)
** 0.1 increase in adv-int-y -> 2.1% increase in number of visitors from "gens"
** 							 -> 5.2% increase in number of visitors from "news"
** 							 -> 6.0% increase in number of visitors from "sports"
** expected nimver of visitors is about 46.2% higher for sport than for gens 
** expected nimver of visitors is about 49.9% higher for sport than for news

mfx compute, at (gens=0 news=0)
** the predicted number of visitors is 1.22
** For Sport Average source: 1% increase in source-vis -> 4.7 increase in number of visitors
** For Sport Average source: 1 unit increase in adv-int-y -> 0.73 increase in number of visitors

mfx compute, at (gens=1 news=0)
** For General Average src: the expected number of visitors 0.77
** source-visitor (like above) -> 3.0
** ad-intensity (like above) -> .16


mfx compute, at (gens=0 news=1)
** For News Average src: the expected number of visitors 0.75
** source-visitor (like above) -> 2.9
** ad-intensity (like above) -> .38


**                            Negative Binomial Model

*** there was suspected overdespertion in myvisitors 

nbreg myvisitors lsv gens news sports intexgens intexnews intexspor, noconstant dispersion(mean) nolog iterate(10)
*** The results of Poisson and Negative Binomial Model are VERY similar !!!
*** Likelihood-ratio test of alpha=0:  chibar2(01) = 0.0e+00 Prob>=chibar2 = 0.500 - no overdispersion
