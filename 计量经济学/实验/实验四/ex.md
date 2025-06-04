>学会托比模型估计的估计，学会解释模型的估计值。

## 题目要求
[abstracted from << Introductory Economerics >>chapter17 C17.9]
Use the data in  APPLE. dta  for this exercise.
These are telephone survey data attempting to elicit the demand for a (fictional) “ecological friendlly” apple. Each family was (randomly) presented with a set of prices for regular apples and the eco-labeled apples. They were asked how many ponds of each kind of apple they would buy.

(i)Of  the 660 families in the sample ,how many report wanting none of the eco-labeled apples at the set price?

(ii)Does the variable ecolbs seem to have a continuous distribution over strictly positive values? What implications does your answer have for the suitability of Tobit model for ecolbs?

(iii)Estimate a Tobit model for ecolbs with ecoprc,regprc,faminc,and hhsize as explanatory variables. Which variables are significant at the 1%level? 

 (iv)Are the signs of the coefficients on the price variables from part (iii) what you expect?Explain. 

(v)Let  be the coefficient on ecoprc and let  be the coefficient on regprc.
Test the hypothsis H0:  against the two-sided alternative. Report the p-value of the test.(You might use stata command: lincom)

 (vi)Obtain the estimates of E(ecolbs|x) for all observations in the sample. Call these
.What are the smallest and largest fitted values?

(vii) Compute the squared correlation between ecolbsi and .

(viii)Now, estimate a linear model for ecolbs using the same explanatory variables from part (iii) .Why are the OLS estimates so much smaller than  the linear model?

(ix)Evaluate the following statement :“Since the R-square from the Tobit model is so small, the  estimated price effects are probably inconsistent.”

(x)Evaluate the following statement:“Because the R-squared from the Tobit model is so small, the estimated price effects are probably inconsistent. ”

## 求解
**翻译如下**
1、在样本的 660 个家庭中，有多少家庭表示在给定的价格下不想购买任何生态标签苹果？

```{stata}
ls
use "apple.dta",clear
desc
count if ecolbs == 0
```

2、变量 ecolbs 是否呈现出一个仅包含严格正值的连续分布？你的回答对于使用 Tobit 模型分析 ecolbs 有何影响？
```{stata}
* 查看 ecolbs 的描述性统计量，特别是最小值
summarize ecolbs

* 绘制 ecolbs 的直方图（可能需要调整 bins）
histogram ecolbs

* 查看 ecolbs > 0 的观测值数量
count if ecolbs > 0
```
运行 summarize ecolbs，检查最小值。如果最小值是 0，说明存在不购买的情况。
运行 count if ecolbs == 0，如果这个数量大于 0，并且相当一部分观测值等于 0，那么 ecolbs 就不是一个严格大于零的连续分布。
启示： Tobit 模型适用于因变量是“删截”（censored）的情况，即因变量在某个点（通常是 0）处存在大量的聚集值，而在其他地方是连续的。如果 ecolbs 存在大量的 0 值，那么它就符合 Tobit 模型的应用场景。Tobit 模型能够处理因变量的这种非负性限制（不能购买负数量的苹果），并区分决定是否购买（在 0 处）和决定购买多少（大于 0 时）这两个过程。如果 ecolbs 都是严格正数，那么 Tobit 模型可能就不适用，直接使用 OLS 可能更合适（或者其他适用于连续正值的方法，如对数转换）。

3、估计一个以 ecolbs 为被解释变量的 Tobit 模型，解释变量包括生态标签苹果价格 (ecoprc)、普通苹果价格 (regprc)、家庭收入 (faminc) 和家庭规模 (hhsize)。哪些变量在 1% 的显著性水平上是显著的？
```{stata}
* 估计 Tobit 模型，下限为 0
tobit ecolbs ecoprc regprc faminc hhsize, ll(0)
```
tobit 命令用于估计 Tobit 模型。ll(0) 指定因变量的下限是 0。

4、第三部分中生态标签苹果价格 (ecoprc) 和普通苹果价格 (regprc) 系数的符号是否符合你的预期？请解释原因。

