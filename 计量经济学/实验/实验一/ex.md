>掌当解释变量为定性变量时，掌握如何用虚拟变量来描述定性变量解释变量；掌握虚拟变量的交互作用在回归模型中的使用。

## 题目要求
[abstracted from << Introductory Economerics >>chapter7 C7.6]

Use the data in SLEEP75.DTA for this exercise. The equation of interest is

(i) Estimate this equation separately for men and women and report the
results in the usual form. Are there notable differences in the two estimated
equations?

(ii) Compute the Chow test for equality of the parameters in the sleep equation
for men and women. Use the form of the test that adds male and
the interaction terms male	totwrk, …, male	yngkid and uses the full set
of observations. What are the relevant df for the test? Should you reject
the null at the 5% level?

(iii) Now allow for a different intercept for males and females and determine
whether the interaction terms involving male are jointly significant.

(iv) Given the results from parts (ii) and (iii), what would be your final
model?


## 求解
**翻译如下**
---

**摘自《Introductory Econometrics》第7章，习题C7.6**

使用SLEEP75.DTA数据集完成这个练习。感兴趣的方程是：

$$ \text{sleep} = \beta_0 + \beta_1 \text{totwrk} + \beta_2 \text{educ} + \beta_3 \text{age} + \beta_4 \text{age}^2 + \beta_5 \text{ynkid} + \mu $$

(i) 分别为男性和女性估计这个方程，并以通常的形式报告结果。在这两个估计方程中，是否存在显著的差异？
```{stata}
gen age2 = age^2
// male
reg sleep totwrk educ age age2 yngkid if male==1
// female
reg sleep totwrk educ age age2 yngkid if male==0
```
两个估计方程是否存在差异？这个应该是需要chow检验，但这里要求以通常形式报告即可，显然是有区别的。

(ii) 计算男性和女性在睡眠方程中参数相等性的Chow检验。使用添加了male（男性虚拟变量）以及交互项male×totwrk（男性×总工作时间），……，male×ynkid（男性×有无小孩）的检验形式，并使用全部观测值。该检验的相关自由度（df）是多少？你是否应该在5%的显著性水平下拒绝原假设？
```{stata}
gen maletotwrk = male*totwrk
gen maleeduc = male*educ
gen maleage = male*age
gen maleage2 = male*age2
gen maleyngkid = male*yngkid

reg sleep male totwrk educ age age2 yngkid maletotwrk maleeduc maleage maleage2 maleyngkid

test maletotwrk maleeduc maleage maleage2 maleyngkid male

* 方法2：使用chowtest命令（如果已安装）
chowtest sleep totwrk educ age agesq yngkid, group(male)
```
显著，拒绝原假设，即男女回归方程不一样

(iii) 现在允许男性和女性有不同的截距，并确定涉及male的交互项是否联合显著。
```{stata}
test maletotwrk maleeduc maleage maleage2 maleyngkid 
```
其原假设为所有交互项系数都为0，备择假设为至少一个交互项系数不为0
显然，不能拒绝原假设，即交互项在统计上不显著。也就是说这些变量对睡眠时间的影响在男性与女性之间没有显著差异。

(iv) 根据(ii)和(iii)部分的结果，你的最终模型是什么？
基于以上分析，我们不需要包含这些交互项，可以使用一个简单的模型
```{stata}
   reg sleep totwrk educ age agesq yngkid male
```