#rm(list=ls())

#set working directory
dir_work <- "D:/Private/R_Study/Coursera_3.Getting and Cleaning Data/Final/UCI HAR Dataset"
setwd(dir=dir_work)

# <step.1. merge data>
#read files
Subject_Test <- read.table(file="test/subject_test.txt")
Test_X <- read.table(file="test/X_test.txt")
Test_Y <- read.table(file="test/Y_test.txt")
Subject_Train <- read.table(file="train/subject_train.txt")
Train_X <- read.table(file="train/X_train.txt")
Train_Y <- read.table(file="train/Y_train.txt")
Activity <- read.table(file="activity_labels.txt")
Feature <- read.table(file="features.txt")
# X : each value (test : 30%, train : 70%)
# Y : activity in number (test : 30%, train : 70%)
# Activity : match total 6 activities with numbers
# Feature : match total 561 features with numbers

#allocate name
names(Subject_Train) <- "SubjectID"
names(Subject_Test) <- "SubjectID"

names(Test_X) <- Feature$V2;names(Train_X) <- Feature$V2
names(Test_Y) <- "activity";names(Train_Y) <- "activity"
#step.4. already done here

#combine overall data into 1 dataset
Overall_Test <- cbind(Subject_Test,Test_Y,Test_X)
Overall_Train <- cbind(Subject_Train,Train_Y,Train_X)
Overall <- rbind(Overall_Test,Overall_Train)
# </step.1. merge data>

# <step.2. extract data>
#extract columns including string "mean()" or "std()"
colNumbers <- grepl("mean\\(\\)",names(Overall)) | grepl("std\\(\\)",names(Overall))
#include SubjectID and activity columns, 1 and 2
colNumbers[1:2] <- TRUE
Overall <- Overall[,colNumbers]
# </step.2. extract data>

# <step.3. use activity names>
#Allocate activity names instead of number
Overall$activity <- factor(Overall$activity, labels = Activity$V2)
# </step.3. use activity names>

# <step.5. create tidy data set>
#aggregate mean value of data by SubjectID and activity
ResultData <- aggregate(. ~ SubjectID + activity,Overall,mean)
# </step.5. create tidy data set>

#save as file
write.table(ResultData,"Output.txt",row.names = FALSE)
