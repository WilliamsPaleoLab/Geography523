#Allie Jensen
#GEOG 920
#Lab 12

#Exercise 1: Coin Flips

#Functions given for this exercise
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
  
  output <- data.frame(parameter=probs,Posterior=posterior,Prior=prior,Likelihood = L)
  matplot(output$parameter,output[,2:4],type='l',xlab='',ylab='')
  mtext(side=1,line=2.2,font=2,expression(Theta),cex=1)
  mtext(side=2,line=2.2,font=2,cex=1,'Probability')
  legend('topleft',col=1:3,lty=1:3,legend=c('Posterior','Prior','Likelihood'))
  return(output)
}

#Equal number of coin flips (20)
#Mode is about 0.5 for prior, 0.75 for likelihood, and about 0.625 for posterior
#(in the middle).

# Observations for Likelihood
n <- 20
h <- 15

# Coin flips for prior
prior.n <- 20
prior.h <- 10

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#Change number of coin flips used as prior

#No coin flips
#Prior is flat line, likelihood is still 0.75, posterior mode is now closer to
#likelihood (0.75, instead of in the middle)

# Observations for Likelihood
n <- 20
h <- 15

# Coin flips for prior
prior.n <- 0
prior.h <-  0

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#Half the data
#Prior flatter, distributed over wider interval, not as much of an obvious mode,
#still looks to be about 0.5, a little lower. Likelihood is the same. Posterior
#a little wider as well, more spread out, shifted to the right a little.

# Observations for Likelihood
n <- 20
h <- 15

# Coin flips for prior
prior.n <- 10
prior.h <-  5

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#Twice the data
#Prior is higher, compressed, distribution more important, now posterior shifted
#closer to prior, also higher more compressed.

# Observations for Likelihood
n <- 20
h <- 15

# Coin flips for prior
prior.n <- 40
prior.h <-  20

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#Change number of coin flips used as data

#Only 4 coin flips
#In this case, the likelihood becomes much wider/spread out, less important, 
#the prior is also wide and the posterior closely tracks the prior. 

# Observations for Likelihood
n <- 4
h <- 3

# Coin flips for prior
prior.n <- 20
prior.h <-  10

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#Twice the number of prior flips
#Likelihood becomes compressed, thinner, more important, posterior resembles the
#likelihood more than the prior, also compressed. Prior looks largely the same.

# Observations for Likelihood
n <- 40
h <- 30

# Coin flips for prior
prior.n <- 20
prior.h <-  10

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#5 times the number of prior flips
#Likelihood is very compressed, taller and skinnier, posterior largely controlled
#by this, also very compressed, as high as likelihood. Prior has similar shape but
#shifted to left.

# Observations for Likelihood
n <- 100
h <- 75

# Coin flips for prior
prior.n <- 20
prior.h <-  10

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#Divide the coin flips into 2 parts 
#Compared to the 40 coin flips, the posteriors are the same, the prior shifted
#more to the right over 0.6, likelihood is wider/larger spread, less obs. compared
#to prior. 

# Observations for Likelihood
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

# Observations for Likelihood
n <- 20
h <- 15

# Coin flips for prior
prior.n <- 40
prior.h <-  25

probs <-  seq(0,1,0.01)

outp <- posterior.fun(probs=probs,
                      n = n,
                      h = h,
                      prior.n = prior.n,
                      prior.h = prior.h)

#Exercise 2: Monte Carlo Sampling

#Reading in a csv of state population data and saving it as matrix StatePop
StatePop <- read.csv("StatePopData.csv", header = TRUE, stringsAsFactors = FALSE)

#Assigning the first column of StatePop to variable state.num, assigning second column
#of StatePop to variable state.pop
state.num <- StatePop[,1]
state.pop <- StatePop[,3]

#Selecting a random sample from state.num to be the first state in the Monte
#Carlo sampling procedure
state1 <- sample(state.num, 1, replace = FALSE)

#Making an empty vector of visits for each state (50 variables long)
visits <- rep(0, 50)

#Defining the Monte Carlo function
stateMC <- function() {
    #Randomly selects second state for sampling procedure
    state2 <- sample(state.num, 1)
    #Calculates ratio of populations in the 2 states
    pop.ratio <- state.pop[state2]/state.pop[state1]
    #If ratio>1, adds a visit +1 to the second state, second state becomes state1
    if (pop.ratio > 1) {
      visits[state2] = visits[state2] + 1
      visits[state1] = visits[state1]
      state1 <<- state2
    #If ratio <1, calculates probability of moving to second state, if prob = 1,
    #adds a visit +1 to second state, second state becomes state1
    } else if (pop.ratio < 1) {
      new.prob <- sample.int(n = 2, size = 1, prob = c(pop.ratio, 1 - pop.ratio))
      if (new.prob == 1) {
        visits[state2] = visits[state2] + 1
        visits[state1] = visits[state1]
        state1 <<- state2
      #If prob != 1, adds a visit to first state, first state stays state1
      } else {
        visits[state1] = visits[state1] + 1
        visits[state2] = visits[state2]
        state1 <<- state1
      }
    }
    #Returns vector of visits
    return(visits)
}

#Repeating the Monte Carlo function 50000 times, saving all the visit vectors
#to a large list
replist <- replicate(50000, stateMC(), simplify = FALSE)

#Creating a sequence of odd numbers from 1 to 49999 to iterate over
x <- seq(1, 49999, 2)

#Creating an empty vector for the sum of visits in each state from 50000 trials
#(50 variables)
repsum <- rep(0, 50)
#Iterating over the number sequence to add each vector in the large list to the vector
#after it, calculating a total vector sum
for (val in x) {
  repsum = repsum + replist[[val]] + replist[[val+1]]
}

#Calculating proportion of visits at each state/total visits
visits.prop <- repsum/sum(repsum)
#Calculating proportion of population in each state/total population
state.pop.prop <- state.pop/sum(state.pop)

#Combining the state names and visit and population proportions into a list with 
#3 elements
state.list <- list("States" = StatePop[,2], "Population Prop." = state.pop.prop,
                     "Visits Prop." = visits.prop)
#Making the list into a matrix
state.matrix <- matrix(unlist(state.list), ncol = 3, byrow = FALSE)
#Assigning column names to the matrix
colnames(state.matrix) <- c("State", "Population Prop.", "Visits Prop.")
#Writing the matrix to a csv file, saved in my working directory
write.csv(state.matrix, "state.matrix.csv", quote = FALSE, row.names = FALSE)
