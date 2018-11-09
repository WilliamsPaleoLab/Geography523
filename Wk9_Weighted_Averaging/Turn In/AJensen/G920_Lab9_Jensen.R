#Allie Jensen
#GEOG 920
#Lab 9

#1. Canonical Correspondance Analysis

#Making a matrix of species data and temp data to calculate species scores
#and site scores
species.matrix <- matrix(data = c(79,19,2,10,60,33,7,12,36,44,20,14,18,43,
                                  39,16,6,31,63,18,1,18,81,20), nrow = 6, 
                         ncol = 4, byrow = TRUE)

#Adding column names to the matrix
colnames(species.matrix) <- c("spec1", "spec2", "spec3", "t.jul")

#Making a for loop over the 6 rows to calculate the score for species 1
spec1list <- c()
for (i in 1:6) {
  var <- (species.matrix[i, 1]/sum(species.matrix[1:6, 1]))*species.matrix[i,4]
  spec1list[i] <- var
}
spec1score <- sum(spec1list)

#Making a for loop over the 6 rows to calculate the score for species 2
spec2list <- c()
for (i in 1:6) {
  var <- (species.matrix[i, 2]/sum(species.matrix[1:6, 2]))*species.matrix[i,4]
  spec2list[i] <- var
}
spec2score <- sum(spec2list)

#Making a for loop over the 6 rows to calculate the score for species 3
spec3list <- c()
for (i in 1:6) {
  var <- (species.matrix[i, 3]/sum(species.matrix[1:6, 3]))*species.matrix[i,4]
  spec3list[i] <- var
}
spec3score <- sum(spec3list)

#Printing the species scores
spec1score
spec2score
spec3score
#The species 1 score is 12.15, the species 2 score is 14.94, and the species
#3 score is 17.75.

#Making a for loop over the 6 rows to calculate the site scores, adding site
#scores to a list
sitescorelist <- c()
for (i in 1:nrow(species.matrix)) {
  var <- (species.matrix[i, 1]/sum(species.matrix[i, 1:3]))*spec1score + (species.matrix[i, 2]/sum(species.matrix[i, 1:3]))*spec2score + (species.matrix[i, 3]/sum(species.matrix[1, 1:3]))*spec3score
  sitescorelist[i] <- var
}

#Printing the site scores list
sitescorelist
#The site 1 score is 12.79, the site 2 score is 13.46, the site 3 score is 14.49,
#the site 4 score is 15.53, the site 5 score is 16.54, and the site 6 score is
#17.18.

#2. Apply CCA to the Arctic Pollen Data

#Loading palaeoSig package from library
library(palaeoSig)

#Loading the arctic pollen data and environmental data
data("arctic.pollen")
data("arctic.env")

#Square-root transforming the pollen data
pollen.transform <- sqrt(arctic.pollen)

#Saving the temperature for all months as a new matrix
temp.months <- arctic.env[,12:23]

#Making a for loop to run CCA constrained by temperature for each month, saving
#the eigenvalues for each month in a vector
eigvec <- c()
for (i in 1:12) {
  v <- cca(formula = pollen.transform ~ temp.months[, i], data = arctic.env)
  eigvalue <- v$CCA$eig
  eigvec[i] <- eigvalue
}

#Assigning names to the eigenvalue vector
names(eigvec) <- c("Dec", "Jan", "Feb", "March", "April", "May", "June",
                   "July", "Aug", "Sept", "Oct", "Nov")

#Finding the highest eigenvalue, temperature variable that explains the most
#variance
max(eigvec)
#August temperature explains the most variance.


#Running CCA constrained by July and January temperatures
July <- cca(formula = pollen.transform ~ arctic.env$tjul + Condition(arctic.env$tjan),
    data = arctic.env)

Jan <- cca(formula = pollen.transform ~ arctic.env$tjan + Condition(arctic.env$tjul),
    data = arctic.env)

#July temperature alone (constrained in first test) explains about 12% of the
#total variance. January temperature alone (constrained in second test)
#explains about 4% of the total variance. Together, July and January 
#temperatures (conditional + constrained) explain about 17% of the total 
#variance. The residuals (unconstrained) explain about 83% of the variance.

#Running CCA constrained by January and July temperatures, annual precipitation,
#and July sunshine
four.vars <- cca(formula = pollen.transform ~ arctic.env$tjan + arctic.env$tjul + 
      arctic.env$ptotal + arctic.env$sjul, data = arctic.env)

#Together, these variables explain about 26% of the total variance. January 
#temperature explains about 18%, July temperature explains about 6%, annual
#precipitation explains about 2%, and July sunshine explains about 1%.

