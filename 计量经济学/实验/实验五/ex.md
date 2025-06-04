>掌握准最大似然估计（QMLE)，学会用泊松回归模型进行估计，学会解释模型的估计值。

## 题目要求
[abstracted from << Introductory Economerics >>chapter17 C17.10]
Use the data SMOKE.dta for this exercise.

(i)The variable cigs is the number of cigarettes smoked per day. How many people in the sample do not smoke at all? What fraction of people claim to smoke 20 cigarettes a day ?Why do you think there is a pileup of people at cigarettes?

(ii)Given your answer to part(i) ,does cigs seem a good candidate for having a conditional poisson distribution?

(iii)Estimate a poisson regression model for cigs, 
including log(cigpric),log(income),white,educ,age,and age2  
as explanatory variables.What are the estimated price and income elasticities?

(iv)Using the maximum likelihood standard errors, are the price and income variables statistically significant at 5% level?

(v)Obtain the estimate of  described after equation.What is How should you adjust the standard errors from part(iv)?

(vi)Using the adjusted standard errors from part(v), are the price and income elasticities now statistically different from zero? Explain.

(vii)Are the education and wage variables significant using the more robust standard errors? How do you interpret the coefficient on educ?

(viii)Obtain the fitted values , , from the Poisson regression model.Find the minimum and maximum values and discuss how well the exponential model predicts heavy cigarette smoking .

(ix)Using the fitted values from part(viii),obtain the squared correlation coefficient between and yi.

(x)Estimate a linear model for cigs by OLS, using the explanatory variables(and same functional forms) as in part(iii).Does the linear model or exponential model provide a better fut? Is either R-squared very large?

## 求解
**翻译如下**
1、 变量 cigs 表示每天吸烟的支数。样本中有多少人完全不吸烟？声称每天吸 20 支烟的人占总样本的比例是多少？你认为为什么吸烟支数会在 20 支这个数值上聚集？
```{stata}
use "SMOKE.dta",clear
count if cigs == 0
count if cigs == 20
```
聚集在 20 支的原因：
整包或整盒： 许多香烟以 20 支一包或一盒出售，人们可能习惯于报告他们吸了“一包”而不是精确的支数。
报告习惯/方便性： 报告一个整数，特别是常见的单位（如 20），比报告精确数字更方便。
四舍五入/估算： 人们可能不会精确计算每天吸的每一支烟，而是估算一个大概数字，20 可能是一个常用的估算值。
社会期望： 在某些情况下，报告 20 支可能是一个社会可接受的或常见的数字，尽管实际可能略多或略少。

2、根据你对第一部分的回答，你认为 cigs 变量适合使用条件 Poisson 分布来建模吗？

尽管 cigs 是计数数据，但其分布特征（特别是大量的零和聚集，可能导致过度分散）表明标准的 Poisson 模型可能不是数据的完美拟合模型。过度分散会使得标准的 Poisson 回归估计量的标准误被低估，导致 t 统计量偏高，从而夸大统计显著性。因此，虽然 Poisson 模型是计数数据的一个起点，但考虑到 cigs 的分布特点，它可能不是一个“好”候选，或者说使用时需要注意过度分散的问题，例如使用泊松回归的稳健标准误或改用负二项回归等模型。

3、 估计一个以每天吸烟支数 (cigs) 为被解释变量的 Poisson 回归模型，解释变量包括香烟价格的对数 (log(cigpric))、收入的对数 (log(income))、是否为白人 (white)、教育年限 (educ)、年龄 (age) 和年龄的平方 (age²)。估计的价格弹性和收入弹性是多少？
```{stata}
poisson cigs lcigpric lincome white educ age agesq 
```
lcigpric 的系数就是香烟价格弹性，lincome 的系数就是收入弹性。
查看 poisson 回归结果表中 lcigpric 和 lincome 的系数估计值，这些就是对应的弹性估计值。

4、 使用最大似然估计得出的标准误，香烟价格和收入变量在 5% 的显著性水平上是否统计显著

