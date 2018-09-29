install.packages ("clam")
install.packages("rbacon")
install.packages("Bchron")
library("clam")
library(rbacon)
library(Bchron)

#### Calibrating Radiocarbon dates: *clam*
calibrate(13000,100)
calibrate(13000,100,cc=2)
calibrate(13000,100,reservoir=c(50,30),cc=2)

### Clam models
clam("DevilsLakeGeoChron", storedat = TRUE)
clam("DevilsLakeGeoChron", type = 1, storedat = TRUE) #type="interp"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]
clam("DevilsLakeGeoChron", type = 2, storedat = TRUE) #type="regr"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]
clam("DevilsLakeGeoChron", type = 2, smooth = 3, storedat = TRUE) #type="regr"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]
clam("DevilsLakeGeoChron", type = 3, storedat = TRUE) #type="spline"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]

clam("DevilsLakeGeoChron", type = 4, storedat = TRUE) #type="smooth"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]
clam("DevilsLakeGeoChron", type = 4, smooth = 0.1, storedat = TRUE) #type="smooth"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]
clam("DevilsLakeGeoChron", type = 4, smooth = 0.6, storedat = TRUE) #type="smooth"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]
clam("DevilsLakeGeoChron", type = 4, smooth = 1, storedat = TRUE) #type="smooth"
calrange[calrange[,1] == 550,]
calrange[calrange[,1] == 490,]

Bacon("DevilsLakeAMS")
quantile(Bacon.Age.d(550), c(0.025, .5, 0.975))
quantile(Bacon.Age.d(490), c(0.025, .5, 0.975))
Bacon("DevilsLakeAMS", thick = 10)
quantile(Bacon.Age.d(550), c(0.025, .5, 0.975))
quantile(Bacon.Age.d(490), c(0.025, .5, 0.975))
Bacon("DevilsLakeAMS", thick = 20)
quantile(Bacon.Age.d(550), c(0.025, .5, 0.975))
quantile(Bacon.Age.d(490), c(0.025, .5, 0.975))
Bacon("DevilsLakeAMS", thick = 20, hiatus=450, hiatus.mean = 100)