#Making a triplot of the CCA constrained by 4 environmental variables
plot(four.vars, scaling = 3, main = "CCA triplot for Norway pollen data 
     constrained by 4 environmental variables")

#The triplot shows several interesting patterns. First, it is clear that total
#precipitation and July temperature are positively correlated, as they both
#increase in the same direction. July sunshine and January temperature appear
#to be negatively correlated, as these variables increase in opposite directions.
#January temperature and July temperature are important in explaining the 
#distribution of response variables (pollen abundances), since much of the 
#pollen data is plotted close to their diagonals (if the diagonals were 
#extended into the upper left quadrant). There is a split in the data 
#around July sunshine, and much of the data is plotted closer to other 
#diagonals, meaning that July sunshine does not explain as much of the variance.

#Adding ordination surfaces for the 4 environmental variables
ordisurf(four.vars, arctic.env$tjan, col = 'blue', main = "Ordination Surface
         for January Temp")
ordisurf(four.vars, arctic.env$tjul, col = 'red', main = "Ordination Surface 
         for July Temp")
ordisurf(four.vars, arctic.env$ptotal, col = 'light blue', main = "Ordination
         Surface for Annual Precip")
ordisurf(four.vars, arctic.env$sjul, col = 'yellow', main = "Ordination Surface
         for July Sunshine")

#3. Weighted Averaging

#Plotting abundances of 4 pollen taxa as a function of July temperature
plot(arctic.env$tjul, pollen.transform$F.CYPE, pch = 16, xlab = "July Temp (C)",
     ylab = "Cyperaceae Abundance")
plot(arctic.env$tjul, pollen.transform$F.BBET, pch = 16, xlab = "July Temp (C)",
     ylab = "Betula Abundance")
plot(arctic.env$tjul, pollen.transform$F.PPIC, pch = 16, xlab = "July Temp (C)",
     ylab = "Picea Abundance")
plot(arctic.env$tjul, pollen.transform$F.PPIN, pch = 16, xlab = "July Temp (C)",
     ylab = "Pinus Abundance")

#Loading the analogue package from library
library(analogue)

#Estimating weighted average optima for the 4 pollen taxa
CYPE.optima <- optima(pollen.transform$F.CYPE, arctic.env$tjul)[1]
BBET.optima <- optima(pollen.transform$F.BBET, arctic.env$tjul)[1]
PPIC.optima <- optima(pollen.transform$F.PPIC, arctic.env$tjul)[1]
PPIN.optima <- optima(pollen.transform$F.PPIN, arctic.env$tjul)[1]

#Calculating weighted average tolerance for the 4 pollen taxa
CYPE.tolerance <- tolerance(pollen.transform$F.CYPE, arctic.env$tjul)[1]
BBET.tolerance <- tolerance(pollen.transform$F.BBET, arctic.env$tjul)[1]
PPIC.tolerance <- tolerance(pollen.transform$F.PPIC, arctic.env$tjul)[1]
PPIN.tolerance <- tolerance(pollen.transform$F.PPIN, arctic.env$tjul)[1]

#Adding the unimodal response approximated by weighted averaging to the 
#abundance plots for the 4 pollen taxa
plot(arctic.env$tjul, pollen.transform$F.CYPE, pch = 16, xlab = "July Temp (C)",
     ylab = "Cyperaceae Abundance (%)", ylim = c(0, 12))
lines(arctic.env$tjul, dnorm(x = arctic.env$tjul, mean = CYPE.optima, 
                             sd = CYPE.tolerance)*100, col = "red")

plot(arctic.env$tjul, pollen.transform$F.BBET, pch = 16, xlab = "July Temp (C)",
     ylab = "Betula Abundance (%)", ylim = c(0, 12))
lines(arctic.env$tjul, dnorm(x = arctic.env$tjul, mean = BBET.optima, 
                             sd = BBET.tolerance)*100, col = "red")

plot(arctic.env$tjul, pollen.transform$F.PPIC, pch = 16, xlab = "July Temp (C)",
     ylab = "Picea Abundance (%)", ylim = c(0, 12))
lines(arctic.env$tjul, dnorm(x = arctic.env$tjul, mean = PPIC.optima, 
                             sd = PPIC.tolerance)*100, col = "red")

plot(arctic.env$tjul, pollen.transform$F.PPIN, pch = 16, xlab = "July Temp (C)",
     ylab = "Pinus Abundance (%)", ylim = c(0, 12))
lines(arctic.env$tjul, dnorm(x = arctic.env$tjul, mean = PPIN.optima, 
                             sd = PPIN.tolerance)*100, col = "red")

#Running WA on the arctic pollen data, including July temperature to be modelled
WA.model <- rioja::WA(y = pollen.transform, x = arctic.env$tjul, mono = TRUE)
#Isolating the WA coefficients from the WA model output to estimate July 
#temperature optima for all taxa in the pollen data set
WA.model$coefficients
#Running CCA on arctic pollen data constrained by July temperature
CCA.July.model <- vegan::cca(formula = pollen.transform ~ arctic.env$tjul)
#Isolating the weighted species scores from the CCA model output
CCA.July.model$CCA$v
#Plotting the estimated July temperature optima by CCA species scores
plot(CCA.July.model$CCA$v, WA.model$coefficients, pch = '*', col = 'blue',
     xlab = "CCA Species Scores", ylab = "WA Coefficients")

#Predicting July temperatures using the weighted average model
predicted.July.temps <- predict(WA.model)
#Isolating the weighted site scores from the CCA model output
CCA.July.model$CCA$u
#Plotting the predicted July temperatures using inverse deshrinking by CCA
#site scores
plot(CCA.July.model$CCA$u, predicted.July.temps[,1], pch = 16, xlab = "CCA 
     Site Scores", ylab = "Predicted July Temperature (C)")
#Plotting the predicted July temperatures using classical deshrinking by CCA
#site scores
plot(CCA.July.model$CCA$u, predicted.July.temps[,2], pch = 16, xlab = "CCA 
     Site Scores", ylab = "Predicted July Temperature (C)")
#Plotting the predicted July temperatures using monotonic deshrinking by CCA
#site scores
plot(CCA.July.model$CCA$u, predicted.July.temps[,3], pch = 16, xlab = "CCA 
     Site Scores", ylab = "Predicted July Temperature (C)")

#Cross validating the WA model
cv.WA.model <- rioja::crossval(WA.model)
#Plotting apparent vs. cross validated predictions of July temperature
plot(cv.WA.model$predicted[,1], predicted.July.temps[,1], pch = '*', 
     col = 'blue', xlab = "Cross Validated July Temp (C)", ylab = "Apparent
     July Temp (C)")

#Calculating performance statistics for the WA model and cross-validated MA
#model
per.WA.model <- rioja::performance(WA.model)
per.WA.model
per.cv.WA.model <- rioja::performance(cv.MA.model)
per.cv.WA.model

#Compare MAT reconstruction to WA reconstruction of same environmental variable
#Loading neotoma package from library
library(neotoma)

#Loading the NAMPD pollen and climate data to be used in MAT reconstruction
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

#Using MAT on the NAMPD pollen proportions and mean annual precipitation
precip.mat.model <- rioja::MAT(Pollen.prop, Climate$annp, lean = FALSE)
#Plotting the MAT output
plot(precip.mat.model)
#Predicting mean annual precipitation at Hyde Park using Hyde pollen proportions
#and the MAT model
Hyde.pred <- predict(precip.mat.model, Hyde.prop)
#Isolating depths for the pollen samples at Hyde Park
Hyde.depths <- Hyde.data[[1]]$sample.meta$depth
#Plotting predicted mean annual precipitation vs. depth for Hyde Park
plot(Hyde.depths, Hyde.pred$fit[ ,'MAT'], type = 'l', xlab = "Depth (cm)", 
     ylab = "Mean Annual Precip (mm)", main = "Predicted Mean Annual Precipitation
     at Hyde Park, NY")

#Running WA on the NAMPD pollen, including mean annual precipitation to be modelled
precip.WA.model <- rioja::WA(y = Pollen.prop, x = Climate$annp, mono = TRUE)
#Predicting mean annual precipitation at Hyde Park using Hyde pollen proportions
#and the WA model
predicted.precip <- predict(precip.WA.model, newdata = Hyde.prop)
#Plotting predicted mean annual precipitation vs. depth for Hyde Park
plot(Hyde.depths, predicted.precip$fit[ ,'WA.inv'], type = 'l', xlab = "Depth (cm)", 
     ylab = "Mean Annual Precip (mm)", main = "Predicted Mean Annual Precipitation
     at Hyde Park, NY")

#The MAT and WA reconstructions of mean annual precipitation at Hyde Park
#have some clear differences. First of all, the MAT reconstruction has much
#more variability than the WA reconstruction, including many peaks and falls
#while the MA reconstruction appears smooth. The range of precipitation 
#predicted also varies between the two reconstructions, the MAT reconstruction
#ranges from 400 to 700 cm and the WA reconstruction ranges from 550 to 750 cm.
