>学会用虚拟变量进行项目评价分析；理解Chow 检验的本质，掌握Chow 检验的方法，并体会其局限性；掌握用Stata产生多分类变量的虚拟变量的使用技巧；掌握Stata的bysort和regress相结合使用来估计不同组的回归方程。通过此题体会Stata的优越性。

## 题目要求
Use the data in 401KSUBS. DTA for this exercise.

(i)Compute the average, standard deviation, minimum ,and maximum values of nettfa in the sample.

(ii)Test the hypothesis that average nettfa does not differ by 401(k) eligibility status; use a two-sided alternative .What is the dollar amount of the estimated difference?
[Hint: regress nettfa on e401k]

(iii) Estimate a multiple linear regression model for nettfa that includes inc, age, and e401k as explanatory variables. The inc and wage variables should appear as quadratics. Now ,what is the estimated dollar effect of 401(k) eligibility.

(iv)To the model estimated in part(iii) ,add the interactions e401k*(age-41) and e401k*(age-41)2.Note that the average age in the sample is about 41,so that in the new model ,the coefficient on e401k is the estimated effect of 401(k) eligibility at the average age. Which interaction term is significant?

(v)Comparing the estimates from parts(iii) and (iv) ,do the estimated effects of e401(k ) eligibility at age 41 differ much? Explain.

(vi)Now, drop the interaction terms from the model ,but define five family size dummy variables:fsize1,fsize2,fsize3,fsize4 and fsize5.The variable fsize5 is unity for families with five or more members. Include the family size dummies in the model estimated from part(iii) ;be sure to close a base group .Are the family dummies significant at 1%level? 

(vii)Now, do a Chow test for the model 

across the five family size categories ,allowing for intercept differences. The restricted 
sum of squared residuals, SSRr ,is obtained from part(vi) because that regression assumes all slopes are the same. The unrestricted sum of squared residuals is
,wher SSRf is the sum of squared residuals for equation estimated using only family size f. You should convince yourself that there are 30 parameters in the unrestricted model(five intercepts plus 25 slopes)
and 10 parameters in the unrestricted model(five intercepts plus 5 slopes).
Therefore, the number of restrictions being tested is q=20,and the df for the  unrestricted model is 9275-30=9245.

## 求解
**翻译如下**

使用 401KSUBS.DTA 数据进行以下练习。
(i) 计算样本中 nettfa 的平均值、标准差、最小值和最大值。
翻译： 计算净金融资产（nettfa）在样本中的平均值、标准差、最小值和最大值。
```{stata}
* 确保你已经加载了数据
* use 401KSUBS.DTA, clear
* 计算 nettfa 的描述性统计量
summarize nettfa
```

2、检验净金融资产（nettfa）的平均值是否因是否拥有 401(k) 资格而有显著差异；使用双侧检验。估计的差异金额是多少？[提示：用 nettfa 对 e401k 进行回归]
```{stata}
* 使用 regress 命令进行 t 检验（e401k 是一个二元变量）
regress nettfa e401k
```
regress nettfa e401k 命令实际上是在进行一个两独立样本 t 检验，比较 e401k=1 组（有资格）和 e401k=0 组（无资格）的 nettfa 平均值。
e401k 的系数估计值就是两组 nettfa 平均值的差异金额。
**原假设，无差异**

3、估计一个以净金融资产（nettfa）为被解释变量，以收入（inc）、年龄（age）和 401(k) 资格（e401k）为解释变量的多元线性回归模型。收入和年龄变量应包含二次项。现在，401(k) 资格的估计美元效应是多少？
```{stata}
reg nettfa inc incsq age agesq e401k
```

4、 在第三部分估计的模型中，加入交互项 e401k*(age-41) 和 e401k*(age-41)^2。请注意，样本中的平均年龄约为 41 岁，因此在新模型中，e401k 的系数代表在平均年龄下 401(k) 资格的估计效应。哪个交互项是显著的？
交互项显著问题，首先构建包含交互项的模型，然后，检验交互项的联合显著性
```{stata}
* 生成 age 减去平均年龄的变量
gen ageminus_41 = age - 41

* 生成交互项
gen e401k_ageint = e401k * ageminus_41
gen e401k_agesq_int = e401k * (ageminus_41)^2

* 估计包含交互项的模型
regress nettfa inc incsq age agesq e401k e401k_ageint e401k_agesq_int

* 检验交互项的联合显著性（可选，但通常也需要）
test e401k_ageint e401k_agesq_int
```
原假设是不显著，即所有交互项系数都为0

5、比较第三部分和第四部分的估计结果，401(k) 资格在 41 岁时的估计效应差异大吗？请解释原因。

