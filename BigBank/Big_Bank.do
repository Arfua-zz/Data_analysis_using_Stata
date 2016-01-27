
   // 1
  // group 1 - no letter
 // group 2 - letter without additional 1% on extra deposits
// group 3 - letter with additional 1% on extra deposits

tsset id period // panel data

// 2 Overview

 // 2.1
// to get overall sum of deposits per group per period: N*Mean :

sort group
by group: sum deposits if period == 1
by group: sum deposits if period == 2
by group: sum deposits if period == 3

 // 2.2
// to get overall sum of current accounts per group per period: N*Mean :

sort group
by group: sum currentaccounts if period == 1
by group: sum currentaccounts if period == 2
by group: sum currentaccounts if period == 3

 // 2.3
// graph deposits vs individuals:

scatter deposits id, by(group)
graph twoway (scatter deposits id if group == 1) (scatter deposits id if group == 2)(scatter deposits id if group == 3), ytitle("Deposits") xtitle("Groups") legend( order(1 "G 1" 2 "G 2" 3 "G 3") )
// Pictures are similar, but in group 3 - an outlier with deposit > 100 000


 // 3
// whether means are equal ?!

mvtest means deposits if period == 1, by(group) // can not reject H0: yes, they're equal
mvtest means deposits if period == 2, by(group) // reject H0: no
mvtest means deposits if period == 3, by(group) // reject H0: no

tsset id period

 // 4
// logarithms, due to inflation and large variances :

gen ldep=log(deposits)
gen lcur=log(currentaccounts)


 // 5
// start with the pooled OLS :

xi: reg ldep age gender lcur i.period*i.group
predict u, res
corr u L.u      //
corr D.u D.L.u // cov(u(it), u(it-1)) << 0, serial corr is present
estat hettest // const variance!


  // 6
 // F-test to check whether fixed effect is present and to choose between:
// pooled OLS & FE :

xtreg  ldep  lcur, fe
xi: xtreg  ldep  lcur i.period i.group, fe
xi: xtreg  ldep  lcur i.period*i.group, fe 
xi: xtreg  ldep  lcur i.period*i.group  i.period*age i.period*gender, fe 
 // always fixed effect is present & we should GET RID OF IT
// thus, FE is better than pooled OLS
est sto m1 


 // 7
// Breush-Pagan Test to choose between pooled OLS & RE :

xi: xtreg ldep lcur i.period*i.group i.period*age i.period*gender, re
xttest0 // reject H0: variance in a's = 0, RE is better than pooled OLS


  // 8
 // Hausman test to choose between FE & RE
// Our hupothesis: FE is better because of correletion in residuals :

xi: xtreg ldep lcur i.period*i.group i.period*age i.period*gender, fe
est store fixed
xi: xtreg ldep lcur i.period*i.group i.period*age i.period*gender, re
est store random
hausman fixed random
// Reject H0 = > FE is better than RE


 // 9
// First Differences to see whether the coefficents are similar for FE & FD :

xi: reg  d.ldep d.lcur i.group*i.period
estat hettest
xi: xtreg ldep lcur i.period*i.group, fe
 // it is difficult to state because of interection terms, but
// anyway FD consumes a lot of degrees of freedom


 // 10 
// Between Regression does not get rid of fixed effect


     // 11
    // FE is the best case:
   // 1. get rid of fixed effect & as a result serial correlation
  // 2. keeps degrees os freedom
 // 3. model includes interections, so we can see the return on age & gender on 
//    ln(deposits) as a change between periods

est tab m1, se stats(N r2_a)
est tab m1, star stats(N r2_a)
