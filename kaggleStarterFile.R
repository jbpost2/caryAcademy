#Script to analyze housing data for kaggle competition

#### Load packages
library(tidyverse)
library(caret)

#### Data (.csv files) can be downloaded from the web using read_csv() 
# train data: https://www4.stat.ncsu.edu/~online/datasets/HousingTrain.csv
# test data: https://www4.stat.ncsu.edu/~online/datasets/HousingTest.csv
#### Remember we don't want to touch the test data until we are ready to predict on it


#### Exploratory Data Analysis on the training data



#### Fitting of Model



#### Prediction on the test set
# The code below assumes your model is stored in an object called fit and the test data is in an object called test
preds <- predict(fit, newdata = test)
# Output your file to submit to kaggle
# You may want to change your working directory!
write_csv(data.frame(Id = test$Id, SalePrice = preds), file = "submission.csv")

#### Submitting
# Head to https://www.kaggle.com/c/house-prices-advanced-regression-techniques/submit
# Drag and drop submission.csv
# Give a brief description of your model
# Hit Make Submission!
# It will score and at the top you'll see a link to see your spot on the leaderboard!













