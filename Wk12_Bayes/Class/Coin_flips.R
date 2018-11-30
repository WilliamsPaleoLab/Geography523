

bin.prob <- function(p,n,h){
  probab  <- factorial(n)*p^h*(1-p)^(n-h)/(factorial(h)*factorial(n-h))
}

normalizing.fun <- function(n,h,prior.n,prior.h){
  beta <- prior.n - prior.h+1
  prior.h <- prior.h+1
  nc <- factorial(n)*beta(h+prior.h,n-h+beta)/(factorial(h)*factorial(n-h)*beta(prior.h,beta))
}



posterior.fun <- function(probs,n,h,prior.n,prior.h){
  
  #define additional variables
  beta <- prior.n - prior.h+1
  alpha <- prior.h+1
  
  #Likelihiood
  L <- dbinom(h,n,probs)
  
  #Prior
  prior <- dbeta(probs,alpha,beta)
  prior <- prior/sum(prior)
  #normalizing constant
  nc <- factorial(n)*beta(h+alpha,n-h+beta)/(factorial(h)*factorial(n-h)*beta(alpha,beta))
  
  posterior <- L*prior/nc
  
  output <- data.frame(Posterior=posterior,Prior=prior,Likelihood = L)
  matplot(probs,output,type='l',xlab='',ylab='')
  mtext(side=1,line=2.2,font=2,expression(Theta),cex=1)
  mtext(side=2,line=2.2,font=2,cex=1,'Probability')
  legend('topleft',col=1:3,lty=1:3,legend=c('Posterior','Prior','Likelihood'))
  return(output)
}

# Observations for LIkelihood
n <- 20
h <- 15

# Coin flips for prior
prior.n <- 20
prior.h <-  10 

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)