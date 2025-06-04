// 1
use "WAGEPAN.DTA",clear
reg lwage educ black hisp

// 2
xtreg lwage educ black hisp,re

// 3
xttest0

// 二

// 1
use "airfare.dta",clear
reg lfare concen ldist ldistsq y98 y99 y00

// 2
reg lfare concen ldist ldistsq y98 y99 y00, robust

// 3
di .9016004/(2*.1030196)

// 4
xtreg lfare concen ldist ldistsq y00 y99 y98,re

// 5
xtreg lfare concen ldist ldistsq y00 y99 y98,fe
est store fe
xtreg lfare concen ldist ldistsq y00 y99 y98,re theta
est store re
hausman fe re