## Lab 5: Neotoma
### Geog920/523
#### Jack Williams & Mathias Trachsel
***
#### Goals
+ Learn how to use the *neotoma* R package and
key functions  (e.g. *get_site, get_dataset, get_download*)
+ Understand the flow of data through the Neotoma Paleoecology Database package, APIs, and *neotoma* package.
+ Develop code to prepare Neotoma data for passing to standard software such as *rioja* or *bacon*

#### Resources
+ [CRAN download](https://CRAN.R-project.org/package=neotoma) for *neotoma* R package:
+ [GitHub Repository](https://github.com/ropensci/neotoma) for *neotoma* source code (hosted by ROpenSci)
+ [Paper](https://openquaternary.com/articles/10.5334/oq.ab/):   Goring, S., Dawson, A., Simpson, G., Ram, K., Graham, R. W., Grimm, E. C., and Williams, J. W. (2015) neotoma: A Programmatic Interface to the Neotoma Paleoecological Database. Open Quaternary 1:1-17.

#### Introduction
In this lab, we'll do a series of exercises designed to give you hands-on practice in using the *neotoma* R package (Goring et al, 2015) and its key functions.  *neotoma*'s primary purpose is to pass data from the Neotoma Paleoecology Database (Neotoma DB) into the R environment.  Neotoma relies on Application Programming Interfaces ([APIs](https://en.wikipedia.org/wiki/Application_programming_interface)) to communicate with the Neotoma Paleoecology Database, so we'll begin by  introduce these to you as well.  

#### APIs
The Neotoma Paleoecology Database is a relational database, hosted on servers at Penn State's [Center for Environmental Informatics](http://www.cei.psu.edu/).  For security reasons, direct access to these servers is quite limited, and available only to a few Neotoma and CEI programmers.  

APIs offer public access points into Neotoma that anyone can use.  Each API is basically a function:  you provide the API with a set of operational parameters, and it returns a set of data or metadata.  [REST-ful APIs ](https://en.wikipedia.org/wiki/Representational_state_transfer) follow a particular set of standards that allow them to be read by web browsers (i.e. within the HTTP protocol) and return data objects, typically in HTML, XML, JSON or other human- & machine-readable formats

The [Neotoma APIs](http://api.neotomadb.org/doc/home) provide a series of functions for retrieving different kinds of data from Neotoma DB.  Data objects are returned in [JSON](https://en.wikipedia.org/wiki/JSON) format.  For this exercise, we strongly recommend adding an extension to your browser that formats the JSON output to make it easier to read

As an example, go to the documentation page for the 'Sites' API:  
http://api.neotomadb.org/doc/resources/sites

Read though the documentation.  Then, try this example by copying the below text and pasting it into your browser address line:

`api.neotomadb.org/v1/data/sites?sitename=*devil*`

This should open a new web page in your browser with a returned JSON object.  For this search, the JSON object should include 16 or more sites with the name 'devil' in them (note the use of asterisks as wildcards), including Devil's Lake, WI.  The opening line 'success = 1' means that the API ran successfully.  

Note that it is possible for an API to run successfully but return no data!  For example, try:

`api.neotomadb.org/v1/data/sites?sitename=devil`

Here, success = 1, but the returned data object is empty.

OK, now your turn.  Here's a few activities for your exercise:
1. **Exercise Question 5.1** Use the *sites* API to retrieve site data for sites of interest.  The *sites* API has a few different parameters, so try out options.  In your homework exercise, provide a script with at least two *sites* API calls with a comment line.  

2. **Exercise Question 5.2** Do the same for the  *datasets* and *downloads* API (only one API example of each needed).  Note that data volumes for objects returned by *downloads* can get quite large, so be judicious.

Note also that the 'DBTables' set of APIs is *very* helpful - this provides direct access to the contents each individual table stored inside of the Neotoma DB.  This is both a good way to get a better sense of the Neotoma DB data model (in addition to the (manual[https://neotoma-manual.readthedocs.io/en/latest/])) and to access data when one of the standard APIs isn't working for you.

3. **Exercise Question 5.3** Write a query that returns 50 records from the *Geochronology* table.

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
