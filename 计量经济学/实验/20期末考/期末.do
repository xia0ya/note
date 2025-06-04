* =============================================
* 第一题：睡眠时间研究 (SLEEP75.dta) [16分]
* =============================================
use "SLEEP75.dta", clear

* (i) 分别对男性和女性进行回归
* 男性样本回归
reg sleep totwrk educ age agesq yngkid if male==1
* 女性样本回归
reg sleep totwrk educ age agesq yngkid if male==0

* (ii) Chow检验
* 生成交互项
gen male_totwrk = male*totwrk
gen male_educ = male*educ
gen male_age = male*age
gen male_agesq = male*agesq
gen male_yngkid = male*yngkid

* 完整模型回归（包含所有交互项）
reg sleep male totwrk educ age agesq yngkid male_totwrk male_educ male_age male_agesq male_yngkid
* 进行Chow检验（检验所有交互项联合显著性）
test male_totwrk male_educ male_age male_agesq male_yngkid male

* 方法2：使用chowtest命令（如果已安装）
chowtest sleep totwrk educ age agesq yngkid, group(male)
* (iii) 允许不同截距项
reg sleep male totwrk educ age agesq yngkid male_totwrk male_educ male_age male_agesq male_yngkid
* 检验交互项联合显著性
test male_totwrk male_educ male_age male_agesq male_yngkid

* (iv) 根据(ii)和(iii)的结果选择最终模型
* 如果Chow检验显著，使用完整模型
* 如果Chow检验不显著，使用简单模型
reg sleep totwrk educ age agesq yngkid

* =============================================
* 第二题：就业培训项目研究 (JTRAIN98.dta) [18分]
* =============================================
use "JTRAIN98.dta", clear

* (i) 计算1998年和1996年失业率
summarize unem98
summarize unem96

* (ii) 简单回归
reg unem98 train

* (iii) 加入控制变量
reg unem98 train earn96 educ age married

* (iv) 完全回归调整
* 计算变量均值
foreach var of varlist earn96 educ age married {
    egen mean_`var' = mean(`var')
    gen `var'_c = `var' - mean_`var'
}

* 生成交互项
foreach var of varlist earn96_c educ_c age_c married_c {
    gen train_`var' = train*`var'
}

* 完整模型回归
reg unem98 train earn96_c educ_c age_c married_c train_earn96_c train_educ_c train_age_c train_married_c

// 法二
sum earn96 educ age married
egen mearn96=mean( earn96 )
egen meduc =mean( educ )
egen mage =mean( age )
egen mmarried =mean( married )
g tmearn96= train* ( earn96 - mearn96 )
g tmage = train* ( age - mage )
g tmeduc = train* ( educ -meduc)
g tmmarried = train*( married- mmarried)
reg unem98 train earn96 educ age married tmearn96 tmage tmeduc tmmarried

* (v) 检验交互项联合显著性
test train_earn96_c train_educ_c train_age_c train_married_c

* (vi) 分别回归方法
* 控制组回归
reg unem98 earn96 educ age married if train==0
predict unem98_0
* 处理组回归
reg unem98 earn96 educ age married if train==1
predict unem98_1
* 计算平均处理效应
gen ate = unem98_1 - unem98_0
summarize ate

* =============================================
* 第三题：工具变量法分析 (LABSUP.dta) [21分]
* =============================================
use "LABSUP.dta", clear

* (i) OLS回归，使用异方差稳健标准误
reg hours kids nonmomi educ age agesq black hispan, robust

* (ii) 第一阶段回归
reg kids samesex nonmomi educ age agesq black hispan
* 检验工具变量相关性
test samesex

* (iii) 使用samesex作为工具变量
ivregress 2sls hours (kids = samesex) nonmomi educ age agesq black hispan, robust

* (iv) 添加multi2nd作为第二个工具变量
* 第一阶段回归
reg kids samesex multi2nd nonmomi educ age agesq black hispan
* 计算F统计量
test samesex multi2nd

* (v) 使用两个工具变量
ivregress 2sls hours (kids = samesex multi2nd) nonmomi educ age agesq black hispan, robust

* (vi) 过度识别检验
ivregress 2sls hours (kids = samesex multi2nd) nonmomi educ age agesq black hispan

estat overid

* =============================================
* 第四题：Probit模型和样本选择 (CPS91.dta) [18分]
* =============================================
use "CPS91.dta", clear

* (i) 计算劳动参与率
summarize inlf
tab inlf
* (ii) 工资方程OLS回归
reg lwage educ exper expersq black hispanic if inlf==1
test black hispanic

* (iii) Probit模型
probit inlf educ exper expersq black hispanic nwifeinc kidlt6

* (iv) 似然比检验
* 保存完整模型
probit inlf educ exper expersq black hispanic nwifeinc kidlt6
estimates store full
* 受限模型
probit inlf educ black hispanic nwifeinc kidlt6
estimates store restricted
* 似然比检验
lrtest full restricted

// 法二
probit inlf educ exper expersq black hispanic nwifeinc kidlt6,nolog
probit inlf educ black hispanic nwifeinc kidlt6,nolog
di 2*(-3537.2544 -(-3589.9891 ))

* (v) 计算平均偏效应
margins, dydx(educ)

* (vi) 样本选择模型
* 计算逆米尔斯比
predict xb, xb
gen lambda = normalden(xb)/normal(xb)
* 将逆米尔斯比加入工资方程
reg lwage educ exper expersq black hispanic lambda if inlf==1

* =============================================
* 第五题：Tobit模型 (JTRAIN98.dta) [11分]
* =============================================
use "JTRAIN98.dta", clear

* (i) 计算零收入比例
count if earn98==0
display r(N)/_N

* (ii) Tobit模型
tobit earn98 train earn96 educ married, ll(0)

* (iii) 计算平均处理效应
margins, dydx(train)

* =============================================
* 第六题：面板数据模型 (wagepan.dta) [16分]
* =============================================
use "wagepan.dta", clear

* (i) 混合OLS回归
reg lwage exper expersq educ black hisp

* (ii) 随机效应模型
xtreg lwage exper expersq educ black hisp, re
* 拉格朗日乘数检验
xttest0

* (iii) 固定效应模型
xtreg lwage exper expersq educ black hisp, fe
* 检验个体效应是否相同
xttest2

* (iv) Hausman检验
// 原假设随机效应
xtreg lwage exper expersq educ black hisp, re
estimates store re
xtreg lwage exper expersq educ black hisp, fe
estimates store fe
hausman fe re
hausman fe re,sigmamore