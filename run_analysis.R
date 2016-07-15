#Set wd and packages#####################################################################################################################################################

setwd("C:/Users/suhaada/Desktop/R/Coursera/Getting and cleaning/Project")
library(reshape2)


## Download/unzip########################################################################################################################################################

filename <- "getdata_dataset.zip"


  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)

  unzip(filename) 



## Set activity labels###################################################################################################################################################

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])


# Subset stdev and mean data#############################################################################################################################################

features1 <- grep(".*mean.*|.*std.*", features[,2])
features1.names <- features[features1,2]
features1.names = gsub('-mean', 'Mean', featuresWanted.names)
features1.names = gsub('-std', 'Std', featuresWanted.names)
features1.names <- gsub('[-()]', '', featuresWanted.names)


# Load each dataset######################################################################################################################################################

train <- read.table("UCI HAR Dataset/train/X_train.txt")[features1]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)
test <- read.table("UCI HAR Dataset/test/X_test.txt")[features1]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


# merge data#############################################################################################################################################################

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", features1.names)


# Factorizing subsetted data#############################################################################################################################################

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

#Create tidy.txt#########################################################################################################################################################
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
