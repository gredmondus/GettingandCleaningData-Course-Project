---
output: html_document
---
---
title: "ReadMe"
author: "gredmondus"
date: "June 19, 2015"
output: word_document
--

The solution for this project was constructed as set of independent manual commands entered into the R console, when combined created the tidy.txt data set. 

1st step was to download and extract the usable data from the zip data file.

The initial steps consisted of reading in the metadata, training and test data. Noted that the data is primary sorted into subject, activity and features.  

In order to create the initial grouping, the data was read into a table as 

subjectTrain, activityTrain and featuresTrain and subjectTest,activityTestand featuresTest

The command(s) in part 1 first combined the training and test data sets and then merged into one data set   

## Part 1 - Merge Training and test sets to create one data set

subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

In part 2, the actions performed on the combined dataset was to extract the mean and standard deviation for each measurement

##Part 2 - Extract only the measurements for mean and standard dev for each measurement

## greb = replace all occurances

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD,562,563)
dim(completeData)

extractedData <- completeData[,requiredColumns]
dim(extractedData)

In this step, the complete data set was set as extracted data.  

The activity in in part 3 included clean up of the "activity" field in the extracted data set. 

##Part 3 - Use Descriptive activity names to name activities in the data set

## Created function - useDescActivityNames

extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

## Manual command to set activity as a factor 
extractedData$Activity <- as.factor(extractedData$Activity) 

In part 4, the variable names in the extractedData set were replaced with more descriptive terms

## Part 4 - Label the data set with descriptive variable names

## Replace Acronyms
names(extractedData)<-gsub("Acc","Accelerometer",names(extractedData))
names(extractedData)<-gsub("Gyro","Gyroscope",names(extractedData))
names(extractedData)<-gsub("BodyBody","Body",names(extractedData))
names(extractedData)<-gsub("Mag","Magnitude",names(extractedData))
names(extractedData)<-gsub("^t","Time",names(extractedData))
names(extractedData)<-gsub("^f","Frequency",names(extractedData))
names(extractedData)<-gsub("tbody","TimeBody",names(extractedData))
names(extractedData)<-gsub("-mean","Mean",names(extractedData), ignore.case=TRUE)
names(extractedData)<-gsub("-std","STD",names(extractedData),ignore.case=TRUE)
names(extractedData)<-gsub("-freq","Frequency",names(extractedData),ignore.case=TRUE)

In part 5, the data from step 4 was ued to create a second, independent tidy data set containing the average fo each variable fro each activity and subject

## Part 5 - Create a second, independent tidy data set with average of each variable for each activty and subject

extractedData$Subject <-as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)
 
tidyData <-aggregate(.~Subject + Activity,extractedData,mean)

tidyData <-tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData,file="Tidy.txt",row.names=FALSE)





