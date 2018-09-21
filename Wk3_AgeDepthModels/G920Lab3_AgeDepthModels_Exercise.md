## Lab 3: Age-Depth Models
### Geog920/523
#### Jack Williams & Mathias Trachsel

In Quaternary paleoecology, radiocarbon dating is expensive – a single sample typically costs $300 to $500 – so usually a given lake-sediment record will have only a scattering (ca. 5-30) of radiocarbon dates and other age controls.  Other kinds of age controls include volcanic ash layers (tephras), 210Pb, optically stimulated luminescence (OSL) dates, historic events such as the rise in *Ambrosia* pollen abundances associated with EuroAmerican land clearance, etc.)  An age model must be constructed to estimate the age of sediments not directly associated with an age control.

More generally, in the geological sciences, time is an unknown variable that must be estimated, with uncertainty. This requires a combination of age controls (age estimates with uncertainty for individual depths) and an age-depth model that estimates age as a function of depth, for all depths within the bounds of the model.  Different kinds of age-depth models exist, each with their own underlying assumptions and behavior.  Commonly used models include:

1) **Linear interpolation**, a.k.a. ‘connect the dots,’ in which straight lines are drawn between each depth-adjacent pair of age controls,
2) **Linear regression** (y=b0 + b1x; y=time and x=depth;  b0 and b1 are constants), in which a single straight line is fitted through the entire set of age controls,
3) **Polynomials**, also fitted to the entire set of age controls (y= b0 + b1x + b2x2 + b3x3 + …bnxn), and
4) **Splines**, which are a special kind of polynomial function that are locally fitted to subsets of  the age controls, and are widely used to smoothly interpolate between points.  (There are many kinds of splines; common forms include cubic, smooth, monotonic, and LOWESS).  
5) **Bayesian age models** (e.g. bacon, bchron, oxcal, etc.).  

Radiocarbon dating adds an additional complication to age-depth modeling because the initial calculation of a radiocarbon age assumes, by convention, that the amount of radiocarbon in the atmosphere is constant over time.  This is untrue, so radiocarbon age estimates must be calibrated using a calibration curve that is based on compiling radiocarbon dates of materials that have precise independent age estimates (e.g. tree rings, corals).  The IntCal series (IntCal04, IntCal09, IntCal13) to produce age estimates in calendar years.  The conversion from radiocarbon to calendar years usually further increases the uncertainty of age estimates.  

Yet another complication in radiocarbon dating is that different calibration curves need to be used for the Northern vs. Southern Hemisphere and for the atmosphere vs. oceans, due to different residence times of 14C in these different reservoirs.  In the oceans for example, radiocarbon has a residence time of centuries before phytoplankton biologically fix it through photosynthesis, which will lead the marine 14C to be depleted (and 'too old') relative to atmospheric 14C.  Use the wrong calibration curve and your age estimate will be highly inaccurate!

Here we will gain practice in working with age-depth models of various kinds, using several standard R packages (*clam*, *rbacon*, and see also *Bchron*), and assessing their age estimates and uncertainty.  We'll begin with a bit of practice in calibrating radiocarbon years to calendar years and comparing the calibration estimates from different calibration curves.  

