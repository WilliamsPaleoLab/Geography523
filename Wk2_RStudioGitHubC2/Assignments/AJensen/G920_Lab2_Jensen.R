#Allie Jensen
#GEOG 920
#Lab 2

#Reading in CSV file of pollen counts at Devil's Lake and assigning it to an object
#(pollen.df). Skipping the first 9 rows because these rows do not contain any
#counts. **NOTE** had to change one taxa name to "Isoetes" with no special characters,
#was getting an error in strat plot when the name contained special characters. 
pollen.df <- read.csv("DevilsLake.csv", header = FALSE, sep = ",", skip = 9)

#Assigning a subset of the pollen count object to a new object that does not contain
#the first 5 columns, since these columns do not contain any count data.
pollen.subset <- pollen.df[ ,6:127]

#Transposing the pollen data so each column contains pollen counts for a different
#taxa. 
pollen.final <- t(pollen.subset)

#Setting column names on the new pollen count object equal to the taxa names (which
#were rows) on the original pollen count object.
colnames(pollen.final) <- pollen.df[,1]

#Setting NA equal to 0 in the pollen count dataframe.
pollen.final[is.na(pollen.final)] <- 0

#Calculating the total pollen counted at each depth, then using these totals to calculate
#the percentage of individual pollen taxa counted at each depth.
sums <- apply(pollen.final, 1, sum)
pollen.percentages <- (pollen.final/sums)*100

#Finding the pollen taxa that make up 5% of the total pollen counted at least twice
#across all depths.
percent.cutoff <- apply(X = pollen.percentages, MARGIN = 2, FUN = function(x) (sum(x>5))>1)

#Limiting the pollen taxa to be plotted to the taxa that satisfy the 5% rule.
pollen.percentages.final <- pollen.percentages[ ,percent.cutoff]

#Loading the rioja package to create the strat diagram.
library(rioja)

#Plotting the pollen percentages in a strat diagram and flipping the y-axis so 
#the core surface is at the top of the plot and deeper depths are at the bottom. 
strat.plot(d = pollen.percentages.final, y.rev = TRUE)

#Reading in the Devil's Lake CSV file and transposing the data so depths
#are a column instead of a header row.
depths <- read.csv("DevilsLake.csv", sep = ",")
depths.transposed <- t(depths)

#Extracting the depths in the column and changing the data type to numeric.
depths.subset <- as.numeric(depths.transposed[6:127,2])

#Converting the depths to a vector to be used in a new strat diagram.
depths.final <- as.vector(depths.subset)

#Plotting the pollen percentages in a strat diagram with depths, flipping the y-axis
#so the core surface is at the top, scaling the x-axis to 10% increments, adding
#a main title, and adjusting label sizes. Saving the final strat diagram as a PDF.
pdf("DevilsLakePollen.pdf")
strat.plot(d = pollen.percentages.final, yvar = depths.final, y.rev = TRUE, scale.percent = TRUE, 
           title = "Pollen Percentages for Devil's Lake, WI", cex.title = 1.2, x.pc.inc = 10, 
           cex.xlabel = 0.75)
dev.off()
