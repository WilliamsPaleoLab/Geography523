#Allie Jensen
#GEOG 920
#Lab 8

#1 Dissimilarity/Distance Metrics

#Loading necessary packages from library
library(analogue)
library(rioja)
library(vegan)
library(maps)

#Loading data needed for exercise
data(Pollen)
data(Climate)
data(Location)
#Looking at the data and how it's structured
head(Pollen)
head(Climate)
head(Location)

#Assigning names to the first 3 columns of climate data
colnames(Climate)[1:3] <- c('tjan','tfeb','tmar')
#Converting the pollen counts into proportions
Pollen.corrected <- replace(Pollen,is.na(Pollen),0)
pollen.prop <- Pollen.corrected/rowSums(Pollen.corrected)

#Saving the latitude and longitude of pollen sites in the NAMPD, making a map
#of pollen sites
lon <- Location$Longitude 
lat <- Location$Latitude 
map(regions=c('USA','Canada','Greenland'),xlim=c(range(lon)),ylim=range(lat))
points(lon,lat,pch = 15,cex =0.25,col='darkgreen')

#Finding the northern-most and southern-most pollen sites and combining 
#their pollen proportions into a dataframe
nm.pollen <- pollen.prop[which.max(lat),] 
sm.pollen <- pollen.prop[which.min(lat),] 
pollen.sn <- rbind(nm.pollen,sm.pollen)
#Ordering all pollen proportions by latitude
pollen.prop.lat.order <- pollen.prop[order(lat),]

#Calculating dissimilarity between the northern-most and southern-most sites
#using 3 metrics (Square Chord, Euclidean, Bray-Curtis)
dist.sn.chord <- analogue::distance(pollen.sn,method='chord')
dist.sn.euclidean <- analogue::distance(pollen.sn,method='euclidean')
dist.sn.bray <- analogue::distance(pollen.sn,method='bray')
#Combining the resulting distances from the 3 metrics into a dataframe
dist.sn <- data.frame(chord = dist.sn.chord[1,2],euclidean = dist.sn.euclidean[1,2],bray = dist.sn.bray[1,2])

#Calculating dissimilarity between 2 nearby pollen sites (ordered by latitude)
#using 3 metrics (Square Chord, Euclidean, Bray-Curtis)
dist.adj.chord <- analogue::distance(pollen.prop.lat.order[2:3,],method='chord')
dist.adj.euclidean <- analogue::distance(pollen.prop.lat.order[2:3,],method='euclidean')
dist.adj.bray <- analogue::distance(pollen.prop.lat.order[2:3,],method='bray')
#Combining the resulting distances from the 3 metrics into a dataframe
dist.adj <- data.frame(chord = dist.adj.chord[1,2],euclidean = dist.adj.euclidean[1,2],bray = dist.adj.bray[1,2])

#Calculating dissimilarity for 1000 random sites using 3 metrics (Square 
#Chord, Euclidean, Bray-Curtis)
dist.rand <-
  replicate(1000,{
    sample.nr <- sample(1:ncol(Pollen),2,replace=FALSE)
    pollen.sample <- pollen.prop[sample.nr,]
    dist.r.chord <- analogue::distance(pollen.sample,method='chord')
    dist.r.euclidean <- analogue::distance(pollen.sample,method='euclidean')
    dist.r.bray <- analogue::distance(pollen.sample,method='bray')
    data.frame(chord = dist.r.chord[1,2], euclid = dist.r.euclidean[1,2],bray = dist.r.bray[1,2])
  })

#Saving the distances from the 3 metrics in a matrix, naming the columns 
#of the matrix
dist.rand.matrix <- matrix(unlist(dist.rand),nrow=1000,ncol=3,byrow=TRUE)
colnames(dist.rand.matrix) <- c('chord','euclidean','bray')

#Finding the quantiles of the 3 types of distances for all 1000 sites
dist.rand.quantiles <- apply(dist.rand.matrix,2,function(x) quantile(x,probs=c(0.025,0.25,0.5,0.75,0.975)))
round(rbind(dist.adj,dist.rand.quantiles,dist.sn),3)

#Calculating dissimilarity for all sites in the NAMPD using 3 metrics (Square 
#Chord, Euclidean, Bray-Curtis)
distance.all.chord <- dist(sqrt(pollen.prop),diag=FALSE,upper=FALSE,method='euclidean')
distance.all.euclid <- dist(pollen.prop,diag=FALSE,upper=FALSE,method='euclidean')
distance.all.bray <- vegan::vegdist(pollen.prop,diag=FALSE,upper=FALSE,method='bray')
#Looking at the quantiles of the distances from the 3 metrics
summary(distance.all.chord)
summary(distance.all.bray)
summary(distance.all.euclid)

