/*
# 2025-4-22
# 周二
# 实验六：两阶段估计

Use the data in CARD. DTA for this problem.



*/
// a. Estimate a logwage equation by OLS with educ, exper, exper2, black, south,
// smsa, reg661 through reg668, and smsa66 as explanatory variables.
use "card.dta",clear
reg lwage educ exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66

// // b. Estimate a reduced form equation for educ containing all explanatory variables
// from part a and the dummy variable nearc4. Do educ and nearc4 have a practically
// and statistically significant partial correlation? 

reg educ nearc4 reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66
// yes

// c. Estimate the logwage equation by IV, using nearc4 as an instrument for educ.
// Compare the 95 percent confidence interval for the return to education with that
// obtained from part a.

ivreg lwage  (educ = nearc4)  exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66,first

ivreg lwage (educ = nearc4 ) exper expersq black smsa south smsa66 reg662-reg669
estimates store iv
reg lwage educ exper expersq black smsa south smsa66 reg662-reg669
estimates store ols
estimates table iv ols, b(%7.4f) se(%7.4f) ci() stats(N r2_a)
estimates table iv ols, star

* 使用 ivregress 2sls 命令进行 IV 估计
* 形式: ivregress 2sls depvar exogenous_vars (endogenous_vars = instruments)
ivregress 2sls lwage exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66 (educ = nearc4)
// 上面的语句不能用，报错，但有参考佳值
esttab  iv ols,ci(2) level(95)
/*
d. Now use nearc2 along with nearc4 as instruments for educ. First estimate the
reduced form for educ, and comment on whether nearc2 or nearc4 is more strongly
related to educ. How do the 2SLS estimates compare with the earlier estimates?
*/

ivreg lwage  (educ = nearc4 nearc2)  exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66,first

* 估计 educ 的简化形式方程，包含 nearc2 和 nearc4
regress educ exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66 nearc2 nearc4

* 评论 nearc2 和 nearc4 哪个与 educ 相关性更强
* 查看上面回归结果表中 nearc2 和 nearc4 的系数大小和 t 统计量 (或 P 值)。系数的绝对值越大，t 统计量越大，表明相关性越强。

* 使用 nearc2 和 nearc4 作为工具变量进行 IV 估计
ivregress 2sls lwage exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66 (educ = nearc2 nearc4)
// nearc4更为显著


// e. For a subset of the men in the sample, IQ score is available. Regress iq on nearc4.
// Is IQ score uncorrelated with nearc4?
reg iq nearc4
// no they are correlated

//
// f. Now regress iq on nearc4 along with smsa66, reg661, reg662, and reg668. Are iq
// and nearc4 partially correlated? What do you conclude about the importance of
// controlling for the 1966 location and regional dummies in the logwage  equation
// when using nearc4 as an IV for educ? 
reg iq nearc4 smsa66 reg661 reg662 reg668
// no they are nocorrelated























