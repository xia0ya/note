# 实验六 聚类分析
>该部分不算困难，有理有据即可
注意：如果加入其他方法，因子分析更适合（相比主成分分析）

```{R}
#实验六：聚类分析
#加载必要的包
library(stats)
library(factoextra)
library(cluster)

#--------------------------第一题：语言聚类分析-------------------------------

#创建距离矩阵
dist_matrix <- matrix(c(
  0, 2, 2, 7, 6, 6, 6, 6, 7, 9, 9,
  2, 0, 1, 5, 4, 6, 6, 6, 7, 8, 9,
  2, 1, 0, 6, 5, 6, 5, 5, 6, 8, 9,
  7, 5, 6, 0, 5, 9, 9, 9, 10, 8, 9,
  6, 4, 5, 5, 0, 7, 7, 7, 8, 9, 9,
  6, 6, 6, 9, 7, 0, 2, 1, 5, 10, 9,
  6, 6, 5, 9, 7, 2, 0, 1, 3, 10, 9,
  6, 6, 5, 9, 7, 1, 1, 0, 4, 10, 9,
  7, 7, 6, 10, 8, 5, 3, 4, 0, 10, 9,
  9, 8, 8, 8, 9, 10, 10, 10, 10, 0, 8,
  9, 9, 9, 9, 9, 9, 9, 9, 9, 8, 0
), nrow = 11, byrow = TRUE)

#设置行名和列名
rownames(dist_matrix) <- c("E", "N", "Da", "Du", "G", "Fr", "Sp", "I", "P", "H", "Fi")
colnames(dist_matrix) <- c("E", "N", "Da", "Du", "G", "Fr", "Sp", "I", "P", "H", "Fi")

#转换为距离对象
dist_obj <- as.dist(dist_matrix)

#(1) 进行不同方法的聚类分析
#最小距离法（single linkage）
hc_single <- hclust(dist_obj, method = "single")
#最大距离法（complete linkage）
hc_complete <- hclust(dist_obj, method = "complete")
#平均距离法（average linkage）
hc_average <- hclust(dist_obj, method = "average")
#Ward聚类法
hc_ward <- hclust(dist_obj, method = "ward.D2")

#(2) 绘制树状图
#设置图形参数
par(mfrow = c(2, 2))

#最小距离法树状图
plot(hc_single, main = "最小距离法聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_single, k = 4, border = "red")

#最大距离法树状图
plot(hc_complete, main = "最大距离法聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_complete, k = 4, border = "red")

#平均距离法树状图
plot(hc_average, main = "平均距离法聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_average, k = 4, border = "red")

#Ward法树状图
plot(hc_ward, main = "Ward法聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_ward, k = 4, border = "red")

#重置图形参数
par(mfrow = c(1, 1))

#--------------------------第二题：浙江省城市消费支出聚类分析-------------------------------

#创建数据框
consumption_data <- data.frame(
  city = c("杭州市", "宁波市", "温州市", "嘉兴市", "湖州市", "绍兴市", 
           "金华市", "衢州市", "舟山市", "台州市", "丽水市"),
  food = c(8528, 8068, 9936, 7709, 7949, 8744, 6952, 6133, 8380, 7175, 6719),
  clothing = c(2421, 2406, 2505, 2074, 2568, 2570, 2472, 2026, 2575, 2156, 2481),
  housing = c(2305, 1741, 2248, 2137, 1523, 1924, 1933, 1195, 1830, 1554, 1531),
  household = c(1580, 1324, 1240, 1533, 1324, 1192, 1442, 1063, 1293, 1106, 1194),
  medical = c(1265, 872, 1113, 1553, 1182, 1041, 1714, 1380, 1632, 1049, 1620),
  transport = c(4725, 4300, 4079, 5241, 4056, 4747, 4722, 3055, 3462, 3706, 3364),
  education = c(2998, 3424, 3627, 3503, 2793, 3355, 3070, 2058, 2934, 3072, 2350),
  other = c(1010, 994, 875, 1101, 732, 897, 866, 495, 1355, 824, 550)
)

#数据标准化
scaled_data <- scale(consumption_data[, -1])
rownames(scaled_data) <- consumption_data$city

#计算欧氏距离
dist_matrix_city <- dist(scaled_data)

#(1) 进行不同方法的聚类分析
#最小距离法
hc_single_city <- hclust(dist_matrix_city, method = "single")
#最大距离法
hc_complete_city <- hclust(dist_matrix_city, method = "complete")
#平均距离法
hc_average_city <- hclust(dist_matrix_city, method = "average")

#(2) 绘制树状图
#设置图形参数
par(mfrow = c(1, 3))

#最小距离法树状图
plot(hc_single_city, main = "最小距离法聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_single_city, k = 3, border = "red")

#最大距离法树状图
plot(hc_complete_city, main = "最大距离法聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_complete_city, k = 3, border = "red")

#平均距离法树状图
plot(hc_average_city, main = "平均距离法聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_average_city, k = 3, border = "red")

#重置图形参数
par(mfrow = c(1, 1))

#(3) 对各项消费支出进行聚类分析（附加题）
# 转置数据框，使变量成为观测
consumption_by_category <- t(consumption_data[, -1])
colnames(consumption_by_category) <- consumption_data$city

#标准化
scaled_category <- scale(consumption_by_category)

#计算距离
dist_category <- dist(scaled_category)

#进行聚类分析
hc_category <- hclust(dist_category, method = "average")

#绘制树状图
plot(hc_category, main = "消费支出类别聚类树状图",
     xlab = "", ylab = "距离", sub = "")
rect.hclust(hc_category, k = 3, border = "red")

```
