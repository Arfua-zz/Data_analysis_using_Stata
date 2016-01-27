**                              OVERVIEW
**                      (descriptive statistics)

*   less important
**  important
*** very important

* best - those in category 3; good - in cat. 2; ok - in cat. 1

sum
* Mean (categories) ~=1.87, thus there're more ok than best
* other var-s show 'Very average' means between possible Min and Max


scatter jobimportance  wage, by(categories)
by  categories, sort: sum  jobimportance
** most of best have job difficulty level less than 50
** most of good have job difficulty level around 50
** most of ok have job difficulty level more than 50

scatter experience  wage, by(categories)
by  categories, sort: sum experience
** ALL good have experience more than 5 years!
** best and ok are experienced at different levels, 
*  but best have a little bit lower average experience
** we are supposed to include [exper^2]

gen expersq=experience^2

** Categories are odered, that's why we are looking for...
** ...            Ordered Probit and Ordered Logit

oprobit  categories jobimportance fixedwage wage experience expersq
 
predict p1, p outcome(1)
predict p2, p outcome(2)
predict p3, p outcome(3)

mfx compute, predict(outcome(1))
mfx compute, at(fixedwage=1) predict(outcome(1))
** For Mr. Average : 
** 1 level increase in Job Importance -> 3% increase in prob to be Ok
** For those with fixed effect Prob to be Ok is 12% lower
** 100 units increase in wage -> 4% higher to be Ok
** 1 year increase in exper -> 2,3% decrease in prob to be Ok...
** ... while return on exper increases by 0,3% ( of prob to be Ok)

mfx compute, predict(outcome(2))
** For Mr. Average : 
** 1 level increase in Job Importance -> 1,4% decrease in prob to be Good
** For those with fixed effect Prob to be Ok is 5,3% higher
** 100 units increase in wage -> 2,2% lower to be Good
** 1 year increase in exper -> 1% increase in prob of being Good...
** ... while return on exper decreases by 0,13%

mfx compute, predict(outcome(3))
** For Mr. Average : 
** 1 level increase in Job Importance -> 1,8% decrease in prob to be Best
** For those with fixed effect Prob to be Best is 6,8% higher
** 100 units increase in wage -> 2,7% lower to be Best
** 1 year increase in exper -> 1,3% increase in prob of being Best...
** ... while return on exper decreases by 0,18%


** The results of Ordered Logit is Very similar!
ologit  categories jobimportance fixedwage wage experience expersq
mfx compute, predict(outcome(1))
mfx compute, at(fixedwage=1) predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))










