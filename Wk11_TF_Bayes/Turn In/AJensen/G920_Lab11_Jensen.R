#Allie Jensen
#GEOG 920
#Lab 11

#1. Significance of pH Reconstruction

#Loading necessary data
data(SWAP)
data(RLGH)
library(palaeoSig)

#Running WAPLS on surface sediment diatom data and lake pH data
#Using 2 components
WAPLS.model <- WAPLS(sqrt(SWAP$spec), SWAP$pH, npls=2)
#Predicting past pH using the WAPLS model and downcore diatom data
WAPLS.ph.predict <- predict(WAPLS.model, newdata = sqrt(RLGH$spec))

#Running WA on surface sediment diatom data and lake pH data
WA.ph.model <- WA(y = sqrt(SWAP$spec), x = SWAP$pH)
#Predicting past pH using the WA model and downcore diatom data
WA.ph.predict <- predict(WA.ph.model, newdata = sqrt(RLGH$spec))

#Running MAT on surface sediment diatom data and lake pH data
MAT.ph.model <- MAT(y = sqrt(SWAP$spec), x = SWAP$pH, dist.method = "sq.euclidean")
#Predicting past pH using the MAT model and downcore diatom data
MAT.ph.predict <- predict(MAT.ph.model, newdata = sqrt(RLGH$spec))

#Using randomTF to test the MAT-based pH reconstruction
MAT.randomTF <- randomTF(spp = sqrt(SWAP$spec), env = data.frame(pH = SWAP$pH), 
                fos = sqrt(RLGH$spec), n = 999, fun = MAT, col = 1, 
                dist.method = "sq.euclidean")
plot(MAT.randomTF)

#From this plot, it is clear that the pH reconstruction explains about 41% 
#of the variance and the first axis of the unconstrained ordination explains 
#about 47% of the variance. 

#Using randomTF to test the WA-based pH reconstruction
WA.randomTF <- randomTF(spp = sqrt(SWAP$spec), env = data.frame(pH = SWAP$pH), 
               fos = sqrt(RLGH$spec), n = 999, fun = WA, col = 1)
plot(WA.randomTF)

#Using the WA method, the pH reconstruction explains about 46% of the variance
#and the first axis of the unconstrained ordination explains about 47% of the 
#variance. This shows that pH explains about the maximum amount of variation
#that any single environmental variable can explain.

#Using randomTF to test the WAPLS-based pH reconstruction
WAPLS.randomTF <- randomTF(spp = sqrt(SWAP$spec), env = data.frame(pH = SWAP$pH), 
                           fos = sqrt(RLGH$spec), n = 999, fun = WAPLS, col = 2)
plot(WAPLS.randomTF)

#Using the WAPLS method, the pH reconstruction explains about 45% of the variance
#and the first axis of the unconstrained ordination explains about 47% of the 
#variance. This pH reconstruction is very similar to the WA pH reconstruction.

#Using obscor to test the WA and WAPLS-based pH reconstructions
WA.obscor <- obs.cor(spp = sqrt(SWAP$spec), env = SWAP$pH, fos = sqrt(RLGH$spec), 
                     ord = rda, n = 999)
