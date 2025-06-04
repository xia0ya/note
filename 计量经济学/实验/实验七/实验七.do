// 2025-6-3
// 实验七
ls
use FISH.DTA,clear
// 回归分析
reg lavgprc mon tues wed thurs wave2 wave3
// 联合显著性检验
test wave2 wave3
//2sls
ivregress 2sls ltotqty (lavgprc= wave2 wave3) mon tues wed thurs
//
reg lavgprc mon tues wed thurs wave2 wave3
test mon tues wed thurs

// 5
ivregress 2sls ltotqty (lavgprc= wave2 wave3) mon tues wed thurs
predict uhat,r
tsset t
g luhat = L.uhat
ivregress 2sls ltotqty luhat (lavgprc= wave2 wave3) mon tues wed thurs