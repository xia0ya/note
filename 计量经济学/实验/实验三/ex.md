>当被解释变量是虚拟变量时，学会用Logistic model或Probit model进行估计，掌握似然比（LR）检验，学会解释模型的估计值

## 题目要求
[abstracted from << Introductory Economerics >>chapter17 C17.8]

The file JTRAIN2.dta ontains data on a job training experiment
for a group of men. Men could enter the program starting in January 1976 up through about mid-1977.The program ended in December 1977.The idea is to test whether participation in the job training program had an effect on unemployment probabilities and earnings in 1978. 

(i)The variable train is the job training indictor. How many men in the example participated in the job training program? What was the highest number of months a man actually participated in the program? (consider the variable mosinex).

(ii)Run a linear regression of train on several demographic and pretraining variables:unem74,unem75,age,educ,black,hisp,and married. Are these variables jointly significant at the 5% level?

(iii)Estimate a probit version of the linear model in part(ii).Compute the likelihood ratio test for joint significance of all variables .What do you conclude?

(iv) Run a simple regression of unem78 on train and report the results in equation form. What is the estimated effect of participating in the job training program on the probability of being unemployed in 1978? Is it statistically significant?

(v)Run a probit of unem78 on train .Does it make sense to compare the probit coefficient on train with the coefficient obtained from the linear model in part(v)?

(vi)Find the fitted probabilities from parts(v) and (vi).Explain why they are identical.
Which approach would you use to measure the effect and statistical significance of the job training program?

(vii)Add all of the variables from part(ii) as additional controls to the models from parts(v) and (vi).Are the fitted probabilities now identical? What is the correlation between them? 
## 求解
**翻译如下**
1、变量 train 表示是否参加了就业培训。样本中有多少人参加了培训？一个人实际参加培训的最长月数是多少？（参考变量 mosinex）
```{stata}
pwd
ls
use "jtrain2.dta",clear
desc

sum train, detail
sum mosinex if train == 1, detail

// 或者
* 计算参加培训的人数 (train == 1)
count if train == 1

* 找到 mosinex 的最大值
summarize mosinex, detail
```

2、以 train 为被解释变量，对其进行线性回归，解释变量包括：1974年是否失业 (unem74)、1975年是否失业 (unem75)、年龄 (age)、教育年限 (educ)、是否为黑人 (black)、是否为西班牙裔 (hisp) 以及是否已婚 (married)。这些解释变量在 5% 的显著性水平上是否联合显著？
```{stata}
* 估计线性回归模型
regress train unem74 unem75 age educ black hisp married

* 检验所有解释变量的联合显著性  // 这个实际上看F值也可以
test unem74 unem75 age educ black hisp married
```
这些变量在5%水平上不显著，甚至在15%水平上也不显著

**LR检验**
3、估计第二部分中线性模型的 Probit 模型版本。计算所有解释变量联合显著性的似然比检验（LR 检验）。你得出什么结论？
```{stata}
probit train unem74 unem75 age educ black hisp married
scalar ll_ur = e(ll)
probit train
scalar ll_r = e(ll)
scalar chi2 = -2 * (ll_r - ll_ur)
display chi2
display 1 - chi2tail(7, chi2)


// 法二
* 估计 Probit 模型
probit train
est store t
probit train unem74 unem75 age educ black hisp married
est store pr
// 该命令需要两个回归模型
lrtest t pr  
```
如果 P 值小于 0.05，则拒绝原假设，认为这些变量联合起来对参加培训的概率有显著影响。

4、 以 1978 年是否失业 (unem78) 为被解释变量，对 train 进行简单回归，并以方程形式写出回归结果。参加就业培训对 1978 年失业概率的估计效应是多少？这个效应在统计上显著吗？
```{stata}
* 对 unem78 进行简单回归
regress unem78 train
```

5、以 1978 年是否失业 (unem78) 为被解释变量，对 train 进行 Probit 回归。将 train 在线性回归结果（第四部分）中获得的系数与此处的 Probit 回归中 train 的系数进行比较是否有意义？
```{stata}
* 对 unem78 进行 Probit 回归
probit unem78 train
```
不建议直接比较线性回归和 Probit 回归中同一个变量的系数。线性回归中的系数代表的是被解释变量平均变化量，而 Probit 回归中的系数本身没有直接的边际效应解释，它反映的是自变量变化对潜在线性组合的影响。
要比较效应，通常需要计算 Probit 模型中的边际效应。对于二元解释变量 train，边际效应通常是计算当 train 从 0 变为 1 时，预测概率的变化。

**拟合概率**
6、求出第四部分（线性回归）和第五部分（Probit 回归）的拟合概率。解释为什么它们是相同的。你会使用哪种方法来衡量就业培训项目的影响和统计显著性？

```{stata}
// 第六问
reg unem78 train
* 第四部分（线性回归）后：
predict prob_linear, xb

probit unem78 train
* 第五部分（Probit 回归）后：
predict prob_probit, pr

est store linear
est store probit
esttab linear probit, se
```
为什么拟合概率相同？ 在只包含一个二元解释变量（train）的简单回归中，线性回归的拟合概率（即预测值）与 Probit 回归计算出的预测概率在数值上是相同的。这是因为线性回归在这种情况下估计的是 unem78 的条件均值，而对于二元变量，条件均值就是概率。 Probit 模型也是直接建模概率。当模型形式非常简单时，两者的预测结果会一致。

7、将第二部分中的所有变量（unem74, unem75, age, educ, black, hisp, married）作为额外的控制变量，分别添加到第五部分（Probit on train）和第四部分（Linear on train）的模型中。现在第四部分和第五部分的拟合概率还相同吗？它们之间的相关性是多少？
```{stata}
* 添加控制变量到第四部分的线性回归模型
regress unem78 train unem74 unem75 age educ black hisp married
predict prob_linear_controlled, xb

* 添加控制变量到第五部分的 Probit 回归模型
probit unem78 train unem74 unem75 age educ black hisp married
predict prob_probit_controlled, pr

* 比较拟合概率，计算相关性
correlate prob_linear_controlled prob_probit_controlled
```
拟合概率是否相同？ 当加入额外的控制变量后，线性概率模型 (LPM) 和 Probit 模型的拟合概率通常不再完全相同。虽然它们仍然是估计概率，但由于模型的函数形式不同（LPM 是线性的，Probit 是 S 形曲线），在包含多个解释变量时，它们的预测值会开始有所差异。
相关性： 尽管拟合概率不再完全相同，但它们通常会高度相关