plot(WA.obscor, ylim = c(-1.5, 1.5))
hist(WA.obscor$sim$n2.joint, xlab = "Weighted Correlation", main = "Correlation
     of Optima to RDA Species Scores")

#2. Significance of Pollen Based Reconstruction

#Loading neotoma and vegan packages from library
library(neotoma)
library(vegan)
library(analogue)

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

#Assessing the significance of the July temp and mean annual precip MAT 
#reconstructions using the randomTF() function
both.MAT.randomTF <- randomTF(spp = Pollen.prop, env = data.frame(Jul = Climate$tjul, Precip = Climate$annp),
                              fos = Hyde.prop, n = 999, fun = MAT, col = 1)
plot(both.MAT.randomTF)

#Using the MAT method, mean annual precip explains about 23% the variance and
#July temp explains about 42% of the variance in the fossil pollen data, so 
#the temperature reconstruction explains a greater amount of the variance.

#Assessing the significance of the July temp and mean annual precip WA 
#reconstructions using the randomTF() function
both.WA.randomTF <- randomTF(spp = Pollen.prop, env = data.frame(Jul = Climate$tjul, Precip = Climate$annp), 
                             fos = Hyde.prop, n = 999, fun = WA, col = 1)
plot(both.WA.randomTF)

#Using the WA method, mean annual precip explains about 28% of the variance and
#July temp explains about 48% of the variance, so once again the temperature
#reconstruction explains a greater amount of variance.

#Assessing the significance of the July temp and mean annual precip WAPLS 
#reconstructions using the randomTF() function
both.WAPLS.randomTF <- randomTF(spp = Pollen.prop, env = data.frame(Jul = Climate$tjul, Precip = Climate$annp),
                                fos = Hyde.prop, n = 999, fun = WAPLS, col = 1)
plot(both.WAPLS.randomTF)

#Using the WAPLS method, mean annual precip explains about 28% of the variance and
#July temp explains about 48% of the variance, just like in the WA reconstruction.

#Assessing the significance of the July temp and mean annual precip WA and
#WAPLS reconstructions using obs.cor()
both.WA.obscor <- obs.cor(spp = Pollen.prop, env = data.frame(Jul = Climate$tjul, Precip = Climate$annp), 
                          fos = Hyde.prop, ord = rda, n = 999)

#The July temperature reconstruction explains more of the variance in fossil data.

#Testing the significance of the 2nd variable (mean annual precip) MAT reconstruction
#using the randomTF() function
annp.MAT.randomTF <- randomTF(spp = Pollen.prop, env = data.frame(Precip = Climate$annp),
                              fos = Hyde.prop, n = 999, fun = MAT, col = 1)
plot(annp.MAT.randomTF)

#When July temp is removed from the MAT reconstruction, mean annual precip explains
#23% of the variance in the fossil pollen data.

#Assessing the significance of the mean annual precip WA reconstruction
#using the randomTF() function
annp.WA.randomTF <- randomTF(spp = Pollen.prop, env = data.frame(Precip = Climate$annp),
                              fos = Hyde.prop, n = 999, fun = WA, col = 1)
plot(annp.WA.randomTF)

#When July temp is removed from the WA reconstruction, mean annual precip explains
#28% of the variance in the fossil pollen data.

#Assessing the significance of the mean annual precip WAPLS reconstruction
#using the randomTF() function
annp.WAPLS.randomTF <- randomTF(spp = Pollen.prop, env = data.frame(Precip = Climate$annp),
                             fos = Hyde.prop, n = 999, fun = WAPLS, col = 2)
plot(annp.WAPLS.randomTF)

#When July temp is removed from the WAPLS reconstruction, mean annual precip explains
#32% of the variance in the fossil pollen data, similar to the WA reconstruction.

#Assessing the significance of mean annual precip WA and WAPLS reconstructions
#using obs.cor()
annp.WA.obscor <- obs.cor(spp = Pollen.prop, env = data.frame(Precip = Climate$annp), 
                          fos = Hyde.prop, ord = rda, n = 999)

#3. Bayesian Inference

Table <- matrix(c(67,33,14,86), ncol = 2, nrow = 2) 
colnames(Table) <- c("Disease (.0001)", "No Disease (99.9999)")
rownames(Table) <- c("Test Pos", "Test Neg")
Table

#Event A = Having the Disease
#Event X = Getting a Positive Diagnosis (whether it is a true or false positive)

#Find P(A|X) = P(X|A)*P(A)/P(X)
#P(X|A) = 0.67
#P(A) = 0.000001
#P(X) = (0.14)*(.999999) + (0.000001)*(.67) = 0.1399999 + 0.00000067 = 0.1400006

Prob = (0.67*0.000001)/(0.1400006)
ProbPercent = Prob*100
ProbPercent

#Probability of having the disease after a positive diagnosis is about 0.0005% 
#(rounding up from 0.00000478*100). 

