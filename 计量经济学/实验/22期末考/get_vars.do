* 创建一个do文件来获取所有数据集的变量信息
* 首先列出所有.dta文件
local files: dir "./" files "*.dta"

* 对每个文件执行以下操作
foreach file of local files {
    display as text _n "============================================="
    display as text "数据集: `file'"
    display as text "============================================="
    
    * 加载数据集
    use "./`file'", clear
    
    * 显示变量标签和描述
    describe, fullnames
    
    * 显示变量标签
    label list
    
    * 显示每个变量的详细标签
    foreach var of varlist _all {
        display as text _n "变量: `var'"
        display as text "标签: `: var label `var''"
        display as text "值标签: `: value label `var''"
    }
    
    * 显示数据的基本统计信息
    summarize
}