#Combining the distances from the 3 metrics into a large matrix, naming the
#columns of the matrix
total.distances <- cbind(distance.all.chord,distance.all.euclid,distance.all.bray)
colnames(total.distances) <-c('chord','euclidean','bray')

# jpeg("distance_pairs.jpeg",height=10,width=10,units='in',res =300)
#   pairs(total.distances,pch = 16,cex = 0.5)
# dev.off()

#2 Calibration

#Loading data needed for exercise
data(IK)
?IK

#Converting the abundance of foram taxa in core-top samples and down-core
#samples into proportions
spp<-IK$spec/100
fossil <- IK$core/100
#Combining both sets of proportions into a list
sppfos<-Merge(spp, fossil, split=TRUE)
spp <- sppfos$spp
fossil <- sppfos$fossil
#Isolating the sea surface temp data and saving it as a new variable
SumSST<-IK$env$SumSST

#Using the modern analog technique on abundance of foram taxa in core-top
#samples and sea surface temp
sumsst.mat.model <- rioja::MAT(spp,SumSST,k=5,lean = FALSE,dist.method='chord')
plot(sumsst.mat.model)

#Cross validating the modern analog technique on foram taxa in core-top samples
#and sea surface temp using k-fold cross validation
cv.sumsst.mat.model <- rioja::crossval(sumsst.mat.model,cv.method='lgo',verbose=FALSE)
plot(cv.sumsst.mat.model)
#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the MAT model
perf.cv.sumsst.mat.model <- rioja::performance(cv.sumsst.mat.model)
perf.cv.sumsst.mat.model

#3 Reconstruction

#Assinging depths of the down-core foram taxa abundances to a new variable
depths <- as.numeric(rownames(fossil))
#Predicting sea surface temp downcore using the core-top foram taxa abundances
#and sea surface temp model
pred <- predict(sumsst.mat.model,fossil)
#Plotting sea surface temp by depth
plot(depths, pred$fit[,'MAT'],type='l',ylab ='T [C]')

#Assessing the quality of analogs produced by the model
goodpoorbad<-quantile(paldist(spp,dist.method='chord'), prob=c(0.05, 0.1))
#Plotting chord distances by depth, adding lines for distances shorter than 5th
#percentile of all distances, distances greater than 10th percentile of all distances
plot(depths, pred$dist.n[,1], ylab="Chord distance", xlab="Depth")
abline(h=goodpoorbad, col=c("orange", "red"))

#Loading palaeoSig package from library
library(palaeoSig)
#Comparing variance of foram species assemblages explained by our reconstruction
#to the variance explained by reconstructions using random data
IKrand <- randomTF(spp = spp, env = data.frame(SumSST = SumSST),fos = fossil,fun =MAT, dist.method = 'chord',n = 999,col=1)
plot(IKrand)

#Using the modern analog technique on pollen proportions from the NAMPD and 
#mean temp of the warmest month
mat.model.mtwa <- rioja::MAT(pollen.prop,Climate$mtwa,lean=FALSE)
#Cross validating the the modern analog technique using pollen proportions and 
#mean temp of the warmest month
cv.mat.model.mtwa <- rioja::crossval(mat.model.mtwa,verbose=FALSE)
#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the MAT model
per.mat.model.mtwa <- rioja::performance(cv.mat.model.mtwa)
#Plotting the MAT model
plot(cv.mat.model.mtwa)

#Using the modern analog technique on pollen proportions from the NAMPD and 
#longitude
mat.model.lon <- rioja::MAT(pollen.prop,lon,lean=FALSE)
#Cross validating the the modern analog technique using pollen proportions and 
#longitude
cv.mat.model.lon <- rioja::crossval(mat.model.lon,verbose=FALSE)
#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the MAT model
per.mat.model.lon <- rioja::performance(cv.mat.model.lon)
#Plotting the MAT model
plot(cv.mat.model.lon)

#Using the modern analog technique on pollen proportions from the NAMPD and 
#all 32 climate variables in the Climate dataset
#mat.model <- lapply(colnames(Climate),function(x){
#  rioja::MAT(pollen.prop,as.vector(Climate[,x]),lean=FALSE)
#  })
#Naming the columns of the MAT model by variable
#names(mat.model) <- colnames(Climate)
 
