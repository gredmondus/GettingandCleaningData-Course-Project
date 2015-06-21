##this script assumes that data has already been downloaded

## Part 1 - Merge Training and test sets to create one data set

subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

##Part 2 - Extract only the measurements for mean and standard dev for each measurement

## greb = replace all occurances

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD,562,563)
dim(completeData)

extractedData <- completeData[,requiredColumns]
dim(extractedData)

##Part 3 - Use Descriptive activity names to name activities in the data set

## Created function - useDescActivityNames

extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

## Manual command to set activity as a factor 
extractedData$Activity <- as.factor(extractedData$Activity) 

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

## Part 5 - Create a second, independent tidy data set with average of each variable for each activty and subject

extractedData$Subject <-as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)
 
tidyData <-aggregate(.~Subject + Activity,extractedData,mean)

tidyData <-tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData,file="Tidy.txt",row.names=FALSE)




