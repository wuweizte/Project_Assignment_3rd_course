##Function Definition Part

## 1.Merges the training and the test sets to create one data set
Merge_Traning_and_Test_Set <- function(){

        ## Inputting Training set
        Training_Set <- fread("./UCI HAR Dataset/train/X_train.txt")
        Training_Activity <- fread("./UCI HAR Dataset/train/y_train.txt")
        Training_subject <- fread("./UCI HAR Dataset/train/subject_train.txt")
        
        Training_Set_df <- tbl_df(Training_Set)
        
        ## Append activity and subject columns to the training set
        Training_Set_df <- mutate(Training_Set_df, 
                                        activity = Training_Activity[[1]],
                                        subject = Training_subject[[1]])
        
        
        ## Inputting Test set
        Test_Set <- fread("./UCI HAR Dataset/test/X_test.txt")
        Test_Activity <- fread("./UCI HAR Dataset/test/y_test.txt")
        Test_subject <- fread("./UCI HAR Dataset/test/subject_test.txt")
        
        Test_Set_df <- tbl_df(Test_Set)
        
        ## Append activity and subject columns to the test set
        Test_Set_df <- mutate(Test_Set_df, 
                                    activity = Test_Activity[[1]],
                                    subject = Test_subject[[1]])
        
        ## Merges the training set and the test set to create one whole data set
        Merge_Set_df <- bind_rows(Training_Set_df, Test_Set_df)
        return(Merge_Set_df)        
}

## 2.Extracts only the measurements on the mean and standard deviation 
##   for each measurement. 
Extract_Mean_and_Std_Col <- function(Merge_Set_df, Measure_Label){
        
        ResultList <- list()
        
        ##find the columns about mean and standard deviation
        mean_index <- grep("[Mm][Ee][Aa][Nn]",Measure_Label[[2]])
        std_index <- grep("[Ss][Tt][Dd]",Measure_Label[[2]])
        
        ## the 562, 563 columns are activity and subject columns
        Mean_and_std_Set <- Merge_Set_df %>% 
                select(mean_index, std_index, 562, 563)
        
        ResultList$Mean_and_std_Set <- Mean_and_std_Set
        ResultList$mean_index <- mean_index
        ResultList$std_index <- std_index
        
        return(ResultList)
}

## 3.Use descriptive activity names to name the activities in the data set
Add_Activity_Name <- function(Mean_and_Std_List){
        
        Mean_and_std_Set <- Mean_and_Std_List$Mean_and_std_Set
        
        ## Add the activity label column
        Mean_and_std_Set$ActivityLabel <- character(nrow(Mean_and_std_Set))
        
        Activity_Label <- fread("./UCI HAR Dataset/activity_labels.txt")
        
        ## Check activity label and fill the new added column
        for(i in 1:nrow(Activity_Label)){
        
                rowindex <- 
                        which(Mean_and_std_Set$activity == Activity_Label$V1[i])
                
                Mean_and_std_Set$ActivityLabel[rowindex] <- Activity_Label$V2[i]
        
        }
        
        ## The original activity column is removed since the activity label
        ##  column is added
        
        Mean_and_Std_List$Mean_and_std_Set <- Mean_and_std_Set %>% 
                                                            select(-activity) 
        
        return(Mean_and_Std_List)
}

## 4.Appropriately labels the data set with descriptive variable names. 
Add_Variable_Label_and_return_dataset <- function(Mean_and_Std_List, 
                                                  Measure_Label){
        
        mean_index <- Mean_and_Std_List$mean_index
        std_index <- Mean_and_Std_List$std_index
        Mean_and_std_Set <- Mean_and_Std_List$Mean_and_std_Set
        
        ## Check contents according to the index and change column names
        colnames(Mean_and_std_Set)[1:length(c(mean_index, std_index))] <- 
                c(Measure_Label[[2]][mean_index], Measure_Label[[2]][std_index])
        
        return(Mean_and_std_Set)
}

## 5.From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.
Group_By_ActivityLabel_subject <- function(dataset_created_in_step4){
        
        
        Activity_and_Subject <- group_by(dataset_created_in_step4, 
                                         ActivityLabel, subject)
        
        colname_Activity_and_Subject <- colnames(Activity_and_Subject)
        colnum_Activity_and_Subject <- length(Activity_and_Subject)
                
        dataset_created_in_step5 <- summarise_each(Activity_and_Subject, 
                                                   funs(mean))

        ## labels the data set with descriptive variable names
        
        ## ActivityLabel and subject columns of Activity_and_Subject data set
        ## are located in the last 2 positions, and those of dataset_created_in_step5
        ## are located in the first 2 positions.
        colnames(dataset_created_in_step5)[3:colnum_Activity_and_Subject] <-  
                        paste("mean of " ,
                                 colname_Activity_and_Subject[1:
                                             (colnum_Activity_and_Subject - 2)])
                
        return(dataset_created_in_step5)
        
}


##Execution Part

## Set current directory to your work directory containing this data set 
## manually first please

library(data.table)
library(dplyr)
library(tidyr)

## 1.Merges the training and the test sets to create one data set

Merge_Set_df <- Merge_Traning_and_Test_Set()

## 2.Extracts only the measurements on the mean and standard deviation 
##   for each measurement. 

Measure_Label <- fread("./UCI HAR Dataset/features.txt")
Mean_and_Std_List <- Extract_Mean_and_Std_Col(Merge_Set_df, Measure_Label)

## 3.Uses descriptive activity names to name the activities in the data set

Mean_and_Std_List <- Add_Activity_Name(Mean_and_Std_List)

## 4.Appropriately labels the data set with descriptive variable names. 

dataset_created_in_step4 <- 
        Add_Variable_Label_and_return_dataset(Mean_and_Std_List, Measure_Label)

## 5.From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.
dataset_created_in_step5 <- 
        Group_By_ActivityLabel_subject(dataset_created_in_step4)

write.table(dataset_created_in_step5, file = "dataset_created_in_step5.txt",
            row.names = FALSE)