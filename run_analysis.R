# read feature names from features.txt
featureNamesTable <- read.table("features.txt")

# convert feature names from factor to characters
featureNames <- as.character(featureNamesTable[,2])


# read training set (subject, X, Y)
dataTrainSubject <- read.table("./train/subject_train.txt")
dataTrainX <- read.table("./train/X_train.txt")
dataTrainY <- read.table("./train/Y_train.txt")


# read test set (subject, X, Y)
dataTestSubject <- read.table("./test/subject_test.txt")
dataTestX <- read.table("./test/X_test.txt")
dataTestY <- read.table("./test/Y_test.txt")


# bind training set
trainFull <- cbind(dataTrainSubject,dataTrainX,dataTrainY)

# bind test set
testFull <- cbind(dataTestSubject,dataTestX,dataTestY)

# bind training and test set
data <- rbind(trainFull,testFull)


# give sensible name to columns
names(data) <- c("Subject",featureNames,"Activity")

# select columns including mean() or std() and add Subject and Activity
featureNames2 <- c("Subject","Activity",featureNames[grepl("mean()",featureNames)|grepl("std()",featureNames)])

# keep selected columns
data <- data[,featureNames2]


# rename 
# "Acc" -> "Acceleration"
names(data) <- gsub("Acc","Acceleration",names(data))
# "Mag" -> "Magnitude"
names(data) <- gsub("Mag","Magnitude",names(data))
# "Gyro" -> "Gyroscope"
names(data) <- gsub("Gyro","Gyroscope",names(data))
# "^t" -> "Time"
names(data) <- gsub("^t","Time",names(data))
# "^f" -> "Frequency"
names(data) <- gsub("^f","Frequency",names(data))
# "-mean()" -> "Mean"
names(data) <- gsub("-mean()","Mean",names(data))
# "-std()" -> "SD"
names(data) <- gsub("-std()","SD",names(data))

names(data)

# factorize Activity outcome
data$Activity <- factor(data$Activity)

# read Activity labels from activity_labels.txt
activityNames <- read.table(file="activity_labels.txt")

# assign factor levels to variable
levels(data$Activity) <- activityNames[,2]


# load the reshape2 package that is used to create tidy data
library(reshape2)


# melt dataset using Subject and Activity as IDs
meltedData <- melt(data, id.vars = c("Subject", "Activity"))

# generate tidy data
tidyData <- dcast(meltedData, Subject + Activity ~ variable, fun.aggregate = mean, na.rm = TRUE)


# export tidy data
write.table(tidyData,file="tidyData.txt",row.name=FALSE)
