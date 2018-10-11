#Allie Jensen
#GEOG 920
#Lab 4


#Queston 1: Sites API
#http://api.neotomadb.org/v1/data/sites?gpid=8996
#This site API call found all neotoma sites in Albemarle County, the home of UVA. 

#http://api.neotomadb.org/v1/data/sites?sitename=*triangle*
#This site API call found all neotoma sites with Triangle in the site name.

#Question 2: Datasets and Downloads API
#http://api.neotomadb.org/v1/data/datasets?ageold=17000&ageyoung=11000&ageof=sample
#This dataset API call found datasets with samples dated during the late-glacial
#period, between 16,000 and 11,000 years ago.

#http://api.neotomadb.org/v1/data/downloads/684
#This downloads API call downloaded the pollen dataset at Devil's Lake.

#Question 3: DB Tables
#http://api.neotomadb.org/v1/dbtables/Geochronology?limit=50&offset=0
#This dbtables API call returned the first 50 records from the Geochronology table.

#Loading neotoma package
library(neotoma)

#Testing out get_site
samwell_site <- get_site(sitename = 'Samwell%')
print(samwell_site)
devil_sites <- get_site(sitename = 'devil%')

#Question 4: Sites with name 'Clear'
clear_sites <- get_site(sitename = 'clear%')
no.sites.w.clear <- length(clear_sites$site.id)
print(no.sites.w.clear)
#There are 40 sites with the word 'Clear' in their name.

#Testing out get_site 
FL_sites <- get_site(loc = c(-88, -79, 25, 30))
NM_sites <- get_site(gpid = 7956)

#Question 5: Number of lakes in WI and MN
WI_sites <- get_site(gpid = "Wisconsin")
MN_sites <- get_site(gpid = "Minnesota")
no.WI.sites <- length(WI_sites$site.id)
no.MN.sites <- length(MN_sites$site.id)
if (no.WI.sites > no.MN.sites) {
  print("TRUE")
} else {
  print("FALSE")
}
print(no.WI.sites)
print(no.MN.sites)
#Wisconsin has 459 sites and Minnesota has 518 sites, so Minnesota has more sites
#than Wisconsin.

#Looking at structure of site objects
str(samwell_site)
samwell_site$description

#Testing out get_dataset
samwell_datasets <- get_dataset(samwell_site)
print(samwell_datasets)
devil.meta.dataset <- get_dataset(devil_sites)
devil.meta.dataset

#Question 6: Kinds of datasets at Devil's Lake
devils.lake.dataset <- get_dataset(x = 666) #List of 5, each list is different dataset
no.devils.datasets <- length(devils.lake.dataset)
print(no.devils.datasets)
#There are 5 different kinds of datasets available for Devil's Lake, WI.

#Testing out browse and get_publication
browse(samwell_datasets)
samwell_pubs <- get_publication(samwell_datasets)

#Testing out get_download
samwell_all1 <- get_download(samwell_site)
samwell_all2 <- get_download(samwell_datasets)
print(samwell_all1)
print(samwell_all2)

#Testing out get_geochron
samwell_geochron <- get_geochron(samwell_site)
print(samwell_geochron)

#Looking at structure of dataframe returned by get_download
samwell_pd <- get_download(14262)
str(samwell_pd[[1]])
head(samwell_pd[[1]]$sample.meta)
head(samwell_pd[[1]]$taxon.list)
head(samwell_pd[[1]]$counts)
head(samwell_pd[[1]]$lab.data)

#Testing out compile_taxa
devil_data <- get_download(devils.lake.dataset)
devil_pollen <-devil_data[[1]]
devil_pollen_p25 <- compile_taxa(devil_data[[1]], list.name = "P25")
devil_pollen_p25$taxon.list[,c("compressed", "taxon.name")]
names(devil_pollen_p25)

