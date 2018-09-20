#Nicholas B. Sullivan
#Lab 2 Work

setwd("C:/Users/nsull/Documents/2017; Wisconsin Doctorate/Classes/2018-09; GEOG920; Advanced Paleoecology (Williams)/Lab2")
rm(list=ls()) #Clear objects from environment
devil.lake <- read.csv(file="G920_Lab2_DLPollen.csv", head=FALSE) #Sample data from Devil's Lake Wisconsin, output from Neotoma
devil.bath.tub <- read.csv(file="G920_Lab2_DBTPollen.csv", head=FALSE)  #Sample data from Devil's Bath Tub, New York
clear.lake <- read.csv(file="G920_Lab2_CLPollen.csv", head=FALSE) #Sample data from Clear Lake, Iowa

format.taxon.table <- function(neotoma.output) { #neotoma output is the raw csv file you get from Neotoma
  taxon.row.start <- as.numeric(min(which(neotoma.output[,4]=="NISP"))) #Determines which row count data starts
  taxon.col.start <- as.numeric(1+which(neotoma.output[1,]=="context")) #Determines which column count data starts 
  taxon.row.end   <- as.numeric(nrow(neotoma.output)) #Determines total number of rows in raw data frame
  taxon.col.end   <- as.numeric(ncol(neotoma.output)) #Determines total number of columnts in raw data frame
  depth.row       <- as.numeric(which(neotoma.output[,1]=="Depth")) #Determines which row the depth values are in
  taxon.names     <- as.character(neotoma.output[taxon.row.start:taxon.row.end,1]) #Extracts taxon names as characters
  depths <- as.numeric(matrix(data=unlist(neotoma.output[depth.row,taxon.col.start:taxon.col.end]),
                              nrow=length(seq(taxon.col.start, taxon.col.end, by=1)),
                              ncol=1)) #Extracts rows as a vector
  pollen.occurrences <- t(matrix(data=as.numeric(matrix(unlist(neotoma.output[taxon.row.start:taxon.row.end,
                                                                              taxon.col.start:taxon.col.end]))),
                                 nrow=length(seq(taxon.row.start, taxon.row.end, by=1)),
                                 ncol=length(seq(taxon.col.start, taxon.col.end, by=1)))) #extracts a transposed matrix of taxon counts
  pollen.occurrences[is.na(pollen.occurrences)] <- 0 #replaces NA values with a 0
  percent.table <- pollen.occurrences #clones the count table, this will be used to generate a percentage table
  for (i in 1:as.numeric(ncol(pollen.occurrences))) { #loop works column by column, counting up total number of counts
    total.counts <- sum(pollen.occurrences[,i]) #this is where we determine number of counts for a taxon in a given column "i"
    for (n in 1:as.numeric(nrow(pollen.occurrences))) { #now go row by row
      percent.table[n,i] <- (pollen.occurrences[n,i] / total.counts) #take taxon count, divide by total, overwrite in percent table
    }
  }
  finished.table <- cbind(depths, percent.table) #add in depths
  colnames(finished.table) <- c("Depth", taxon.names) #add header
  finished.table #print output
}

########################################################################################################################################
#a few tests of the function, seems to work on three different csv files with different headers
library(rioja)
strat.plot(d=format.taxon.table(neotoma.output=devil.lake)[,2:4],
           yvar=format.taxon.table(neotoma.output=devil.lake)[,1],
           y.rev=TRUE)

strat.plot(d=format.taxon.table(neotoma.output=devil.bath.tub)[,2:4],
           yvar=format.taxon.table(neotoma.output=devil.bath.tub)[,1],
           y.rev=TRUE)

strat.plot(d=format.taxon.table(neotoma.output=clear.lake)[,2:4],
           yvar=format.taxon.table(neotoma.output=clear.lake)[,1],
           y.rev=TRUE)
