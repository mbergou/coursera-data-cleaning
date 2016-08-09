# Coursera - Getting and Cleaning Data Course Project

The goal of this project is to turn the [data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) collected from users of the Samsung Galaxy S smartphone into a tidy data set. The data consists of measurements obtained from the phone's accelerometer and gyroscope for various subjects performing various activities.

The `run_analysis.R` script performs the following steps in order to turn the  data into a tidy data set.

1. If not already available, that data set is downloaded from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> and unzipped to the `data/` directory in the current working directory.
2. The files containing the subject ids, accelerometer/gyroscope measurements, and activity ids for each obervation are read in for both the training and test sets, and each set is merged.
3. The accelerometer/gyroscope measurements are filtered so that only the measurements corresponding to a mean or a standard deviation are kept. To determine this, only measurements that have "mean()" or "std()" in their name are kept in this step.
4. The map from activity id to name is read in from `activity_labels.txt`, and this is used to convert the activities in the original data from id to name so that they are more human readable.
5.  Each column of the final data set is given a descriptive name. The column containing the id of each subject is called "subject" and the column containing the name of the activity performed is called "activity." The columns corresponding to measurements are named based on their names from the `features.txt` file, with the following changes applied to make the names more readable:
    * The "t" and "f" prefixes in the names are converted to "time" and "frequency," respectively.
    * "Acc" is replaced with "Acceleration."
    * "Mag" is replaced with "Magnitude."
    * "mean()" and "std()" is replaced with "Mean" and "StandardDeviation."
    * All occurrences of "-" are removed from the name.

    The result of these changes is that, for example, "tGravityAcc-std()-X" is changed to "timeGravityAccelerationStandardDeviationX."
    
6. The average of each accelerometer/gyroscope measurement for each combination of subject and activity is computed, and the result is stored to the `tidyData.txt` file. The format is the same as the data set from step 5, where the columns correspond to subject id, activity, and one each for each accelerometer/gyroscope measurement. The data set can be read in with `read.table("tidyData.txt", header = TRUE)`.

The data sets produced by this script are tidy because:

1.  The variables of interest are the subjects involved in the study, the activity being performed, and the various measurements recorded by the accelerometer/gyroscope. Each one of these variables is a column in the data sets.
2.  Each observation forms a row, consisting of the subject, activity, and recorded measurements.
3.  In this case, there is only one observational unit, so there is only one table.