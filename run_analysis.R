rm(list = ls())
library(dplyr)

# Data preprocessing
# Get Data
#download zip file containing data if it hasn't already been downloaded
if (!file.exists("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/dataset.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, destfile = "C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/dataset.zip" , method="curl")
}  
if (!file.exists("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset")) { 
  unzip("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/dataset.zip") 
}


# read training data
xTrain <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/train/Y_train.txt")
subTrain <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/train/subject_train.txt")

# read test data
xTest <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/test/Y_test.txt")
subTest <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/test/subject_test.txt")

# read data description
varNames <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/features.txt")

# read activity labels
actLabels <- read.table("C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/activity_labels.txt")
##########################################################################
# The following are the requested steps for the project
# 1. Merge the training and the test sets to create one data set.
xTotal <- rbind(xTrain, xTest)
yTotal <- rbind(yTrain, yTest)
subTotal <- rbind(subTrain, subTest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selectedVar <- varNames[grep("mean\\(\\)|std\\(\\)",varNames[,2]),]
xTotal <- xTotal[,selectedVar[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(yTotal) <- "activity"
yTotal$actLab <- factor(yTotal$activity, labels = as.character(actLabels[,2]))
actLab <- yTotal[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(xTotal) <- varNames[selectedVar[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(subTotal) <- "subject"
tot <- cbind(xTotal, actLab, subTotal)

totMean <- tot %>% group_by(actLab, subject) %>% summarise_each(funs(mean))
write.table(totMean, file = "C:/Users/borah/Desktop/Data Science/John Hopkins University/Getting and Cleaning Data/Project/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

