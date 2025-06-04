// 2015-3-31
// 刘晓亮
// 实验二


/*

(i)Compute the average, standard deviation, minimum ,and maximum values of nettfa in the sample.
(ii)Test the hypothesis that average nettfa does not differ by 401(k) eligibility status; use a two-sided alternative .What is the dollar amount of the estimated difference?
[Hint: regress nettfa on e401k]
(iii) Estimate a multiple linear regression model for nettfa that includes income, age, and e401k as explanatory variables. The income and wage variables should appear as quadratics. Now ,what is the estimated dollar effect of 401(k) eligibility.
(iv)To the model estimated in part(iii) ,add the interactions e401k*(age-41) and e401k*(age-41)2.Note that the average age in the sample is about 41,so that in the new model ,the coefficient on e401k is the estimated effect of 401(k) eligibility at the average age. Which interaction term is significant?
(v)Comparing the estimates from parts(iii) and (iv) ,do the estimated effects of e401(k ) eligibility at age 41 differ much? Explain.
(vi)Now, drop the interaction terms from the model ,but define five family size dummy variables:fsize1,fsize2,fsize3,fsize4 and fsize5.The variable fsize5 is unity for families with five or more members. Include the family size dummies in the model estimated from part(iii) ;be sure to close a base group .Are the family dummies significant at 1%level? 
(vii)Now, do a Chow test for the model 
 
across the five family size categories ,allowing for intercept differences. The restricted 
sum of squared residuals, SSRr ,is obtained from part(vi) because that regression assumes all slopes are the same. The unrestricted sum of squared residuals is
 ,wher SSRf is the sum of squared residuals for equation estimated using only family size f. You should convince yourself that there are 30 parameters in the unrestricted model(five intercepts plus 25 slopes)
and 10 parameters in the unrestricted model(five intercepts plus 5 slopes).
Therefore, the number of restrictions being tested is q=20,and the df for the  unrestricted model is 9275-30=9245.

*/


pwd
ls
use "401ksubs.dta",clear

// 第一问
desc
sum nettfa, detail

// 第二问
reg nettfa e401k

// 第三问
reg nettfa inc incsq age agesq e401k

// 第四问
gen age_41 = age - 41
gen age_41_2 = age_41^2
gen e401k_age_41 = e401k * age_41
gen e401k_age_41_2 = e401k * age_41_2
reg nettfa inc incsq age agesq e401k e401k_age_41 e401k_age_41_2

//
* 生成 age 减去平均年龄的变量
gen age_minus_41 = age - 41

* 生成交互项
gen e401k_age_int = e401k * age_minus_41
gen e401k_age_sq_int = e401k * (age_minus_41)^2

* 估计包含交互项的模型
regress nettfa inc incsq age agesq e401k e401k_age_int e401k_age_sq_int

* 检验交互项的联合显著性（可选，但通常也需要）
test e401k_age_int e401k_age_sq_int




// 第五问
reg nettfa inc incsq age agesq e401k
reg nettfa inc incsq age agesq e401k e401k_age_41 e401k_age_41_2

// 第六问
gen fsize2 = fsize == 2
gen fsize3 = fsize == 3
gen fsize4 = fsize == 4
gen fsize5 = fsize >= 5
reg nettfa inc incsq age agesq e401k fsize2 fsize3 fsize4 fsize5

// 第七问
reg nettfa inc incsq age agesq e401k if fsize == 1
scalar SSRf1 = e(rss)
reg nettfa inc incsq age agesq e401k if fsize == 2
scalar SSRf2 = e(rss)
reg nettfa inc incsq age agesq e401k if fsize == 3
scalar SSRf3 = e(rss)
reg nettfa inc incsq age agesq e401k if fsize == 4
scalar SSRf4 = e(rss)
reg nettfa inc incsq age agesq e401k if fsize >= 5
scalar SSRf5 = e(rss)
scalar SSRur = SSRf1 + SSRf2 + SSRf3 + SSRf4 + SSRf5
scalar SSRr = 30215207.5
scalar F = ((SSRr - SSRur) / SSRur) * (9245 / 20)
display F
















