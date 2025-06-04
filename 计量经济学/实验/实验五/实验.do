// 2024-4-26
// 刘晓亮
// 星期六


/*
(i) 变量cigs是每天吸烟的数量。样本中有多少人根本不吸烟？有多少人声称每天吸20支烟？你认为为什么在香烟数量上会聚集这么多人？
(ii) 根据你在第一部分的回答，cigs是否看起来像是一个条件泊松分布的良好候选？
(iii) 估计一个泊松回归模型用于cigs，包括log(cigpric)、log(income)、white、educ、age和age²作为解释变量。估计的价格弹性和收入弹性是多少？
(iv) 使用最大似然标准误差，价格和收入变量在5%的水平上是否具有统计显著性？
(v) 获得方程之后描述的 α
^的估计值。它是什么？你应该如何调整第(iv)部分的标准误差
(vi) 使用第(v)部分调整后的标准误差，价格和收入弹性现在是否与零有统计显著差异？解释原因。
(vii) 使用更稳健的标准误差，教育和工资变量是否显著？如何解释educ的系数？
(viii) 从泊松回归模型中获得拟合值 y^i
。找到最小值和最大值，并讨论指数模型对重度吸烟的预测效果如何。
(ix) 使用第(viii)部分的拟合值，获得 y^i和y i之间的平方相关系数。
(x) 使用与第(iii)部分相同的解释变量（以及相同的形式），通过最小二乘法(OLS)估计cigs的线性模型。线性模型还是指数模型提供更好的拟合？R²是否很大？
*/

// 1

use "SMOKE.dta",clear
count if cigs == 0
count if cigs == 20

//2
summarize cigs
tabulate cigs

//3

poisson cigs lcigpric lincome white educ age agesq 
poisson cigs lcigpric lincome white educ age agesq, nolog vce(robust)
* 在 Poisson 回归（第三部分）后，估计过度分散参数
estat gof
//5
poisson cigs lcigpric lincome white educ age agesq ,nolog
predict hat 
gen res = cigs-hat
gen ressq = res^2
gen a = ressq/hat
tabstat a,statistics(sum)
di 16484.84/(807-6-1)
di 20.60605^0.5

poisson cigs lcigpric lincome white educ age agesq,robust


// ix
corr hat cigs

// viii
poisson cigs lcigpric lincome white educ age agesq ,nolog
predict hat 
sum hat

//(vii) 
poisson cigs lcigpric lincome white educ age agesq,robust 
di (exp(-.0600986)-1)*100
//多接受一年教育会使预期吸烟数量减少


//vi
poisson cigs lcigpric lincome white educ age agesq,robust


























