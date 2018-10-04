#################################################################################################################################
#compare temperatures South Central Wisconsin and southeast wisconsin
#################################################################################################################################
my.wd <- '~/teaching/'

setwd(my.wd)
data.loc <- 'data/'
plot.loc <- 'figures/'
code.loc <-'R/'

source(paste(code.loc,'load_data.R',sep=''))

ann.se <- tann[,9][!is.na(tann[,9])]
ann.sc <- tann[,8][!is.na(tann[,8])]

ann.se.cent <- ann.se-mean(ann.se)
ann.sc.cent <- ann.sc-mean(ann.sc)

cov.ann <- cov(cbind(ann.se,ann.sc),use = 'complete.obs')
eigen.cov <- eigen(cov.ann)
value <- eigen.cov$value
vector <- eigen.cov$vectors



pdf(paste(plot.loc,'scatter_Mil_Mad.pdf',sep=''),height = 8, width = 8)
plot(ann.se.cent,ann.sc.cent,xlab='',ylab='',pch = 16)
mtext(side = 1,line = 2.2, font = 2, 'Temperature Milwaukee')
mtext(side = 2,line = 2.2, font = 2, 'Temperature Madsion')
abline(h = 0,lty=2)
abline(v = 0,lty=2)
dev.off()


pdf(paste(plot.loc,'scatter_Mil_Mad_with_lines.pdf',sep=''),height = 8, width = 8)
plot(ann.se.cent,ann.sc.cent,xlab='',ylab='',pch = 16)
mtext(side = 1,line = 2.2, font = 2, 'Temperature Milwaukee')
mtext(side = 2,line = 2.2, font = 2, 'Temperature Madsion')
abline(h = 0,lty=2)
abline(v = 0,lty=2)
arrows(-10*0.8,-10*0.6,10*0.8,10*0.6,col=2,lwd = 2,lty=2)
arrows(-10*0.9,-10*sqrt(0.19),10*0.9,10*sqrt(0.19),col=4,lwd = 2,lty=2)
arrows(-10*0.75,-10*sqrt(1-0.75^2),10*0.75,10*sqrt(1-0.75^2),col='orange',lwd = 2,lty=2)
dev.off()



pdf(paste(plot.loc,'scatter_Mil_Mad_with_lines.pdf',sep=''),height = 8, width = 8)
plot(ann.se.cent,ann.sc.cent,xlab='',ylab='',pch = 16)
mtext(side = 1,line = 2.2, font = 2, 'Temperature Milwaukee')
mtext(side = 2,line = 2.2, font = 2, 'Temperature Madsion')
abline(h = 0,lty=2)
abline(v = 0,lty=2)
arrows(-10*0.8,-10*0.6,10*0.8,10*0.6,col=2,lwd = 2,lty=2)
arrows(-10*0.9,-10*sqrt(0.19),10*0.9,10*sqrt(0.19),col=4,lwd = 2,lty=2)
arrows(-10*0.75,-10*sqrt(1-0.75^2),10*0.75,10*sqrt(1-0.75^2),col='orange',lwd = 2,lty=2)
dev.off()



pdf(paste(plot.loc,'scatter_Mil_Mad_ev_points.pdf',sep=''),height = 8, width = 8)
plot(ann.se.cent,ann.sc.cent,xlab='',ylab='',pch = 16)
mtext(side = 1,line = 2.2, font = 2, 'Temperature Milwaukee')
mtext(side = 2,line = 2.2, font = 2, 'Temperature Madsion')
abline(h = 0,lty=2)
abline(v = 0,lty=2)
points(t(vector[,1]),col=4,pch = 16,cex = 2)
points(t(vector[,2]),col=4,pch = 16,cex = 2)
points(matrix(ncol=2,c(0,0)),col=4,pch = 16,cex = 2)
dev.off()



pdf(paste(plot.loc,'scatter_Mil_Mad_ev_lines.pdf',sep=''),height = 8, width = 8)
plot(ann.se.cent,ann.sc.cent,xlab='',ylab='',pch = 16)
mtext(side = 1,line = 2.2, font = 2, 'Temperature Milwaukee')
mtext(side = 2,line = 2.2, font = 2, 'Temperature Madsion')
abline(h = 0,lty=2)
abline(v = 0,lty=2)
points(t(vector[,1]),col=4,pch = 16,cex = 2)
points(t(vector[,2]),col=4,pch = 16,cex = 2)
points(matrix(ncol=2,c(0,0)),col=4,pch = 16,cex = 2)
arrows(-10*vector[1,1],-10*vector[2,1],10*vector[1,1],10*vector[2,1],col=2,lwd = 2,lty=2)
arrows(-10*vector[1,2],-10*vector[2,2],10*vector[1,2],10*vector[2,2],col=2,lwd = 2,lty=2)
dev.off()

# cov.ann <- cov(cbind(ann.se,ann.sc),use = 'complete.obs')
# eigen.cov <- eigen(cov.ann)
# value <- eigen.cov$value
# vector <- eigen.cov$vectors
# 
# plot(ann.se-mean(ann.se,na.rm=TRUE),ann.sc-mean(ann.sc,na.rm=TRUE))
# abline(h = 0,lty=2)
# abline(v = 0,lty=2)
# points(t(vector[,1]),col=4,pch = 16,cex = 2)
# points(t(vector[,2]),col=4,pch = 16,cex = 2)
# points(matrix(ncol=2,c(0,0)),col=4,pch = 16,cex = 2)
# arrows(-10*vector[1,1],-10*vector[2,1],10*vector[1,1],10*vector[2,1],col=2,lwd = 2,lty=2)
# arrows(-10*vector[1,2],-10*vector[2,2],10*vector[1,2],10*vector[2,2],col=2,lwd = 2,lty=2)

###################################################################################################################################


pc1 <- ann.se.cent*vector[1,1] + ann.sc.cent *vector[2,1]
pc2 <- ann.se.cent*vector[1,2] + ann.sc.cent *vector[2,2]

pdf(paste(plot.loc,'pca_new_axes.pdf',sep=''),height = 8, width = 8)
plot(pc1,pc2,xlab='',ylab='',pch = 16,xlim=range(pc1,na.rm=TRUE),ylim=range(pc1,na.rm=TRUE))
mtext(side = 1,line = 2.2, font = 2, 'PC 1')
mtext(side = 2,line = 2.2, font = 2, 'PC 2')
abline(h = 0,lty=2,col=2,lwd=2)
abline(v = 0,lty=2,col=2,lwd=2)
dev.off()

value <- eigen.cov$value
var(pc1) -value[1] 
var(pc2) -value[2]
value

pdf(paste(plot.loc,'pc1.pdf',sep=''),height = 6, width = 12)
plot(all_dat[[1]][-nrow(all_dat[[1]]),'YEAR'],pc1,type='l',xlab='',ylab='')
mtext(side=1,line=2.2,font=2,'Time')
mtext(side=2,line=2.2,font=2,'PC1')
abline(h=0,lty=2)
dev.off()
