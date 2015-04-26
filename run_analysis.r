library(plyr)
library(dplyr)
library(data.table)
library(reshape2)

## Load featrues and activity labels and extract mean and standard deviation 
## measurments.
features <- read.table("features.txt", sep = "")
activities <- read.table("activity_labels.txt")[,2]
extracted_features <- grepl("mean|std", features)

## Load, subset and extract train data
x_train <- read.table("train\\X_train.txt", sep = "")
y_train <- read.table("train\\Y_train.txt", sep = "")
subject_train <- read.table("train\\subject_train.txt", sep = "")

names(x_train) <- features
x_train <- x_train[, extracted_features]
names(subject_train) <- "subject"
y_train[,2] = activities[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")

## Load, subset and extract test data
x_test <- read.table("test\\X_test.txt", sep = "")
y_test <- read.table("test\\Y_test.txt", sep = "")
subject_test <- read.table("test\\subject_test.txt", sep = "")

names(x_test) <- features
x_test <- x_test[, extracted_features]
names(subject_test) <- "Subject"
y_test[,2] = activities[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")

## Merge to one data set
data_train <- cbind(cbind(x_train, subject_train), y_train)
data_test <- cbind(cbind(x_test, subject_test),  y_test)
data <- rbind(data_train, data_test)

data_mean_std <- merge(data_mean_std, activities, all= TRUE)
data_mean_std <- data_mean_std[,-1]

## Relabel columns
names(data_mean_std) <- gsub('\\(|\\)',"",names(data_mean_std), perl = TRUE)
## Make syntactically valid names
names(data_mean_std) <- make.names(names(data_mean_std))
## Make clearer names
names(data_mean_std) <- gsub('Acc',"Acceleration",names(data_mean_std))
names(data_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(data_mean_std))
names(data_mean_std) <- gsub('Gyro',"AngularSpeed",names(data_mean_std))
names(data_mean_std) <- gsub('Mag',"Magnitude",names(data_mean_std))
names(data_mean_std) <- gsub('^t',"TimeDomain.",names(data_mean_std))
names(data_mean_std) <- gsub('^f',"FrequencyDomain.",names(data_mean_std))
names(data_mean_std) <- gsub('\\.mean',".Mean",names(data_mean_std))
names(data_mean_std) <- gsub('\\.std',".StandardDeviation",names(data_mean_std))
names(data_mean_std) <- gsub('Freq\\.',"Frequency.",names(data_mean_std))
names(data_mean_std) <- gsub('Freq$',"Frequency",names(data_mean_std))

data_avg_by_act_sub = ddply(data_mean_std, c("Subject","Activity"), 
                              numcolwise(mean), drop = TRUE)
write.table(data_avg_by_act_sub, file = "data_avg_by_act_sub.txt")