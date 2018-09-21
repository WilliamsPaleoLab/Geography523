###CKeeve_Lab2_G920

##Created object Everglades, which is where the site is
everglades<-read.csv('dataset15383.csv',skip=7,header=FALSE)

##Verified everglades exists
View(everglades)

##Created object pollencounts, which eliminated the first 5 columns of everglades
pollencounts<-t(everglades[,-c(1:5)])

##Verified
View(pollencounts)

##Set taxa of everglades as columns of pollencounts
colnames(pollencounts)<-everglades[,1]

##Verified that this worked
View(pollencounts)

##Changed all the NA values in pollencounts to 0s
pollencounts[is.na(pollencounts)]<-0
View(pollencounts)

##Renamed pollencounts to everglades_final
everglades_final<-pollencounts
View(everglades_final)

##Converted pollen count values to percentages
percentages<-100*everglades_final/rowSums(everglades_final)
View(percentages)

##Installed rioja package
install.packages("rioja")

#Created stratigraphic plot through rioja
rioja::strat.plot(percentages)
