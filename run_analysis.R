# R script for the assignment from week 4 in "Getting and cleaning data" course

# Task 1: Merges the training and the test sets to create one data set
# the trainging and test data sets were merged into one set respectively. 

x.training <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
x.test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
x.merged <- rbind(x.training, x.test)

y.training <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
y.test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
y.merged <- rbind(y.training, y.test)

test.subject <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")
training.subject <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")
subject.merged <- rbind(training.subject, test.subject)


# Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./UCI_HAR_Dataset/features.txt")
selected_features <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
x.merged <- x.merged[, selected_features[,1]]


# Task 3: Uses descriptive activity names to name the activities in the data set
activity.labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
colnames(y.merged) <- "activity"

y.merged$activitylabel <- factor(y.merged$activity, labels = as.character(activity.labels[,2]))
activitylabel <- y.merged[,-1]

# Task 4: Appropriately labels the data set with descriptive variable names.
colnames(x.merged) <- features[selected_features[,1],2]

# Task 5: From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
library(dplyr)
colnames(subject.merged) <- "subject"
total <- cbind(x.merged, activitylabel, subject.merged)
total.mean <- total %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(total.mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
# End