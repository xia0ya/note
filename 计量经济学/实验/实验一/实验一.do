// 2025-3-4
// Chow Test 实验一
// 刘晓亮
use  SLEEP75.DTA,clear


/*
(i) 分别对男性和女性估计这个方程，并以通常的形式报告结果。两个估计方程之间是否有显著差异？
(ii) 计算男性和女性睡眠方程参数相等性的Chow检验。使用添加男性和交互项male_totwrk，...，male_yngkid并使用完整观测集的检验形式。检验的相关自由度(df)是多少？在5%的水平上是否应该拒绝原假设？
(iii) 现在允许男性和女性的截距不同，并确定涉及男性的交互项是否共同显著。
(iv) 根据(ii)和(iii)部分的结果，你的最终模型是什么？
*/

/*  第一问  */
// ----------------------------------------------------
gen age2 = age^2
// male
reg sleep totwrk educ age age2 yngkid if male==1
// female
reg sleep totwrk educ age age2 yngkid if male==0
// 有显著差异



/*  第二问  */
// -----------------------------------------------------
gen maletotwrk = male*totwrk
gen maleeduc = male*educ
gen maleage = male*age
gen maleage2 = male*age2
gen maleyngkid = male*yngkid

reg sleep male totwrk educ age age2 yngkid maletotwrk maleeduc maleage maleage2 maleyngkid

test maletotwrk maleeduc maleage maleage2 maleyngkid male

* 方法2：使用chowtest命令（如果已安装）
chowtest sleep totwrk educ age agesq yngkid, group(male)



// 显著，男女回归方程不一样，拒绝原假设


/*  第三问  */
// -----------------------------------------------------
test maletotwrk maleeduc maleage maleage2 maleyngkid 
// 五个斜率不显著


/*  第四问  */
// -----------------------------------------------------
// 最终模型
reg sleep totwrk educ age age2 yngkid maleyngkid














