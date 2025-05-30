library(stats)
library(psych)
subjects_cor <- matrix(c(
  1.0, 0.439, 0.410, 0.288, 0.329, 0.248,
  0.439, 1.0, 0.351, 0.354, 0.320, 0.329,
  0.410, 0.351, 1.0, 0.164, 0.190, 0.181,
  0.288, 0.354, 0.164, 1.0, 0.595, 0.470,
  0.329, 0.320, 0.190, 0.595, 1.0, 0.464,
  0.248, 0.329, 0.181, 0.470, 0.464, 1.0
), nrow = 6, byrow = TRUE)

subjects_cor
princomp_1 <- princomp(subjects_cor, cor = T)
summary(princomp_1,loadings=T)