在模型 (iii) 中，e401k 的系数代表 401(k) 资格对 nettfa 的平均效应，不区分年龄。
在模型 (iv) 中，e401k 的系数代表 401(k) 资格在年龄为 41 岁时对 nettfa 的效应。
比较这两个系数的数值。如果交互项 e401k_ageint 和 e401k_agesq_int 在模型 (iv) 中不显著，那么在 41 岁时 e401k 的效应在模型 (iv) 中会与模型 (iii) 中的 e401k 系数接近。如果交互项显著，则两者可能会有较大差异。
原因在于模型 (iv) 允许 401(k) 资格对 nettfa 的影响随着年龄变化而变化，而模型 (iii) 假设这种影响是固定的。

6、现在，从模型中删除交互项，但定义五个家庭规模的虚拟变量：fsize1, fsize2, fsize3, fsize4 和 fsize5。变量 fsize5 对于家庭成员数大于等于五的家庭取值为 1。在第三部分估计的模型中包含这些家庭规模的虚拟变量；请务必省略一个基准组。家庭虚拟变量在 1% 的显著性水平下是否显著？

**tabulate class,gen(c)//一次性定义虚拟变量**
```{stata}
* 首先，根据家庭规模变量（假设为 family_size 或类似名称）生成虚拟变量
* 你可能需要根据实际数据中的家庭规模变量来创建这些虚拟变量。
* 假设原始数据中有变量 'fam_size' 表示家庭成员数量
gen fsize1 = (fam_size == 1)
gen fsize2 = (fam_size == 2)
gen fsize3 = (fam_size == 3)
gen fsize4 = (fam_size == 4)
gen fsize5 = (fam_size >= 5)

* 估计包含家庭规模虚拟变量的模型，排除一个基准组（例如 fsize1）
regress nettfa inc incsq age agesq e401k fsize2 fsize3 fsize4 fsize5

* 检验家庭规模虚拟变量的联合显著性
test fsize2 fsize3 fsize4 fsize5
```
在回归中包含虚拟变量时，需要省略一个作为基准组，否则会存在完全多重共线性。这里我们省略了 fsize1，因此所有虚拟变量的系数都是相对于家庭规模为 1 的家庭。
查看 test fsize2 fsize3 fsize4 fsize5 命令的输出。如果 P 值小于 0.01，则在 1% 的显著性水平下拒绝原假设（所有家庭规模虚拟变量的系数都为 0），说明家庭规模对 nettfa 有联合显著影响。

7、现在，对模型 nettfa = β₀ + β₁inc + β₂inc² + β₃age + β₄age² + β₅e401k + μ 在五个家庭规模类别之间进行 Chow 检验，允许不同截距。受限残差平方和 SSRr 从第六部分（包含家庭规模虚拟变量但不含交互项的模型）获得，因为该回归假设所有斜率在不同家庭规模组中是相同的。非受限残差平方和 SSRu 是通过分别对每个家庭规模组进行回归，然后将它们的残差平方和相加得到：SSRu = SSR₁ + SSR₂ + ... + SSR₅，其中 SSRf 是仅使用家庭规模为 f 的样本估计的方程的残差平方和。你应该自己确认非受限模型有 30 个参数（五个截距加上五个家庭规模组各自的五个斜率），而受限模型（来自第六部分）有 10 个参数（一个整体截距、四个家庭规模虚拟变量的系数以及五个斜率）。因此，检验的约束数量 q 为 20，非受限模型的自由度为 9275-30=9245。

```{stata}
* 受限模型
* regress nettfa inc incsq age agesq e401k fsize2 fsize3 fsize4 fsize5

* 分别对每个家庭规模组进行回归并获取 SSR
regress nettfa inc incsq age agesq e401k if fam_size == 1
* 保存 SSR1
ereturn list
local ssr1 = e(rss)

regress nettfa inc incsq age agesq e401k if fam_size == 2
* 保存 SSR2
ereturn list
local ssr2 = e(rss)

regress nettfa inc incsq age agesq e401k if fam_size == 3
* 保存 SSR3
ereturn list
local ssr3 = e(rss)

regress nettfa inc incsq age agesq e401k if fam_size == 4
* 保存 SSR4
ereturn list
local ssr4 = e(rss)

regress nettfa inc incsq age agesq e401k if fam_size >= 5
* 保存 SSR5
ereturn list
local ssr5 = e(rss)

* 计算非受限模型的总 SSRu
local ssru = `ssr1' + `ssr2' + `ssr3' + `ssr4' + `ssr5'
display "Non-restricted SSR (SSRu): " `ssru'


* 估计受限模型
regress nettfa inc incsq age agsq e401k fsize2 fsize3 fsize4 fsize5

* 使用 chowtest 命令进行检验
* chowtest nettfa inc incsq age agesq e401k, group(fam_size) full
```