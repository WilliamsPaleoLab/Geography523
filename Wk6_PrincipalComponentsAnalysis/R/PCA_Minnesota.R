################################################################################################################
# PCA for spatial climate data mostly from Minnesota
################################################################################################################
my.wd <- '~/teaching/'
setwd(my.wd)
plot.loc <- 'plots/'
data.loc <- 'data/'
if (!file.exists(plot.loc)){
  dir.create(plot.loc)
}
if (!file.exists(data.loc)){
  dir.create(data.loc)
}      



################################################################################################################
#load envirionmental data of the North American modern pollen database
library(analogue)
data("Pollen")
data("Climate")
head(Climate)
data(Location)
lon <- Location$Longitude
lat <- Location$Latitude

##################################################################################################################
#dind sites in Minnesota
use.index <- ((lon>(-99)) & (lon<(-91)) & (lat<49)& (lat>44))
climate.use <- Climate[use.index,]
location.use<- Location[use.index,]

cold.index <- climate.use[,'tave']<2.75
warm.wet.index <- ((climate.use[,'tave']>7.25) &(climate.use[,'annp']>775))
cold.dry.index <- ((climate.use[,'tave']<4) &(climate.use[,'annp']<500))
warm.dry.index <- ((climate.use[,'tave']>6) &(climate.use[,'annp']<500))


###################################################################################################################
#run pca for four variables (3 precipitation, 1 temperature, 1PC represents precipt varying east west, second temperature varying north south)
clim.five.var <- climate.use[,c('tave','tjul','annp','pnov','pdec')]

write.csv(round(cor(clim.five.var),2),paste(data.loc,'cor_Minnesota.csv',sep=''))

pca <- rda(clim.five.var,scale=TRUE)
var.scores <- scores(pca,choices=1:2,display='species')
sample.scores <- scores(pca,choices=1:2,display='sites')

limits <- max(abs(sample.scores))

x11(6,20)
#par(mfrow=c(1,3),oma=c(1,1,1,1))
layout(matrix(c(2,3,1),nrow=1))
par(oma=c(1,1,1,1))
map('state',xlim=c(-99,-91),ylim=c(44,49))
points(location.use[,c('Longitude','Latitude')])
points(location.use[cold.index,c('Longitude','Latitude')],col=4,pch = 16,cex = 1.5)
points(location.use[warm.wet.index,c('Longitude','Latitude')],col='purple',pch = 16,cex = 1.5)
points(location.use[cold.dry.index,c('Longitude','Latitude')],col='cyan',pch = 16,cex = 1.5)
points(location.use[warm.dry.index,c('Longitude','Latitude')],col='orange',pch = 16,cex = 1.5)
ordisurf(x=location.use[,c('Longitude','Latitude')],y=climate.use$tave,add=TRUE)
ordisurf(x=location.use[,c('Longitude','Latitude')],y=climate.use$annp,col=4,add=TRUE)
box()

plot(sample.scores,xlim=c(-limits,limits),ylim=c(-limits,limits))
points(sample.scores[cold.index,],col=4,pch = 16,cex = 1.5)
points(sample.scores[warm.wet.index,],col='purple',pch = 16,cex = 1.5)
points(sample.scores[cold.dry.index,],col='cyan',pch = 16,cex = 1.5)
points(sample.scores[warm.dry.index,],col='orange',pch = 16,cex = 1.5)
abline(h=0,lty=2)
abline(v=0,lty=2)
sapply(1:4, function(x){
  arrows(0,0,var.scores[x,1]/5,var.scores[x,2]/5,col=ifelse(x<2,2,4))  
})




plot(sample.scores,xlim=c(-limits,limits),ylim=c(-limits,limits))
points(sample.scores[cold.index,],col=4,pch = 16,cex = 1.5)
points(sample.scores[warm.wet.index,],col='purple',pch = 16,cex = 1.5)
points(sample.scores[cold.dry.index,],col='cyan',pch = 16,cex = 1.5)
points(sample.scores[warm.dry.index,],col='orange',pch = 16,cex = 1.5)
abline(h=0,lty=2)
abline(v=0,lty=2)
ordisurf(x=pca,y=climate.use$tave,add=TRUE)
ordisurf(x=pca,y=climate.use$annp,col=4,add=TRUE)
# 
# sample.scores[,'PC1'] <- -sample.scores[,'PC1']
# var.scores[,'PC1'] <- -var.scores[,'PC1']
# 
# plot(sample.scores[,c('PC2','PC1')],xlim=c(-1.1,1.1),ylim=c(-1.1,1.1))
# abline(h=0,lty=2)
# abline(v=0,lty=2)
# points(var.scores[,c('PC2','PC1')]/5,col=2,pch=16)
# ordisurf(x=sample.scores[,c('PC2','PC1')],y=climate.use$tave,add=TRUE)
# ordisurf(x=sample.scores[,c('PC2','PC1')],y=climate.use$annp,col=4,add=TRUE)



# plot(location.use)
# ordisurf(x=location.use,y=climate.use$tave)
# ordisurf(x=location.use,y=climate.use$annp,col=4,add=TRUE)

