#Allie Jensen
#GEOG 920
#Lab 5

#Loading the palaeosig package from my library
library(palaeoSig)

#Loading the arctic climate data, saving the 6 important columns as new variables,
#combining the columns to create a dataframe of the 6 variables of interest
data("arctic.env")
maxtemp <- arctic.env[,10]
mintemp <- arctic.env[,11]
avgtemp <- arctic.env[,9]
julyprecip <- arctic.env[,32]
janprecip <- arctic.env[,26]
sumprecip <- arctic.env[,25]
climdata <- cbind(maxtemp, mintemp, avgtemp, julyprecip, janprecip, sumprecip)

#Running PCA on the climate data with princomp, using the correlation matrix
pcacorr <- princomp(climdata, cor = TRUE, scores = TRUE)
#Viewing results of PCA
summary(pcacorr)

#Creating a screeplot with the princomp object
screeplot(pcacorr, npcs = 6, type = c("barplot"), 
          main = "PCA Using Correlation Matrix for Arctic Climate Data")

#Running PCA on the climate data with princomp, using the covariance matrix
pcacov <- princomp(climdata, cor = FALSE, scores = TRUE)
#Viewing the results of PCA
summary(pcacov)

#Creating a screeplot with princomp object
screeplot(pcacov, npcs = 6, type = c("barplot"), 
          main = "PCA Using Covariance Matrix for Arctic Climate Data")

#The variances explained are very different using the correlation and 
#covariance matrices. In the covariance matrix, component 1 explains about
#99% of the variance, while in the correlation matrix, component 1 explains
#about 65% and component 2 explains about 25%. The variances are so different
#because the correlation matrix uses standardized variables, meaning they all
#have the same weight. Without standardized variables, the precipitation sum 
#has more weight than the other variables, so it dominates the analysis. 

#Creating a biplot with the princomp output, using the correlation matrix
biplot(pcacorr, cex = 0.6, main = "Biplot Using Standardized Variables for 
       Arctic Climate Data")

#The biplot shows that max temp and min temp are the dominant variables on axis 
#2, while the precipitation variables, account for variation along axis 1.

#Running PCA on the climate data with rda, not scaled to unit variance
rdanoscale <- rda(climdata, scale = FALSE)
#Viewing the results of PCA
summary(rdanoscale)
#Creating screeplot with the rda output
screeplot(rdanoscale, npcs = 6, type = c("barplot"), main = "PCA Not Scaled
          to Unit Variance for Arctic Climate Data")

#Running PCA on the climate data with rda, scaled to unit variance
rdascale <- rda(climdata, scale = TRUE)
#Viewing the results of PCA
summary(rdascale)
#Creating screeplot with the rda output
screeplot(rdascale, npcs = 6, type = c("barplot"), main = "PCA Scaled to Unit
          Variance for Arctic Climate Data")

#Running PCA with the rda function yields a similar result -- with the data
#not scaled by variance, component 1 explains 99% of the variance and this
#component is highly correlated with sum of precipitation. With the data
#scaled by variance, component 1 explains 64% and component 2 explains 25% 
#of the variance. 

#Creating a biplot with the rda output, scaled to unit variance
plot(rdascale, scaling = 1, display = 'sites', xlim = c(-1,1), ylim = c(-1,1), type = "n")
#Adding points to the plot for "sites" or observations
points(rdascale, display = 'sites', scaling = 1, pch = 1, col = arctic.env$BIOME)
#Adding points to the plot for "species" or climate variables
points(rdascale, display = 'species', scaling = 0, pch = 15, col = 4)
#Adding text to the plot to label the climate variables
text(rdascale, display = 'species', scaling = 0, pos = 1)

#The biplot shows that all climate variables have a positive score on axis 1,
#but there is more variation along axis 2, with max temp, avg temp, and july
#precip having a positive score and sum precip, jan precip, and min temp
#having negative scores. The site data is largely clumped in the middle, with
#a group of sites having a more negative score on axis 2 and larger spread on
#axis 1.

#When color-coding the sites by biome, it is clear that axis 2 helps discriminate
#between the biomes. Max and min temperature have high loadings on this axis,
#making it clear that temperature is important in explaining the difference
#between biomes.

#Loading the neotoma package from my library
library(neotoma)

#Retrieving site object, dataset object, and downloading datasets from neotoma.
#Isolating the pollen dataset and compiling taxa to the top 25.
Patschke.site <- get_site(sitename = "Patschke Bog")
Patschke.dataset <- get_dataset(Patschke.site)
Patschke.data <- get_download(Patschke.dataset)
Patschke.pollen <- Patschke.data[[2]]
Patschke.pollen.25 <- compile_taxa(Patschke.pollen, list.name = "P25")

#Isolating pollen counts from the pollen dataset, summing pollen counts and
#calculating percentages, removing taxa that have an average of less than 2%.
#Isolating pollen count dates from the pollen dataset.
Patschke.counts <- Patschke.pollen.25$counts
Patschke.sums <- apply(Patschke.counts, 1, sum)
Patschke.percents <- (Patschke.counts/Patschke.sums)*100
Patschke.percents.norare <- Patschke.percents[, colMeans(Patschke.percents, na.rm = TRUE) > 2]
Patschke.dates <- Patschke.data[[2]]$sample.meta$age

#Using the pollen count dates to limit pollen percentages to the last
#9000 years. 
Patschke.dates.recent <- Patschke.dates[1:19]
Patschke.counts.recent <- Patschke.percents.norare[1:19,]

#Transforming the pollen percentages by square root. 
Patschke.counts.transform <- sqrt(Patschke.counts.recent)

#Performing PCA on the transformed pollen percentages using rda(), scaled to unit variance
rdapollen <- rda(Patschke.counts.transform, scale = TRUE)
#Making a screeplot for the rda output, adding a broken stick
screeplot(rdapollen, type = c("barplot"), bstick = TRUE, main = "PCA for Patschke
          Bog Pollen Data")

#Based on the screeplot, there are 4 significant axes, as the broken 
#stick intersects with the bars representing the first 4 components and the
#bars representing the last two components fall below the broken stick line. 

#Saving the scores of the rda output as a new variable
s <- scores(rdapollen)
#Plotting PC1 for the "sites" or observations
plot(s$sites[,1], scaling = 1, display = 'sites', type = "l", ylab = "PC1")

#Creating a biplot with the rda pollen output 
plot(rdapollen, scaling = 1, display = 'sites', xlim = c(-1,1), ylim = c(-1,1))
#Adding points to the plot for "sites" or observations
points(rdapollen, display = 'sites', scaling = 1, pch = 16)
#Adding points to the plot for "species" or pollen taxa
points(rdapollen, display = 'species', scaling = 0, pch = 15, col = c("red"))
#Adding text to the plot to label the pollen taxa
text(rdapollen, display = 'species', scaling = 0, pos = 1)

#In the pollen data biplot, Alnus, Poaceae, and Prairie Forbs have high
#loadings on axis 2 in the negative direction. This makes sense because 
#Poaceae and Prairie Forbs follow very similar trajectories through the 
#last 9000 years, however it is unclear why Alnus has a high loading on this
#axis, since it is present in low quantities over the past 9000 years.
#Cyperaceae has a high loading on axis 2 in the positive direction, which 
#also makes sense because it peaks at a different time than Poaceae and 
#Prairie Forbs. Quercus and "Other" appear to be explained by axis 1, and 
#they fall very close to each other, which makes sense because their trajectories
#over the last 9000 years are almost identical. 

