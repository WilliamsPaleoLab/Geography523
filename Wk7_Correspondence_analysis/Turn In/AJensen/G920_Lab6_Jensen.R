#Allie Jensen
#GEOG 920
#Lab 6

#Question 2

#Loading the palaeoSig package from library
library(palaeoSig)

#Loading the arctic climate data and pollen data
data("arctic.env")
data("arctic.pollen")
#Square-root transforming the pollen data and saving it as a new variable
pollen.transformed <- sqrt(arctic.pollen)

#Loading the vegan package from library
library(vegan)

#Running correspondance analysis on the arctic pollen data
arctic.ca.1 <- cca(arctic.pollen)
#Viewing results of the correspondance analysis
summary(arctic.ca.1)

#Making a screeplot using the correspondance analysis output, adding the
#broken stick line
screeplot(arctic.ca.1, bstick = TRUE, main = "Screeplot of CA Analysis for Arctic Pollen Data")

#From the screeplot, it is clear that there are 5 significant components that
#explain about 70% of the variance. The first component explains 27% of the
#variance, the second component explains 14%, the third and fourth components
#explain about 1%, and the fifth component explains about 0.5% of the variance.

#Plotting site scores on correspondance analysis axes 1 and 2
plot(arctic.ca.1, display = 'sites', scaling = 3, type = "none", main = "Joint Plot for 
     Correspondance Analysis on Arctic Pollen Data")
points(arctic.ca.1, display = 'sites', scaling = 3, pch = 20)
points(arctic.ca.1, display = 'species', scaling = 3, pch = 4, col = c("red"))

#The scores appear to be compressed at the upper end of the component 2 axis 
#and they form a clear 90 degree angle, indicating that there is an arch effect.
#This means that we can interpret the component 1 axis, but there is no strong
#second dimension in the data, and we should refrain from interpreting the 
#component 2 axis. 

#Adding an ordination surface for July temp to the correspondance analysis
#joint plot
ordisurf(arctic.ca.1, arctic.env[,19], main = "Joint Plot with Ordination 
         Surface for July Temp.")

#Since there is an arch, plotting site scores on correspondance analysis axes
#3 and 2 to look at the data, then making an ordination surface plot using
#July temp
plot (arctic.ca.1, choices = c(3,2), display = 'sites', scaling = 3, type = "none")
points(arctic.ca.1, choices = c(3,2), display = 'sites', scaling = 3, pch = 20)
ordisurf(arctic.ca.1, choices = c(3,2), arctic.env[,19], main = "Joint Plot
         (Axes 3 and 2) with Ordination Surface for July Temp.")

#Question 4

#Reading in the Norway pollen data from RDS file
Norway.data <- readRDS("RDA_Data.RDS")
#Saving just the pollen data columns as a new variable
Norway.pollen <- Norway.data[,1:25]
#Saving just the precip data column as a new variable
Norway.precip <- Norway.data[,26]
#Saving just the temp data column as a new variable
Norway.temp <- Norway.data[,27]
#Square-root transforming the pollen data
Norway.pollen.transformed <- sqrt(Norway.pollen)

#Running RDA on Norway pollen data constrained by mean annual precip only
rda.precip <- rda(Norway.pollen.transformed ~ Norway.precip, scale = TRUE)
summary(rda.precip)
#The variance explained by the constrained RDA axis is 17% and the variance 
#explained by the unconstrained PCA axis is 83%.

#Running RDA on Norway pollen data constrained by July temp only
rda.temp <- rda(Norway.pollen.transformed ~ Norway.temp, scale = TRUE)
summary(rda.temp)
#The variance explained by the constrained RDA axis is 22% and the variance
#explained by the unconstrained PCA axis is 78%.

#Running RDA on the Norway pollen data constrained by both mean annual precip
#and July temp
rda.both <- rda(Norway.pollen.transformed ~ Norway.precip + Norway.temp, scale = TRUE)
summary(rda.both)
#The variance explained by the constrained RDA axis is 40% and the variance
#explained by the unconstrained PCA axis is 60%.

#Making a triplot for RDA using July temp and mean annual precip as constraints
plot(rda.both, scaling = 1, main = "Triplot of Redundancy Analysis for Norway
     Pollen Data, using Temp and Precip as Constraints")

#In this triplot, you can see low numbers, between 1 and 15, are grouped with 
#other low numbers and high numbers, between 30 and 50, are grouped with other 
#high numbers. This makes sense because all the lower number observationss 
#are from a similar time period, so they should have similar pollen counts 
#compared to higher number observations, and vice versa. The lower numbers
#seem to be separated from the higher numbers along RDA axis 1, meaning this
#axis likely explains much of the variation for these observations, while the
#higher numbers seem to be split along RDA axis 2, meaning this axis is 
#important for these observations. The arrows show the direction of increasing
#gradients in precip and temp -- sites from 20 to mid-30s are located along the
#precip arrow, and sites from mid-30s to 40s are located along the temp arrow.

#Plotting ordination surfaces of mean annual precip and July temp
ordisurf(rda.both, Norway.precip, main = "Ordination Surface for Mean Annual Precip")
ordisurf(rda.both, Norway.temp, main = "Ordination Surface for July Temp")




#Extra code for writing a redundancy analysis function (unfinished, can ignore)

#For loop to regress all the pollen data columns on the precip data, saving the
#pollen data fitted values and pollen data residuals as separate lists
pollen.fittedvalues <- list()
pollen.residuals <- list()
for(i in 1:ncol(Norway.pollen.transformed)) {
  model <- lm(Norway.pollen.transformed[,i] ~ Norway.precip)
  pollen.fittedvalues[[i]] <- model$fitted.values
  pollen.residuals[[i]] <- model$residuals
}

#Unlisting the fitted values and residuals, converting to a matrix where columns
#are pollen taxa, rows are observations for PCA
pollen.fittedvalues.precip <- matrix(unlist(pollen.fittedvalues), nrow = 45,
                                     ncol = 25, byrow = FALSE)
pollen.residuals.precip <- matrix(unlist(pollen.residuals), nrow = 45, ncol
                                  = 25, byrow = FALSE)

#Running PCA on the fitted values to find RDA axis 1, running PCA on residuals
#to find PCA axes 1 to n-1
rda1.precip <- rda(pollen.fittedvalues.precip, scale = TRUE)
pca1.precip <- rda(pollen.residuals.precip, scale = TRUE)

#For loop to regress all the pollen data columns on the temp data, saving the
#pollen data fitted values and pollen data residuals as separate lists
pollen.fittedvalues2 <- list()
pollen.residuals2 <- list()
for(i in 1:ncol(Norway.pollen.transformed)) {
  model <- lm(Norway.pollen.transformed[,i] ~ Norway.temp)
  pollen.fittedvalues2[[i]] <- model$fitted.values
  pollen.residuals2[[i]] <- model$residuals
}

#Unlisting the fitted values and residuals, converting to a matrix where columns
#are pollen taxa, rows are observations for PCA
pollen.fittedvalues.temp <- matrix(unlist(pollen.fittedvalues2), nrow = 45,
                                     ncol = 25, byrow = FALSE)
pollen.residuals.temp <- matrix(unlist(pollen.residuals2), nrow = 45, ncol
                                  = 25, byrow = FALSE)

#Running PCA on the fitted values to find RDA axis 1, running PCA on residuals
#to find PCA axes 1 to n-1
rda1.temp<- rda(pollen.fittedvalues.temp, scale = TRUE)
pca1.temp<- rda(pollen.residuals.temp, scale = TRUE)