pca$tot.chi


######################################################################################################################
#
######################################################################################################################


# make own scaling type 3
eig.vals <- pca$CA$eig
eigenvalue1 <-eig.vals[1]
eigenvalue2 <- eig.vals [2]
sqrt.eig1 <- sqrt(eigenvalue1)
sqrt.eig2 <- sqrt(eigenvalue2)
var.exp1 <- eigenvalue1/

eigenvectors <- pca$CA$v

var.exp1 <- 100 * round(eigenvalue1/ncol(eigenvectors),2)
var.exp2 <- 100 * round(eigenvalue2/ncol(eigenvectors),2)

sample.scores1 <- sample.scores 
sample.scores1[,1] <- sample.scores[,1]*sqrt.eig1
sample.scores1[,2] <- sample.scores[,2]*sqrt.eig2
limits <- max(abs(sample.scores1))

var.scores1 <- var.scores
var.scores1[,1] <- eigenvectors[,1]*sqrt.eig1
var.scores1[,2] <- eigenvectors[,2]*sqrt.eig2


##############################################################################################################
pdf(paste(plot.loc,'PCA_Minnesota_arrows.pdf',sep=''),height = 12, width = 12)
plot(sample.scores1,xlim=c(-limits,limits),ylim=c(-limits,limits),xlab='',ylab='')
mtext(side = 1,line = 2.2, text = paste('PC1 ' ,var.exp1,'% variance explained'))
mtext(side = 2,line = 2.2, text = paste('PC2 ' ,var.exp2,'% variance explained'))
points(sample.scores1[cold.index,],col=4,pch = 16,cex = 1.5)
points(sample.scores1[warm.wet.index,],col='purple',pch = 16,cex = 1.5)
points(sample.scores1[cold.dry.index,],col='cyan',pch = 16,cex = 1.5)
points(sample.scores1[warm.dry.index,],col='orange',pch = 16,cex = 1.5)
abline(h=0,lty=2)
abline(v=0,lty=2)
sapply(1:ncol(eigenvectors), function(x){
  arrows(0,0,var.scores1[x,1],var.scores1[x,2],col=ifelse(x<3,2,4))  
})
dev.off()




##############################################################################################################
#add ordination surface
pdf(paste(plot.loc,'PCA_Minnesota_ordisurf.pdf',sep=''),height = 12, width = 12)
plot(sample.scores1,xlim=c(-limits,limits),ylim=c(-limits,limits),xlab='',ylab='')
mtext(side = 1,line = 2.2, text = paste('PC1 ' ,var.exp1,'% variance explained'))
mtext(side = 2,line = 2.2, text = paste('PC2 ' ,var.exp2,'% variance explained'))
points(sample.scores1[cold.index,],col=4,pch = 16,cex = 1.5)
points(sample.scores1[warm.wet.index,],col='purple',pch = 16,cex = 1.5)
points(sample.scores1[cold.dry.index,],col='cyan',pch = 16,cex = 1.5)
points(sample.scores1[warm.dry.index,],col='orange',pch = 16,cex = 1.5)
ordisurf(x=sample.scores1,y=climate.use$tave,add=TRUE)
ordisurf(x=sample.scores1,y=climate.use$annp,col=4,add=TRUE)
abline(h=0,lty=2)
abline(v=0,lty=2)
dev.off()
#################################################################################################################
# Minnesota with 
pdf(paste(plot.loc,'Minnesota_climate_map.pdf',sep=''),height = 12, width = 12)
map('state',xlim=c(-99,-91),ylim=c(44,49))
points(location.use[,c('Longitude','Latitude')])
points(location.use[cold.index,c('Longitude','Latitude')],col=4,pch = 16,cex = 1.5)
points(location.use[warm.wet.index,c('Longitude','Latitude')],col='purple',pch = 16,cex = 1.5)
points(location.use[cold.dry.index,c('Longitude','Latitude')],col='cyan',pch = 16,cex = 1.5)
points(location.use[warm.dry.index,c('Longitude','Latitude')],col='orange',pch = 16,cex = 1.5)
ordisurf(x=location.use[,c('Longitude','Latitude')],y=climate.use$tave,add=TRUE)
ordisurf(x=location.use[,c('Longitude','Latitude')],y=climate.use$annp,col=4,add=TRUE)
box()
dev.off()

#################################################################################################################
#
tave.vec <- eigenvectors['tave',]*eig.vals
tjul.vec <- eigenvectors['tjul',]*eig.vals
annp.vec <- eigenvectors['annp',]*eig.vals
annp.vec <- eigenvectors['annp',]*eig.vals

sum(tave.vec*tjul.vec)/(sqrt(sum(tave.vec^2))*sqrt(sum(tjul.vec^2)))
sum(tave.vec*annp.vec)/(sqrt(sum(tave.vec^2))*sqrt(sum(annp.vec^2)))

round(cor(climate.use[,c('tave','tjul','annp','pnov','pdec')]),2)
                     