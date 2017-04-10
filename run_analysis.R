##----Part 1:Merges the training and the test sets to create one data set-----
## considering zip file is downloaded and saved under working directory
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

## test data:
XTest<- read.table("UCI HAR Dataset/test/X_test.txt")
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")

## train data:
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")

## features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

##Part1 - merges train and test data in one dataset (full dataset at the end)
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)

##----Part 2:Extracts only the measurements on the mean and standard deviation for each measurement-----
index<-grep("mean\\(\\)|std\\(\\)", features[,2]) ##getting features indeces which contain mean() and std() in their name
length(index) ## count of features
X<-X[,index] ## getting only variables with mean/stdev
dim(X) ## checking dim of subset 

##----Part 3:Uses descriptive activity names to name the activities in the data set-----
Y[,1]<-activity[Y[,1],2] ## replacing numeric values with lookup value from activity.txt; won't reorder Y set
head(Y) 

##----Part 4:Appropriately labels the data set with descriptive variable names-----
names<-features[index,2] ## getting names for variables

names(X)<-names ## updating colNames for new dataset
names(Subject)<-"SubjectID"
names(Y)<-"Activity"

CleanedData<-cbind(Subject, Y, X)
head(CleanedData[,c(1:4)]) ## first 5 columns

##----Part 5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity'] ## features average by Subject and by activity
dim(TidyData)

head(TidyData[order(SubjectID)][,c(1:4), with = FALSE],12) 
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)
