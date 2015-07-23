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

On sourcing run_analysis.R:

1. **Steps to complete here**
10. loadAllMeasures(lim=-1) function loads the features.txt file for the dataset. Loads the individual *test* and *train* datasets via loadMeasure(), binds them into a single data frame. Optional lim parameter specifies rows to read per dataset for testing purposes.
11. loadMeasure() loads the individual X_ , y_ and subject_ files for a dataset and combines them, using a supplied list of feature names. An error is produced if:
    * There are inconsistent numbers of observations.
    * The number of X_ variables doesn't match the features list.
12. loadSelectedMeasures() filter for only the required features and **todo** perform some renaming magic.

[gettingandcleaning]: https://class.coursera.org/getdata-030
[datasharing]: https://github.com/jtleek/datasharing