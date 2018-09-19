library("rioja")

#Read in the csv file for my location (I picked Richland Creek Dataset from Illinois in Peiora)

#have a raw file in case we need to reference the headers again in the future (like we do below)
data_raw<-read.csv("dataset3569.csv") 

#skip the first six lines becuase they are headers 
data<-read.csv("dataset3569.csv",skip=6,header=FALSE) 

#Remove the first five columns beacuse we do not need them 
data.clean<-data[-1:-5] 

#transpose so we have rows=observations and columns = variables 
pollen.data<-t(data.clean)

#assign column names
colnames(pollen.data)<-data[,1]

#assign row names, pulling from the raw data file, row 2 is the depth, and we only want columns 6-15 since the first six columns are just species names etc. 
rownames(pollen.data)<-data_raw[2,6:15]

#make row names a numeric value so we can plot depth below 
rownames.new<-as.numeric(rownames(pollen.data))

#replace NA with 0, so we can use the N/A values in our percentage calculation. Call this pollen.data to have a new separate matrix
pollen.data[is.na(pollen.data)]<-0 #now if we open 'pollen.data' matrix, the top column will label the taxon and the left column will be in units of depth! 

#compile 'final counts' matrix that will help convert into percentages 
counts.final<-pollen.data

#Convert pollen counts into percentages
#do this by multiplying the counts.final individual cells by the rowSums (row sums are how many taxon there are by depth, which is why we are dividing)
percentages<-100*counts.final/rowSums(counts.final)

#we have 29 taxa. I only include taxa that cross the 10% threshold twice, so it's easier to see the overall picture. 
inclusion.criterion10<-apply(percentages,2,function(x) (sum(x>10))>1)

#create a new matrix with just percentage totales for taxon that cross the 10% threshold twice.
#do this by calling from the original percentages matrix, but only pull (all) rows that have the inclusion criterion of 10 
percentages_clean10<-percentages[,inclusion.criterion10]


#Plot the final diagram

#create a new window 
quartz(height=16,width=6)
##defining parameters, but specifically here, number of rows andn columns, margin and outer margin size in inches to reduce white space##
par(mfrow=c(1,1), mai=c(0.1,1,0.25,1),omi=c(0.75,0.1,0.25,0.1))

# Define colour scheme, found this one online and I liked it so kept it. 
p.col <- c(rep("forestgreen", times=7), rep("gold2", times=20))
# Define y axis. We want our y-axis to be in depth, so call the 'rownames.new' that I made numerical above 
y.scale <- rownames.new
# Plot bar plot using rioja (strat.plot)
pol.plot <- strat.plot(percentages_clean5, yvar=y.scale, y.tks=y.scale, y.rev=TRUE, plot.line=FALSE, plot.poly=FALSE, plot.bar=TRUE, col.bar=p.col, lwd.bar=10, scale.percent=TRUE, xSpace=0.01, x.pc.lab=TRUE, x.pc.omit0=TRUE, las=2)

#label my axis
xlab="percentages"
