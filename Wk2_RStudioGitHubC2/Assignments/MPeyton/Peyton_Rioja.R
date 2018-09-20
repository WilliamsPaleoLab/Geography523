#------------------Set up pollen dataset---------------------------
library(rioja)
library(vegan)
setwd("C:/Users/micha/Desktop/github/")
#Read the csv file for Devil's Lake, WI
maui <- read.csv("maui.csv")
#Make a data frame with just the pollen data
set <- maui[7:72,]
pollen.data <- set[,6:39]
#Flip columns and rows
pollen.data <- t(pollen.data)
#Convert to numeric
pollen.data <- matrix(sapply(pollen.data,as.numeric),ncol=66,nrow=34)
#Convert NA's to zeroes
pollen.data[is.na(pollen.data)] <- 0
#Convert to data frame
pollen.data <- as.data.frame(pollen.data)
#Convert counts to percentages
pollen.data.percents <- 100*(pollen.data/rowSums(pollen.data))

#------------------Set up taxa names-------------------------------
taxa <- maui[7:72,1]
colnames(pollen.data.percents) <- taxa

#------------------Set up depth------------------------------------
depth <- as.numeric(as.vector(unlist(maui[2,6:39])))
rownames(pollen.data.percents) <- depth

#------------------Exclude taxa <10% & Lycopodium spike-------------
pollen.sum <- colSums(pollen.data.percents)
pollen.clean <- pollen.data.percents[,pollen.sum > 10]
pollen.clean <- pollen.clean[colnames(pollen.clean) != "Lycopodium spike"]
head(pollen.clean)

#------------------Stratigraphic plot------------------------------

rioja::strat.plot(pollen.clean, yvar = depth, scale.percent = TRUE,
           wa.order = "bottomleft", plot.poly = TRUE, col.poly = "tan", y.rev = TRUE, )

