## Lab 5: Direct Porting of Neotoma Data into R: APIs and *neotoma*
### Geog920/523
#### Jack Williams, Mathias Trachsel, and Simon Goring

***
#### Goals
+ Understand the flow of data through the Neotoma Paleoecology Database package, APIs, and *neotoma* package.
+ Learn how to use the *neotoma* R package and
key functions  (e.g. *get_site, get_dataset, get_download*)
+ Learn and develop code for single-site and multi-site data visualizations.
+ Learn to prepare Neotoma data for passing to standard software such as *rioja* or *analogue*

#### Resources
+ [CRAN download](https://CRAN.R-project.org/package=neotoma) for *neotoma* R package:
+ [GitHub Repository](https://github.com/ropensci/neotoma) for *neotoma* source code (hosted by ROpenSci)
+ [Paper](https://openquaternary.com/articles/10.5334/oq.ab/):   Goring, S., Dawson, A., Simpson, G., Ram, K., Graham, R. W., Grimm, E. C., and Williams, J. W. (2015) neotoma: A Programmatic Interface to the Neotoma Paleoecological Database. *Open Quaternary* 1:1-17.

#### Introduction
This series of exercises is designed to give you hands-on practice in using APIs and the *neotoma* R package (Goring et al, 2015), both for practical reasons and for  insights into how open-data systems work.  *neotoma*'s primary purpose is to pass data from the Neotoma Paleoecology Database (Neotoma DB) into the R environment.  Neotoma relies on Application Programming Interfaces ([APIs](https://en.wikipedia.org/wiki/Application_programming_interface)) to communicate with the Neotoma Paleoecology Database, so we'll begin with an introduction to APIs.  

Note that the R components of this exercise are adapted from materials originally developed by Simon Goring, Jack Williams, and others for Neotoma training workshops at PalEON and elsewhere (e.g. [HTML](http://www.goring.org/resources/Neotoma_Lesson.html) and [GitHub](https://github.com/SimonGoring/Neotoma_Lesson)) and are reproduced here under the [MIT License](https://opensource.org/licenses/MIT). Thanks to Simon and all! The PalEON2016 materials and other Neotoma Workshop resources can be found on the [NeotomaDB Repository](https://github.com/NeotomaDB/Workshops).

#### APIs
The Neotoma Paleoecology Database is a relational database, hosted on servers at Penn State's [Center for Environmental Informatics](http://www.cei.psu.edu/).  For security reasons, direct access to these servers is quite limited, and available only to a few Neotoma and CEI programmers.  

**APIs** offer public access points into Neotoma that anyone can use.  Each API is basically a function:  you provide the API with a set of operational parameters, and it returns a set of data or metadata.  Each API hence is designed to support one particular task or set of tasks; it offers a narrow window into the larger Neotoma DB. [REST-ful APIs ](https://en.wikipedia.org/wiki/Representational_state_transfer) follow a particular set of standards that allow them to be read by web browsers (i.e. within the HTTP protocol) and return data objects, typically in HTML, XML, JSON or other human- & machine-readable formats

The [**Neotoma APIs**](http://api.neotomadb.org/doc/home) provide a series of functions for retrieving different kinds of data from Neotoma DB.  Data objects are returned in [JSON](https://en.wikipedia.org/wiki/JSON) format.  For this exercise, we strongly recommend adding an extension to your browser that formats the JSON output to make it easier to read, such as [JSONView](https://addons.mozilla.org/en-US/firefox/addon/jsonview/).

As an example, go to the documentation page for the `Sites` API:  
http://api.neotomadb.org/doc/resources/sites

Read though the documentation.  Then, try this example by copying the below text and pasting it into your browser address line:

`api.neotomadb.org/v1/data/sites?sitename=*devil*`

This should open a new web page in your browser with a returned JSON object.  For this search, the JSON object should include 16 or more sites with the name 'devil' in them (note the use of asterisks as wildcards), including Devil's Lake, WI.  The opening line `success = 1` means that the API ran successfully.  

Note that it is possible for an API to run successfully but return no data!  For example, try:

```
api.neotomadb.org/v1/data/sites?sitename=devil
```

Here, `success = 1`, but `data=[]`, i.e. the API successfully reported back to you that no sites in Neotoma have the exact name of 'devil'.

OK, now your turn:  
<p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;"><b>Exercise Question 1</b> Use the *sites* API to retrieve site data for sites of interest.  The *sites* API has a few different parameters, so try out options.  In your homework exercise, provide at least two *sites* API calls with a comment line.</p>  

<p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;"><b>Exercise Question 2</b> Do the same for the  *datasets* and *downloads* API (only one API example of each needed).  Note that data volumes for objects returned by *downloads* can get quite large, so be judicious.</p>

Note also that the 'DBTables' set of APIs is *very* helpful - this provides direct access to the contents of each individual table stored inside of Neotoma DB.  DBTables provides both a good way to get a better sense of the Neotoma DB data model (in addition to the [Neotoma Manual](https://neotoma-manual.readthedocs.io/en/latest/)) and a good way to access data when one of the standard APIs doesn't meet your needs.

<p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;"><b>Exercise Question 3</b> Write an API call that returns 50 records from the *Geochronology* table.</p>

#### Importing Neotoma Data into R and *neotoma*
##### *neotoma*: Overview and Loading

The *neotoma* package provides a series of functions inside of R, each one of which calls one or more APIs.  *neotoma* was primarily written by Simon Goring, with support from NSF-Geoinformatics and the ROpenSci project.

Let's begin by installing and loading the *neotoma* package into RStudio. To install, open RStudio, install the package and then load the functions:

```
install.packages('neotoma')
library(neotoma)
```

##### Finding Sites, Getting Metadata: `get_site()`

We'll start with `get_site`.  `get_site` returns a [data frame](http://www.r-tutor.com/r-introduction/data-frame) with metadata about sites. You can use this to find the spatial coverage of data in a region (using `get_site` with a bounding box), or to get explicit site information easily from more complex data objects.  Use `?get_site` to see all the options available.  `get_site` is essentially an R wrapper for the API `sites` and has very similar functionality.

You can easily search by site name, for example.  

`samwell_site <- get_site(sitename = 'Samwell%')`

Examine the results: `print(samwell_site)`

`get_site` can return one site (as above) or many, e.g.:

`devil_sites <- get_site(sitename = 'devil%')`

`get_site` (and most *neotoma* functions) returns an data object of type `data.frame` that stores vectors of equal length.  The nice thing about a `data.frame` is that each vector can be of a different type (character, numeric values, etc.). In RStudio, use the Environment panel in upper right to explore the contents of `samwell_site`.

While `samwell_site` is a data frame, it also has class `site`, so the print output looks a little different than a standard R data frame.  This also allows you to use some of the other *neotoma* functions more easily.  

<p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;">**Exercise Question 4** How many sites have the name 'clear' in them?  Show both your code and provide the total count.</p>

You can also search by lat/lon bounding box.  This one roughly corresponds to Florida.

`FL_sites <- get_site(loc = c(-88, -79, 25, 30))
`

You can also search by geopolitical name or geopolitical IDs (`gpid`) stored in Neotoma. For a list of names and gpids, go to [http://api.neotomadb.org/apdx/geopol.htm](), or use the `get_table(table.name = "GeoPoliticalUnits")` command.  This command works either with an explicit numeric ID, or with a text string:

Example: *get all sites in New Mexico (gpid=7956)*

`NM_sites <- get_site(gpid = 7956)`

*get all sites in Wisconsin*

`WI_sites <- get_site(gpid = "Wisconsin")`

<p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;"><b>Exercise Question 5</b> Which state has more sites, Minnesota or Wisconsin?  How many of each?  Provide both code and answer.</p>


We noted above that the object returned from `get_site()` is both a `data.frame` and a `site` object.  Because it has a special `print` method some of the information from the full object is obscured when printed.  You can see all the data in the `data.frame` using `str` (short for *structure*):

`str(samwell_site)`

Let's look at the `description` field:

`samwell_site$description`

##### Finding Datasets, Getting Metadata: `get_dataset()`

The structure of the Neotoma data model, as expressed through the API is roughly: "`counts` of a fossil taxa within `download`, `download` within `dataset`, `dataset` within `site`".  So a `dataset` contains information about a particular dataset from a given site.  A site may have one or several associated datasets.

`get_dataset` returns a list of datasets containing the metadata for each dataset.  It can receive as inputs vectors of site names, vectors of site IDs, or data objects of class `site` (i.e. output from `get_site`!).  For example:

```
samwell_datasets <- get_dataset(samwell_site)
print(samwell_datasets)
```

We can pass output from `get_site` to `get_dataset`, even if `get_site` returns multiple sites

`devil.meta.dataset  <- get_dataset(devil_sites)`

Let's look at the dataset metadata:

`devil.meta.dataset`

<p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;">**Question 6**: How many different kinds of datasets are available at Devil's Lake, WI? Show both code and answer.  Ensure that your code just retrieves datasets for just this single site. </p>

##### What have I found? `browse`

Sometimes, it's helpful to quickly spot-check your results using Neotoma Explorer and its quick-look visualizations.  You can pass your results back to Explorer using the `browse` command.  `browse` will accept a numberic value (a single Dataset ID) and data objects of type 'dataset', 'dataset_list', 'download', or 'download_list'  

For example: `browse(samwell_datasets)`

Note that `browse` returns a local result of `null` to R (which is normal) and then calls a new browser window, showing the Samwell datasets in Neotoma Explorer.

[*Oct 4, 2018: A bug:  browse() works, but Neotoma Explorer development version isn't calling Google Maps correctly.*]

##### Want to read more? *get_publication*

Like `browse()`, you can use `get_publication()` to get more information.  Pass in the publication IDs or a `dataset` object, e.g.:
`samwell_pubs <- get_publication(samwell_datasets)`

##### Can I Haz Data?  *get_download* and *get_geochron*

`get_download()` returns a `list` that stores a list of `download` objects - one for each retrieved `dataset`.  Note that `get_download()` returns the actual data associated with each dataset, rather than a list of the available datasets, as in `get_dataset()` above.

 `get_download()` will accept an object of class dataset (e.g., `samwell_dataset`) or of class site (e.g., `samwell_site`). If the latter, it will automatically query for the datasets associated in each site.  For example:

`samwell_all1 <- get_download(samwell_site)`

`samwell_all2 <- get_download(samwell_datasets)`

`print(samwell_all1)`

`print(samwell_all2)`

Note that by default, `get_download` produces a number of messages. These can be suppressed with the flag `verbose = FALSE` in the function call.  

`samwell_all1 <- get_download(samwell_site, verbose = FALSE)`

You'll note that not all of the datasets can be downloaded directly to a `download` object.  This is because geochronological datasets have a different data structure than other data, requiring different fields, and as such, they are obtained using  `get_geochron`:

`samwell_geochron <- get_geochron(samwell_site)`

`print(samwell_geochron)`

The result is effectively the inverse of the first.

Let's look a bit more closely at the data frame returned by `get_download`, using the just the vertebrate datasets for  Samwell Cave Popcorn Dome (dataset 14262):
`samwell_pd <- get_download(14262)`

Let's examine the available data in this download:

`str(samwell_pd[[1]])`

There are 6 associated fields:

1. dataset
    + site.data
    + dataset.meta
    + pi.data
    + submission
    + access.date
    + site
2. sample.meta
3. taxon.list
4. counts
5. lab.data
6. chronologies

Within the download object, `sample.meta` stores the core depth and age information for that dataset. We just want to look at the first few lines, so are using the `head()` function.  Let's explore different facets of the dataset

`head(samwell_pd[[1]]$sample.meta)`

`taxon.list` stores a list of taxa found  in the  dataset
`head(samwell_pd[[1]]$taxon.list)`

`taxon.list` stores a list of taxa found  in the  dataset
`head(samwell_pd[[1]]$taxon.list)`

`counts` stores the the counts, presence/absence data, or percentage data for each taxon for each sample
`head(samwell_pd[[1]]$counts)`

`lab.data` stores any associated  laboratory measurements in the dataset. e.g. for pollen data, this will return information about any spike added to calculate concentrations
`head(samwell_pd[[1]]$lab.data)`


#### Helper function:  *compile_taxa*

The level of taxonomic resolution can vary among analysts.  Often for multi-site analyses it is helpful to aggregate to a common taxonomic resolution. The `compile_taxa` function in `neotoma` will do this.  To help support rapid prototyping, `neotoma` includes a few pre-built taxonomic lists, so far mostly for North American pollen types. **However**, the function also supports the use of a custom-built `data.frame` for aligning taxonomies.  Because new taxa are added to Neotoma regularly (based on analyst identification), it is worthwhile to check the assignments performed by the `compile_taxa` function, and, if needed, build your own  compilation table.

For example, the 'P25' list derives from Gavin et al., (2003) Quaternary Research, and includes 25 pollen taxa.  For Devil's Lake:

#To get Devil's Lake data, pass in SiteID 666)
`devil_datasets <- get_dataset(666)`
`devil_data <- get_download(devil_datasets)`
#First dataset  at Devil's Lake is the Maher pollen dataset
`devil_pollen <-devil_data[[1]]`
#Now, compile the Devil's Lake pollen data using the P25 listL
`devil_pollen_p25 <- compile_taxa(devil_data[[1]], list.name = "P25")`

You'll notice that warning messages return  a number of taxa that cannot be converted using the existing data table.  Are these taxa important?  They may be important for you.  Check to see which taxa have been converted by looking at the new taxon table:

`devil_pollen_p25$taxon.list[,c("compressed", "taxon.name")]`

And note that if you look at the names of the objects in the new `download` object (using `names(devil_pollen_p25)`, there is now a `full.counts` object.  This allows you to continue using the original counts, while also retaining the new compiled counts.

#### Visualization and Analysis: One Site
The larger goal here is to pass Neotoma data to other R packages for visualization and analysis.  Here we will show how to prepare data for passing to the `analogue` package. Later, you'll prepare data for passing to `rioja`.

Note: to make it clear which functions come from the `analogue` package we will use `analogue::` before each function name.   This is optional but good practice when using many R packages (just in case two packages have used the same name for a function).

`library("analogue")`

#Convert the Devils Lake pollen data to percentages
`devil_pollen_pct <- analogue::tran(x = devil_pollen$counts, method = 'percent')`

#Keep only the common taxa (avg>2%), drop rare taxa
#Warning: JWW2018/10/07: May need to rm(devil_pollen_pct_norare) if pre-existing.
`devil_pollen_pct_norare <- devil_pollen_pct[, colMeans(devil_pollen_pct, na.rm = TRUE) > 2]`

#Make a pollen diagram in *analogue*

```r
colOrder = order(colMeans(devil_pollen_pct_norare, na.rm = TRUE),  decreasing = TRUE)
analogue::Stratiplot(x = devil_pollen_pct_norare[ , colOrder], 
                     y = devil_data[[1]]$sample.meta$age,
                    ylab = devil_data[[1]]$sample.meta$age.type[1],
                    xlab = " Pollen Percentage")
```

 <p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;">**Question 7**: Make a stratigraphic pollen diagram in *rioja*, for a site of your choice (not Devils Lake).  Show code and resulting diagram. </p>

#### Visualization and Analysis: Multiple Sites
What if we want to look at data from multiple sites?  We can use the same set of `get_dataset` and `get_download` functions, but add some specialized functions for compiling the datasets to help improve our ability to analyze the data.  Lets start by looking for sites with hemlock pollen in the upper Midwest, and we'll border the dates using a buffer around the hemlock decline.

```r
# Search for datasets with Tsuga in them
hem_dec <- get_dataset(taxonname = "Tsuga*",
                       datasettype = "pollen",
                       loc = c(-98.6, 36.5, -66.1, 49.75),
                       ageyoung = 4500, ageold = 6000)
# Download the datasets (this will take a few minutes)
hem_dec_dl <- get_download(hem_dec)
```

Let's see where the sites are (you'll need the `rworldmap` package):

```r
library(rworldmap)
map <- getMap()

plot(hem_dec)
plot(map, add = TRUE)
```

Now we use the function `compile_download` to combine the records.  We're really only interested in the *Tsuga* in this case, so we can search for *Tsuga* related columns.  `compile_download` also adds critical content to the first 10 columns of the output `data.frame`, so we want to keep those as well.

```r
hem_compiled <- compile_downloads(hem_dec_dl)
```

This next set of code gets a bit gnarly, but order of operations is 1) find the unique taxon names from across all the downloaded sites,  2) isolate only trees, shrubs & upland herbs, 3) convert to proportion, and 4) isolate the *Tsuga* percentages.  

```r
# Extract all taxon tables from the original download object  
all_taxa <- do.call(rbind.data.frame, lapply(hem_dec_dl, function(x)x$taxon.list[,1:6]))

# Remove duplicate names
all_taxa <- all_taxa[!duplicated(all_taxa),]

# Limit the taxa to everything that is a tree or shrub, or upland herbs. (This information is stored within a field called `ecological.group` )
# Because columns in R by default change all punctuation and spaces to periods we have
#  to use regular-expression commands to change spaces `[ ]` and punctuation
#  `[[:punct:]]` to a period using the `gsub` command.

good_cols <- c(1:10, which(colnames(hem_compiled) %in%
      gsub("[ ]|[[:punct:]]", ".",
      all_taxa[all_taxa$ecological.group %in%
      c("TRSH", "UPHE"),1])))

# Take just those trees, shrubs & herbs and transform counts to proportions:
hem_compiled <- hem_compiled[ ,good_cols]

hem_pct <- hem_compiled[,11:ncol(hem_compiled)] / rowSums(hem_compiled[,11:ncol(hem_compiled)],             na.rm = TRUE)

hem_only <- rowSums(hem_pct[,grep("Tsuga", colnames(hem_pct))], na.rm = TRUE)
```

We can pull ages from the `compiled_downloads` object (`hem_compiled`) by taking the `rowMeans` of the age columns, and then plot hemlock percentages against age.


```r
age_cols <- grep("^age", colnames(hem_compiled))

hemlock_all <- data.frame(ages = rowMeans(hem_compiled[,age_cols], na.rm = TRUE),
                          prop = hem_only)

plot(hemlock_all, col = rgb(0.1, 0.1, 0.1, 0.3), pch = 19, cex = 0.4,
     xlim = c(0, 20000),
     ylab = "Proportion of Hemlock",          xlab = "Years Before Present")
```

We should now be able to see the well-known rapid decline of *Tsuga* in northeastern United States and Canada.  Note the large number of "zero" points.  It's also worth noting that there are a number of records that are only in Radiocarbon years.  This is critically important, given the offset between radiocarbon and calendar years.  (We and others are actively uploading new calendar-year age models to Neotoma).  The plot looks somewhat different if we separate sites with radiocarbon-year chronologies from other date types:

```r
plot(hemlock_all,
     col = c(rgb(0.1, 0.1, 0.1, 0.3),
             rgb(1, 0, 0, 0.3))[(hem_compiled$date.type == "Radiocarbon years BP") + 1],
     pch = 19, cex = 0.4,
     xlim = c(0, 20000),
     ylab = "Proportion of Hemlock", xlab = "Years Before Present")
```

If you look closely you can clearly see the offset at the time of the Decline between the Radiocarbon ages and the calibrated dates.  Obviously, more data cleaning needs to be done here.

 <p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;">**Question 8**: Repeat the above exercise, for *Picea* or a taxon of your choice. Show code and plot. </p>

#### Fun with For-Loops
In this next example, we'll show how to use *neotoma*  and a `for` loop to extract data for multiple sites at multiple time intervals. We're going to make a set of calls to the `get_dataset` command, looking for all sites with *Tsuga* in them at 500 year intervals.  We're going to limit our searches to the west coast, a bounding box from [-150^o^W, 20^o^N] to [-100^o^W, 60^o^N].  The `get_dataset` function will help us do that:

`one_slice <- get_dataset(taxonname='Tsuga*', loc=c(-150, 20, -100, 60), ageyoung = 0, ageold = 500)`

So, this call gets returns a set of sites within this bounding box for this one time interval (0 to 500 yr BP).  Now we need to figure out a way to loop this, and to get the total number of sites returned.  First, lets create a *vector* of values, from 0 to 10000, incrementing by 500:

`increment <- seq(from = 0, to = 10000, by = 500)`

We can replace parameters in our original call with the `increment` variable, or at least, the first element of it this way:

`one_slice <- get_dataset(taxonname = 'Tsuga*',
                         loc = c(-150, 20, -100, 60),
                         ageyoung = increment[1],
                         ageold = increment[2])
`

This should return the same dataset as the prior function call.  Now, let's increase the values of the indices (the `[1]` and `[2]`) programmatically, so that we keep getting new time slices using a `for` loop.  Each time this loop iterates, the time interval defined by `ageyounger` and `ageolder` will increment by one.

```
for(i in 1:20){
  one_slice <- get_dataset(taxonname = 'Tsuga*',
              datasettype = 'pollen',
              loc = c(-150, 20, -100, 60),
              ageyoung = increment[i],
              ageold = increment[i + 1])
}
```

However, in this code, each iteration of the `for` loop overwrites the variable `one_slice`.  So, we can create a new variable, filled with 20 `NA` values, ready to store data from each iteration of the loop:

```
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

`plot(increment[-1], site_nos)`

```r
site_all <- rep(NA, 20)
for (i in 1:20) {
  all_slice <- get_dataset(datasettype = 'pollen',
                           loc = c(-150, 20, -100, 60),
                           ageyoung = increment[i],
                           ageold = increment[i + 1])
  site_all[i] <- length(all_slice)
}

plot(increment[-21], site_nos/site_all)
```

Yes!  So we see increasing proportions of *Tsuga* pollen over time.  Where is the pollen coming from?  Let's get the latitude of the samples while we're also getting the percentages.  A `dataset` in the Neotoma package is actually a complicated data object.  It has information about the site, the actual location of the dataset, but also information about the specific dataset (a single site might contain multiple datasets).  To extract the latitude information we can use the `get_site` command:


```

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

 <p style="border:3px; border-style:solid; border-color:#a9a9a9; padding: 1em;">**Question 9**: Repeat the analysis for *Picea* and for the last 21,000 years in the Upper Midwest. What patterns do you see now? Can you rewrite the `for` loop to produce all the values at the same time (so you only need to run it once)?  </p>
