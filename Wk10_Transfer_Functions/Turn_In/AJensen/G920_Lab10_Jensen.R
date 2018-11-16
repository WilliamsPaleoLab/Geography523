#Allie Jensen
#GEOG 920
#Lab 10

#1. Comparison of Transfer Functions

#Loading rioja package from library
library(rioja)

#Loading pH and diatom data
data("SWAP")
data(RLGH)

#Running WAPLS on pH and diatom data using 2 pls components
WAPLS.model <- WAPLS(SWAP$spec, SWAP$pH, npls=2)
#Cross validating the WAPLS model
cv.WAPLS.model <- rioja::crossval(WAPLS.model)

#Predicting pH using the WAPLS model and predict() function
WAPLS.ph.predict <- predict(WAPLS.model, newdata = RLGH$spec)

#Running WA on the pH and diatom data
WA.ph.model <- WA(y = SWAP$spec, x = SWAP$pH)
#Predicting pH using the WA model and predict() function
WA.ph.predict <- predict(WA.ph.model, newdata = RLGH$spec)

#Running MAT on the pH and diatom data using square-chord distances
MAT.ph.model <- MAT(y = SWAP$spec, x = SWAP$pH, dist.method = "sq.chord")
#Predicting pH using the MAT model and predict() function
MAT.ph.predict <- predict(MAT.ph.model, newdata = RLGH$spec)

#Formatting the predicted pH data for plotting
WAPLS.vec <- as.vector(unname(WAPLS.ph.predict$fit[,1]))
WA.vec <- as.vector(unname(WA.ph.predict$fit[,2]))
MAT.vec <- as.vector(unname(MAT.ph.predict$fit[,2]))

#Comparing the 3 pH reconstructions by time series plot
jpeg("DiatomLine.jpeg")
plot(x = RLGH$depths[,2], MAT.vec, type = 'l', ylim = c(4.6,5.5), col = "blue",
     xlab = "Depth (cm)", ylab = "pH")
lines(WA.vec, col = "light blue")
lines(WAPLS.vec, col = "light green")
legend(x = "topleft", legend = c("MAT", "WA", "WAPLS"), lty = c(1, 1, 1), 
       col = c("blue", "light blue", "light green"))
dev.off()

#Comparing the 3 pH reconstructions by scatter plot
jpeg("DiatomScatter.jpeg")
plot(x = RLGH$depths[,2], MAT.vec, pch = 16, ylim = c(4.6,5.4), col = "blue",
     xlab = "Depth (cm)", ylab = "pH")
points(WA.vec, pch = 16, col = "light blue")
points(WAPLS.vec, pch = 16, col = "light green")
legend(x = "topleft", legend = c("MAT", "WA", "WAPLS"), lty = c(1, 1, 1), 
       col = c("blue", "light blue", "light green"))
dev.off()

#Creating a dataframe with the 3 types of reconstructions as columns
reconstructions <- data.frame(WAPLS.vec, WA.vec, MAT.vec)
#Calculating correlations between the 3 types of reconstructions
cor(reconstructions)
#Plotting the correlations between the 3 types of reconstructions
jpeg("DiatomPairs.jpeg")
pairs(reconstructions)
dev.off()

#MAT uses 5 different analogues.

#2. Spatial Autocorrelation

#Loading palaeoSig package from library
library(palaeoSig)

#Loading Arctic pollen and Arctic environmental data
data(arctic.pollen)
data("arctic.env")

#Square-root transforming the pollen data
pollen.transform <- sqrt(arctic.pollen)

#Running MAT on the pollen data and July sunshine using the Euclidean Squared distance metric
MAT.sjul <- rioja::MAT(pollen.transform, x = arctic.env$sjul, dist.method = "sq.euclidean", lean = FALSE)
#Cross validating the MAT model
cv.MAT.sjul <- rioja::crossval(MAT.sjul)

#Running MAT on the pollen data and July temp using the Euclidean Squared distance metric
MAT.tjul <- rioja::MAT(y = pollen.transform, x = arctic.env$tjul, dist.method = "sq.euclidean", lean = FALSE)
#Cross validating the MAT model
cv.MAT.tjul <- rioja::crossval(MAT.tjul)

#Running WA on the pollen data and July sunshine
WA.sjul <- rioja::WA(y = pollen.transform, x = arctic.env$sjul, mono = TRUE)
#Cross validating the WA model
cv.WA.sjul <- rioja::crossval(WA.sjul)

