# File in downloaded zip UCI HAR Dataset
## activity_labels.txt
It tells us what does y_test/train mean, and we need to convert numbers in y_test.train into corresponding activities.
## features.txt
It shows what each columns in X_test/train mean. To be honest, I got confused with this file. Because X_test/train have no column names! I figured
it out how these two file connect when I ran nrow in features.txt, and ncol in X_test?train mean.
It also tells us which variables to keep, because we just need mean and sd in this dataset. I used grep to find the indexs to keep. And I just keep
this columns in X_test/train.
## train/test:/ X_test/train
It gives us the test/train data.
## train/test:/ y_test/train
It tells us which activty each row in X_test/train matches. It ranges from 1 to 6. 
## train/test:/ subject_test/train
It tells us which subject each row in X_test/train matches. It ranges from 1 to 30. 

# Steps to get tidydata
## Figure out which columns in X_test/train to keep
1.We need to select rows in activity_labels.txt that documented mean/sd.   
2.Then, according to the indexs we get, we can select columns in X_test/train and name the columns.    
3.Merge the subject, activity and X_test/train together. Therefore, we know who do which acitivty in each row.  
4.Merge test and train dataset.    
5.reshape the data to get the average of each variable for each activity and each subject.  
