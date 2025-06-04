// 2025-3-31
// 刘晓亮

/*
[abstracted from << Introductory Economerics >>chapter17 C17.9]
Use the data in  APPLE. dta  for this exercise.
These are telephone survey data attempting to elicit the demand for a (fictional) "ecological friendlly" apple. Each family was (randomly) presented with a set of prices for regular apples and the eco-labeled apples. They were asked how many ponds of each kind of apple they would buy.
(i)Of  the 660 families in the sample ,how many report wanting none of the eco-labeled apples at the set price?
(ii)Does the variable ecolbs seem to have a continuous distribution over strictly positive values? What implications does your answer have for the suitability of Tobit model for ecolbs?
(iii)Estimate a Tobit model for ecolbs with ecoprc,regprc,faminc,and hhsize as explanatory variables. Which variables are significant at the 1%level? 
 (iv)Are the signs of the coefficients on the price variables from part (iii) what you expect?Explain. 
(v)Let   be the coefficient on ecoprc and let   be the coefficient on regprc.
Test the hypothsis H0:   against the two-sided alternative. Report the p-value of the test.(You might use stata command: lincom)
 (vi)Obtain the estimates of E(ecolbs|x) for all observations in the sample. Call these
 .What are the smallest and largest fitted values?
(vii) Compute the squared correlation between ecolbsi and  .
(viii)Now, estimate a linear model for ecolbs using the same explanatory variables from part (iii) .Why are the OLS estimates so much smaller than  the linear model?
(ix)Evaluate the following statement :"Since the R-square from the Tobit model is so small, the  estimated price effects are probably inconsistent."
(x)Evaluate the following statement:"Because the R-squared from the Tobit model is so small, the estimated price effects are probably inconsistent. "

*/

// 第一问
ls
use "apple.dta",clear
desc
count if ecolbs == 0

// 第二问
hist ecolbs, frequency
* 查看 ecolbs 的描述性统计量，特别是最小值
summarize ecolbs

* 绘制 ecolbs 的直方图（可能需要调整 bins）
histogram ecolbs

* 查看 ecolbs > 0 的观测值数量
count if ecolbs > 0
// 第三问
tobit ecolbs ecoprc regprc faminc hhsize, ll(0)

// 第四问
tobit ecolbs ecoprc regprc faminc hhsize, ll(0)

// 第五问
tobit ecolbs ecoprc regprc faminc hhsize, ll(0)
lincom ecoprc + regprc
* 在 Tobit 回归（第三部分）之后运行 lincom
lincom -_b[ecoprc] - _b[regprc]
// 第六问
tobit ecolbs ecoprc regprc faminc hhsize, ll(0)
predict ecolbs_hat, xb
sum ecolbs_hat, detail

// 第七问
gen ecolbs2 = ecolbs^2
gen ecolbs_hat2 = ecolbs_hat^2
corr ecolbs ecolbs_hat


// 第八问
reg ecolbs ecoprc regprc faminc hhsize




















