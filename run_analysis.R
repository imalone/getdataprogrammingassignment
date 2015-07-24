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
loadAllMeasures <- function(limrow=-1) {
  # Load the features list, don't turn names into factors
  featuresList <- read.table("features.txt",as.is=2)
  activitiesList <- read.table("activity_labels.txt")
  names(featuresList) <- c("id","name")
  
  trainSet <- loadMeasure("train",featuresList,limrow=limrow)
  testSet  <- loadMeasure("test",featuresList,limrow=limrow)
  # Don't need to check trainSet, testSet columns separately
  # as already compared against featuresList
  
  print("Combining data")
  allMeas <- rbind(trainSet,testSet)

  # Set up factors, do this after merging data so all
  # subject levels are present
  allMeas$Activity = as.factor(allMeas$Activity)
  levels(allMeas$Activity)<-activitiesList[,2]
  allMeas$Subject = as.factor(allMeas$Subject)

  allMeas
}


loadSelectedMeasures <- function(limrow=-1) {
  allMeas<-loadAllMeasures(lim=1000)
  # Get only mean(), std() and the factor labels
  selectMeas<-allMeas[grep("((mean|std)\\(\\))|Subject|Activity",names(allMeas))]
  # Remove unfriendly - and () characters
  names(selectMeas)<-gsub("-(mean|std)\\(\\)",".\\1",names(selectMeas))
  selectMeas
}


## Raw code to demo name tidy, group_by and summarise
selMeas<-loadSelectedMeasures(lim=1000)
library(dplyr)
selMeas2<-selMeas

groupMeas<-group_by(selMeas2,Label,Subj)
summarise(groupMeas,mean(fBodyBodyGyroMag.std))
## ... just need to properly tidy variables and report all
## fields
allMeas<-selMeas2

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
    "Mag", ".Magnitude"
  )
)
# Then use apply to run gsub on each column in turn,
# <<- operator refers back to allMeas names in outer
# scope.
apply(gsubmaps,2,function(x){
  names(allMeas)<<-gsub(x[1],x[2],names(allMeas),perl = TRUE)
})
