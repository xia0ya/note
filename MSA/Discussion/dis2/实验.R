# 加载必要的包
library(MASS)
data(iris)

# 使用公式接口进行LDA分析
iris1 <- lda(iris[, 3:4], factor(iris$Species))

# 提取LDA结果中的奇异值
svd_values <- iris1$svd
print("奇异值：")
print(svd_values)

# 分组计算均值和中心化数据
split_data <- split(iris[, 3:4], iris$Species)
group_means <- lapply(split_data, colMeans)
tbar <- colMeans(iris[, 3:4])

# 计算组间协方差矩阵 B
centered_means <- lapply(group_means, \(m) m - tbar)
B <- 50 * Reduce("+", lapply(centered_means, \(cm) cm %*% t(cm)))

# 计算组内协方差矩阵 W
centered_data <- lapply(split_data, \(df) scale(df, scale = FALSE))
W <- Reduce("+", lapply(centered_data, \(x) crossprod(x)))

# 计算 B(W^-1) 的特征值
eigen_BW <- eigen(B %*% solve(W))$values
print("B(W^-1)的特征值：")
print(eigen_BW)

# 计算 B((B+W)^-1) 的特征值
eigen_BplusW <- eigen(solve(B + W) %*% B)$values
print("B((B+W)^-1)的特征值：")
print(eigen_BplusW)

# 奇异值的平方
eigen_values_from_svd <- svd_values^2
print("通过奇异值平方计算的特征值：")
print(eigen_values_from_svd)

# 比较
print("B(W^-1)的特征值：")
print(eigen_BW)

# 通过奇异值平方计算的迹比例
trace_proportions_from_svd <- eigen_values_from_svd / sum(eigen_values_from_svd)
print("通过奇异值平方计算的迹比例：")
print(trace_proportions_from_svd)

# 通过 B(W^-1) 的特征值计算的迹比例
trace_proportions_BW <- eigen_BW / sum(eigen_BW)
print("通过 B(W^-1) 的特征值计算的迹比例：")
print(trace_proportions_BW)


# 通过 B((B+W)^-1) 的特征值计算的迹比例
trace_proportions_BplusW <- eigen_BplusW / sum(eigen_BplusW)
print("通过 B((B+W)^-1) 的特征值计算的迹比例：")
print(trace_proportions_BplusW)


#===============================#

# 生成标题
header <- "迹比例计算结果：\n方法\t\t\t迹比例\n"

# 各方法的结果字符串
result_svd <- paste("奇异值平方\t", paste(round(trace_proportions_from_svd, 4), collapse = ", "), "\n")
result_bw <- paste("B(W^-1) 特征值\t", paste(round(trace_proportions_BW, 4), collapse = ", "), "\n")
result_bplusw <- paste("B((B+W)^-1) 特征值\t", paste(round(trace_proportions_BplusW, 4), collapse = ", "), "\n")

# 最后统一打印结果
cat(header, result_svd, result_bw, result_bplusw, sep = "")