#Running WA on the pollen data and July temp
WA.tjul <- rioja::WA(y = pollen.transform, x = arctic.env$tjul, mono = TRUE)
#Cross validating the WA model
cv.WA.tjul <- rioja::crossval(WA.tjul)

#Generating a matrix of random data to train the transfer functions
env.data <- matrix(data = runif(n = 999*nrow(arctic.env), 0, 1), nrow = nrow(arctic.env), ncol = 999)

#Running MAT on the pollen data and each column of the random data matrix (simulated
#environmental variables), cross validating the MAT model, computing the 
#performance statistics for the cross-validated model, and saving the 
#r-squared values in a list 
r.squared.list <- list()
for (i in 1:ncol(env.data)) {
  MAT.rand <- rioja::MAT(y = pollen.transform, x = env.data[ ,i], dist.method = "sq.euclidean", 
                         lean = FALSE)
  cv.rand <- rioja::crossval(MAT.rand)
  per.rand <- rioja::performance(cv.rand)
  r.squared <- per.rand$crossval[1:5, 2]
  r.squared.list[[i]] <- r.squared
}

#Running WA on the pollen data and each column of the random data matrix (simulated
#environmental variables), cross validating the WA model, computing the 
#performance statistics for the cross-validated model, and saving the 
#r-squared values in a list 
r.squared.list2 <- list()
for (i in 1:ncol(env.data)) {
  WA.rand <- rioja::WA(y = pollen.transform, x = env.data[ ,i])
  cv.WA.rand <- rioja::crossval(WA.rand)
  per.WA.rand <- rioja::performance(cv.WA.rand)
  r.squared2 <- per.WA.rand$crossval[, 2]
  r.squared.list2[[i]] <- r.squared2
}

#Plotting histograms of the cross-validated R^2 values using MAT and WA on 
#999 columns of randomly-simulated environmental data
jpeg("MATandWARandom.jpeg")
par(mfrow=c(1,2))
hist(unlist(r.squared.list), xlab = "R^2 Values", main = "MAT using random data")
hist(unlist(r.squared.list2), xlab = "R^2 Values", main = "WA using random data")
dev.off()

#Loading the spatially-structured random data from the working directory
sjul.random <- readRDS('sjul.RDS')
tjul.random <- readRDS('tjul.RDS')

#Reformating the July sunshine data into a matrix with 796 rows and 999 cols
s <- unlist(sjul.random @data)
l <- unname(s)
sjul.matrix <- matrix(data = l, nrow = 796, ncol = 999, byrow = FALSE)

#Reformatting the July temp data into a matrix with 796 rows and 999 cols
s2 <- unlist(tjul.random @data)
l2 <- unname(s2)
tjul.matrix <- matrix(data = l2, nrow = 796, ncol = 999, byrow = FALSE)

#Removing all the pollen data sites that are duplicates in order to run
#transfer functions
latlong <- data.frame(arctic.env$Latitude, arctic.env$Longitude)
dup <- duplicated(latlong)
pollen.transform.new <- pollen.transform[!dup,]

#Running MAT on the pollen data and spatially-structured July sunshine data,
#cross validating the MAT model, computing the performance statistics for the
#cross-validated model, and saving the r-squared values in a list 
sjul.random.list <- list()
for (i in 1:ncol(sjul.random)) {
  MAT.rand <- rioja::MAT(y = pollen.transform.new, x = sjul.matrix[ ,i], dist.method = "sq.euclidean", 
                         lean = FALSE)
  cv.rand <- rioja::crossval(MAT.rand)
  per.rand <- rioja::performance(cv.rand)
  r.squared <- per.rand$crossval[1:5, 2]
  sjul.random.list[[i]] <- r.squared
}

#Running MAT on the pollen data and spatially-structured July temp data,
#cross validating the MAT model, computing the performance statistics for the
#cross-validated model, and saving the r-squared values in a list 
tjul.random.list <- list()
for (i in 1:ncol(tjul.random)) {
  MAT.rand <- rioja::MAT(y = pollen.transform.new, x = tjul.matrix[ ,i], dist.method = "sq.euclidean", 
                         lean = FALSE)
  cv.rand <- rioja::crossval(MAT.rand)
  per.rand <- rioja::performance(cv.rand)
  r.squared <- per.rand$crossval[1:5, 2]
  tjul.random.list[[i]] <- r.squared
}

jpeg("JulyCompare.jpeg")
#Setting graphical parameters to plot 3 graphs in same row
par(mfrow = c(1,3))

