# Load the data for the measName directory and combine
# label and subject columns
loadMeasure <- function (measName, featuresList) {
  #Name pattern:
  #  train/X_train.txt
  #  train/y_train.txt
  #  train/subject_train.txt
  dataFile <- file.path(measName,paste("X_",measName,".txt",sep=""))
  labelFile <- file.path(measName,paste("y_",measName,".txt",sep=""))
  subjFile <- file.path(measName,"subject_train.txt")

  meas<-read.table(dataFile)
  measLabel<-read.table(labelFile)
  measSubj<-read.table(subjFile)
  
  if (length(measLabel) != nrow(meas)) {
    stop(meas," number of label rows didn't match")
  }
  if (length(measSubj) != nrow(meas)) {
    stop(meas," number of subject rows didn't match")
  }
  
  if ( ncol(meas) != nrow(featuresList)) {
    stop (meas, " number of columns doesn't match features.txt entries")
  }
  names(meas)<-featuresList[,"name"]  
  
  measSubset$Label <- trainLabel
  measSubset$Subj <- trainSubj
  meas
}


# Load all measurement data, bind feature names
loadAllMeasures <- function() {
  # Load the features list, don't turn names into factors
  featuresList <- read.table("features.txt",as.is=2)
  names(featuresList) <- c("id","name")
  
  trainSet <- loadMeasure("train",featuresList)
  testSet  <- loadMeasure("test",featuresList)
  # Don't need to check trainSet, testSet columns separately
  # as already compared against featuresList
  
  rbind(trainSet,testSet)
}
