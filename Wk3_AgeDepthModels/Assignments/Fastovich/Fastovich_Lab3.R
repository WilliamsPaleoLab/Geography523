# Loading needed libraries. Looks like the clam packages is giving me a tough time so I dowloaded the code from Marten Blaauws website and will use it that way.
library(clam)
library(rbacon)

# Part 1: Comparing calibratied radiocarbon ages
# When using CALIB 7.1 online to calibrate 13,000 $^{14}C$ age the calibrated age range is:
#  
#   Calibration Curve | Median Age | 2-$\sigma$ error
#   ------------------|------------|-----------------
#   Intcal13          | 15,552     | 15,232 - 15,879
#   Marine13          | 15,897     | 14,339 - 15,249
#   
# Comparing this with `clam` we get:

calibrate(13000, error = 100, graph = FALSE) # Using the default Intcal13 calibration curve
calibrate(13000, 100, cc=2, graph = FALSE) # Using the Marine13 calibration curve
calibrate(13000, 100, reservoir = c(50, 30), cc = 2, graph = FALSE) # Using the Marine13 calibration curve with a reservior correction of 50 years and an additional uncertainty of 30 years
# The calibrations appear close but not identical.

# Classic Age Models `clam`
clam("tulane_ages", type = 1, storedat = TRUE) # Interpolated
calrange[calrange[,1] == 4060,] # Notable event 1
calrange[calrange[,1] == 4000,] # Notable event 2
clam("tulane_ages", type = 2, storedat = TRUE) # Regression
calrange[calrange[,1] == 4060,] # Notable event 1
calrange[calrange[,1] == 4000,] # Notable event 2
clam("tulane_ages", type = 2, smooth = 3, storedat = TRUE) # 3rd order polynomial regression
calrange[calrange[,1] == 4060,] # Notable event 1
calrange[calrange[,1] == 4000,] # Notable event 2
clam("tulane_ages", type = 3, storedat = TRUE) # Cubic spline
calrange[calrange[,1] == 4060,] # Notable event 1
calrange[calrange[,1] == 4000,] # Notable event 2
clam("tulane_ages", type = 4, smooth = 2, storedat = TRUE)
calrange[calrange[,1] == 4060,] # Notable event 1
calrange[calrange[,1] == 4000,] # Notable event 2
clam("tulane_ages", type = 4, smooth = 3, storedat = TRUE)
calrange[calrange[,1] == 4060,] # Notable event 1
calrange[calrange[,1] == 4000,] # Notable event 2
clam("tulane_ages", type = 4, smooth = 4, storedat = TRUE)
calrange[calrange[,1] == 4060,] # Notable event 1
calrange[calrange[,1] == 4000,] # Notable event 2

# Bacon Age Models `bacon`
Bacon("Tulane", run = FALSE) # Thickness of 10
quantile(Bacon.Age.d(4060), c(0.025, 0.5, 0.975))
quantile(Bacon.Age.d(4000), c(0.025, 0.5, 0.975))
Bacon("Tulane_20", thick = 20, run = FALSE) # Thickness of 20
quantile(Bacon.Age.d(4060), c(0.025, 0.5, 0.975))
quantile(Bacon.Age.d(4000), c(0.025, 0.5, 0.975))
Bacon("Tulane_30", thick = 30, run = FALSE) # Thickness of 30
quantile(Bacon.Age.d(4060), c(0.025, 0.5, 0.975))
quantile(Bacon.Age.d(4000), c(0.025, 0.5, 0.975))