#Unlisting the cross-validated R^2 values produced by running MAT on
#random July temp data
r.squared.vec <- unlist(r.squared.list)

#Making a histogram of the R^2 values for the random July temp data
hist(r.squared.vec, xlab = "R Squared Values", xlim = c(0, 0.02), main = 
       "Random Data R^2")

#Unlisting the cross-validated R^2 values produced by running MAT on
#spatially structured July temp data
r.squared.ss <- unlist(tjul.random.list)

#Making a histogram of the R^2 values for the spatially structured July temp data
hist(r.squared.ss, xlab = "R Squared Values", xlim = c(0.2, 0.8), main = 
       "Spatially-Structured Data R^2")

#Calculating performance statistics for the actual MAT model using July temp 
per.cv.MAT.tjul <- rioja::performance(cv.MAT.tjul)
per.cv.MAT.tjul$crossval[1:5, 2]
#Making a histogram of the R^2 values for the actial MAT model using July temp
plot(per.cv.MAT.tjul$crossval[1:5, 2], pch = 16, ylab = "R Squared Values", main = 
       "Actual MAT R^2")
dev.off()

#Comparing the R^2 values of MAT with random July temp data to MAT with
#real July temp data, there are clear differences in the model's predictive
#ability. Using MAT with completely random data generates very low R^2 values
#that are close to 0. Using MAT with spatially structured data generates higher
#R^2 values, centered around 0.5-0.6. Using MAT with actual temp data produces
#the highest R^2 values, around 0.85. This tells us that spatial autocorrelation
#is important for the MAT technique, as spatially-correlated data can 
#significantly change the model results. 

jpeg("SunshineCompare.jpeg")
#Setting graphical parameters to plot 3 graphs in same row
par(mfrow = c(1,3))

#Making a histogram of the R^2 values for the random July sunshine data
hist(r.squared.vec, xlab = "R Squared Values", xlim = c(0, 0.02), main = 
       "Random Data R^2")

#Unlisting the cross-validated R^2 values produced by running MAT on
#spatially structured July sunshine data
r.squared.ssun <- unlist(sjul.random.list)

#Making a histogram of the R^2 values for the spatially structured July sunshine data
hist(r.squared.ssun, xlab = "R Squared Values", xlim = c(0.5, 0.9), main = 
       "Spatially-Structured Data R^2")

#Calculating performance statistics for the actual MAT model using July sunshine 
per.cv.MAT.sjul <- rioja::performance(cv.MAT.sjul)
per.cv.MAT.sjul$crossval[1:5, 2]
#Making a histogram of the R^2 values for the actial MAT model using July sunshine
plot(per.cv.MAT.sjul$crossval[1:5, 2], pch = 16, ylab = "R Squared Values", main = 
       "Actual MAT R^2")
dev.off()

#Looking at the R^2 values for MAT using random July sunshine data vs. actual
#July sunshine data yields a similar result as July temp. R^2 values are low,
#around 0, when completely random data is used. The R^2 values are quite high,
#around 0.85, when spatially structured data is used, and R^2 values are also
#high when actual July sunshine data is used. Once again, this tells us that
#spatial autocorrelation has a large impact on the outcome of transfer functions
#like MAT.

#3. Assessment of Transfer Functions

#Loading neotoma and vegan packages from library
library(neotoma)
library(vegan)

#Loading the NAMPD pollen data and climate data
data(Pollen)
data(Climate)

#Retrieving site data for Hyde Park, NY
Hyde.site <- get_site(sitename = "Hyde Park")
#Retrieving dataset info for Hyde Park, NY
Hyde.dataset <- get_dataset(Hyde.site)
#Downloading datasets from Hyde Park, NY
Hyde.data <- get_download(Hyde.dataset)
#Isolating the pollen data and saving it as a new variable
Hyde.pollen <- Hyde.data[[1]]
#Compiling the Hyde Park pollen taxa using the Whitemore list, the list of
#taxa used in the NAMPD
Hyde.pollen.comp <- compile_taxa(Hyde.pollen, list.name = "WhitmoreFull")
#Isolating the pollen counts and saving them as a new variable
Hyde.counts <- Hyde.pollen.comp$counts
#Removing the "other" column from the Hyde Park pollen counts, since this is
#not a taxa in the NAMPD
Hyde.counts.final <- Hyde.counts[ , c(-31)]

