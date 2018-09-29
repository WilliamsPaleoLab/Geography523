#Allie Jensen
#Geog 920
#Lab 3

# Loading clam package into library, using the calibrate function to find the
# clam-calibrated age for 13000 radiocarbon years, changing the type of curve used.
library(clam)
calibrate(cage = 13000, error = 100)
calibrate(cage = 13000, error = 100, cc = 2)
calibrate(cage = 13000, error = 100, reservoir = c(50,30), cc = 2)

# Running clam with Devil's Lake data and default parameters
clam(core="DevilsLake2")

# Building the 4 age-depth models
# Running clam using an interpolation method, reversing the axis, saving plot
# as PDF. Storing the estimated age and 95% CI at 500 cm and 300 cm into separate
# variables for building table. 
clam(core = "DevilsLake2", type = 1, revaxes = TRUE, revd = FALSE, revyr = FALSE, plotpdf = TRUE, plotpng = FALSE, storedat = TRUE)
Int1 = calrange[480,]
Int2 = calrange[280,]
# Running clam using the linear regression method, reversing the axis, 
# savingg as PDF. Storing the estimated age and 95% CI at 500 cm and 300 cm
# into separate variables for building table.
clam(core = "DevilsLake2", type = 2, revaxes = TRUE, revd = FALSE, revyr = FALSE, plotpdf = TRUE, plotpng = FALSE)
LnReg1 = calrange[480,]
LnReg2 = calrange[280,]
# Running clam with the third order polynomial method, reversing axis, 
# saving as PDF. Storing the estimated age and 95% CI at 500 cm and 300 cm
# into separate variables for building table.
clam(core = "DevilsLake2", type = 2, smooth=3, revaxes = TRUE, revd = FALSE, revyr = FALSE, plotpdf = TRUE, plotpng = FALSE)
thirdpoly1 = calrange[480,]
thirdpoly2 = calrange[280,]
# Running clam with the cubic spline method, reversing axis, saving as PDF.
# Storing the estimated age and 95% CI at 500 cm and 300 cm into separate 
# variables for building table.
clam(core = "DevilsLake2", type = 3, revaxes = TRUE, revd = FALSE, revyr = FALSE, plotpdf = TRUE, plotpng = FALSE)
cubic1 = calrange[480,]
cubic2 = calrange[280,]

# Building the table comparing dates for the Picea decline at approx. 500 cm
picea.decline <- matrix(c(10244, 10126, 10318, 10406, 10242, 10544, 10280, 10222, 10357, 10140, 9780, 10427), ncol = 3, byrow = TRUE)
colnames(picea.decline) <- c("Point","Min 95% Range", "Max 95% Range")
rownames(picea.decline) <- c("Interpolation", "Linear Regression", "3rd Order Polynomial", "Cubic Spline")
picea.decline <- as.table(picea.decline)
picea.decline

# Building the table comparing dates for the Ulmus decline at approx. 300 cm
ulmus.decline <- matrix(c(5330, 5199, 5463, 5758, 5530, 5951, 5246, 5149, 5361, 5256, 5096, 5427), ncol = 3, byrow = TRUE)
colnames(ulmus.decline) <- c("Point","Min 95% Range", "Max 95% Range")
rownames(ulmus.decline) <- c("Interpolation", "Linear Regression", "3rd Order Polynomial", "Cubic Spline")
ulmus.decline <- as.table(ulmus.decline)
ulmus.decline

# Running clam with a low smoothing parameter of 0.1. Saving age estimates at
# 500 cm and 300 cm for the table.
clam(core = "DevilsLake2", type = 4, smooth = 0.1, revaxes = TRUE, revd = FALSE, revyr = FALSE, plotpdf = TRUE, plotpng = FALSE)
lowsmooth1 = calrange[480,]
lowsmooth2 = calrange[280,]
# Running clam with the default smoothing parameter of 0.3. Saving age estimates
# at 500 cm and 300 cm for the table.
clam(core = "DevilsLake2", type = 4, smooth = 0.3, revaxes = TRUE, revd = FALSE, revyr = FALSE, plotpdf = TRUE, plotpng = FALSE)
midsmooth1 = calrange[480,]
midsmooth2 = calrange[280,]
# Running clam with a high smoothing parameter of 0.6. Saving age estimates at 
# 500 cm and 300 cm for the table. 
clam(core = "DevilsLake2", type = 4, smooth = 0.6, revaxes = TRUE, revd = FALSE, revyr = FALSE, plotpdf = TRUE, plotpng = FALSE)
highsmooth1 = calrange[480,]
highsmooth2 = calrange[280,]

# Building the table comparing dates for the Picea decline at approx. 500 cm
picea.decline2 <- matrix(c(10199, 10077, 10305, 10221, 10153, 10288, 10326, 10264, 10388), ncol = 3, byrow = TRUE)
colnames(picea.decline2) <- c("Point","Min 95% Range", "Max 95% Range")
rownames(picea.decline2) <- c("Low Smoothing", "Default Smoothing", "High Smoothing")
picea.decline2 <- as.table(picea.decline2)
picea.decline2

# Building the table comparing dates for the Ulmus decline at approx. 300 cm
ulmus.decline2 <- matrix(c(5267, 5115, 5429, 5319, 5161, 5470, 5378, 5301, 5460), ncol = 3, byrow = TRUE)
colnames(ulmus.decline2) <- c("Point","Min 95% Range", "Max 95% Range")
rownames(ulmus.decline2) <- c("Low Smoothing", "Default Smoothing", "High Smoothing")
ulmus.decline2 <- as.table(ulmus.decline2)
ulmus.decline2

# Loading rbacon package into library, running Bacon with default data and 
# Devil's Lake data
library(rbacon)
Bacon()
Bacon(core = "DevilsLakeB")

# Saving Bacon-estimated dates and 95% CIs at 500 cm and 300 as new variables.
# Adding Bacon-estimated dates to the original table comparing the dates of
# the Picea/Ulmus declines
vec1 = unlist(hists[480])
picea.decline.bc <- matrix(c(10244, 10126, 10318, 10406, 10242, 10544, 10280, 10222, 10357, 10140, 9780, 10427, vec1[517], vec1[519], vec1[520]), ncol = 3, byrow = TRUE)
colnames(picea.decline.bc) <- c("Point","Min 95% Range", "Max 95% Range")
rownames(picea.decline.bc) <- c("Interpolation", "Linear Regression", "3rd Order Polynomial", "Cubic Spline", "Bacon Default")
picea.decline.bc <- as.table(picea.decline.bc)
picea.decline.bc

vec2 = unlist(hists[280])
ulmus.decline.bc <- matrix(c(5330, 5199, 5463, 5758, 5530, 5951, 5246, 5149, 5361, 5256, 5096, 5427, vec2[517], vec2[519], vec2[520]), ncol = 3, byrow = TRUE)
colnames(ulmus.decline.bc) <- c("Point","Min 95% Range", "Max 95% Range")
rownames(ulmus.decline.bc) <- c("Interpolation", "Linear Regression", "3rd Order Polynomial", "Cubic Spline", "Bacon Default")
ulmus.decline.bc <- as.table(ulmus.decline.bc)
ulmus.decline.bc

# Experimenting with Bacon, increasing thickness
Bacon(core = "DevilsLakeB", thick = 20)

# Experimenting with Bacon, adding hiatuses
Bacon(core = "DevilsLakeB", thick = 10, hiatus.depths = c(200,400), hiatus.max = 50)
