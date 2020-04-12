# Download and get the Data
library(data.table)
library(tidyverse)

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

#load labels
act_lab<-data.table::fread(file.path(path,"UCI HAR Dataset/activity_labels.txt"),col.names = c("classlabels", "activityname"),with=F)

#indentify which rows are measures 
fea<-data.table::fread(file.path(path,"UCI HAR Dataset/features.txt"),col.names =c ("row","feature_name"),with=F)
ncol<-grep("([Mm][Ee][Aa][Nn]|[Ss][Tt][Dd])\\(\\)",fea$feature_name)


#select mean or sd coloumns in  train
train<-data.table::fread(file.path(path,"UCI HAR Dataset\\train\\X_train.txt"),select=ncol,col.names=fea$feature_name[ncol],with=F)
train_sub<-data.table::fread(file.path(path,"UCI HAR Dataset\\train\\subject_train.txt"),col.names = "subject",with=F)
train_act<-data.table::fread(file.path(path,"UCI HAR Dataset\\train\\y_train.txt"),col.names = "activity",with=F)
train<-cbind(train_sub,train_act,train)
# rename the col with out ()
names(train)<-gsub("\\(\\)","",names(train))

#select mean or sd coloumns in  train
test<-data.table::fread(file.path(path,"UCI HAR Dataset\\test\\X_test.txt"),select=ncol,col.names=fea$feature_name[ncol],with=F)
test_sub<-data.table::fread(file.path(path,"UCI HAR Dataset\\test\\subject_test.txt"),col.names = "subject",with=F)
test_act<-data.table::fread(file.path(path,"UCI HAR Dataset\\test\\y_test.txt"),col.names = "activity",with=F)
test<-cbind(test_sub,test_act,test)
# rename the col with out ()
names(test)<-gsub("\\(\\)","",names(test))

#merge test and train then rename the activity variable
df<-rbind(train,test)
df$activity<-factor(df[,activity],
                    levels = act_lab$classlabels,
                    labels=act_lab$activityname)
df$subject<-factor(df[,subject])

# creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
df<-reshape2::melt(df, id.vars = c("subject","activity"))
df<-reshape2::dcast(df,subject+activity~variable,mean)
write.table(df, "cousrera3_project_tidydata.txt" ,row.name=FALSE)