对 ecoprc 系数的预期： 生态标签苹果本身的价格 (ecoprc) 应该与需求量 (ecolbs) 呈负相关。根据需求定律，一种商品的价格越高，其需求量通常越低（假设其他条件不变）。所以预期 ecoprc 的系数为负。
对 regprc 系数的预期： 普通苹果和生态标签苹果是替代品。如果普通苹果的价格 (regprc) 上升，消费者可能会转而购买相对便宜的生态标签苹果，从而增加生态标签苹果的需求量。所以预期 regprc 的系数为正。

5、 设 β₁ 是 ecoprc 的系数，β₂ 是 regprc 的系数。检验原假设 H₀: -β₁ = β₂，备择假设为双侧检验（即 H₁: -β₁ ≠ β₂）。报告检验的 p 值。（提示：可以使用 Stata 命令 lincom）
```{stata}
tobit ecolbs ecoprc regprc faminc hhsize, ll(0)
lincom ecoprc + regprc
lincom -_b[ecoprc] - _b[regprc] // 两命令除了符号不一致，其他都一样
```
这个 P 值就是检验 H₀: -β₁ = β₂ 的结果。如果 P 值小于 0.05，则拒绝原假设。

6、计算样本中所有观测值在给定解释变量条件下的期望值 $E(ecolbs|x)$的估计值。将这些估计值命名为 $\hat{ecolbs}$ 这些拟合值的最小值和最大值是多少？
```{stata}
tobit ecolbs ecoprc regprc faminc hhsize, ll(0)
predict ecolbs_hat, xb
sum ecolbs_hat, detail
```

7、计算 ecolbs 和 $\hat{ecolbs}i$ 之间的平方相关系数。
```{stata}
gen ecolbs2 = ecolbs^2
gen ecolbs_hat2 = ecolbs_hat^2
corr ecolbs ecolbs_hat
```

8、现在，使用与第三部分相同的解释变量，对 ecolbs 估计一个线性回归模型（OLS）。为什么 OLS 的估计值比 Tobit 模型的估计值小得多

```{stata}
* 估计线性回归模型
regress ecolbs ecoprc regprc faminc hhsize
```
为什么 OLS 估计值会小？ 当因变量在某个点被删截（如这里的 0）时，OLS 估计是有偏的且不一致。具体来说，由于 OLS 没有考虑因变量不能取负值的限制，它会被大量的 0 值“拉低”。OLS 估计的是 E(ecolbs∣x)E(ecolbs∣x)，但它没有正确处理因变量在 0 处的概率质量。Tobit 模型通过最大似然估计，考虑了这种删截特性，因此它对解释变量的效应估计通常会比简单的 OLS 估计更大（在绝对值意义上），尤其是在影响购买概率和购买数量的变量上。OLS 混淆了不购买（ecolbs=0）和购买少量这两种情况。Tobit 模型则能更好地估计解释变量对潜在购买量（即使观察到的是 0）的影响。

9、评估以下陈述：“因为 Tobit 模型的 R 方很小，所以估计的价格效应可能是不一致的。

评估陈述： 这个陈述是错误的。
解释：
Tobit 模型的“R 方”概念与 OLS 的 R2R 2不同，它通常不是解释因变量总变异的比例。Tobit 模型的拟合优度衡量（如伪 R 方或通过平方相关系数计算）通常比 OLS 的 R2R 2  要低，这是正常的，尤其是在数据中存在大量 0 值的情况下。
模型估计量的一致性是一个大样本性质，取决于模型的设定是否正确以及估计方法是否恰当。Tobit 模型是处理删截因变量的一致估计方法，前提是模型的潜在部分是正确指定的（例如，潜在误差项是正态分布的）。OLS 在处理删截因变量时是不一致的。
因此，Tobit 模型的“R 方”大小与估计量的一致性没有直接关系。即使“R 方”很小，如果 Tobit 模型设定正确，其估计量仍然是一致的。小“R 方”可能仅仅表示模型解释因变量变异的能力有限，或者数据的内在随机性很大。