#Making analogue plot for Devil's Lake pollen
library("analogue")
devil_pollen_pct <- analogue::tran(x = devil_pollen$counts, method = 'percent')
devil_pollen_pct_norare <- devil_pollen_pct[, colMeans(devil_pollen_pct, na.rm = TRUE) > 2]
analogue::Stratiplot(x = devil_pollen_pct_norare[, order(colMeans(devil_pollen_pct_norare, na.rm = TRUE), decreasing = TRUE)], y = devil_data[[1]]$sample.meta$age, ylab = devil_data[[1]]$sample.meta$age.type[1], xlab = " Pollen Percentage")

#Question 7: Making stratigraphic pollen diagram in rioja

#Downloading data from Patschke Bog, TX, isolating the pollen dataset and
#assigning it to a new variable, compiling the pollen data
Patschke.site <- get_site(sitename = "Patschke Bog")
Patschke.dataset <- get_dataset(Patschke.site)
Patschke.data <- get_download(Patschke.dataset)
Patschke.pollen <- Patschke.data[[2]]
Patschke.pollen.25 <- compile_taxa(Patschke.pollen, list.name = "P25")

#Assigning pollen counts to a new variable, converting them into percentages,
#excluding rare taxa, assigning the age of the pollen samples to a new variable
Patschke.counts <- Patschke.pollen.25$counts
Patschke.sums <- apply(Patschke.counts, 1, sum)
Patschke.percents <- (Patschke.counts/Patschke.sums)*100
Patschke.percents.norare <- Patschke.percents[, colMeans(Patschke.percents, na.rm = TRUE) > 2]
Patschke.dates <- Patschke.data[[2]]$sample.meta$age

