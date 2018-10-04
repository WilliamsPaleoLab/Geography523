##############################################################################################################################
#
##############################################################################################################################
library(english)
my.wd <- '~/teaching/'


setwd(my.wd)
data.loc <- 'data/'
plot.loc <- 'figures/'

all_dat <- 
lapply(1:9,function(x){

  temp0 <- read.csv(paste(data.loc,'WI-0',x,'-TEMP-sco.csv',sep=''),skip=3) 

  temp0 <- temp0[which(as.numeric(as.character(temp0$YEAR))<2019),]
  temp0 <- apply(temp0,2,function(x) { 
    tt <- as.numeric(as.character(x))
    tt <- ifelse(((!is.na(tt)) & (tt<200)), round((tt-32)*5/9,2),tt)
  })
})


tann <- sapply(1:length(all_dat),function(x){
  all_dat[[x]][,'ANNUAL'] #- mean(all_dat[[x]][,'ANNUAL'],na.rm=TRUE)
}) 


sapply(c(2,5,9),function(x){
pdf(paste(plot.loc,as.english(x),'_pairs.pdf',sep=''),height = 8, width = 8)
pairs(tann[,1:x])
dev.off()
})


####################################################################################################################################

panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}


panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y,use='complete.obs'))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}

pdf(paste(plot.loc,'pairs_with_correlations.pdf',sep=''),height = 8, width = 8)
pairs(tann,lower.panel=panel.cor)
dev.off()


pdf(paste(plot.loc,'correlation_matrix.pdf',sep=''),height = 8, width = 8)
pairs(tann,lower.panel=panel.cor,upper.panel = panel.cor)
dev.off()
