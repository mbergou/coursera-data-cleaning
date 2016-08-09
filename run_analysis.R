# Download and unzip the dataset if necessary.
baseDir <- file.path("data")
if (!dir.exists(baseDir)) dir.create(baseDir)
filename <- file.path(baseDir, "UCI_HAR_Dataset.zip")
if (!file.exists(filename)) {
  download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    filename)
}
dataDir <- file.path(baseDir, "UCI HAR Dataset")
if (!dir.exists(dataDir)) unzip(filename, exdir = baseDir)
trainDir <- file.path(dataDir, "train")
testDir <- file.path(dataDir, "test")

# Step 1: Merge the training and the test sets to create one data set.

# Read the subject id for each observation
subjectsTrain <- read.table(file.path(trainDir, "subject_train.txt"))
subjectsTest <- read.table(file.path(testDir, "subject_test.txt"))
# Read the features for each observation
XTrain <- read.table(file.path(trainDir, "X_train.txt"))
XTest <- read.table(file.path(testDir, "X_test.txt"))
# Read the activity id for each observation
activityTrain <- read.table(file.path(trainDir, "y_train.txt"))
activityTest <- read.table(file.path(testDir, "y_test.txt"))
# Merge each training/test set
subjects <- rbind(subjectsTrain, subjectsTest)
X <- rbind(XTrain, XTest)
y <- rbind(activityTrain, activityTest)

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement.

# Read the feature ids and their names
features <- read.table(
  file.path(dataDir, "features.txt"),
  col.names = c("id", "name"),
  stringsAsFactors = FALSE)
# Keep only the feature ids that contain "mean()" or "std()" in their names.
features <- features[grepl("mean\\(\\)|std\\(\\)", features$name), ]
# Keep only the measurements corresponding to the kept features
X <- X[, features$id]

# Step 3: Use descriptive activity names to name the activities in the data set

# Read the activity ids and their associated labels
activityLabels <- read.table(
  file.path(dataDir, "activity_labels.txt"),
  col.names = c("id", "activity"))
# Convert activities to lower case to make them a bit easier to read
activityLabels$activity <- as.factor(tolower(activityLabels$activity))
# Convert activity id to activity name
y[, 1] <- activityLabels[y[, 1], 2]

# Step 4: Appropriately label the data set with descriptive variable names

# Give the subject variable a descriptive name
names(subjects) <- c("subject")
# Give the activity variable a descriptive name
names(y) <- c("activity")
# Make the feature names a bit more readable
features$name <- gsub("^t([A-Z])", "time\\1", features$name)
features$name <- gsub("^f([A-Z])", "frequency\\1", features$name)
features$name <- gsub("Acc", "Acceleration", features$name)
features$name <- gsub("Mag", "Magnitude", features$name)
features$name <- gsub("mean\\(\\)", "Mean", features$name)
features$name <- gsub("std\\(\\)", "StandardDeviation", features$name)
features$name <- gsub("-", "", features$name)
# Give each feature a descriptive name
names(X) <- features$name
# Combine the subjects, features, and activities into a single dataset.
dataSet <- cbind(subjects, X, y)

# Step 5: From the data set in step 4, create a second, independent tidy data
# set with the average of each variable for each activity and each subject.

# Compute the average of each feature for each subject and activity.
averagesBySubjectAndActivity <- aggregate(
  dataSet[, names(dataSet) != c("subject", "activity")],
  by = list(subject = dataSet$subject, activity = dataSet$activity),
  FUN = mean)
# Write the resulting dataset to a file.
write.table(
  averagesBySubjectAndActivity,
  file = "tidyData.txt",
  row.names = FALSE)