two_coins_fun <- function(pgrid, kappa,a.omega,b.omega,n1,h1,n2,h2){

  prior.omega <- dbeta(pgrid,a.omega+1,b.omega+1)
  prior.omega <- prior.omega/sum(prior.omega)



  theta.prior <- sapply(1:length(pgrid),function(x) {
    omega <- pgrid[x] 
    a <- omega*(kappa-2)+1
    b <- (1-omega)*(kappa-2)+1
    theta <- dbeta(pgrid,a,b)*prior.omega[x]
  })


  prior <-  array(dim=rep(length(pgrid),3))

  for(i in 1:length(pgrid)){
    prior[,,i] <- theta.prior*theta.prior[,i]#*theta.prior[iii]      
  }

  prior <- prior/sum(prior)


  p.margtheta2 <- apply(prior,c(1,2),sum)
  p.margtheta1 <- apply(prior,c(1,3),sum)

  #Likelihood functions
  likelihood1 <- dbinom(h1,n1,pgrid)
  likelihood2 <- dbinom(h2,n2,pgrid)

  posterior <- array(dim=rep(length(pgrid),3))


  for(i in 1:length(pgrid)){
    for(ii in 1:length(pgrid)){
      for(iii in 1:length(pgrid)){
        posterior[i,ii,iii] <- prior[i,ii,iii]*likelihood1[ii]*likelihood2[iii]      
      }
    }
  }

  posterior <- posterior/sum(posterior)

  marg.theta2 <- apply(posterior,c(1,2),sum)
  marg.theta1 <- apply(posterior,c(1,3),sum)

  omega <- rowSums(marg.theta2)
  omega.test <- rowSums(marg.theta1)

  theta1 <- colSums(marg.theta2)
  theta2 <- colSums(marg.theta1)

  list(prior.omega = prior.omega, 
     total.prior = prior,
     likelihood1 = likelihood1,
     likelihood2 = likelihood2,
     posterior = posterior,
     post.omega.theta1 = marg.theta2,
     post.omega.theta2 =marg.theta1,
     post.omega = omega,
     post.theta1 = theta1,
     post.theta2 = theta2)
}

# grid on which we will estimate probabilities
pgrid <- seq(0,1,0.01)




#specifying the shape of the beta distribution used as prior for omega (hyperparamter)
a.omega <- 2
b.omega <- 2
#define ho strongly Theta can deviate from omega
kappa <-  5

#number of flips and heads of coin 1
n1 <- 15
h1 <- 3

#number of flips and heads of coin 2
n2 <- 5
h2 <- 4 


output <- two_coins_fun(pgrid = pgrid,
              kappa = kappa,
              a.omega = a.omega,
              b.omega = b.omega,
              n1 = n1,
              h1 = h1,
              n2 = n2,
              h2=h2)


# prior.omega.theta <- apply(output$total.prior,c(1,2),sum)
# prior.omega.theta <- prior.omega.theta/sum(prior.omega.theta)
# prior.theta <-colSums(prior.omega.theta)
# prior.omega <-rowSums(prior.omega.theta)
# 
# contour(pgrid,pgrid,t(output$post.omega.theta2))
# contour(pgrid,pgrid,t(output$post.omega.theta1))
# contour(pgrid,pgrid,prior.omega.theta,labcex=1,xlab=expression(Theta),ylab=expression(omega))
# 
# 
# plot(pgrid,output$post.omega,type='l')
# plot(pgrid,output$post.theta1,type='l')
# plot(pgrid,output$post.theta2,type='l')
# plot(pgrid,prior.theta,type='l')
# plot(pgrid,output$prior.omega,type='l')


probs <- cbind(output$post.omega,
      output$post.theta1,
      output$post.theta2,
      output$prior.omega,
      output$likelihood1,
      output$likelihood2)

matplot(pgrid,probs[,c(1,4)],type='l')
legend('topleft',col=1:2,lty=1:2,legend=c('Posterior Omega','Prior Omega'))

matplot(pgrid,probs[,c(2,5)],type='l')
legend('topright',col=1:2,lty=1:2,legend=c('Posterior Theta1','Likelihood Theta1'))

matplot(pgrid,probs[,c(3,6)],type='l')
legend('topleft',col=1:2,lty=1:2,legend=c('Posterior Theta2','Likelihood Theta2'))
