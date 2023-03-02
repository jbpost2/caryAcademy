# caryAcademy

This repo contains the presentations, applications, and other files associated with lectures given to the Cary Academy 'statculus' class in 2021 and 2023.

## 2021 Offering

For the 2021 offering, the focus was on predictive modeling and understanding what makes a good prediction. 

### Day 1 

We discuss what it means to do a good job predicting through a loss function. We use a [card simulation app](https://shiny.stat.ncsu.edu/jbpost2/CardSim/) to visualize the idea. Then we show that the sample mean is the optimal predictor (that uses the response values only) in terms of minimizing squared error loss. We then relate this to theoretical distributions by minimizing the expected loss function.

### Day 2

On the second day we tried to bring in the idea of having a predictor variable and minimizing our loss function when the prediction is some $f(x)$. The idea of using a linear approximation is discussed.

### Day 3

We went through and saw how to do a basic EDA and fitting of a simple linear regression model. We use it to predict for a new value of $x$ and look at basic model assumption checks.

### Day 4

We extend the SLR model to an MLR model! This leads to a discussion of prediction on new values we haven't used in the fitting of the model. Training and test sets are used to get an idea of model performance.

### Day 5

(Note this is labeled as day 4 in the notes, we fell behind as you can imagine!)  To give them an idea about other models they could use for $f(x)$ we introduced the idea of k nearest neighbors. The [app here was used to visualize the basic idea](https://shiny.stat.ncsu.edu/jbpost/kNNCA/).  The selection of $k$ based on cross-validation was discussed.

### Day 6

We spent time practicing what was learned on a kaggle competition! Students eventually created video presentations explaining their models and submitted their predictions to the competition!

## 2023 Offering

For the 2023 offering, the focus was on creating some models for the students to use in an actuarial data challenge. They needed to try and come up with a recommendation based on their analysis. This required a bit more emphasis on the inference part of modeling rather than the prediction side of things.

### Day 1

Starting with a big picture discussion of what makes something a statistical model, we considered what kinds of data we might have and what we would try and 'model'. We then went through the basic process of conducting an EDA together.

### Day 2

We introduced the simple linear regression model and discussed how the model is fit to data. This was followed by a discussion of what indicates a significant relationship and what assumptions should be checked. We wrapped up by fitting models in R.

### Day 3
As many of the groups had response variables that were of the yes/no variety, we introduce the logistic regression model (with one predictor). We related the model to linear regression and also determined the hypotheses of interest. We then fit some logistic regression models in R.

### Day 4

In order to extend improve their models, we discussed multiple linear regression models including polynomial terms and interaction terms. We fit these models in R.

### Day 5

Similar to day 4, we discussed the implications of fitting a logistic regression model with multiple predictors and fit those models in R.

### Day 6

The last day was a working day where the students tried to clean their data and fit some models in order to get ready for their actuarial challenge submission!

