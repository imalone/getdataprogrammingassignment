# Load the data for the measName directory and combine
# label and subject columns
loadMeasure <- function (measName, featuresList, limrow=-1) {
  #Name pattern:
  #  train/X_train.txt
  #  train/y_train.txt
  #  train/subject_train.txt
  getPath <- function(...) {
    file.path(measName,paste(...,sep=""))
  }
  print(paste("Loading", measName))
  dataFile <- getPath("X_",measName,".txt")
  labelFile <- getPath("y_",measName,".txt")
  subjFile <- getPath("subject_",measName,".txt")

  meas<-read.table(dataFile, nrow=limrow)
  measLabel<-read.table(labelFile, nrow=limrow)
  measSubj<-read.table(subjFile, nrow=limrow)
  
  if (nrow(measLabel) != nrow(meas)) {
    stop(measName," number of label rows didn't match")
  }
  if (nrow(measSubj) != nrow(meas)) {
    stop(measName," number of subject rows didn't match")
  }
  
  if ( ncol(meas) != nrow(featuresList)) {
    stop (measName, " number of columns doesn't match features.txt entries")
  }
  names(meas)<-featuresList[,"name"]  
  
  meas$Label <- measLabel[,1]
  meas$Subj <- measSubj[,1]
  print(paste("Loaded", measName))
  meas
}


# Load all measurement data, bind feature names
loadAllMeasures <- function(limrow=-1) {
  # Load the features list, don't turn names into factors
  featuresList <- read.table("features.txt",as.is=2)
  names(featuresList) <- c("id","name")
  
  trainSet <- loadMeasure("train",featuresList,limrow=limrow)
  testSet  <- loadMeasure("test",featuresList,limrow=limrow)
  # Don't need to check trainSet, testSet columns separately
  # as already compared against featuresList
  
  print("Combining data")
  allMeas <- rbind(trainSet,testSet)
  allMeas
}

loadSelectedMeasures <- function(limrow=-1) {
  allMeas<-loadAllMeasures(lim=1000)
  selectMeas<-allMeas[grep("((mean|std)\\(\\))|Subj|Label",names(allMeas))]
}

## Raw code to demo name tidy, group_by and summarise
selMeas<-loadSelectedMeasures(lim=1000)
library(dplyr)
selMeas2<-selMeas
names(selMeas2)<-gsub("-mean\\(\\)",".mean",names(selMeas2))
names(selMeas2)<-gsub("-std\\(\\)",".std",names(selMeas2))
groupMeas<-group_by(selMeas2,Label,Subj)
summarise(groupMeas,mean(fBodyBodyGyroMag.std))
## ... just need to properly tidy variables and report all
## fields
## Strictly speaking Label and Subj should be factors and
## names could be changed to Activity and Subject, Activity
## levels names should be descriptive text.