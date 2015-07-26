# Code book for Coursera summary of "Human Activity Recognition Using Smartphones Data Set"

## Experimental design
This data is based on the UCI ["Human Activity Recognition Using Smartphones Data Set"][ucilink]. Accelerometer and gyroscope data from a Samsung Galaxy S II smartphone worn on the waist. Measurements were recorded for 30 volunteers each performing six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

<cite> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012</cite>

## Raw data
The raw data was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip on 2015-07-25. The following information summarises the README.txt and features_info.txt files.

For each observation, subject and activity number. The 30 subjects were divided into test (n=9) training (n=21) datasets. The raw time-series (50Hz) data of the accelerometer and gyroscope were noise filtered (low pass Butterworth filter 20Hz). The acceleration data was filtered with a low-pass Butterworth filter with 0.3Hz to separate gravity and "body" acceleration. Features were extracted from the raw time-series data sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window)

There are three classes of time series measure (prefixed with "t"):

* Gravity - low frequency component of acceleration.
* Body - high frequency component of acceleration and gyroscope.
* Gyro - gyroscope data.

For both Gyro and Body data a Jerk measure is calculated from their time derivatives. All measures have separate X, Y and Z axial components and a Euclidean norm Mag component.

Measures are also Fourier transformed to produce time domain signals, prefixed with "f".

The raw features are made up of the following parameters calculated on these measures:

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number     of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain     a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy()

And an average for: gravityMean, tBodyAccMean, tBodyAccJerkMean,
tBodyGyroMean, tBodyGyroJerkMean

Features were normalized and bounded within [-1,1] and are thus
unitless.

## Processed data
* UCI_HAR_Dataset_summary.txt contains the summarised data. It can
  be loaded in R by
  ``uciSummary<-read.table("UCI_HAR_Dataset_summary.txt",header=TRUE)``
* Test and training observations were combined into a single dataset
  containing all 30 subjects.
* Activity label numbers were converted to labels taken from
  activity_labels.txt
* Only mean() and std() measurements were retained. The overall
  "Mean" values are not as the summary will calculate mean values
  per activity.
* Feature names from features.txt were applied to the values.
  They were then transformed as follows:
    - The "fBodyAccJerkMag" values were found to have been labelled
      "fBodyBodyAccJerkMag" and were corrected in our processed
      data.
    - Acceleration values were renamed to Linear.Acceleration or
      Linear.Jerk
    - Gyroscope values were expanded to Gyroscope or Gyroscope.Jerk
    - Mag values were expanded to Magnitude.
    - t and f prefixes expanded to time and frequency
    - mean and std components were placed at the end of the
      variable name
    - Example final names:
        * time.Body.Linear.Acceleration.Magnitude.std
          (tBodyAccMag-std())
        * frequency.Body.Linear.Acceleration.X.mean
          (fBodyAcc-mean()-X)
* Observations were grouped by Subject number and Activity, and
  average (mean) values of each feature calculated within
  Subject + Activity. Final variable names are prefixed with
  "average." to indicate this.
* The summary information was recorded in the file
  UCI_HAR_Dataset_summary.txt as space separated format with a
  header row. The observations are presented in ["wide format"][wide]
  with each row containing the observation for a subject + activity.

### Variables
The final data has 68 columns: Subject and Activity labels (2) and average feature values (66). As for the raw data features, all measurements are unitless.
  
* [XYZ] indicates the axis component of the name may be X, Y or Z.
* [mean/std] all variables are in .mean and .std pairs, referring
  to the original feature mean() or std() (standard deviation).

* Subject
    - subject number (1-30)
* Activity
    - activity being carried out: WALKING, WALKING_UPSTAIRS,
      WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* average.time.Body.Linear.Acceleration.[XYZ].[mean/std]
    - average of time domain body acceleration measure for
      axis [XYZ]
* average.time.Gravity.Linear.Acceleration.[XYZ].[mean/std]
    - average of time domain gravity acceleration measure for
      axis [XYZ]
* average.time.Body.Linear.Jerk.[XYZ].[mean/std]
    - average of time domain body jerk (acceleration time
      derivative) measure for axis [XYZ]
* average.time.Body.Gyroscope.[XYZ].[mean/std]
    - average of time gyroscope measure for axis [XYZ]
* average.time.Body.Gyroscope.Jerk.[XYZ].[mean/std]
    - average of time gyroscope jerk (time derivative)
      measure for axis [XYZ]
* average.time.Body.Linear.Acceleration.Magnitude.[mean/std]
    -  average of time domain body acceleration magnitude measure
* average.time.Gravity.Linear.Acceleration.Magnitude.[mean/std]
    - average of time domain gravity acceleration magnitude measure
* average.time.Body.Linear.Jerk.Magnitude.[mean/std]
    - average of time domain body jerk (acceleration time
      derivative) magnitude measure
* average.time.Body.Gyroscope.Magnitude.[mean/std]
    - average of time domain gyroscope magnitude measure
* average.time.Body.Gyroscope.Jerk.Magnitude.[mean/std]
    - average of time domain gyroscope jerk (time derivative)
      magnitude measure
* average.frequency.Body.Linear.Acceleration.[XYZ].[mean/std]
    - average of frequency domain body acceleration measure for
      axis [XYZ]
* average.frequency.Body.Linear.Jerk.[XYZ].[mean/std]
    - average of frequency domain body jerk (acceleration time
      derivative) measure for axis [XYZ]
* average.frequency.Body.Gyroscope.[XYZ].[mean/std]
    - average of frequency gyroscope measure for axis [XYZ]
* average.frequency.Body.Linear.Acceleration.Magnitude.[mean/std]
    - average of frequency domain body acceleration magnitude
      measure
* average.frequency.Body.Linear.Jerk.Magnitude.[mean/std]
    - average of frequency domain body jerk (acceleration time
      derivative) magnitude measure
* average.frequency.Body.Gyroscope.Magnitude.[mean/std]
    - average of frequency domain gyroscope magnitude measure
* average.frequency.Body.Gyroscope.Jerk.Magnitude.[mean/std]
    - average of frequency domain gyroscope jerk (time derivative)
      magnitude measure

[ucilink]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[wide]:https://class.coursera.org/getdata-030/forum/thread?thread_id=107