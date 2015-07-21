featuresList <- read.table("features.txt",as.is=2)

train<-read.table("train/X_train.txt")
trainLabel<-read.table("train/y_train.txt")
trainSubj<-read.table("train/subject_train.txt")
names(train)<-featuresList[,2]

trainSubset <- train[,grep("(mean|std)\\(\\)",featuresList[,2])]
trainSubset$Label <- trainLabel
trainSubset$Subj <- trainSubj
