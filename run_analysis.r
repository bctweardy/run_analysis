library(plyr)
 
## Merge the training and test data sets to create a master data set

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
 
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

## Merge x data sets
x <- rbind(x_train, x_test)
## Merge y data sets
y <- rbind(y_train, y_test)
## Merge subject data sets
subject <- rbind(subject_train, subject_test)

## Extracting only the measurements on the mean and standard deviation for each 
## measurement
features <- read.table("features.txt")

## Get only columns with mean() or std() in their names
mean_sd_features <- grep("-(mean|std)\\(\\)", features[, 2])

## Subset the desired columns with features file
x <- x[, mean_sd_features]

## Correcting the column names with features file
names(x) <- features[mean_sd_features, 2]

## Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
y[, 1] <- activities[y[, 1], 2]

## Correcting column name
names(y) <- "activity"

# Appropriately label the data set with descriptive variable names
# correcting column name
names(subject) <- "subject"
 
## Creating a master data set by bingding all the data in a single data set
data <- cbind(x, y, subject)

## Create a second, independent tidy data set with the average of each variable
## for each activity and each subject

averages_data <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]))
 
write.table(averages_data, "averages_data.txt", row.name=FALSE)