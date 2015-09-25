run_analysis <- function() {
  # load necessary packages
  library(dplyr)
  library(plyr)
  # Tests to see if data is there, if not, grabs data and unzips
  if(!file.exists("samsung.zip")) {
    print("No File")
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,"samsung.zip")
    unzip("samsung.zip")
  }
  # read in all the data files 
  testData <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
  trainingData <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
  subtest <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
  subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
  actTestData <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
  actTrainData <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
  cnames <- read.table("UCI HAR Dataset/features.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)
  # bind the subject and activity codes to the respective test and training data frames
  testData <- cbind(subtest,actTestData,testData)
  trainingData <- cbind(subtrain,actTrainData,trainingData)
  # merge test and training data sets
  data <- rbind(testData,trainingData)
  # Pull in and name columns
  colnames <- cnames[,2]
  colnames <- c("Subject","Activity",colnames)
  colnames <- gsub("[()]","",colnames)
  colnames <- gsub("-","_",colnames)
  colnames <- gsub("Acc","Accel",colnames)
  colnames <- gsub("Body","Body_",colnames)
  colnames <- gsub("Jerk","_Jerk",colnames)
  colnames(data) <- colnames
  # removes duplicated columns, none have mean or std
  data <- data[,!duplicated(colnames)]
  # selects Subject, Activity Code and all columns with mean and std in column name
  subset <- select(data,1:2,contains("mean", ignore.case = TRUE),contains("std", ignore.case = TRUE))
  # Get Activity Labels from file and add to subset dataframe, name columns
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
  colnames2 <- c("Activity", "Activity_Description")
  colnames(activityLabels) <- colnames2
  subset$Subject <- factor(subset$Subject)
  subset$Activity <- factor(subset$Activity)
  goal <- ddply(subset,.(Activity,Subject),numcolwise(mean))
  goal <- join(goal,activityLabels)
  goal <- select(goal, 89,2:88)
  write.table(goal,"course_project_output.txt", row.name = FALSE)
}