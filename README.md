# gettingandcleaningdata_project

#  list of files
* run_analysis.R : see description below
* CodeBook.md : indicate all the variables and summaries calculated, along with units, and any other relevant information




## aim of the function
The aim of the function is to collect, edit and clean data sets from the accelerometers from the Samsung Galaxy S smartphone. 

## run_analysis.R 
1- The scripts automatically creates the "project" folder, download the data from the web and sets the working directory to be the folder containing all the data files. 
2- The script then merge the training and the test sets to create one data set.
3- It extracts only the measurements on the mean and standard deviation for each measurement.
4- It clean variable names by using descriptive activity names to name the activities in the data set and appropriately labels the data set with descriptive variable names.
5- Finally,it creates a  tidy data set with the average of each variable for each activity and each subject.

