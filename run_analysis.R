## This script assumes that there is a directory UCI HAR Dataset (unzipped) in the same folder as 
## this script. Also the following libraries must be installed
library(stringr)  # for str_count function
library(dplyr)

### Given a dataset, create a dataset with averages of each variable by activity and subject
### This function calls the function readdatafromfiles

computeaverages<-function(){
  ## Read the tidied data into a dataframe
  TidyDF<-readdatafromfiles()
  ## Compute means of columns by SubjectId and TrainingLabel
  AveragesDF<-TidyDF %>% group_by(SubjectId,TrainingLabel) %>%summarize_if(is.numeric,mean)
  # Substitute codes of training activities by names; first get the labels from the dataset
  fileLocation<-"UCI HAR Dataset/activity_labels.txt"
  activity_labels<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))
  # Create a new column with activity names, and then delete the column with activity codes
  AveragesDF$TrainingLabelName<-activity_labels[AveragesDF$TrainingLabel,2]
  AveragesDF<-AveragesDF[,-2]
  # Re-arrange columns so that activity name is second
  AveragesDF<-AveragesDF[,c(1,68,2:67)]
  AveragesDF
}

### Reading the data from files
readdatafromfiles<-function(){
  
  ## reading features dataset
  fileLocation<-"UCI HAR Dataset/features.txt"
  features<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))

  ## reading data for subjects in training, saving them into data frames, naming columns
  trainDF<-data.frame()
  
  fileLocation<-"UCI HAR Dataset/train/subject_train.txt"
  trainDF_sub<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))
  colnames(trainDF_sub)[1]<-"SubjectId"
  
  fileLocation<-"UCI HAR Dataset/train/x_train.txt"
  trainDF_x<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))
  
  # Deleting columns which are not mean or std: first determine if std or mean 
  # appear in the column name in features; then delete the corresponding column from
  # trainDF_x and from features
  findstdmean<-str_count(features$V2,"std|mean+[^Freq]")
  features$stdmeanornot<-findstdmean
  # Get the numbers of columns which contain means or stds; keep only them
  features<-filter(features,stdmeanornot!=0)
  coltokeep<-features$V1
  trainDF_x<-trainDF_x[,coltokeep]
  # Rename columns in trainDF_x using names in features
  colnames(trainDF_x)<-features$V2
  
  # Read training labels for rows
  fileLocation<-"UCI HAR Dataset/train/y_train.txt"
  trainDF_y<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))
  colnames(trainDF_y)[1]<-"TrainingLabel"
  # Collect all data for the training group into the same dataframe
  trainDF<-cbind(trainDF_sub,trainDF_y,trainDF_x)
  
  #clear the memory
  remove(trainDF_y,trainDF_x,trainDF_sub)
  
  ###### Do the same sequence of steps for test variables
  ## reading data for subjects in training, saving them into data frames, naming columns
  testDF<-data.frame()
  fileLocation<-"UCI HAR Dataset/test/subject_test.txt"
  testDF_sub<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))
  colnames(testDF_sub)[1]<-"SubjectId"
  
  fileLocation<-"UCI HAR Dataset/test/X_test.txt"
  testDF_x<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))
  
  # Deleting columns which are not mean or std, use variables features and stdmeanornot
  # from the previous step; then delete the corresponding column from testDF_x 
  testDF_x<-testDF_x[,coltokeep]
  # Rename columns in testDF_x using names in features
  colnames(testDF_x)<-features$V2
  
  # Read training labels for activities
  fileLocation<-"UCI HAR Dataset/test/y_test.txt"
  testDF_y<-data.frame(read.delim(fileLocation,header = FALSE,sep = ""))
  colnames(testDF_y)[1]<-"TrainingLabel"
  # Record all data for test subjects to a single dataframe
  testDF<-cbind(testDF_sub,testDF_y,testDF_x)
  # clear the memory
  remove(testDF_x,testDF_y,testDF_sub)
  
  #put together training and test datasets
  FinalDF<-rbind(trainDF,testDF)
  FinalDF
}