#Cross validating the the modern analog technique using pollen proportions and 
#all 32 climate variables in the Climate dataset
#crossval.mat <- lapply(names(mat.model),function(x){
#  rioja::crossval(mat.model[[x]],verbose=FALSE)
#  })
#Naming the columns of the cross-validated MAT model by variable
#names(crossval.mat) <- colnames(Climate)

#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the MAT model using all 32 climate variables
#perf.mat <- lapply(names(mat.model),function(x){
#  rioja::performance(crossval.mat[[x]])
#  })
#Naming the columns of the performance statistics output by variable
#names(perf.mat) <- colnames(Climate)

#4 Spatial Autocorrelation

#Loading field package from library 
library(fields)
#Creating a matrix of the latitude/longitude of Calgary
coord.calgary <- matrix(c(-114,51),ncol=2)
#Calculating the distance between all sites in the NAMPD and Calgary
dist.calgary <- t(rdist.earth(coord.calgary,cbind(lon,lat)))
#Calculating the correlation between these distances and climate variables
cor.env.var <- round(cor(dist.calgary,Climate),2)
print(cor.env.var)
#Using the modern analog technique on pollen proportions from the NAMPD and 
#distance to Calgary
mat.calgary <- rioja::MAT(y = pollen.prop,dist.calgary,lean=FALSE) 
#Cross validating the the modern analog technique using pollen proportions and 
#distance to Calgary
cv.calgary <- rioja::crossval(mat.calgary,verbose=FALSE)
#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the MAT model
perf.calgary <- rioja::performance(cv.calgary)
#Plotting the cross-validated MAT model and mean temp of the warmest month vs.
#distance to Calgary
plot(cv.calgary)
plot(dist.calgary,Climate$mtwa)

#Calculating the distance between all sites in the NAMPD
dist.h <- rdist.earth(cbind(lon,lat),cbind(lon,lat))
#Using h-block cross validation on the modern analog technique using pollen
#proportions and distance to Calgary
cv.calgary.h.block <- rioja::crossval(mat.calgary,h.cutoff = 500,h.dist=dist.h,cv.method = 'h-block',verbose=FALSE)
#Plotting the h-block cross-validated model vs. distance to Calgary
plot(dist.calgary,cv.calgary.h.block$predicted[,'N05'])
abline(a=0,b=1,lty=2)
#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the cross-validated MAT model
rioja::performance(cv.calgary.h.block)
#Using h-block cross validation on the modern analog technique using pollen
#proportions and mean temp of the warmest month
cv.mtwa.h.block <- rioja::crossval(mat.model.mtwa,h.cutoff = 500,h.dist=dist.h,cv.method = 'h-block',verbose=FALSE)
#Plotting the h-block cross-validated model vs. mean temp of the warmest month
plot(Climate$mtwa,cv.mtwa.h.block$predicted[,'N05'])
abline(a=0,b=1,lty=2)
#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the cross-validated MAT model
rioja::performance(cv.mtwa.h.block)


#Exercises

#Loading neotoma package from library
library(neotoma)

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

#First Reconstruction: Mean Annual Precipitation

#Using the modern analog technique on pollen proportions from the NAMPD and 
#mean annual precipitation
precip.mat.model <- rioja::MAT(Pollen.prop, Climate$annp, lean = FALSE)
plot(precip.mat.model)

#Cross validating the the modern analog technique using pollen proportions and 
#mean annual precipitation
cv.precip.mat.model <- rioja::crossval(precip.mat.model, verbose = FALSE)
plot(cv.precip.mat.model)

#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the cross-validated MAT model
per.precip.mat.model <- rioja::performance(cv.precip.mat.model)
per.precip.mat.model

#Isolating the depths of all pollen samples at Hyde Park from the Hyde Park pollen
#dataset
Hyde.depths <- Hyde.data[[1]]$sample.meta$depth

#Predicting the down-core mean annual precip at Hyde Park using the MAT model
Hyde.pred <- predict(precip.mat.model, Hyde.prop)

