#loading libraries 
install.packages ("dplyr")
install.packages ("data.table")
library (dplyr)
library (data.table)


#Reading files 
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
location <- "/Users/meeraganesh/Desktop/R\ Studio/Getting-Cleaning\ Data/Week\ 4/FinalProj.zip"
download.file (URL,location, method = "curl")
unzip(location, exdir = "/Users/meeraganesh/Desktop/R\ Studio/Getting-Cleaning\ Data/Week\ 4")

#Naming Files


fileloc <- "Users/meeraganesh/Desktop/R\ Studio/Getting-Cleaning\ Data/Week\ 4/UCI HAR Dataset"
files <- list.files(fileloc, recursive = TRUE)
featuresfile <- paste(fileloc, "features.txt", sep="/")
activitylabelsfile <- paste(fileloc, "activity_labels.txt", sep="/")
testvariablesfile <- paste(fileloc, "test/X_test.txt", sep="/")
testactivityfile <- paste(fileloc, "test/y_test.txt", sep="/")
testsubjectfile <- paste(fileloc, "test/subject_test.txt", sep="/")
trainvariablesfile <- paste(fileloc, "train/X_train.txt", sep="/")
trainactivityfile <- paste(fileloc, "train/y_train.txt", sep="/")
trainsubjectfile <- paste(fileloc, "train/subject_train.txt", sep="/")

#Creating the Tables
features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table(activitylabelsfile, col.names = c("code", "activity"))
subject_test <- read.table(testsubjectfile, col.names = "subject")
x_test <- read.table(testvariablesfile, col.names = features$functions)
y_test <- read.table(testactivityfile, col.names = "code")
subject_train <- read.table(trainsubjectfile, col.names = "subject")
x_train <- read.table(trainvariablesfile, col.names = features$functions)
y_train <- read.table(trainactivityfile, col.names = "code")

#Combining Talbes
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
CombineFile <- cbind(Subject, Y, X)

#Cleaning 
CleanDat <- CombineFile %>% select(subject, code, contains("mean"), contains("std"))

CleanDat$code <- activities[CleanDat$code, 2]

#CleaningData
names(CleanDat)[2] = "activity"
names(CleanDat)<-gsub("Acc", "Accelerometer", names(CleanDat))
names(CleanDat)<-gsub("Gyro", "Gyroscope", names(CleanDat))
names(CleanDat)<-gsub("BodyBody", "Body", names(CleanDat))
names(CleanDat)<-gsub("Mag", "Magnitude", names(CleanDat))
names(CleanDat)<-gsub("^t", "Time", names(CleanDat))
names(CleanDat)<-gsub("^f", "Frequency", names(CleanDat))
names(CleanDat)<-gsub("tBody", "TimeBody", names(CleanDat))
names(CleanDat)<-gsub("-mean()", "Mean", names(CleanDat), ignore.case = TRUE)
names(CleanDat)<-gsub("-std()", "STD", names(CleanDat), ignore.case = TRUE)
names(CleanDat)<-gsub("-freq()", "Frequency", names(CleanDat), ignore.case = TRUE)
names(CleanDat)<-gsub("angle", "Angle", names(CleanDat))
names(CleanDat)<-gsub("gravity", "Gravity", names(CleanDat))


FinalData <- CleanDat %>% group_by(subject, activity) %>% summarise_all(funs(mean))

write.table(FinalData, "/Users/meeraganesh/Desktop/R\ Studio/Getting-CLeaning\ Data/Week\ 4/FinalData.txt", row.name=FALSE)


print (file.exists ("Users/meeraganesh/Desktop/R\ Studio/Getting-Cleaning\ Data/Week\ 4/UCI HAR Dataset/features.txt"))

       
       