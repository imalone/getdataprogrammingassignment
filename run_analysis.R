# Load the data for the measName directory and combine
# label and subject columns
loadMeasure <- function (measName, dataDir, featuresList, limrow=-1) {
  #Name pattern:
  #  train/X_train.txt
  #  train/y_train.txt
  #  train/subject_train.txt
  # getPath(), pastes together arguments and returns full
  # path to file name
  getPath <- function(...) {
    file.path(dataDir,measName,paste(...,sep=""))
  }
  print(paste("Loading", measName))
  dataFile <- getPath("X_",measName,".txt")
  activityFile <- getPath("y_",measName,".txt")
  subjFile <- getPath("subject_",measName,".txt")

  meas<-read.table(dataFile, nrow=limrow)
  measActivity<-read.table(activityFile, nrow=limrow)
  measSubj<-read.table(subjFile, nrow=limrow)
  
  if (nrow(measActivity) != nrow(meas)) {
    stop(measName," number of label/activity rows didn't match")
  }
  if (nrow(measSubj) != nrow(meas)) {
    stop(measName," number of subject rows didn't match")
  }
  
  if ( ncol(meas) != nrow(featuresList)) {
    stop (measName, " number of columns doesn't match features.txt entries")
  }
  names(meas)<-featuresList[,"name"]  
  
  meas$Activity <- measActivity[,1]
  meas$Subject <- measSubj[,1]
  print(paste("Loaded", measName))
  meas
}


# Load all measurement data, bind feature names
loadAllMeasures <- function(dataDir, limrow=-1) {
  # Load the features list, don't turn names into factors
  featuresFile <- file.path(dataDir,"features.txt")
  featuresList <- read.table(featuresFile,as.is=2)
  activitiesFile <- file.path(dataDir,"activity_labels.txt")
  activitiesList <- read.table(activitiesFile)
  names(featuresList) <- c("id","name")
  
  trainSet <- loadMeasure("train",dataDir,featuresList,limrow=limrow)
  testSet  <- loadMeasure("test",dataDir, featuresList,limrow=limrow)
  # Don't need to check trainSet, testSet columns separately
  # as already compared against featuresList
  
  print("Combining data")
  allMeas <- rbind(trainSet,testSet)

  # Set up factors, do this after merging data so all
  # subject levels are present

  allMeas$Subject = as.factor(allMeas$Subject)
  allMeas$Activity = as.factor(allMeas$Activity)
  if ( length(levels(allMeas$Activity)) != nrow(activitiesList)) {
    stop ("Number of rows in activity_labels.txt doesn't ",
          "match number of labels in data")
  }
  levels(allMeas$Activity)<-activitiesList[,2]

  allMeas
}


# Load data and reduce to only the labels and desired mean()
# and std() variables
loadSelectedMeasures <- function(dataDir, limrow=-1) {
  allMeas<-loadAllMeasures(dataDir, limrow=limrow)
  # Get only mean(), std() and the factor labels
  selectMeas<-allMeas[grep("((mean|std)\\(\\))|Subject|Activity",names(allMeas))]
  # Remove unfriendly - and () characters
  names(selectMeas)<-gsub("-(mean|std)\\(\\)",".\\1",names(selectMeas))
  selectMeas
}


# Load data and apply substitutions to tidy names.
loadWithTidyNames <- function(dataDir, limrow=-1) {
  selectMeas <- loadSelectedMeasures(dataDir, limrow=limrow)
  
  # Make certain substitutions on the variable names to
  # make them more friendly. First set up the list of substitutions
  # as columns in a matrix
  gsubmaps <- matrix(
    nrow = 2,
    data = c(
      "BodyBody", "Body", # Fix double-Body typo
      "AccJerk", ".Linear.Jerk",
      "Gyro(?!Jerk)", ".Gyroscope", # Perl-type regex
      "GyroJerk", ".Gyroscope.Jerk",
      "Acc", ".Linear.Acceleration",
      "Mag", ".Magnitude",
      "(mean|std)-([XYZ])", "\\2.\\1",
      "^f", "frequency.",
      "^t", "time."
    )
  )
  # Then use apply to run gsub on each column in turn,
  # <<- operator refers back to selectMeas names in outer
  # scope.
  apply(gsubmaps,2,function(x){
    names(selectMeas)<<-gsub(x[1],x[2],names(selectMeas),perl = TRUE)
  })
  selectMeas
}


# Check features_info.txt can be found. If not try to download
# zipped dataset and extract it.
getDataIfMissing <-function(dataDir) {
  testFile<-file.path(dataDir,"features_info.txt")
  if ( ! file.exists(testFile)) {
    print("Couldn't find data, trying to download, could take some time.")
    dataSource <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipFile <- "UCI HAR Dataset.zip"
    zipLog <- "UCI HAR Dataset.txt"
    download.file(dataSource,destfile = zipFile, method="curl")
    unzip(zipFile, exdir="./")
    retrieveDate<-data.frame(RetrievedAt=Sys.time())
    write.table(retrieveDate, file=zipLog, row.names = FALSE)
  }
  if ( ! file.exists(testFile)) {
    stop("Failed to download or extract data.")
  }
}


# Get data if missing, call functions to load data,
# compute and write summary
loadAndSummarise <- function(limrow=-1) {
  library(dplyr)
  dataDir<-"UCI HAR Dataset"
  summFile<-"UCI_HAR_Dataset_summary.txt"
  getDataIfMissing(dataDir)
  selMeas<-loadWithTidyNames(dataDir,limrow=limrow)
  groupMeas<-group_by(selMeas,Subject,Activity)
  tidyData = summarise_each(groupMeas,funs(mean))
  # Prepend "average" to indicate transformation
  names(tidyData)<-sapply(names(tidyData), function(x){
    if (! x %in% c("Activity","Subject")) {
      paste("average.",x,sep="") 
    } else {
      x
    }
  })
  print(paste("Writing summary",summFile))
  write.table(tidyData,file=summFile,row.name=FALSE)
}

loadAndSummarise()
