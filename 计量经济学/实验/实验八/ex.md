> 掌握面板数据的固定效应模型，随机效应模型的估计。对于面板数据的3种估计方法：POOLED OLS,FE,RE，如何在其中的两种方法中进行选择。主要掌握LMtest和Hausman test.

# 题目要求
## 第一题

 [abstracted from《Introductory Econometrics A Modern Approchg》J.M.Wooldridge, chapter 14 C14. 9]
Use the data in wagepan.dta for this exercise.
(i)Estimate the model 
by pooled OLS, and report the estimates and standard errors in the usual form. 

(ii)Estimate the model from part (i) by random effects (thinking that ).How do the RE and pooled OLS estimators of  compare?

(iii)	Are the RE and pooled OLS standard errors the same? Which ones are more reliable, and 

## 第二题
 [abstracted from《Introductory Econometrics A Modern Approach》(3rdJ.M.Wooldridge, chapter 14 C14. 10]
Use the data in airfare.dta for this exercise. We are interested in estimating the model

Where  means that we allow for different year intercepts.[Hint: y98,y99,y00]

(i)Estimate the above equation by pooled OLS, being sure to include year dummies. If ,what is the estimated percentage increase in fare?

(ii)What is the usual OLS 95% confidence interval for ? Why is it probably not reliable? If you have access to a statistical package that computes fully robust standard error, find the fully robust 95% CI for . Compare it to the usual CI and comment.

(iii)Describe what is happening with the quadratic in log(dist). In particular, for what values of dist does the relationship between log(fare) and dist become positive? [Hint:: First figure out the turning point value for log(dist), and exponentiate .]Is the turning point outside the range of the data?

(iv)Now estimate the equation using random effects. How does the estimate of  change?

(v) Now estimate the equation using fixed effects. What is the  FE estimate of ? Why is it fairly similar to the RE estimate? [Hint:: What is  for RE estimation?]

# 求解
**翻译如下**
## 实验题目一：
[摘自《Introductory Econometrics A Modern Approach》J.M.Wooldridge, chapter 14 C14.9]
使用数据集wagepan.dta进行这个练习。

(i) 估计模型

$$
lwage_{it} = \beta_0 + \beta_1 educ_{it} + \beta_2 black_{it} + \beta_3 hisp_{it} + \gamma_{it}
$$

通过合并OLS估计，并以通常形式报告估计值和标准误。
```{stata}
* use wagepan.dta, clear
* 估计 Pooled OLS 模型
regress lwage educ black hisp
```

(ii) 从部分(i)通过随机效应估计模型（假设 $$v_{it} = \alpha_i + u_{it}$$）。RE和合并OLS估计的$$\beta_j$$如何比较？
```{stata}
* 设置面板数据
xtset id year

* 使用随机效应估计模型
xtreg lwage educ black hisp, re
```
(iii) RE和合并OLS标准误是否相同？哪些更可靠，为什么？
标准误不同。我们可以用LM Test检验哪一个估计方法更好

```{stata}
xttest0
```
---

## 实验题目二：
[摘自《Introductory Econometrics A Modern Approach》(第3版)J.M.Wooldridge, chapter 14 C14.10]
使用数据集airfare.dta进行这个练习。我们有兴趣估计模型

$$
\log(fare_{it}) = \theta_t + \beta_1 concen_{it} + \beta_2 \log(dist_{it}) + \beta_3 (\log(dist_{it}))^2 + \alpha_i + u_{it}, t = 1, ..., 4.
$$

其中 $$\theta_t$$ 意味着我们允许不同的年份截距。[提示：y98.y99.y00]

(i) 通过合并OLS估计上述方程，确保包括年份虚拟变量。如果 $$\Delta concen = .10$$，那么估计的票价百分比增加是多少？
```{stata}
use "airfare.dta",clear
reg lfare concen ldist ldistsq y98 y99 y00
```
β 1=0.36，如果△concen =.10，那么△log（fare）=0.36*0.10=0.036，即票价提高
3.6%

(ii) $$\beta_1$$ 的通常OLS 95%置信区间是什么？为什么它可能不可靠？如果您有访问计算完全稳健标准误差的统计包，找到 $$\beta_1$$ 的完全稳健95%置信区间。将其与通常的CI进行比较并评论。
```{stata}
reg lfare concen ldist ldistsq y98 y99 y00, robust
```
OLS 95%置信区间不可靠的原因是可能回归方程中误差项会存在异方差或解释变量与误差项不自相关

(iii) 描述log(dist)的二次项发生了什么。特别是，对于哪些dist值，log(fare)和dist之间的关系变为正？[提示：首先找出log(dist)和exponentiate的转折点值。] 转折点是否在数据范围之外？

Log(fare)和log(dist)之间是开口向上的二次型，当log(dist）小于4.37时，log(fare)随之增大而减小。

(iv) 现在使用随机效应估计方程。$$\beta_1$$ 的估计值如何变化？
```{stata}
* 设置面板数据 (假设个体是 route 或 pair of airports)
* 你需要知道数据集中哪个变量代表个体（例如 route），假设是 routeid
xtset routeid year
xtreg lfare concen ldist ldistsq y00 y99 y98,re
```
beta发生了改变，但是显著性未发生改变

(v) 现在使用固定效应估计方程。$$\beta_1$$ 的FE估计值是多少？为什么它与RE估计值相当相似？[提示：RE估计的$$\hat{\lambda}$$是什么？]
```{stata}
xtreg lfare concen ldist ldistsq y00 y99 y98,fe
est store fe
xtreg lfare concen ldist ldistsq y00 y99 y98,re theta
est store re
hausman fe re
```
为什么与 RE 相似？ 在随机效应模型中，估计量是 Pooled OLS 估计量和固定效应估计量的一个加权平均，权重取决于 λ。λ 衡量了个体特定异质性方差在总残差方差中所占的比例。
λ = 0 时，RE 估计量等于 Pooled OLS 估计量。
λ = 1 时，RE 估计量等于 FE 估计量。
λ 介于 0 和 1 之间。
在 xtreg, re 的输出中，会报告 λ 的估计值。如果 λ 的估计值接近 1，那么 RE 估计量就会非常接近 FE 估计量。RE 估计量接近 FE 估计量通常发生在个体特定效应 $\alpha_i$
在总变异中占比较大，或者解释变量在个体内部随时间的变化（within-variation）相对较少的情况下。
因此，如果 FE 估计值与 RE 估计值相似，很可能是因为 λ 的估计值接近 1，表明 RE 估计量给了 FE 部分较大的权重，或者因为数据中的 within-variation 占比较小。