library(readxl)


df <- read_excel("数据.xlsx") 
data_for_fa <- df[, sapply(df, is.numeric)]
fa_result <- factanal(data_for_fa, factors = 2, rotation = "varimax", scores = "regression")
print(fa_result$loadings)
factor_scores <- as.data.frame(fa_result$scores)
df_with_scores <- cbind(df, factor_scores)
df_with_scores$rank_F2 <- rank(df_with_scores$Factor2)
head(df_with_scores[order(df_with_scores$rank_F2), ])
# 筛选 Romania 和 USSR 的排名信息
subset_rank <- df_with_scores[df_with_scores$Country %in% c("rumania", "ussr"), 
                              c("Country", "Factor1", "rank_F2")]

print(subset_rank)


# 单变量正态性检验
# 针对所有数值型变量做正态性检验
data_for_fa <- df[, sapply(df, is.numeric)]
normality_tests <- sapply(data_for_fa, function(x) shapiro.test(x)$p.value)
print(normality_tests)



#-----------------------------------------
library(readxl)
library(psych)


df <- read_excel("数据.xlsx")

data_for_fa <- df[, sapply(df, is.numeric)]

fa_result <- fa(data_for_fa, nfactors = 2, rotate = "promax", scores = "regression")
print(fa_result$loadings)
factor_scores <- as.data.frame(fa_result$scores)
df_with_scores <- cbind(df, factor_scores)

df_with_scores$rank_F1 <- rank(df_with_scores$MR1)  # psych::fa 默认命名为 ML1, ML2, ...
subset_rank <- df_with_scores[df_with_scores$Country %in% c("rumania", "ussr"), 
                              c("Country", "MR1", "rank_F1")]

print(subset_rank)

# 计算因子相关性
# 获取因子得分
factor_scores1 <- fa_result$scores

# 计算因子得分之间的相关性矩阵
cor_matrix <- cor(factor_scores1)

print(cor_matrix)
# 使用 cor.test 检验相关性是否显著
cor_test_result <- cor.test(factor_scores$MR1, factor_scores$MR2)

print(cor_test_result)




# ------------------对照实验------------------
set.seed(123)

library(psych)

# 模拟样本数量和变量数
n <- 100
p <- 6

### 正态性满足的数据 ###
normal_data <- as.data.frame(matrix(rnorm(n * p), ncol = p))
colnames(normal_data) <- paste0("V", 1:p)

### 非正态数据（对数正态 + 指数分布） ###
non_normal_data <- as.data.frame(
  cbind(
    matrix(rexp(n * 3, rate = 1), ncol = 3),         # 指数分布：偏态
    matrix(rlnorm(n * 3, meanlog = 0), ncol = 3)     # 对数正态分布：右偏严重
  )
)
colnames(non_normal_data) <- paste0("V", 1:p)

### 做因子分析（2 因子，varimax） ###
fa_normal <- factanal(normal_data, factors = 2, rotation = "varimax", scores = "regression")
fa_non_normal <- factanal(non_normal_data, factors = 2, rotation = "varimax", scores = "regression")

# 得分和排名
scores_normal <- as.data.frame(fa_normal$scores)
scores_non_normal <- as.data.frame(fa_non_normal$scores)

scores_normal$rank_F1 <- rank(-scores_normal$Factor1)        # 越大越好
scores_non_normal$rank_F1 <- rank(-scores_non_normal$Factor1)

# 添加编号
scores_normal$ID <- scores_non_normal$ID <- paste0("Obj", 1:n)

# 合并对比
compare_rank <- data.frame(
  ID = scores_normal$ID,
  Rank_Normal = scores_normal$rank_F1,
  Rank_NonNormal = scores_non_normal$rank_F1
)

# 差值计算
compare_rank$Diff = abs(compare_rank$Rank_Normal - compare_rank$Rank_NonNormal)

# 显示排名差异最大的前 10 个
head(compare_rank[order(-compare_rank$Diff), ], 10)


# ----------------------------------数据正态化------------------
library(readxl)
library(caret)
library(MVN)

# Step 1: 读取主数据
df <- read_excel("数据.xlsx")

# Step 2: 选出数值列
data_for_fa <- df[, sapply(df, is.numeric)]

# Step 3: 正态化新数据（使用 YeoJohnson 更通用）
pre_proc <- preProcess(data_for_fa, method = "YeoJohnson")
data_normalized <- predict(pre_proc, data_for_fa)

# Step 4: 合并国家列
df_orig <- cbind(Country = df$Country, data_for_fa)
df_norm <- cbind(Country = df$Country, data_normalized)

# Step 5: 定义因子分析函数
run_fa <- function(df_input) {
  data_num <- df_input[, sapply(df_input, is.numeric)]
  fa_result <- factanal(data_num, factors = 2, rotation = "varimax", scores = "regression")
  
  factor_scores <- as.data.frame(fa_result$scores)
  df_with_scores <- cbind(df_input, factor_scores)
  df_with_scores$rank_F1 <- rank(df_with_scores$Factor1)
  
  subset_rank <- df_with_scores[df_with_scores$Country %in% c("rumania", "ussr"), 
                                c("Country", "Factor2", "rank_F1")]
  return(subset_rank)
}

# Step 6: 执行分析
rank_orig <- run_fa(df_orig)
rank_norm <- run_fa(df_norm)

# Step 7: 显示结果
cat("🧾 原始数据下排名：\n")
print(rank_orig)
cat("\n🧾 正态化数据下排名：\n")
print(rank_norm)




