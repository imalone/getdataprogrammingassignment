# getdataprogrammingassignment
Repository for Coursera [Getting and Cleaning Data][gettingandcleaning] course assignment.

## Contents
* README.md
    This readme
* run_analysis.R
    R script to compile data to tidy format 
* CodeBook.md **todo**
    Data code book.
    
## run_analysis.R
This is a single R script. Per [datasharing][datasharing] the variables selected and transformations applied are documented in the code book. In this README the operation of the script itself is explained.

## Requirements
The ["dplyr" library][dplyr] is loaded and used.

## Running
On sourcing the run_analysis.R file it will automatically run. If the "UCI HAR Dataset" is not found it will attempt to download the zip file (60MB) and extract it. The data will be summarised and written to **UCI_HAR_Dataset_summary.txt**. To the run_analysis.R file in R:

1. Copy run_analysis.R to the directory in which you want to run
    the analysis. If you have already downloaded and extracted UCI
    HAR Dataset this should be the directory that contains the
    "UCI HAR Dataset" directory.
2. In R use setwd() to change the working directory to the analysis
    directory.
3. Run ``source("run_analysis.R")``

## Output
 The resulting data is written to **UCI_HAR_Dataset_summary.txt**
 using ``write.table(...,row.name=FALSE)``. It can be read into R
 using:
 
 ```
 uciSummary<-read.table("UCI_HAR_Dataset_summary.txt",header=TRUE)
 ```
 
 See **CodeBook.md** for a description of the data.

## Operation
* The loadAndSummarise() function is the main function of the file.
    Data is loaded, summarised using dplyr and written to
    **UCI_HAR_Dataset_summary.txt**
* getDataIfMissing() is used to download and extract the source data
    if not in the directory.
* loadWithTidyNames() uses loadSelectedMeasures() and tidies the
    factor names.
* loadSelectedMeasures() uses loadAllMeasures() and extracts only
    the required variables
* loadAllMeasures() uses loadMeasure() for the training and testing
    data sets, combines them and converts labels to factors.
* loadMeasure() reads the required X_*.txt and associated label 
    files, combines them with feature names.

An error is produced if:

* There are inconsistent numbers of observations and labels.
* The number of X_ variables doesn't match the features list.

The optional lim parameter for load* functions specifies rows to read per dataset for function testing purposes.

[gettingandcleaning]: https://class.coursera.org/getdata-030
[datasharing]: https://github.com/jtleek/datasharing
[dplyr]: https://cran.r-project.org/web/packages/dplyr/index.html