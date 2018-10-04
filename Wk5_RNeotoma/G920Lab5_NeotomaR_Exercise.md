## Lab 5: Neotoma
### Geog920/523
#### Jack Williams & Mathias Trachsel
##### Goals
+ Learn how to use the *neotoma* R package
+ Learn key *neotoma* get_site, get_dataset, get_download
+ Understand the flow of data from the Neotoma R package, APIs, and R package.
+ Develop code to pass data from Neotoma Database to standard software such as *rioja* or *clam*
##### Resources
+ *neotoma* R package: [CRAN download](https://CRAN.R-project.org/package=neotoma)
+ *neotoma* [GitHub Repository](https://github.com/ropensci/neotoma) (hosted by ROpenSci)
+ [Paper](https://openquaternary.com/articles/10.5334/oq.ab/):  Goring, S., Dawson, A., Simpson, G., Ram, K., Graham, R. W., Grimm, E. C., and Williams, J. W. (2015) neotoma: A Programmatic Interface to the Neotoma Paleoecological Database. Open Quaternary 1:1-17.
##### Introduction
In this lab, we'll do a series of exercises designed to give you hands-on practice in using the *neotoma* R package (Goring et al, 2015)
API



XXX TEXT FROM Simon
# Starting Out in R

R is statistical software.  R is a programming language.  R is a valuable tool.  R is your best friend.  R would never let you down (would you R?).  R can also be a bit daunting.  This section is designed to give you a very gentle introduction, and to show you how powerful the database can be as a tool for discovery.

Let's start out by using R to find Marion Lake again.  The first thing to know is that R itself doesn't know how to find these data.  Base R "knows" how to calculate averages (the `mean` command), do linear regression (the `lm` command) and plot, among other things.  R knows some basic things, but to do more you need to load in packages.  Luckily R makes this very easy.  To load in the `neotoma` package, all you have to do is open RStudio and type the command:

```{r, eval = FALSE}
install.packages('neotoma')
```

This loads the package onto your computer.  You can put it into memory using the command:

```{r}
library(neotoma)
```

We're going to do a really simple example.  We're going to make a set of calls to the `get_dataset` command, looking for all sites with *Tsuga* in them at 500 year intervals.  We're going to limit our searches to the west coast, a bounding box from [-150^o^W, 20^o^N] to [-100^o^W, 60^o^N].  The `get_dataset` function will help us do that:

```{r}
one_slice <- get_dataset(taxonname='Tsuga*', loc=c(-150, 20, -100, 60), ageyoung = 0, ageold = 500)
```

So, this call gets 76 results.  Now we need to figure out a way to loop this, and to get the total number of sites returned.  First, lets create a *vector* of values, from 0 - 10000, incrementing by 500:

```{r}
increment <- seq(from = 0, to = 10000, by = 500)
```

We can replace parameters in our original call with the `increment` variable, or at least, the first element of it this way:

```{r}
one_slice <- get_dataset(taxonname = 'Tsuga*',
                         loc = c(-150, 20, -100, 60),
                         ageyoung = increment[1],
                         ageold = increment[2])
```

You should get 76 results again.  A variable is just a box for a value.  `increment` is a vector, a set of integer values, in order.  We could increase the values of the indices (the `[1]` and `[2]`) programmatically, so that we keep getting new time slices using a `for` loop.  Don't run this yet, but know that now, each time this is run, the time interval defined by `ageyounger` and `ageolder` will increment by one.

```r
for(i in 1:20){

  one_slice <- get_dataset(taxonname = 'Tsuga*',
                           datasettype = 'pollen',
                           loc = c(-150, 20, -100, 60),
                           ageyoung = increment[i],
                           ageold = increment[i + 1])
}
```
The problem is, each itteration of the `for` loop overwrites the variable `one_slice`.  I actually don't care what the datasets look like, I just want to know the number of datasets, so we can create a new variable, filled with 20 `NA` values, one for each itteration of the loop:

```{r, message=FALSE}

site_nos <- rep(NA, 20)

for (i in 1:20) {

  one_slice <- get_dataset(taxonname = 'Tsuga*',
                           datasettype = 'pollen',
                           loc = c(-150, 20, -100, 60),
                           ageyoung = increment[i],
                           ageold = increment[i + 1])
  site_nos[i] <- length(one_slice)

}

```

This might take a bit of time, but you'll see the progression, and for each value of `i`, from `1` to `20`, we're filling `one_slice` with new information, and then taking the `length` of that new dataset and putting it into the vector `site_nos`, at position `i`.

We can now plot the values and take a look at them:

```{r}
plot(increment[-1], site_nos)
```

So what does this tell us about *Tsuga* pollen on the west coast?  This might not actually be the best, call.  Maybe it's a sampling issue, maybe there are more young records than old records.  Why not correct our data:


```{r, message=FALSE}

site_all <- rep(NA, 20)

for (i in 1:20) {

  all_slice <- get_dataset(datasettype = 'pollen',
                           loc = c(-150, 20, -100, 60),
                           ageyoung = increment[i],
                           ageold = increment[i + 1])
  site_all[i] <- length(all_slice)

}

```

Does the pattern hold up?

```{r}
plot(increment[-21], site_nos/site_all)
```

Yes!  So we see increasing proportions of *Tsuga* pollen over time.  Where is the pollen coming from?  Let's get the latitude of the samples while we're also getting the percentages.  A `dataset` in the Neotoma package is actually a complicated data object.  It has information about the site, the actual location of the dataset, but also information about the specific dataset (a single site might contain multiple datasets).  To extract the latitude information we can use the `get_site` command:


```{r, message=FALSE}

site_lat <- rep(NA, 20)

for (i in 1:20) {

  all_site <- get_site(get_dataset(taxonname = 'Tsuga*',
                                   datasettype = 'pollen',
                                   loc = c(-150, 20, -100, 60),
                                   ageyoung = increment[i],
                                   ageold = increment[i + 1]))

  site_lat[i] <- mean(all_site$lat)

}

```

To finish off, let's plot this out.  You're on your own for this.

Think about what problems you might encounter with this example.  Can you figure out which sites you're actually getting?  What types of dates are they returning?  Are they radiocarbon dates, calibrated ages, varved ages?

Repeat this analysis, but push the starting age back to 21,000 years.  What does the pattern look like now?  Can you rewrite the `for` loop to produce all the values at the same time (so you only need to run it once)?
