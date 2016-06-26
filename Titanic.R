install.packages("caret", dependencies=TRUE)
install.packages("randomForest")
install.packages("fields")
library(dplyr)
library(caret)
library(randomForest)
trainSet<-read.table("train.csv", sep=",", header=TRUE)
testSet<-read.table("test.csv", sep=",", header=TRUE)
head(testSet)
#crosstabs categories
table(trainSet[c("Survived","Pclass")])
table(trainSet[c("Survived","Sex")])
library(fields)
#plot continuous variables (such as age)
bplot.xy(trainSet$Survived, trainSet$Age)
summary(trainSet$Age)
#lots of NAs, mean for survived vs dead not very diff, not very useful
bplot.xy(trainSet$Survived, trainSet$Fare)
summary(trainSet$Fare)
#convert survived to factor
trainSet$Survived<-factor(trainSet$Survived)
#set a random seed
set.seed(42)
#train the model with random forest algorith
model<-train(Survived~Pclass+Sex+SibSp+Embarked+Parch+Fare, data=trainSet, 
             method="rf", trControl=trainControl(method="cv", number=5))
#rf=random forest algorithm, cv=cross validation, 5=use 5 folds for cross validation
summary(testSet)
testSet$Fare<-ifelse(is.na(testSet$Fare),mean(testSet$Fare, na.rm=TRUE),testSet$Fare)
testSet$Survived<-predict(model, newdata=testSet)
submission<-testSet[,c("PassengerId","Survived")]
write.table(submission, file="submission.csv", col.names=TRUE, row.names=FALSE, sep=",")


