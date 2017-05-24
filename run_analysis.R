getwd()
setwd("E:/Anuja/Study/DS_Specialization/Course 3/UCI HAR Dataset")

#  Downloading and unzipping dataset

if(!file.exists("./project")){dir.create("./project")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./project/Dataset.zip")

# Unzip dataSet to /project directory
unzip(zipfile="./project/Dataset.zip",exdir="./project")
# Reading trainings tables:
x_train <- read.table("./project/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./project/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./project/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./project/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./project/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./project/UCI HAR Dataset/activity_labels.txt')

# Assign col Names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Merge datasets

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# reading Col Names

colNames <- colnames(setAllInOne)

# Create variables


mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Set variables

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#Merge

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# Data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# write to Txt File


write.table(secTidySet, "secTidySet.txt", row.name=FALSE)

