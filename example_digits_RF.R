#random forest benchmark

library(randomForest)
library(readr)

set.seed(0)

numTrain<-10000
numTrees<-25

train<-read_csv("digits/train_digits.csv")
test<-read_csv("digits/test_digits.csv")

rows<-sample(1:nrow(train), numTrain)
labels<-as.factor(train[rows,1])
train<-train[rows,-1]

rf<-randomForest(train, labels, xtest=test, ntree=numTrees)
predictions<-data.frame(ImageID=1:nrow(test), Label=levels(labels)[rf$test$predicted])

head(predictions)

print(rf$confusion)

write_csv(predictions, "rf_benchmark.csv")
