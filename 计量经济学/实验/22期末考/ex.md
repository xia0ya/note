```{stata}
* 计量经济学期末考代码
* ======================
* 第一题：生育率分析
* ======================
use FERTIL2.dta, clear

* (i) OLS估计
reg children educ age agesq urban electric tv


* (ii) 城市和非城市居民生育率差异
ttest children, by(urban)

* (iii) 分别估计城市和非城市居民的方程
reg children educ age agesq electric tv if urban==1

reg children educ age agesq electric tv if urban==0


* (iv) Chow检验
* 首先计算完整模型的SSR
reg children educ age agesq urban electric tv
scalar SSR_full = e(rss)

* 计算城市样本的SSR
reg children educ age agesq electric tv if urban==1
scalar SSR_urban = e(rss)

* 计算非城市样本的SSR
reg children educ age agesq electric tv if urban==0
scalar SSR_nonurban = e(rss)

* 计算Chow统计量
scalar SSR_restricted = SSR_urban + SSR_nonurban
scalar N = e(N)
scalar k = 5  // 限制的数量
scalar F = ((SSR_full - SSR_restricted)/k)/(SSR_restricted/(N-2*k))
display "Chow F统计量 = " F
display "p值 = " Ftail(k, N-2*k, F)

* ======================
* 第二题：吸烟分析
* ======================
use smoke.dta, clear

* (i) 计算不吸烟人数
count if cigs==0
display "不吸烟人数：" r(N)

* (ii) 泊松回归
poisson cigs lcigpric lincome white educ age agesq


* (iii) 使用最大似然标准误检验显著性
test lcigpric lincome

* (iv) 计算sigma^2

poisson cigs lcigpric lincome white educ age agesq ,nolog
predict hat 
gen res = cigs-hat
gen ressq = res^2
gen a = ressq/hat
tabstat a,statistics(sum)
di 16484.84/(807-6-1)
di 20.60605^0.5


* (v) 使用调整后标准误重新检验
poisson cigs lcigpric lincome white educ age agesq, vce(robust)
test lcigpric lincome

* (vi) 使用稳健标准误检验教育和年龄变量
test educ age agesq
poisson cigs lcigpric lincome white educ age agesq,robust 
di (exp(-.0600986)-1)*100

* (vii) 获取拟合值
summarize cigs_hat

* (viii) 计算相关系数
correlate cigs cigs_hat
display "R-squared = " r(rho)^2

* ======================
* 第三题：幸福感分析
* ======================
use happiness.dta, clear

* (i) 基础probit模型估计
probit vhappy occattend regattend y96 y98 y00 y02 y04 y06
margins, dydx(occattend regattend) atmeans


* (ii) 添加新变量并重新估计
gen highinc = (income >= 12)  // 收入大于25000美元
probit vhappy occattend regattend highinc unem10 educ teens y96 y98 y00 y02 y04 y06
margins, dydx(occattend regattend highinc unem10 educ teens) atmeans


* (iii) 讨论新变量的APE和显著性
* 结果已在(ii)部分的margins命令中给出

* (iv) 检验性别和种族差异
probit vhappy occattend regattend highinc unem10 educ teens black female blackfemale y96 y98 y00 y02 y04 y06
margins, dydx(black female blackfemale) atmeans
test black female blackfemale
outreg2 using "第三题结果.doc", append

* ======================
* 第四题：吸烟与收入关系分析
* ======================
use smoke.dta, clear

* (i) 收入方程OLS估计
* 解释beta1：表示每天多吸一支烟对收入的影响
* 如果beta1为负，说明吸烟可能通过健康问题或生产力损失降低收入
reg lincome cigs educ age agesq
outreg2 using "第四题结果.doc", replace

* (ii) 香烟需求方程
* 预期gamma5(价格)为负：价格上升，需求下降
* 预期gamma6(限制)为负：限制增加，需求下降
reg cigs lincome educ age agesq lcigpric restaurn
outreg2 using "第四题结果.doc", append

* (iii) 收入方程的可识别性
* 收入方程可识别的条件是：
* 1. 香烟需求方程中的lcigpric和restaurn是外生的
* 2. 这些变量在收入方程中不直接出现
* 3. 这些变量与香烟消费相关

* (iv) OLS估计结果讨论
* 重新运行OLS并详细讨论beta1
reg lincome cigs educ age agesq
display "beta1的估计值：" _b[cigs]
display "beta1的标准误：" _se[cigs]
display "beta1的t统计量：" _b[cigs]/_se[cigs]
display "beta1的p值：" 2*ttail(e(df_r),abs(_b[cigs]/_se[cigs]))

* (v) 简化形式估计
* 将cigs对所有外生变量回归
reg cigs educ age agesq lcigpric restaurn
* 检验工具变量的显著性
test lcigpric restaurn
display "F统计量：" r(F)
display "p值：" r(p)

* (vi) 2SLS估计
* 使用lcigpric和restaurn作为工具变量
ivregress 2sls lincome (cigs = lcigpric restaurn) educ age agesq

* 比较OLS和2SLS结果
display "OLS beta1：" _b[cigs]
display "2SLS beta1：" _b[cigs]
display "差异：" _b[cigs] - _b[cigs]

* 进行Hausman检验
* 保存OLS估计结果
reg lincome cigs educ age agesq
estimates store ols
* 保存2SLS估计结果
ivregress 2sls lincome (cigs = lcigpric restaurn) educ age agesq
estimates store iv
* 进行Hausman检验
hausman iv ols, sigmamore

* 输出结果解释
display "=== 第四题结果解释 ==="
display "1. OLS估计显示吸烟对收入的影响为：" _b[cigs]
display "2. 2SLS估计显示吸烟对收入的影响为：" _b[cigs]
display "3. Hausman检验p值：" r(p)
display "4. 工具变量F统计量：" r(F)

* ======================
* 第五题：养老金分析
* ======================
use fringe.dta, clear

* (i) 养老金统计
summarize pension
count if pension==0
display "养老金为零的工人比例：" r(N)/_N*100 "%"

* (ii) Tobit模型估计
tobit pension exper age tenure educ depends married white male, ll(0)
outreg2 using "第五题结果.doc", replace

* (iii) 计算预期养老金差异
* 白人男性
scalar xb_white_male = _b[_cons] + _b[exper]*10 + _b[age]*35 + _b[tenure]*10 + ///
    _b[educ]*16 + _b[depends]*0 + _b[married]*0 + _b[white]*1 + _b[male]*1
scalar sigma = e(sigma)
scalar E_white_male = xb_white_male*normal(xb_white_male/sigma) + ///
    sigma*normalden(xb_white_male/sigma)

* 非白人女性
scalar xb_nonwhite_female = _b[_cons] + _b[exper]*10 + _b[age]*35 + _b[tenure]*10 + ///
    _b[educ]*16 + _b[depends]*0 + _b[married]*0 + _b[white]*0 + _b[male]*0
scalar E_nonwhite_female = xb_nonwhite_female*normal(xb_nonwhite_female/sigma) + ///
    sigma*normalden(xb_nonwhite_female/sigma)

display "预期养老金差异：" E_white_male - E_nonwhite_female

* ======================
* 第六题：机票价格分析
* ======================
use airfare.dta, clear

* (i) 汇总OLS估计
reg lfare concen ldist ldistsq y98 y99 y00
outreg2 using "第六题结果.doc", replace

* (ii) OLS 95%置信区间
reg lfare concen ldist ldistsq y98 y99 y00
display "beta1的95%置信区间：" _b[concen] - invttail(e(df_r),.025)*_se[concen] ///
    " to " _b[concen] + invttail(e(df_r),.025)*_se[concen]

* (iii) 随机效应估计
xtset id year
xtreg lfare concen ldist ldistsq y98 y99 y00, re
outreg2 using "第六题结果.doc", append

* (iv) 固定效应估计
xtreg lfare concen ldist ldistsq y98 y99 y00, fe
outreg2 using "第六题结果.doc", append

* 关闭日志
log close

```