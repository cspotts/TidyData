#install.packages("dplyr")
#install.packages("data.table")
library(dplyr)
library(data.table)

# set directory:
setwd("C:/Users/e16005195/Documents/Coursera/Getting and Cleaning Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
list.files()

# read in activity labels file:
activity_labels <- read.table("activity_labels.txt")
# rename columns 
names(activity_labels) <- c("activityid","activity")
# rename activity variables, lowercase, remove "_"
activity_labels$activity <- tolower(activity_labels$activity)
activity_labels$activity <- sub("_", "",activity_labels$activity)

# read in features file:
features <- read.table("features.txt")
names(features) <- c("featurenumber","feature")

# read in test files:
subject_test <- read.table("./test/subject_test.txt")
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
# rename subject and activity variables
names(subject_test) <- "subjectid"
names(y_test) <- "activityid"

# read in train files;
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
# rename subject and activity variables
names(subject_train) <- "subjectid"
names(y_train) <- "activityid"

# only want measurements for mean and sd
# include cols: mean, mean(), std, std()
mean_sd_cols <- grep("mean|std", features$feature)

# keep only these cols with mean and std
x_train <- x_train[,mean_sd_cols]
x_test <- x_test[,mean_sd_cols]

# combine components of test dataset
test <- cbind(subject_test, y_test, x_test)

# combine components of train dataset
train <- cbind(subject_train, y_train, x_train)

# combine all: test and train
test_train <- rbind(test, train)

# rename each activity using activity_labels
test_train <- test_train %>%
  full_join(activity_labels, by="activityid") %>%
  select(-activityid) %>%
  # reorder cols so subject and activity are at start
  select(subjectid, as.factor(activity), V1:V552)

# rename cols V1:V552 with feature names (column 3 onwards)
feature_names <- as.vector(features$feature[mean_sd_cols])
names(test_train)[3:81] <- tolower(feature_names)

# col names: change f to freq, t to time
# remove () and replace - with .
names(test_train)[3:81] <- sub("^t","time.", names(test_train)[3:81])
names(test_train)[3:81] <- sub("^f","freq.", names(test_train)[3:81])
names(test_train)[3:81] <- sub("\\(\\)","", names(test_train)[3:81])
names(test_train)[3:81] <- gsub("-",".", names(test_train)[3:81])

# tidy data: 
# group by subject, then activity
# get mean for each observation
test_train <- test_train %>%
  group_by(subjectid, activity) %>%
  summarise_all(list(mean))

write.table(test_train, "tiny_data.txt")