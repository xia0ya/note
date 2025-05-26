# 实验五：判别分析
>这个对我目前是陌生的，首先熟悉这个

```{R}
#实验五：判别分析
#加载必要的包
library(MASS)
library(ggplot2)

#--------------------------第一题：血友病A携带者判别-------------------------------

#创建训练数据
group1 <- data.frame(
  x1 = c(-0.0056, -0.1698, -0.3469, -0.0894, -0.1679, -0.0836, -0.1979, -0.0762, -0.1913, -0.1092,
         -0.5268, -0.0842, -0.0225, 0.0084, -0.1827, 0.1237, -0.4702, -0.1519, 0.0006, -0.2015,
         -0.1932, 0.1507, -0.1259, -0.1551, -0.1952, 0.0291, -0.228, -0.0997, -0.1972, -0.0867),
  x2 = c(-0.1657, -0.1585, -0.1879, 0.0064, 0.0713, 0.0106, -0.0005, 0.0392, -0.2123, -0.119,
         -0.4773, 0.0248, -0.058, 0.0782, -0.1138, 0.214, -0.3099, -0.0686, -0.1153, -0.0498,
         -0.2293, 0.0933, -0.0669, -0.1232, -0.1007, 0.0442, -0.171, -0.0733, -0.0607, -0.056),
  Group = 1
)

group2 <- data.frame(
  x1 = c(-0.3478, -0.3618, -0.4986, -0.5015, -0.1326, -0.6911, -0.3608, -0.4535, -0.3479, -0.3539,
         -0.4719, -0.361, -0.3226, -0.4319, -0.2734, -0.5573, -0.3755, -0.495, -0.5107, -0.1652,
         -0.2447, -0.4232, -0.2375, -0.2205, -0.2154, -0.3447, -0.254, -0.3778, -0.4046, -0.0639,
         -0.3351, -0.0149, -0.0312, -0.174, -0.1416, -0.1508, -0.0964, -0.2642, -0.0234, -0.3352,
         -0.1878, -0.1744, -0.4055, -0.2444, -0.4784),
  x2 = c(0.1151, -0.2008, -0.086, -0.2984, 0.0097, -0.339, 0.1237, -0.1682, -0.1721, 0.0722,
         -0.1079, -0.0399, 0.167, -0.0687, -0.002, 0.0548, -0.1865, -0.0153, -0.2483, 0.2132,
         -0.0407, -0.0998, 0.2876, 0.0046, -0.0219, 0.0097, -0.0573, -0.2682, -0.1162, 0.1569,
         -0.1368, 0.1539, 0.14, -0.0776, 0.1642, 0.1137, 0.0531, 0.0867, 0.0804, 0.0875,
         0.251, 0.1892, -0.2418, 0.1614, 0.0282),
  Group = 2
)

#合并训练数据
train_data <- rbind(group1, group2)

#新观测数据
new_obs <- data.frame(
  x1 = c(-0.112, -0.059, 0.064, -0.043, -0.050),
  x2 = c(-0.279, -0.068, 0.012, -0.052, -0.098)
)

#(1) 检验二元正态性
#对两组数据分别进行Shapiro-Wilk检验
shapiro.test(group1$x1)
shapiro.test(group1$x2)
shapiro.test(group2$x1)
shapiro.test(group2$x2)

#(2) 计算协方差矩阵
cov1 <- cov(group1[,1:2])
cov2 <- cov(group2[,1:2])
print("Group 1协方差矩阵：")
print(cov1)
print("Group 2协方差矩阵：")
print(cov2)

#检验协方差矩阵是否相等
#使用Box's M检验
box_m_test <- function(x, y) {
  n1 <- nrow(x)
  n2 <- nrow(y)
  p <- ncol(x)
  
  S1 <- cov(x)
  S2 <- cov(y)
  S_pooled <- ((n1-1)*S1 + (n2-1)*S2)/(n1+n2-2)
  
  M <- (n1+n2-2)*log(det(S_pooled)) - (n1-1)*log(det(S1)) - (n2-1)*log(det(S2))
  c <- (2*p^2 + 3*p - 1)/(6*(p+1)) * (1/(n1-1) + 1/(n2-1) - 1/(n1+n2-2))
  
  chi_sq <- M*(1-c)
  df <- p*(p+1)/2
  
  p_value <- 1 - pchisq(chi_sq, df)
  return(list(statistic = chi_sq, p_value = p_value))
}

box_m_result <- box_m_test(group1[,1:2], group2[,1:2])
print("Box's M检验结果：")
print(box_m_result)

#(3) 散点图
#创建包含训练数据和新观测的散点图
plot_data <- rbind(
  data.frame(x1 = train_data$x1, x2 = train_data$x2, 
             Group = factor(train_data$Group), Type = "Training"),
  data.frame(x1 = new_obs$x1, x2 = new_obs$x2, 
             Group = factor(3), Type = "New")
)

ggplot(plot_data, aes(x = x1, y = x2, color = Group, shape = Type)) +
  geom_point() +
  scale_color_manual(values = c("1" = "blue", "2" = "red", "3" = "green")) +
  scale_shape_manual(values = c("Training" = 16, "New" = 17)) +
  labs(title = "血友病A携带者数据散点图",
       x = "log10(AHF activity)",
       y = "log10(AHF antigen)") +
  theme_minimal()

#(4) 线性判别分析
lda_model <- lda(Group ~ x1 + x2, data = train_data)
lda_pred <- predict(lda_model, new_obs)
print("LDA预测结果：")
print(lda_pred$class)

#(5) 二次判别分析
qda_model <- qda(Group ~ x1 + x2, data = train_data)
qda_pred <- predict(qda_model, new_obs)
print("QDA预测结果：")
print(qda_pred$class)

#(6) 比较误判率
#对训练数据进行交叉验证
lda_cv <- lda(Group ~ x1 + x2, data = train_data, CV = TRUE)
qda_cv <- qda(Group ~ x1 + x2, data = train_data, CV = TRUE)

lda_error <- mean(lda_cv$class != train_data$Group)
qda_error <- mean(qda_cv$class != train_data$Group)

print("LDA误判率：")
print(lda_error)
print("QDA误判率：")
print(qda_error)

#--------------------------第二题：商学研究生院招生判别-------------------------------

#创建数据
accept <- data.frame(
  GPA = c(2.96, 3.14, 3.22, 3.29, 3.69, 3.46, 3.03, 3.19, 3.63, 3.59, 3.3, 3.4, 3.5, 3.78, 3.44,
          3.48, 3.47, 3.35, 3.39, 3.28, 3.21, 3.58, 3.33, 3.4, 3.38, 3.26, 3.6, 3.37, 3.8, 3.76, 3.24),
  GMAT = c(596, 473, 482, 527, 505, 693, 626, 663, 447, 588, 563, 553, 572, 591, 692, 528, 552, 520,
           543, 523, 530, 564, 565, 431, 605, 664, 609, 559, 521, 646, 467),
  Group = 1
)

reject <- data.frame(
  GPA = c(2.54, 2.43, 2.2, 2.36, 2.57, 2.35, 2.51, 2.51, 2.36, 2.36, 2.66, 2.68, 2.48, 2.46, 2.63,
          2.44, 2.13, 2.41, 2.55, 2.31, 2.41, 2.19, 2.35, 2.6, 2.55, 2.72, 2.85, 2.9),
  GMAT = c(446, 425, 474, 531, 542, 406, 412, 458, 399, 482, 420, 414, 533, 509, 504, 336, 408, 469,
           538, 505, 489, 411, 321, 394, 528, 399, 381, 384),
  Group = 2
)

wait <- data.frame(
  GPA = c(2.86, 2.85, 3.14, 3.28, 2.89, 3.15, 3.5, 2.89, 2.8, 3.13, 3.01, 2.79, 2.89, 2.91, 2.75,
          2.73, 3.12, 3.08, 3.03, 3, 3.03, 3.05, 2.85, 3.01, 3.03, 3.04),
  GMAT = c(494, 496, 419, 371, 447, 313, 402, 485, 444, 416, 471, 490, 431, 446, 546, 467, 463, 440,
           419, 509, 438, 399, 483, 453, 414, 446),
  Group = 3
)

#合并数据
admission_data <- rbind(accept, reject, wait)

#(1) 散点图
ggplot(admission_data, aes(x = GPA, y = GMAT, color = factor(Group))) +
  geom_point() +
  scale_color_manual(values = c("1" = "green", "2" = "red", "3" = "blue"),
                    labels = c("接受", "不接受", "待定")) +
  labs(title = "商学研究生院申请者数据散点图",
       x = "GPA",
       y = "GMAT",
       color = "分类") +
  theme_minimal()

#(2) 线性判别分析
lda_admission <- lda(Group ~ GPA + GMAT, data = admission_data)
print("LDA模型结果：")
print(lda_admission)

#(3) 二次判别分析
qda_admission <- qda(Group ~ GPA + GMAT, data = admission_data)
print("QDA模型结果：")
print(qda_admission)

#(4) 比较误判率
lda_cv_admission <- lda(Group ~ GPA + GMAT, data = admission_data, CV = TRUE)
qda_cv_admission <- qda(Group ~ GPA + GMAT, data = admission_data, CV = TRUE)

lda_error_admission <- mean(lda_cv_admission$class != admission_data$Group)
qda_error_admission <- mean(qda_cv_admission$class != admission_data$Group)

print("LDA误判率：")
print(lda_error_admission)
print("QDA误判率：")
print(qda_error_admission)

#(5) 新申请者判别
new_applicant <- data.frame(GPA = 3.21, GMAT = 497)

#在散点图中添加新申请者
ggplot(admission_data, aes(x = GPA, y = GMAT, color = factor(Group))) +
  geom_point() +
  geom_point(data = new_applicant, aes(x = GPA, y = GMAT), 
             color = "purple", size = 3, shape = 17) +
  scale_color_manual(values = c("1" = "green", "2" = "red", "3" = "blue"),
                    labels = c("接受", "不接受", "待定")) +
  labs(title = "商学研究生院申请者数据散点图（含新申请者）",
       x = "GPA",
       y = "GMAT",
       color = "分类") +
  theme_minimal()

#使用LDA和QDA进行预测
lda_pred_new <- predict(lda_admission, new_applicant)
qda_pred_new <- predict(qda_admission, new_applicant)

print("LDA预测结果：")
print(lda_pred_new$class)
print("QDA预测结果：")
print(qda_pred_new$class)

#(6) 检查异常值
#计算马氏距离
mahalanobis_dist <- mahalanobis(admission_data[,1:2], 
                               colMeans(admission_data[,1:2]), 
                               cov(admission_data[,1:2]))

#找出可能的异常值（马氏距离大于3的观测）
outliers <- which(mahalanobis_dist > 3)
print("可能的异常值：")
print(admission_data[outliers,])

#移除异常值后重新进行判别分析
clean_data <- admission_data[-outliers,]

#重新训练模型
lda_clean <- lda(Group ~ GPA + GMAT, data = clean_data)
qda_clean <- qda(Group ~ GPA + GMAT, data = clean_data)

#对新申请者进行预测
lda_pred_clean <- predict(lda_clean, new_applicant)
qda_pred_clean <- predict(qda_clean, new_applicant)

print("移除异常值后的LDA预测结果：")
print(lda_pred_clean$class)
print("移除异常值后的QDA预测结果：")
print(qda_pred_clean$class)

```