#Loading rioja package, building stratigraphic diagram with pollen counts
#and ages, reversing the y-axis so younger ages are at the top of the diagram, 
#scaling the pollen axis by 10%. Saving diagram as a PDF.
library(rioja)
pdf("PatschkeBogPollenDiagram.pdf")
strat.plot(d = Patschke.percents.norare, yvar = Patschke.dates, scale.percent = TRUE,
          xLeft = 0.09, yTop = 0.65, title = "Pollen Percentages for Patschke
          Bog, TX", cex.title = 1.1, y.rev = TRUE, x.pc.inc = 10, cex.xlabel = 0.7)
dev.off()

#Example looking at the hemlock decline across the upper Midwest

#Downloading Midwest hemlock pollen data between 6000 and 4500 years ago
hem_dec <- get_dataset(taxonname = "Tsuga*",
                       datasettype = "pollen",
                       loc = c(-98.6, 36.5, -66.1, 49.75),
                       ageyoung = 4500, ageold = 6000)
hem_dec_dl <- get_download(hem_dec)

#Loading worldmap package 
library(rworldmap)

#Plotting the sites with hemlock pollen data on a map
map <- getMap()
plot(hem_dec)
plot(map, add = TRUE)

#Compiling downloaded hemlock data across sites
hem_compiled <- compile_downloads(hem_dec_dl)

#Extracting all taxon tables from the original download object  
all_taxa <- do.call(rbind.data.frame, lapply(hem_dec_dl, function(x)x$taxon.list[,1:6]))

#Removing duplicate names, limiting taxa to trees/shrubs/upland herbs
all_taxa <- all_taxa[!duplicated(all_taxa),]
good_cols <- c(1:10, which(colnames(hem_compiled) %in%
              gsub("[ ]|[[:punct:]]", ".",
              all_taxa[all_taxa$ecological.group %in%
              c("TRSH", "UPHE"),1])))

#Transforming counts of trees/shrubs/upland herbs to proportions, then isolating
#hemlock proportions
hem_compiled <- hem_compiled[ ,good_cols]
hem_pct <- hem_compiled[,11:ncol(hem_compiled)] / 
           rowSums(hem_compiled[,11:ncol(hem_compiled)], na.rm = TRUE)
hem_only <- rowSums(hem_pct[,grep("Tsuga", colnames(hem_pct))], na.rm = TRUE)

#Retrieving age data from the compiled hemlock object, creating a dataframe with
#ages and hemlock proportions, plotting proportion of sites with hemlock by age
age_cols <- grep("^age", colnames(hem_compiled))
hemlock_all <- data.frame(ages = rowMeans(hem_compiled[,age_cols], na.rm = TRUE),
                          prop = hem_only)
plot(hemlock_all, col = rgb(0.1, 0.1, 0.1, 0.3), pch = 19, cex = 0.4,
     xlim = c(0, 20000), ylab = "Proportion of Hemlock", xlab = "Years 
     Before Present")

#Recreating the plot, sites with radiocarbon year ages instead of calendar
#year ages distinguished by red 
plot(hemlock_all, col = c(rgb(0.1, 0.1, 0.1, 0.3),
    rgb(1, 0, 0, 0.3))[(hem_compiled$date.type == "Radiocarbon years BP") + 1],
    pch = 19, cex = 0.4, xlim = c(0, 20000), ylab = "Proportion of Hemlock", xlab = "Years Before Present")


#Question 8: Rise of hickory across the upper Midwest

#Searching for Midwest datasets with hickory between 11000 and 9000 years ago
hick.rise <- get_dataset(taxonname = "Carya*",
                       datasettype = "pollen",
                       loc = c(-98.6, 36.5, -66.1, 49.75),
                       ageyoung = 9000, ageold = 11000)

#Downloading the datasets with hickory in this time interval
hick.rise.dl <- get_download(hick.rise)

#Loading rworldmap package, plotting the sites with hickory against a map
library(rworldmap)
map <- getMap()
plot(hick.rise)
plot(map, add = TRUE)

#Compiling downloaded hickory data across sites
hick.compiled <- compile_downloads(hick.rise.dl)

#Extracting all taxon tables from the original download object  
all.taxa <- do.call(rbind.data.frame, lapply(hick.rise.dl, function(x)x$taxon.list[,1:6]))

#Removing duplicate names, limiting taxa to trees/shrubs/upland herbs
all.taxa <- all.taxa[!duplicated(all.taxa),]
hick.cols <- c(1:10, which(colnames(hick.compiled) %in%
              gsub("[ ]|[[:punct:]]", ".",
              all.taxa[all.taxa$ecological.group %in%
              c("TRSH", "UPHE"),1])))

#Transforming counts of trees/shrubs/upland herbs to proportions, then isolating
#hickory proportions
hick.compiled <- hick.compiled[ ,hick.cols]
hick.percentages <- hick.compiled[,11:ncol(hick.compiled)] / 
                    rowSums(hick.compiled[,11:ncol(hick.compiled)], na.rm = TRUE)
hick.only <- rowSums(hick.percentages[,grep("Carya", colnames(hick.percentages))], na.rm = TRUE)

#Retrieving age info from the compiled hickory object, creating a dataframe with
#ages and hickory proportions, plotting proportion of sites with hickory by age
hick.age <- grep("^age", colnames(hick.compiled))
hickory.all <- data.frame(ages = rowMeans(hick.compiled[,hick.age], na.rm = TRUE),
                          prop = hick.only)
pdf("HickoryRiseUpperMidwest.pdf")
plot(hickory.all, col = rgb(0.1, 0.1, 0.1, 0.3), pch = 19, cex = 0.4,
     xlim = c(0, 20000), main = "Rise of Hickory across the Upper Midwest", ylab = "Proportion of Hickory", xlab = "Years 
     Before Present")
dev.off()

#Example using a for loop to extract tsuga data at multiple sites at multiple
#time intervals

#Retrieving West Coast datasets with tsuga between 0 and 500 years ago
one_slice <- get_dataset(taxonname='Tsuga*', loc=c(-150, 20, -100, 60), 
                         ageyoung = 0, ageold = 500)

#Creating a vector going from 0 to 10000 by intervals of 500
increment <- seq(from = 0, to = 10000, by = 500)

#Retrieving West Coast datasets with tsuga between 0 and 500 years ago
one_slice <- get_dataset(taxonname = 'Tsuga*', loc = c(-150, 20, -100, 60), 
                         ageyoung = increment[1], ageold = increment[2])

#For loop to find datasets with tsuga pollen in 500 yr intervals from 0 to
#10000 years ago
for(i in 1:20) { 
  one_slice <- get_dataset(taxonname = 'Tsuga*', datasettype = 'pollen', 
                           loc = c(-150, 20, -100, 60), ageyoung = increment[i], 
                           ageold = increment[i + 1]) 
  }

#For loop to find number of datasets with tsuga pollen in 500 yr intervals from
#0 to 10000 years ago, saving numbers in a new vector called site_nos
site_nos <- rep(NA, 20) 
for (i in 1:20) { 
  one_slice <- get_dataset(taxonname = 'Tsuga*', datasettype = 'pollen', 
                           loc = c(-150, 20, -100, 60), ageyoung = increment[i],
                           ageold = increment[i + 1]) 
  site_nos[i] <- length(one_slice) 
  }

#Plotting the number of datasets with tsuga pollen over time
plot(increment[-1], site_nos)

#For loop to find the total number of West Coast datasets with pollen in 500
# yr intervals from 0 to 10000 years ago
site_all <- rep(NA, 20)
for (i in 1:20) {
  all_slice <- get_dataset(datasettype = 'pollen',
                           loc = c(-150, 20, -100, 60),
                           ageyoung = increment[i],
                           ageold = increment[i + 1])
  site_all[i] <- length(all_slice)
}

#Plotting the datasets with tsuga/total pollen datasets over time
plot(increment[-21], site_nos/site_all)

#For loop to find the latitude of sites with tsuga pollen in 500 yr intervals
#from 0 to 10000 years ago
site_lat <- rep(NA, 20)
for (i in 1:20) {
  all_site <- get_site(get_dataset(taxonname = 'Tsuga*',
                                   datasettype = 'pollen',
                                   loc = c(-150, 20, -100, 60),
                                   ageyoung = increment[i],
                                   ageold = increment[i + 1]))
  site_lat[i] <- mean(all_site$lat)
}
print(site_lat)

#Question 9: Picea in the Upper Midwest over the past 21,000 years

#Creating a vector increasing from 0 to 21000 by intervals of 500
increment2 <- seq(from = 0, to = 21000, by = 500)

#Creating two empty vectors, pic.sites and all.sites, to be filled by the 
#for loop
pic.sites <- rep(NA, 42) 
all.sites <- rep(NA, 42)

#For loop retrieving the number of datasets with picea pollen in 500 yr intervals
#from 0 to 21000 years ago, storing this number in the pic.sites vector. Also
#retrieving the total number of datasets with pollen in 500 yr intervals from
#0 to 21000 years ago, storing this number in the all.sites vector.
for (i in 1:42) { 
  pic.slice <- get_dataset(taxonname = 'Picea*', datasettype = 'pollen', 
                          loc = c(-98.6, 36.5, -66.1, 49.75), ageyoung = 
                          increment2[i], ageold = increment2[i + 1]) 
  pic.sites[i] <- length(pic.slice) 
  all.slice <- get_dataset(datasettype = 'pollen',
                           loc = c(-98.6, 36.5, -66.1, 49.75),
                           ageyoung = increment2[i],
                           ageold = increment2[i + 1])
  all.sites[i] <- length(all.slice)
}

#Plotting the datasets with picea/total pollen datasets over the past 21000
#years. 
pdf("PiceaDecline21000yrs.pdf")
plot(increment2[-42], pic.sites/all.sites, pch = 19, xlab = "Time (cal yr BP)", 
     ylab = "Picea Sites/All Pollen Sites", main = "The Upper Midwest Picea 
  decline over the last 21,000 years")
dev.off()

#Using the for loop to find datasets with Picea over the last 21000 years,
#you can see an obvious drop in the number of datasets with Picea pollen about 
#10000 years ago. You also see a resurgence in the number of sites with
#Picea pollen about 5000 years ago.