5、获得方程后描述的 σ² 的估计值。σ² 是什么？你应该如何调整第四部分得到的标准误？
```{stata}
poisson cigs lcigpric lincome white educ age agesq ,nolog
predict hat 
gen res = cigs-hat
gen ressq = res^2
gen a = ressq/hat
tabstat a,statistics(sum)
di 16484.84/(807-6-1)
di 20.60605^0.5
```

6、 使用第五部分调整后的标准误，香烟价格和收入弹性现在在统计上是否与零有显著差异？请解释原因。
```{stata}
poisson cigs lcigpric lincome white educ age agesq,robust
```
如果在部分 (iv) 中，价格或收入是显著的，但在部分 (vi) 中使用稳健标准误后变得不显著，这表明过度分散导致了原先的标准误被低估，夸大了显著性。稳健标准误提供了对系数真实变异性的更可靠估计，即使模型存在过度分散，基于稳健标准误的推断也是有效的（在大样本下）。

7、使用更稳健的标准误，教育年限 (educ) 变量是否显著？你如何解释 educ 的系数？
```{stata}
poisson cigs lcigpric lincome white educ age agesq,robust
```
educ 系数的解释： 在 Poisson 回归中，解释变量的系数代表它对因变量对数期望值的影响。具体来说，educ 的系数 β_educ 表示在其他变量保持不变的情况下，教育年限每增加一年，cigs 的期望值会改变 $exp(β_educ)−1$ 的比例，或者说大约改变 
 $β_edc×100%$ 如果 $β_educ$ 是负的且显著，说明教育年限越多，期望的吸烟支数越少。

8、获得 Poisson 回归模型的拟合值 $\hat{\mu}i$ 。找出最小值和最大值，并讨论指数模型预测重度吸烟者的能力如何。
```{stata}
poisson cigs lcigpric lincome white educ age agesq ,nolog
predict hat 
sum hat
```
查看拟合值的最大值。重度吸烟者可能每天吸 20 支、40 支甚至更多。如果拟合值的最大值远小于这些实际观测到的最大值，说明模型在预测吸烟量大的个体时可能表现不佳。Poisson 模型预测的期望值通常相对较小，因为它假设方差等于均值，这在存在重度吸烟者导致方差很大的情况下可能限制了其预测大数值的能力。过度分散是另一个可能导致模型低估高计数值的原因。

9、使用部分 (viii) 的拟合值 $\hat{\mu}i$ 和实际值 $cigs_i$，计算它们之间的平方相关系数。
```{stata}
corr hat cigs
```

10、使用与第三部分相同的解释变量（以及相同的函数形式，例如也包含 log 转换和平方项），使用 OLS 估计以 cigs 为被解释变量的线性模型。线性模型（OLS）和指数模型（Poisson 模型）哪个提供更好的拟合？任一模型的 R 方都非常大吗？

```{stata}
* 估计线性回归模型（OLS）
regress cigs log_cigpric log_income white educ age age_sq
```
模型比较：

从理论上讲，对于计数数据，**Poisson 模型**（或考虑过度分散的负二项模型）比 **OLS** 更合适，因为 Poisson 模型考虑了因变量的非负整数性质以及通常的非线性关系 $log(E[cigs \mid x])$。OLS 可能会预测负的吸烟支数，并且没有正确处理方差结构。

从拟合优度上看，可以比较两个模型的平方相关系数（类似于 $R^2$ ）。第八部分和第九部分计算了 Poisson 模型的平方相关系数。运行 OLS 回归后，直接查看 OLS 回归输出中的 $R^2$ 或计算 `cigs` 与 OLS 拟合值之间的平方相关系数（`predict cigs_ols_hat, xb` 后 `correlate cigs cigs_ols_hat`）。

比较两个模型的平方相关系数，数值更大的模型在描述因变量变异方面可能表现更好。然而，需要记住理论上的适用性也很重要。

$ R^2 $大小：

查看 OLS 回归的 $R^2 $ 以及第九部分计算的 Poisson 模型的平方相关系数。对于个体层面的微观数据，通常模型的 $ R^2 $ 或类似的拟合优度衡量不会非常大，因为个体行为的随机性很大，模型难以解释所有的变异。所以预期两个模型的$ R^2 $ 都不会非常大。