#Subsetting the NAMPD pollen counts by taxa in the compiled Hyde Park pollen counts
Pollen.counts <- Pollen[which(colnames(Pollen) %in% colnames(Hyde.counts))]
#Converting the Hyde Park pollen counts to pollen proportions
Hyde.sums <- apply(Hyde.counts.final, 1, sum)
Hyde.prop <- (Hyde.counts.final/Hyde.sums)
#Converting the NAMPD pollen counts to pollen proportions
Pollen.sums <- apply(Pollen.counts, 1, sum)
Pollen.prop <- (Pollen.counts/Pollen.sums)

#Running MAT on the NAMPD pollen proportions and July temp
tjul.MAT.model <- rioja::MAT(Pollen.prop, Climate$tjul, lean = FALSE)

#Predicting July temp at Hyde Park using Hyde pollen proportions and the MAT
#model
tjul.MAT.Hyde.pred <- predict(tjul.MAT.model, Hyde.prop)

#Running MAT on the NAMPD pollen proportions and Jan temp
tjan.MAT.model <- rioja::MAT(Pollen.prop, Climate$Sitename, lean = FALSE)

#Predicting Jan temp at Hyde Park using Hyde pollen proportions and the MAT
#model
tjan.MAT.Hyde.pred <- predict(tjan.MAT.model, Hyde.prop)

#Running WA on the NAMPD pollen, including July temp to be modelled
tjul.WA.model <- rioja::WA(y = Pollen.prop, x = Climate$tjul, mono = TRUE)

#Predicting July temp at Hyde Park using Hyde pollen proportions and the WA 
#model
tjul.WA.Hyde.pred <- predict(tjul.WA.model, newdata = Hyde.prop)

#Running WA on the NAMPD pollen, including Jan temp to be modelled
tjan.WA.model <- rioja::WA(y = Pollen.prop, x = Climate$Sitename, mono = TRUE)

#Predicting Jan temp at Hyde Park using Hyde pollen proportions and the WA 
#model
tjan.WA.Hyde.pred <- predict(tjan.WA.model, newdata = Hyde.prop)

#Running WAPLS on the NAMPD pollen proportions and July temp using 3 pls 
#components
tjul.WAPLS.model <- WAPLS(Pollen.prop, Climate$tjul, npls=3)

#Predicting July temp at Hyde Park using Hyde pollen proportions and the WAPLS
#model
tjul.WAPLS.Hyde.pred <- predict(tjul.WAPLS.model, newdata = Hyde.prop)

#Running WAPLS on the NAMPD pollen proportions and Jan temp using 3 pls
#components
tjan.WAPLS.model <- WAPLS(Pollen.prop, Climate$Sitename, npls=3)

#Predicting Jan temp at Hyde Park using Hyde pollen proportions and the WAPLS
#model
tjan.WAPLS.Hyde.pred <- predict(tjan.WAPLS.model, newdata = Hyde.prop)

#Isolating depths for the pollen samples at Hyde Park
Hyde.depths <- Hyde.data[[1]]$sample.meta$depth

jpeg("HydeJulytemp.jpeg")
#Setting graphical parameters back to default
par(mfrow=c(1,1))

#Plotting predicted July temp using the 3 different reconstruction methods
plot(Hyde.depths, tjul.MAT.Hyde.pred$fit[ ,'MAT'], type = 'l', col = "red",
     xlab = "Depth (cm)", ylab = "July Temp (C)")
lines(Hyde.depths, as.vector(unname(tjul.WA.Hyde.pred$fit[ ,2])), col = "orange")
lines(Hyde.depths, as.vector(unname(tjul.WAPLS.Hyde.pred$fit[,1])), col = "yellow")
legend(x = "topleft", legend = c("MAT", "WA", "WAPLS"), lty = c(1, 1, 1), 
       col = c("red", "orange", "yellow"))
dev.off()

#The general trends of the reconstructions agree, as they predict lower July
#temps from 0 to 75 cm, then a large increase in July temp, then higher
#July temps for the rest of the record. However, the actual temperatures
#predicted by the reconstructions differ by method. MAT predicts higher July
#temps compared to WA, which predicts lower July temps. These different results
#come from the different ways the reconstructions are calculated, for example
#MAT is a local method that uses samples close to the sample of interest to
#calculate the environmental variable, while WA is a global method that uses
#all samples to calculate the environmental variable.

jpeg("HydeJanTemp.jpeg")
#Plotting predicted Jan temp using the 3 different reconstruction methods
plot(Hyde.depths, tjan.MAT.Hyde.pred$fit[ ,'MAT'], type = 'l', col = "blue",
     xlab = "Depth (cm)", ylab = "July Temp (C)", ylim = c(-26, -10))
