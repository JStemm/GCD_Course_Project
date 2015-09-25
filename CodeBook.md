The data provided was measured using Samsung Galaxy II.  

86 variables were retained.  Naming works as follows:

leading character of "t" indicates Time domain
leading character of "f" indicates Frequency domain

Use of "Accel" indicates the data originates from the phone's Accelerometer
Use of "Gyro" indicates the data originates from the phone's Gyroscope

Acceleration signals were additionally broken down into body's acceleration and that of gravity, indicated by "Body" and "Gravity" respectively

"Mag" indicates the magnitude of the signal, which was calculated using the Euclidean norm.  

X, Y, and Z are all used to indicate the signal in the X, Y and Z dimensions for respective signals.

mean is indicated by "Mean" or "mean"

standard deviation is indicated by "std"


The source data was manipulated in the following ways to create the tidy dataset:


For each dataset (training and test), the Activity Code and Subject Codes were consolidated with the experiment data and then the 2 data sets were merged.

Column Headers are created for the consolidated dataset from features info in a provided file from the UCI data directory and cleaned to remove paranthesis, hyphens and to otherwise improve the usefulness of the Variable names.

Duplicate column headers are then discarded and the process of creating the "tidy" data set begins.  

All variables containing "mean" or "std" in the name are selected along with the subject and activity codes, discarding the remainder of the variables from the final tidy data set.  The ddply function is called to collapse the dataset into one calculating the mean of each feature for each subject and activity pairing.  (In other words, the mean for all mean and stdev measurements for each subjects measurements within each activity).  

The output is a N*M by 88 data frame written as a txt file, where N is the Number of Subjects and M is the number of activities.  In the given dataset, this is 30*6, so 180 row by 88 column data table.   





Source Data documentation from UCI Datafolder below, reproduced from the "features_info.txt" file:  

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'
