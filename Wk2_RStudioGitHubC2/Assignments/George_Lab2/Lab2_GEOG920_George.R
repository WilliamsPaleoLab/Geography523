# Install and make "rioja" package, used to make stratigraphic pollen diagram, part of library
install.packages("rioja")
library("rioja")

# Imports Davis Lake pollen data into a dataframe in R, skipping the first seven rows
# of the spreadsheet that aren't pollen records
davis_lake <- read.csv('Wk2_RStudioGitHubC2/Assignments/George_Lab2/dataset550.csv',skip=7,header = FALSE)

# Transposes pollen table, switching rows and columns
pollen_counts <- t(davis_lake[,-c(1:7)])

# Assigns the taxa names as the column names for the matrix
colnames(pollen_counts) <- davis_lake[,1]

# Assigns zero to values with no pollen count recorded
pollen_counts[is.na(pollen_counts)] <- 0
counts_final <- pollen_counts

# Divides raw pollen counts by total pollen count and multiplies by 100 to get percentages
percentages <- 100*(counts_final/rowSums(counts_final))

# Selects only taxa with at least two peaks of at least 3%
inclusion.criterion <- apply(percentages,2,function(x) (sum(x>3))>1)
percentages_clean <- percentages[,inclusion.criterion]

#Defines y-axis using depth data from file 
davis_lake_total <- read.csv('Geog920_HW/dataset550.csv')
depths <- as.numeric(as.character(unlist(davis_lake_total[2,-c(1:7)])))

# Creates stratigraphic diagram of taxa with two peaks of at least 3%
rioja::strat.plot(percentages_clean, yvar = depths, ylabel = "Depth (cm)")