lines(Hyde.depths, as.vector(unname(tjan.WA.Hyde.pred$fit[ ,2])), col = "purple")
lines(Hyde.depths, as.vector(unname(tjan.WAPLS.Hyde.pred$fit[,1])), col = "green")
legend(x = "topleft", legend = c("MAT", "WA", "WAPLS"), lty = c(1, 1, 1), 
       col = c("blue", "purple", "green"))
dev.off()

#Using the 3 methods of reconstruction for Jan temp, the general trends of
#the WA and WAPLS reconstructions are very similar, but the MAT reconstruction
#deviates from these. I would expect this result because WAPLS is a combination
#of WA and partial least squares, so it makes sense that the two methods
#would produce similar reconstructions. MAT is calculated differently, using
#the 5 closest analogues to the sample of interest, which might explain why
#this method produced a different trend. 

#Making a dataframe of July temps with the 3 reconstruction methods
July.temps <- data.frame(MAT = tjul.MAT.Hyde.pred$fit[ ,'MAT'], WA = as.vector(unname(tjul.WA.Hyde.pred$fit[ ,2])),
                         WAPLS = as.vector(unname(tjan.WAPLS.Hyde.pred$fit[,1])))

#Calculating correlations between the 3 reconstruction methods for July temp
cor(July.temps)
jpeg("JulyTempPairs.jpeg")
pairs(July.temps)
dev.off()

#Making a dataframe of Jan temps with the 3 reconstruction methods
Jan.temps <- data.frame(MAT = tjan.MAT.Hyde.pred$fit[ ,'MAT'], WA = as.vector(unname(tjan.WA.Hyde.pred$fit[ ,3])),
                        WAPLS = as.vector(unname(tjan.WAPLS.Hyde.pred$fit[,1])))

#Calculating correlations between the 3 reconstruction methods for Jan temp
cor(Jan.temps)
jpeg("JanTempPairs.jpeg")
pairs(Jan.temps)
dev.off()

#Making a dataframe of the WA optimas for Jan and July temps
optimas <- data.frame(tjan.WA.model$coefficients, tjul.WA.model$coefficients)
#Calculating the correlation between the optimas
cor(optimas)
jpeg("OptimaPairs.jpeg")
pairs(optimas)
dev.off()

#Making a dataframe of actual Jan and July temps from original data
temps <- data.frame(Jan = Climate$Sitename, Jul = Climate$tjul)
#Calculating the correlation between the actual temps
cor(temps)
jpeg("ActualTempPairs.jpeg")
pairs(temps)
dev.off()

#The optimas have an r value of 0.89 and the actual temps have an r value
#of 0.74, which means the predicted temperature optimas are more closely
#related than the actual temperatures.

#Calculating the minimum square-chord distances for July temp in each
#Hyde Park sample
min.jul.distances <- apply(tjul.MAT.Hyde.pred$dist.n, 1, min)
#Plotting the minimum SCD vs. depth
jpeg("MinSCD.jpeg")
plot(Hyde.depths, min.jul.distances, pch = 16, xlab = "Depth (cm)", ylab = 
       "Minimum Square-Chord Distance")
dev.off()

#Calculating the standard deviation of the July temp analogues chosen for 
#each Hyde Park sample
std.dev <- apply(tjul.MAT.Hyde.pred$x.n, 1, sd)
#Plotting the minimum SCD vs. standard deviation
jpeg("SCDandSD.jpeg")
plot(std.dev, min.distances, pch = 16, xlab = "Standard Dev of Analogues", 
     ylab = "Minimum Square-Chord Distance")
dev.off()

#Making a dataframe with Jan and July temps of all analogues chosen by MAT
analogtemps <- data.frame(tjul.MAT.Hyde.pred$x.n, tjan.MAT.Hyde.pred$x.n)
#Calculating the correlation between all analogues chosen by MAT
cor(analogtemps)
jpeg("AllAnalogPairs.jpeg")
pairs(analogtemps)
dev.off()

#Making a dataframe with Jan and July temps predicted by MAT
MAT.reconstruct <- data.frame(Jul = tjul.MAT.Hyde.pred$fit[ ,'MAT'], Jan = tjan.MAT.Hyde.pred$fit[ , 'MAT'])
#Calculating the correlation between Jan and July temps predicted by MAT
cor(MAT.reconstruct)
jpeg("ReconstructPairs.jpeg")
pairs(MAT.reconstruct)
dev.off()

