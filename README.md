# Project_Assignment_3rd_course

1. run_analysis.R consists of 2 parts : Function Definition Part and Execution 
Part. 

2. Five functions are defined in Function Definition Part. They realized respective
step according to the requirement. These 5 functions are shown as follows:

2-1) Merge_Traning_and_Test_Set(): The 1st step--Merges the training and the 
test sets to create one data set.

a)Inputting Training set
b)Append activity and subject columns to the training set
c)Inputting Test set
d)Append activity and subject columns to the test set
e)Merges the training set and the test set to create one whole data set and return it 
as the function output.


2-2) Extract_Mean_and_Std_Col(): The 2nd step--Extracts only the measurements 
on the mean and standard deviation  for each measurement.

a) The output data set in step1 is one input parameter. The data set created by 
'features.txt' file is another input parameter.
b) Find the content of the 2nd parameter to collect the location information 
about mean and standard deviation labels.
c) Select the relative column in the data set of the 1st parameter. Activity and 
subject columns are also selected. These selected columns forms one new data set.
d)The new data set and the location information about mean and standard deviation 
labels forms one list and return this list as the function output.

2-3) Add_Activity_Name(): The 3rd step--Use descriptive activity names to name 
the activities in the data set.

a) The output list in the step2 is the only input parameter.
b) Create the activity label in the dataset of the input list.
c) Input the activity_labels.txt file to get the relation between activity codes
and activity names. Fill the activity label column according to the relation.
d) The list containing updated data is return as the function output.


2-4) Add_Variable_Label_and_return_dataset(): The 4th step--Appropriately labels 
the data set with descriptive variable names.

a) The output list in step3 is one input parameter.The data set created by 
'features.txt' file is another input parameter.
b) According to the location information about mean and standard deviation 
labels containing in the input list, the data set created by 
'features.txt' file is retrieved and labels the data set containing in the input 
list with descriptive variable names.
c) The dataset containing variable names is return as the function output.

2-5) Group_By_ActivityLabel_subject(): The 5th step--From the data set in step 4, 
creates a second, independent tidy data set with the average of each variable for 
each activity and each subject.

a) The output data set in step4 is the only input parameter.
b) Create the mean volumn for the 1st variable.
c) Calculate the mean column of the rest variables.
d) Appropriately labels the data set with descriptive variable names.

3. The above 5 functions are called subsequently in execution part to get the 
tidy data set.

4. run_analysis.R must be placed with 'UCI HAR Dataset' folder together under the 
working directory. 
