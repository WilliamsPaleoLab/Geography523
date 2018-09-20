############### Importing data
## Read csv file
hawaii.raw <- read.csv("~/Desktop/github/assignment2/dataset17832.csv")
class(hawaii.raw) # dataset type = data.frame
typeof(hawaii.raw) # vector type = list

################ selecting only pollen dataset
rm.row <- c(1:6)
rm.col <- c(1:5)
hawaii.pollen <- hawaii.raw[-rm.row,-rm.col] # selecting only pollen dataset
hawaii.pollen <- t(hawaii.pollen) # transpose
class(hawaii.pollen) # dataset type = matrix
typeof(hawaii.pollen) # vector type = character
hawaii.pollen <- matrix(sapply(hawaii.pollen,as.numeric),ncol=66,nrow=34) # change character matrix to numeric matrix
hawaii.pollen[is.na(hawaii.pollen)] <- 0 ## Convert NA to 0
hawaii.pollen <- as.data.frame(hawaii.pollen) ## DATA FRAME 

################# taxa column names
taxa.name <- as.character(hawaii.raw$name[7:72])
colnames(hawaii.pollen) <- taxa.name
rownames(hawaii.pollen) <- seq(1,length(rownames(hawaii.pollen)),1)
hawaii.pollen <- hawaii.pollen[,-38] # Remove Lycopodium Spike column 

################## Pollen abundance (%)
hawaii.pollen.cont <- round(hawaii.pollen/rowSums(hawaii.pollen[1:65]), digit=3)*100
head(hawaii.pollen.cont)

################## Adding depth to rownames
depth <- as.numeric(as.vector(unlist(hawaii.raw[2,seq(6,39,1)])))
rownames(hawaii.pollen.cont) <- depth
head(hawaii.pollen.cont)

################## Pollen diagram with all taxa
strat.plot(hawaii.pollen.cont, scale.percent = TRUE, yvar=depth,y.rev=TRUE, 
           wa.order = "bottomleft",ylabel="depth (cm)")

################## Subset taxa with the pollen sum more than 10% over depth + pollen diagram
pollen.sum <- colSums(hawaii.pollen.cont) # Column sums
hawaii.pollen.trim <- hawaii.pollen.cont[,which(pollen.sum>10)] # Subset
strat.plot(hawaii.pollen.trim, scale.percent = TRUE, yvar=depth, y.rev=TRUE, 
           wa.order = "bottomleft",ylabel="depth (cm)") # pollen diagram

################## Filled pollen diagram: subset taxa
## Grey filled pollen diagram
strat.plot(hawaii.pollen.trim, scale.percent=TRUE, yvar=depth,y.rev=TRUE, 
           wa.order="bottomleft", col.line = p.col, ylabel="depth (cm)", 
           plot.bar=FALSE, plot.poly=TRUE)
## Color fill pollen diagram
n <- length(colnames(hawaii.pollen.trim)) # The number of trimmed taxa
p.col <- randomcoloR::distinctColorPalette(n) # Defining color scheme
strat.plot(hawaii.pollen.trim, scale.percent=TRUE, yvar=depth,y.rev=TRUE, 
           wa.order="bottomleft", col.line = p.col, ylabel="depth (cm)", 
           plot.bar=FALSE, plot.poly=TRUE, col.poly = p.col)
