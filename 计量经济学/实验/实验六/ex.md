> 掌握二阶段最小二乘法的估计。

## 题目要求
[abstracted from《Econometric Analysis of Cross Section and Panel Data》 J.M.Wooldridge, MIT, chapter 4 problems 5.4]
 Use the data in CARD. DTA for this problem.

a. Estimate a logwage equation by OLS with educ, exper, exper2, black, south,
smsa, reg661 through reg668, and smsa66 as explanatory variables.

b. Estimate a reduced form equation for educ containing all explanatory variables
from part a and the dummy variable nearc4. Do educ and nearc4 have a practically
and statistically significant partial correlation? 

c. Estimate the logwage equation by IV, using nearc4 as an instrument for educ.
Compare the 95 percent confidence interval for the return to education with that
obtained from part a.

d. Now use nearc2 along with nearc4 as instruments for educ. First estimate the
reduced form for educ, and comment on whether nearc2 or nearc4 is more strongly
related to educ. How do the 2SLS estimates compare with the earlier estimates?

e. For a subset of the men in the sample, IQ score is available. Regress iq on nearc4.
Is IQ score uncorrelated with nearc4?

f. Now regress iq on nearc4 along with smsa66, reg661, reg662, and reg668. Are iq
and nearc4 partially correlated? What do you conclude about the importance of
controlling for the 1966 location and regional dummies in the logwage  equation
when using nearc4 as an IV for educ? 

## 求解
**翻译如下**
1、使用普通最小二乘法 (OLS) 估计工资对数 (logwage) 的方程，解释变量包括教育年限 (educ)、工作经验 (exper)、工作经验的平方 (exper²)、是否为黑人 (black)、是否在美国南方 (south)、是否在大都市区 (smsa)、1966年的区域虚拟变量 (reg661 到 reg668)，以及1966年是否在大都市区 (smsa66)。
```{stata}
use "card.dta",clear
reg lwage educ exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66
```
2、估计一个以教育年限 (educ) 为被解释变量的简化形式方程，解释变量包括部分 a 中的所有解释变量以及虚拟变量 nearc4（居住地附近是否有四年制大学）。educ 和 nearc4 在控制了其他变量后，是否具有实际意义上的相关性，以及统计上显著的部分相关性？
```{stata}
reg educ nearc4 reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66
```
统计上显著的部分相关性： 查看 nearc4 的 P 值。如果 P 值小于 0.05，则认为在控制了其他变量后，nearc4 与 educ 之间存在统计上显著的相关性。这是工具变量有效性的一个重要条件（工具变量与内生变量相关）。
实际意义上的相关性： 查看 nearc4 的系数大小。系数的绝对值越大，表明 nearc4 每变化一个单位，educ 平均变化越多，这意味着 nearc4 对 educ 的影响越强。你需要根据系数的大小来判断这种相关性在实际中是否“显著”，即它是否能解释 educ 变异中相当一部分。通常，较大的 t 统计量（P 值小）和较大的系数绝对值都支持较强的实际相关性。

3、使用工具变量 (IV) 方法估计工资对数 (logwage) 的方程，使用 nearc4 作为教育年限 (educ) 的工具变量。将通过 IV 估计得到的教育回报率的 95% 置信区间与部分 a 中 OLS 估计得到的教育回报率的 95% 置信区间进行比较。
```{stata}
ivreg lwage  (educ = nearc4)  exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66,first

ivreg lwage (educ = nearc4 ) exper expersq black smsa south smsa66 reg662-reg669
estimates store iv
reg lwage educ exper expersq black smsa south smsa66 reg662-reg669
estimates store ols
estimates table iv ols, star
```
4、现在同时使用 nearc2（居住地附近是否有两年制大学）和 nearc4 作为教育年限 (educ) 的工具变量。首先估计以 educ 为被解释变量的简化形式方程，并评论 nearc2 和 nearc4 哪个与 educ 的相关性更强。使用这两个工具变量进行 2SLS 估计，结果与之前仅使用 nearc4 作为工具变量的估计相比如何？
```{stata}
ivreg lwage  (educ = nearc4 nearc2)  exper expersq black south smsa reg661 reg662 reg663 reg664 reg665 reg666 reg667 reg668 smsa66,first
```

5、对于样本中的一部分男性，智商分数 (iq) 是可用的。以 iq 为被解释变量，对 nearc4 进行回归。IQ 分数与 nearc4 是否不相关？
```{stata}
* 估计 iq 对 nearc4 的回归（只使用 IQ 分数可用的子集）
regress iq nearc4
```

6、现在以 iq 为被解释变量，对其进行回归，解释变量包括 nearc4 以及 smsa66、reg661、reg662 和 reg668。在控制了这些位置和区域虚拟变量后，iq 和 nearc4 是否仍然部分相关？当你使用 nearc4 作为教育年限 (educ) 的工具变量时，根据这个结果，你对在 logwage 方程中控制 1966 年的位置和区域虚拟变量的重要性有什么结论？
```{stata}
* 估计 iq 对 nearc4 和位置/区域虚拟变量的回归
regress iq nearc4 smsa66 reg661 reg662  reg668
```
 如果在控制了 1966 年位置和区域变量后，nearc4 与 iq 之间的相关性消失或显著减弱（如 P 值变得不显著），这表明 nearc4 可能主要是通过与这些位置/区域特征相关联来影响 iq。由于这些位置/区域特征也可能直接影响工资（例如通过劳动力市场条件），因此在 IV 估计 logwage 方程时，控制这些 1966 年的位置和区域虚拟变量是非常重要的。这样做有助于确保 nearc4 只有通过影响 educ 来间接影响 logwage（工具变量有效性的排除性约束），而不是通过与影响 logwage 的遗漏变量（如由出生地决定的能力，可能与 iq 相关且与靠近大学相关）相关联。如果在不控制这些变量的情况下使用 nearc4 作为 IV，IV 估计可能会因工具变量的外生性被违反而产生偏误。

 在对数工资方程中控制1966年的地理位置和地区虚拟变量的作用主要是为了反映地理位置对收入的影响，通过引入这些虚拟变量，可以观察不同地区或不同地理位置的工资是否存在差异，可以更准确地估计其他解释变量对工资的影响。