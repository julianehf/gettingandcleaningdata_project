rm(list=ls())
setwd('UCI HAR Dataset')

#################################################################
# Q1
# Merges the training and the test sets to create one data set.
#################################################################

# TRAIN SETS-----------------------------
# get the names of the columns from "features.txt" file 
namesdata = read.table('features.txt')
dim(namesdata) # 562 x 2
namesdata$V2 = as.character(namesdata$V2)
namesdata = namesdata$V2

# list of activities
# get the list of activities for each observation point from "train/y_txt"
act_train = read.table('train/y_train.txt')
dim(act_train) # 7352  x  1
names(act_train)='activity'

# list of subjects IDs
# get the list of subjects IDs for each observation point from "train/subject_train.txt'
subject_train = read.table('train/subject_train.txt')
dim(subject_train) # 7352 x 1
names(subject_train)='subject'


# combine subjects IDs with activity list
act_train = cbind(subject_train,act_train)

# load raw data from 'train/x_train.txt'        
data_trainr = read.table('train/x_train.txt')
dim(data_trainr) # 7352 x 561
names(data_trainr) = namesdata # set column names from namesdata

# combine Subject ID, Activity & Data into a unique dataset called data_train
data_train = cbind(act_train,data_trainr)
data_train$sets = 'train'

# TEST SETS -----------------------------
# do the same steps for the TEST sets 
# list of activities
act_test = read.table('test/y_test.txt')
dim(act_test) # 2947  x  1
names(act_test)='activity'

# list of subjects IDs
subject_test = read.table('test/subject_test.txt')
dim(subject_test) # 2947 x 1
names(subject_test)='subject'

# combine subjects IDs with activity list
act_test = cbind(subject_test,act_test)

# data        
data_testr = read.table('test/X_test.txt')
dim(data_testr) # 2947 x 561
names(data_testr) = namesdata

# combine Subject ID, Activity & Data 
data_test = cbind(act_test,data_testr)
data_test$sets = 'test'

####combine TRAIN and TEST sessions
data = rbind(data_train,data_test)

#########################################################################################
# Q2
# Extracts only the measurements on the mean and standard deviation for each measurement
#########################################################################################

meancol = grep('mean[()]',names(data)) # get column numbers that correspond to mean()
stdcol = grep('std[()]',names(data)) # get column numbers that correspond to std()
data = data[,c(1,2,meancol,stdcol,ncol(data))] # keep first and second rows as it's subject and activity as well as last row (variable sets we defined)


########################################################################
# Q3
# Uses descriptive activity names to name the activities in the data set
########################################################################

# replace activities 1,2, ...,6 by names // identify from the file 'activity_labels.txt'
act = read.table('activity_labels.txt')
data$activity = as.integer(data$activity)
data$activity = act[data$activity,]$V2

####################################################################
# Q4
# Appropriately labels the data set with descriptive variable names
####################################################################

# do lower case , remove () after mean and std, etc.
names(data) = tolower(names(data))
names(data) = gsub('[()]','',names(data))
names(data) = gsub("acc",'accelerometer',names(data))
names(data) = gsub("^t","time",names(data))
names(data) = gsub("^f","FFT",names(data))
names(data) = gsub("gyro",'gyroscope',names(data))

###############################################################################################################################################
# Q5
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##############################################################################################################################################
library(plyr)
library(dplyr)

data_simplified = ddply(data, .(subject,activity), numcolwise(mean))
sets_ds = ddply(data, .(subject,activity), catcolwise(unique))$sets # to make sure that we still have the column SETS to know if subject is from TRAIN or TEST set
data_simplified=cbind(data_simplified,sets_ds)


write.table(data_simplified,"../../submission/data_simplified.txt",row.name=FALSE)
