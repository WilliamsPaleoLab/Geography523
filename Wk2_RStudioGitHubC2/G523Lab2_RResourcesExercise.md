
## Lab 2: Making A Pollen Diagram in R
### Geog920/523
#### Jack Williams & Mathias Trachsel

The goal of this exercise is to give you practice in basic data handling and visualization and, along the way, make sure that everyone is good to go with their R and RStudio installations.  We'll also gain practice in using RM

In this exercise, we will download a CSV datafile of pollen counts from Neotoma using the Neotoma Explorer interface, import the data to R, calculate relative percentages, and make a pollen diagram.

Please turn in your assignment as an R or RMarkdown file, with your code commented.  Please also include the CSV file that you use as your starting input.  If all goes well, I should be able to easily read and rerun your code.  Upload your assignment to GitHub using the Git commands described previously.

#### R & Markdown Resources
[R Guide](https://cran.r-project.org/doc/contrib/Owen-TheRGuide.pdf) by WJ Owen (local copy also on Repo)
[Intro to R Manual](http://cran.r-project.org/doc/manuals/r-release/R-intro.pdf) on CRAN
More R [manuals](http://cran.r-project.org/manuals.html) at CRAN
Still ore great [manuals](http://cran.r-project.org/other-docs.html)
[Markdown Formatting Guide](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

#### Lab 2 Exercise
##### Get a Pollen Dataset from Neotoma
Go to Neotoma Explorer and find a site with an interesting pollen record.  Devil's Lake, WI is a good option if you don't want to look around too much.  
+ Download it as a CSV file
+ Open the CSV file in Excel or other spreadsheet program.  Quick datalooks can be helpful to understand your data and format.  
+ The Neotoma CSV exports age information a bit We're going to do a simple data cleaning here and remove

###### Import the CSV file into R
Recommend the ```read.csv``` command.  This will create a Data Frame

###### Prepare the data for *rioja*
You'll need to do the following processing steps:
+ Extract pollen counts from Data Frame and create a holding matrix
+ Ensure that your matrix follows the format of rows=observations and columns=variables.  You may need to transpose your data.
+ You'll also need to convert your matrix to type numeric
+ Convert counts to percentages for each sample.  The commands ```rowSum```, ```rowSums```, or ```rowsum.data.frame``` are useful here.

These operations are a good chance to learn or refresh yourself on R syntax.  

###### Make a pollen diagram in *rioja*
This can be done using the ```strat.plot``` command in *rioja*
