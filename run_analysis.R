library(dplyr)

setwd("UCI HAR Dataset")

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/Y_train.txt")
sub_train <- read.table("./train/subject_train.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/Y_test.txt")
sub_test <- read.table("./test/subject_test.txt")

features <- read.table("./features.txt")

activity_labels <- read.table("./activity_labels.txt")

x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)

sub_total <- rbind(sub_train, sub_test)

sel_features <- features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total <- x_total[,sel_features[,1]]

colnames(x_total) <- sel_features[,2]
colnames(y_total) <- "activity"
colnames(sub_total) <- "subject"

total <- cbind(sub_total, y_total, x_total)

total$activity <- factor(total$activity, levels = activity_labels[,1], labels = activity_labels[,2])
total$subject <- as.factor(total$subject)

total_mean <- total %>% group_by(activity, subject) %>% summarize_all(funs(mean))

write.table(total_mean, file = ".tidydata.txt", row.names = FALSE, col.names = TRUE)