#Plotting the mean annual precip over depth
pdf("PrecipReconstruction.pdf")
plot(Hyde.depths, Hyde.pred$fit[ ,'MAT'], type = 'l', xlab = "Depth (cm)", 
     ylab = "Mean Annual Precip (mm)", main = "Predicted Mean Annual Precipitation
     at Hyde Park, NY")
dev.off()

#Plotting the minimum square-chord distance over depth
pdf("PrecipDistance.pdf")
plot(Hyde.depths, Hyde.pred$dist.n[ ,1], ylab = "Chord Distance", 
     xlab = "Depth (cm)", pch = 16, main = "Minimum Square-Chord Distance 
     for Precipitation at Hyde Park, NY")
dev.off()

#Second Reconstruction: Mean Temp of the Warmest Month

#Using the modern analog technique on pollen proportions from the NAMPD and 
#mean temp of the warmest month
warm.month.mat.model <- rioja::MAT(Pollen.prop, Climate$mtwa, lean = FALSE)
plot(warm.month.mat.model)

#Cross validating the the modern analog technique using pollen proportions and 
#mean temp of the warmest month
cv.warm.month.mat.model <- rioja::crossval(warm.month.mat.model, verbose = FALSE)
plot(cv.warm.month.mat.model)

#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the cross-validated MAT model
per.warm.month.mat.model <- rioja::performance(cv.warm.month.mat.model)
per.warm.month.mat.model

#Predicting the down-core mean temp of the warmest month at Hyde Park using
#the MAT model
pdf("MTWMReconstruction.pdf")
Hyde.pred2 <- predict(warm.month.mat.model, Hyde.prop)
plot(Hyde.depths, Hyde.pred2$fit[ ,'MAT'], type = 'l', xlab = "Depth (cm)",
     ylab = "Temp (C)", main = "Predicted Mean Temp of
     the Warmest Month at Hyde Park, NY")
dev.off()

#Plotting the minimum square-chord distance over depth
pdf("MTWMDistance.pdf")
plot(Hyde.depths, Hyde.pred2$dist.n[,1], ylab = "Chord Distance", 
     xlab = "Depth (cm)", pch = 16, main = "Minimum Square-Chord Distance 
     for Temp of the Warmest Month at Hyde Park, NY")
dev.off()

#Third Reconstruction: Mean Temp of the Coldest Month

#Using the modern analog technique on pollen proportions from the NAMPD and 
#mean temp of the coldest month
cold.month.mat.model <- rioja::MAT(Pollen.prop, Climate$mtco, lean = FALSE)
plot(cold.month.mat.model)

#Cross validating the the modern analog technique using pollen proportions and 
#mean temp of the coldest month
cv.cold.month.mat.model <- rioja::crossval(cold.month.mat.model, verbose = FALSE)
plot(cv.cold.month.mat.model)

#Determining the RMSE, apparent performance statistics, cross-validated
#performance statistics of the cross-validated MAT model
per.cold.month.mat.model <- rioja::performance(cv.cold.month.mat.model)
per.cold.month.mat.model

#Predicting the down-core mean temp of the coldest month at Hyde Park using
#the MAT model
pdf("MTCMReconstruction.pdf")
Hyde.pred3 <- predict(cold.month.mat.model, Hyde.prop)
plot(Hyde.depths, Hyde.pred3$fit[ ,'MAT'], type = 'l', xlab = "Depth (cm)",
     ylab = "Temp (C)", main = "Predicted Mean Temp of
     the Coldest Month at Hyde Park, NY")
dev.off()

#Plotting the minimum square-chord distance over depth
pdf("MTCMDistance.pdf")
plot(Hyde.depths, Hyde.pred3$dist.n[ ,1], ylab = "Chord Distance", 
     xlab = "Depth (cm)", pch = 16, main = "Minimum Square-Chord Distance 
     for Temp of the Coldest Month at Hyde Park, NY")
dev.off()

#Creating a pollen stratigraphic diagram for Hyde Park, NY
pdf("HydeParkPollenDiagram.pdf")
strat.plot(d = Hyde.prop, yvar = Hyde.depths, scale.percent = FALSE,
          title = "Pollen Proportions for Hyde Park, NY", cex.title = 1.3, 
          y.rev = TRUE, x.pc.inc = 10, cex.xlabel = 0.7)
dev.off()

#Comparing the pollen diagram to the climate reconstructions, it is clear that
#mean annual precipitation was predicted to be high from 50 cm to 0 cm and the 
#mean temp of the warmest month was predicted to be low over this interval.
#This corresponds with high abundance of Spruce, which makes sense because
#Spruce is a conifer that does not thrive in very warm environments. We also
#see high abundance of deciduous hardwoods, like Birch, Oak, and Hornbeam,
#which is unexpected during a time of low mean temps in warm months, since
#these taxa do well in warm environments. However, predicted mean temp
#in the coldest month increased significantly during this period, which might
#allow the deciduous hardwoods to persist on the landscape. From 150 to 100 cm,
#mean annual precipitation and mean temp of the warmest month are both predicted
#to be high, which corresponds with a high abundance of Pine. We would expect
#this trend, since we often see Pine increase with the warming of the early Holocene. 
