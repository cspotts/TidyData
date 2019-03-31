## Getting and Cleaning Data: Week 4 Assignment

The packages "dplyr" and "data.table" were used for this analysis.

The following files were read into R using the read.table() function:
- activity_labels (6 activities)
- features (561 features)
- subject_test (subject ids from 1-30 for the test set)
- x_test (test set)
- y_test (test labels)
- subject_train (subject ids from 1-30 for the train set)
- x_train (train set)
- y_train (train labels)

Combining data:
The columns names of files were renamed to reflect the information they contained when the data
was first read in.
The mean, mean(), std and std() were selected from the features file.  Only these
columns containing mean/std were kept from the train and test set. All of the components
of the train and test set were combined, including the subject ids, activity labels for both 
the test and train set.  These two datasets sets were combined into one large dataset containing
all the test data first then train data.  This meant all the subject ids were in the first column,
activities in the second column, and all of the features in column three onwards.

Renaming columns:
The activity column was renamed using the activity_labels file according to id, matching that up 
to the correct activity (walking, sitting etc). The columns containing the features were then renamed
using the features file.  The features columns were reformatted to remove any characters (e.g. "()", "-")
and so they were more descriptive (e.g. "time" instead of "t").

Final tidied dataset:
The dataset was then grouped by subject id, then activities.  Finally, for each subject-activity
pair the mean was calculated.  The final dataset contained 180 observations (rows) and 81 variables 
(subject, activity, and 79 measured variables)