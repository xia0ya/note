> 明确用IVs(2SLS)估计联立方程时IVs满足的两个条件；掌握用2SLS估计联立方程。

## 题目要求
 [abstracted from《Introductory Econometrics A Modern Approach》J.M.Wooldridge, chapter 16 ]
 Use the data set in FISH.DTA ,which comes from Graddy(1995), to do this exercise. Now ,we will use it to estimate a demand function for fish.

(i)Assume that the demand equation can be written, in equilibrium for each time period,as

so that demand is allowed to differ across days of the week. Treating the price variable as endogenous, what additional information do we need to consistently estimate the demand-equation parameters?

(ii)The variable wave2t and wave3t, are measures of ocean wave heights over the past several days. What two assumptions do we need to make in order to use wave2t and wave3t as IVs for log(avgprct) in estimating the demand equation?

(iii)Regress log(avgprct) on the day-of-the-week dummies and the two wave measures. Are wave2t and wave3t,jointly significant? What is the p-value of the test?

(iv)Now, estimate the demand equation by 2SLS .What is the 95% confidence interval for the price elasticity of demand? Is the estimated elasticity reasonable?

(v)Obtain the 2SLS residuals,.Add a single lag ,,in estimating the demand equation by 2SLS.Remember, use , ,as its own instrument .Is there evidence of AR(1) serial correlation in the demand equation errors?

(vi)Given that the supply equation evidently depends on the wave variables, what two assumptions would we need to make in order to estimate the price elasticity of supply?

(vii)In the reduced form equation for log(avgprct),are the day-of- the-week dummies jointly significant? What do you conclude about being able to estimate the supply elasticity?

## 求解
**翻译如下**
1、(i) 假设需求方程可以为每个时间段写出如下形式的均衡方程：

$$
\log(\text{totqty}_t) = \alpha_1 \log(\text{avgprc}_t) + \beta_{10} + \beta_{11}\text{mon}_t + \beta_{12}\text{tues}_t + \beta_{13}\text{wed}_t + \beta_{14}\text{thurs}_t + u_{n1}
$$

这样需求就可以在一周的不同日子有所不同。将价格变量视为内生变量，为了一致地估计需求方程的参数，我们需要哪些额外的信息？
相关性 (Relevance): 至少有一个我们选择的工具变量与内生变量 (log(avgprc)) 在控制了外生解释变量后是相关的。
外生性 (Exogeneity) 或排除性约束 (Exclusion Restriction)

2、 变量 wave2 和 wave3 是过去几天的海浪高度测量值。为了在估计需求方程时使用 wave2 和 wave3 作为平均价格对数 (log(avgprc)) 的工具变量，我们需要满足哪两个假设？
相关性与外生性

3、以平均价格对数 (log(avgprc)) 为被解释变量，对其进行回归，解释变量包括星期几的虚拟变量和 wave2、wave3。wave2 和 wave3 是否联合显著？检验的 P 值是多少？
```{stata}
use FISH.DTA,clear
// 回归分析
reg lavgprc mon tues wed thurs wave2 wave3
// 联合显著性检验
test wave2 wave3
```

4、现在，使用两阶段最小二乘法 (2SLS) 估计需求方程。需求价格弹性的 95% 置信区间是多少？估计的弹性值合理吗？
```{stata}
ivregress 2sls ltotqty (lavgprc= wave2 wave3) mon tues wed thurs
```
在这个对数-对数模型中，log(avgprc) 的系数就是需求价格弹性的估计值。
查看回归结果表中 log(avgprc) 系数的 95% 置信区间。
弹性是否合理？ 从经济学理论上看，需求价格弹性通常是负数（价格越高，需求量越低）。对于多数商品，需求是富有弹性的（弹性绝对值大于 1）。所以，如果估计的弹性为负，且绝对值在合理范围内（例如在 0 到几之间），则认为是合理的。如果估计为正，或者绝对值异常大，可能表明 IV 估计存在问题（如弱工具变量）

5、(v) 获取2SLS残差。在估计需求方程时加入单个滞后项$$\hat{u}_{t-1,1}$$，记得使用$$\hat{u}_{t-1,1}$$作为它自己的工具变量。需求方程误差中是否有证据表明存在AR(1)序列相关？
```{stata}
ivregress 2sls ltotqty (lavgprc= wave2 wave3) mon tues wed thurs
predict uhat,r
tsset t
g luhat = L.uhat
ivregress 2sls ltotqty luhat (lavgprc= wave2 wave3) mon tues wed thurs
```
显著（P 值小于 0.05），则拒绝不存在 AR(1) 序列原假设，认为存在 AR(1) 序列相关的证据。

6、考虑到供给方程很可能取决于海浪变量（海浪影响捕鱼成本或数量）。为了估计供给的价格弹性，我们需要满足哪两个假设？

要使用 IV 方法估计供给方程（以 log(avgprc) 为被解释变量，log(totqty) 为内生变量，其他变量如星期几可能影响供给），我们需要找到影响需求曲线但不直接影响供给曲线（除了通过数量）的工具变量。这里的工具变量应该满足以下两个条件：
相关性： 至少有一个工具变量与内生变量 log(totqty) 在控制了外生解释变量后是相关的。
外生性 (排除性约束)： 这些工具变量在控制了供给方程中的其他外生解释变量后，不应直接影响鱼的供给量 (log(totqty))，也不应与供给方程的误差项相关。它们只能通过影响需求来间接影响数量。
在鱼市场这个例子中，影响消费者偏好或需求的变量（除了价格）可以作为估计供给方程的潜在工具变量。例如，可能影响当天鱼类需求的其他相关商品的价格，或者某些节日/季节性因素（如果未被星期几虚拟变量完全捕获）都可能是潜在的工具变量，前提是它们不直接影响鱼的捕捞或销售供给。
为了估算供给弹性，我们必须假设变量mon、tues、wed、thurs 不出现在供给方程中，但会出现在需求方程中。

7、在第三部分估计的以平均价格对数 (log(avgprc)) 为被解释变量的简化形式方程中，星期几的虚拟变量是否联合显著？根据这个结果，你对估计供给弹性有什么结论？
```{stata}
reg lavgprc mon tues wed thurs wave2 wave3
test mon tues wed thurs
```
由输出结果可知，F检验的p值为0.7134，大于0.05接受原假设，认为mon、tues、wed、thurs变量不联合显著。因此尽管这些变量出现在了需求方程中，但一旦引进 wave2 和 wave3 变量，它们就无法对 lavgprc产生显著影响