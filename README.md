The run_analysis R script attached is designed to read in datasets from the web address: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

This data set is contained as 2 separate datasets, one designated a "training" data set and the other a "test" dataset.  Each data set has data contained in 3 separate files, 1 with the experiment data, 1 with the Activity Code and the other with the Subject Code.  

The run_analysis.R script downloads the file, unzips it and reads in each of the files for each dataset (training and test).  

For each dataset, the Activity Code and Subject Codes are consolidated with the experiment data and then the 2 data sets are merged.

Column Headers are created for the consolidated dataset from features info in a provided file from the UCI data directory and cleaned to remove paranthesis, hyphens and to otherwise improve the usefulness of the Variable names.

Duplicate column headers are then discarded and the process of creating the "tidy" data set begins.  

All variables containing "mean" or "std" in the name are selected along with the subject and activity codes.  The ddply function is called to collapse the dataset into one calculating the mean of each feature for each subject and activity pairing.  (In other words, the mean for all mean and stdev measurements for each of each subjects activities).  

The output is a N*M by 88 data frame written as a txt file, where N is the Number of Subjects and M is the number of activities.  In the given dataset, this is 30*6, so 180 row by 88 column data table.   


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