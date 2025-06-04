// 2025-3-31
// 刘晓亮


/*

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

*/


// 第一问
pwd
ls
use "jtrain2.dta",clear
desc

sum train, detail
sum mosinex if train == 1, detail


// 第二问
reg train unem74 unem75 age educ black hisp married
test unem74 unem75 age educ black hisp married


// 第三问
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
* 进行似然比检验（probit 回归后直接运行即可，默认检验所有模型中的解释变量）
lrtest t pr

// 第四问
reg unem78 train

// 第五问
probit unem78 train


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
// 第七问
reg unem78 train unem74 unem75 age educ black hisp married
probit unem78 train unem74 unem75 age educ black hisp married

// 法二
* 添加控制变量到第四部分的线性回归模型
regress unem78 train unem74 unem75 age educ black hisp married
predict prob_linear_controlled, xb

* 添加控制变量到第五部分的 Probit 回归模型
probit unem78 train unem74 unem75 age educ black hisp married
predict prob_probit_controlled, pr

* 比较拟合概率，计算相关性
correlate prob_linear_controlled prob_probit_controlled


// 第八问
probit unem78 train unem74 unem75 age educ black hisp married
margins, dydx(train)