#### Calibrating Radiocarbon dates:  CALIB & *clam*
1.	Lt’s try out [CALIB](http://calib.org/calib/), developed and maintained by Minze Stuiver and Paula Reimer. The default calibration curve in the website is IntCal13. This is a handy resource if you want to do a couple of quick calibrations.
+ Click on *Execute Version 7.1html*
  + Click on *Data Input Menu*
  + Enter “13000” in *Radiocarbon age BP* and “100” in *Standard Deviation*. Leave other fields as they are.
  + Click on box left of *Enter Data*.  Notice that the information now appears in the window below.  You could keep adding dates using the fields above, directly type additional rows into the window, or copy and paste from your spreadsheet to this one.
+	Click on *Calibration & Plot Options Menu*
  +	Under *Age Display*, select BP.
+	Run the calibration by clicking the big Calibrate button.
+	Results appear in the top window – you may need to scroll down to see them.
+ Clear the data and redo the exercise, this time using the MARINE13 curve.  This is for a hypothetical global marine reservoir correction.  The actual marine reservoir correction can vary from location to location.
+	For your homework, write down the median estimate and 2-sigma (95% CI) age ranges. Note that there is no convenient way to summarize the calibrated age distribution (the full PDF is best) but the 95%CI is a common summary.
2. Now, having done this by hand using CALIB, do the same calibration using the *calibration* function in *clam*
  + ```calibrate(13000,100)```  Calibrate using the default NH calibration curve
  + ```calibrate(13000,100,cc=2))``` Calibrate using using the MARINE13 curve
  + ```calibrate(13000,100,reservoir=c(50,30),cc=2)``` Calibrate using using the MARINE13 curve and a specified marine reservoir correction of 50 years with uncertainty of 30 years. Note the use of ```c``` (concatenate) to combine the individual values 50,50 into a single vector that is then the argument passed to the reservoir parameter.
+ Hopefully your CALIB and *clam* numbers agree!  

#### Classic Age Models (*clam*)
1. Pick a site from Neotoma and download geochronological data & pollen data, using the scripts you developed in the previous lab.  You may use the same site as last week or a new one.  Try to pick a site that spans at least the last 15,000 years and has a few bends in its age-depth plot.  Neotoma Explorer's Stratigraphic Diagrammer may be helpful here. Devils Lake WI is a good default option.
  + clam expects input dates in a csv file in a subdirectory of the same name (e.g. ```./MyCore1/MyCore1.csv```) - see Example/Example.csv for the expected format
  + to run:  ```clam(core="MyCore1")```
2. Build the following age-depth models using clam:
  + linear interpolation (```type="interp"```)
  + linear regression (```type="regr"```)  [default is linear]
  + 3rd-order polynomial (```type="regr", smooth=3```) [the ```smooth``` parameter sets the polynomial degree]
  + cubic spline (```type="spline"```)
3. For each age model:
  + Make a age-depth plot that shows both the age controls and age-depth model.  Plot depth on the x-axis and age on the y-axis.
  + Pick two notable events (e.g. end-Pleistocene Picea decline) and build a table that reports in separate columns the mean age and uncertainty (either 1 sigma or 2 sigma ok, but be consistent and note which you report)  
4. Using clam, construct a smooth spline (```type="smooth"```) with the default smoothing parameter
  + Experiment with alternative values of the ```smooth``` parameter and pick 3-4 that show a range of model behavior
  + Then, as in 3., make an age-depth plot that shows the various splines and a table that reports their age estimates and uncertainties.
5. Note that in *clam* you can also specify the position of 'slumps' (instantaneously deposited sediments, like a flood layer) and 'hiatuses' (gaps in the sediment record)

#### Bayesian Age Models (*bacon*)
A very useful resource:  the [Bacon Manual](http://www.chrono.qub.ac.uk/blaauw/manualBacon_2.2.pdf)
1. Simply running ```bacon()``` will run bacon using all default parameters and the sample dataset.  Try it.
2. Now, let's run *bacon* for your dataset. Like *clam*, *bacon* expects your input data to be in a csv file in a subdirectory of the same name.  Common parameters:
  + ```core="MyCore1"```
  + ```thick=5``` Bacon breaks up each core into a series of sections.  This parameter determines the section length.  e.g. for a core of total length 100cm, thick=5 would produce 20 section of 5cm apiece.
  + ```hiatus=450``` places a hiatus at 450cm.
  + ```hiatus.mean=100``` prescribes the length of the hiatus to 100 years
3. Bacon produces a standard output visualization with a MCMC trace in upper left and estimates of accumulation rate and memory in upper middle and upper right, and the age-depth plot in lower center.  Add a  snapshot of this output to your homework.  And, add the bacon age estimates and uncertainties to the table for the events you chose above.
4. Experiment with different choices of ```thick``` and evaluate their effect on runtime and the stiffness of the curve.  Experiment with placing hiatuses.  Add a couple of snapshots of interesting experiments with a sentence or two of commentary explaining what you changed and what happened.
