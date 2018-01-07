<style>
/* Your other css */
    body {
      background-image: url(https://raw.githubusercontent.com/aarora79/DS_For_HighSchoolers/master/images/background7.png);
      background-position: center center;
      background-attachment: fixed;
      background-repeat: no-repeat;
      background-size: 100% 100%;
      text-color: blue;
    }
.section .reveal .state-background {
    background-image: url(http://goo.gl/yJFbG4);
    background-position: center center;
    background-attachment: fixed;
    background-repeat: no-repeat;
    background-size: 100% 100%;
}
</style>

Lecture 6: Finding relationships between features, Linear Models
========================================================
author: Amit Arora
date: 2018-01-07
autosize: true

Some Math Review
========================================================

Equation of a straight line: <b>y = mx + b</b>
What does this mean? In real world terms, not in terms of x and y.
 - It means that we can determine y if we know x, it means that a real world thing represented by the variable y can be determined using this equation if we know the real world thing x. 
 
 - In this equation b represents the value of y if x is 0 and m represents the change in the value of y for a unit change (a change of 1) in x.
 
 How this related to data science? Well one of the objectives we have in data science is to say given what we know how can we determine (as accurately as possible) what we dont know. It is like saying we know the value of x and we dont know y but using this equation y = mx + b we can determine y.
 
Putting this more in data science context with an example
========================================================
 
Lets take a dataset called "mpg" that comes built in with the ggplot library. This dataset tells about fuel economy of cars.

We want to determine a relationship between the city mileage (the feature cty in the dataset) of a car and some other variable (lets only consider one variable for simplicity).

Why do we want to do this? Well, because lets say if we find a way to determine the mileage based on some other easily known factors then we can determine the estimate of the mileage of a new car without having to actually drive it around the city (ofcourse this is a simplified example meant only for helping to understand the concepts).

So we now have a two fold problem, firstly, what is that feature in the dataset which will help us determine the city mileage and secondly once we know this feature and want to create a linear equation with this feature as the 'x' variable what are the values of 'm' and 'b' in the equation.

cty Vs displ in the mpg dataset
========================================================

The first problem is what is known as "feature selection" i.e. what features to choose to determine the "response" variable of interest. The response variable is also known as the dependant variable and the features used to determine the dependant variable are also known as independant variables.

We use the GGally::ggpairs function to see which features appear to statistically correlated (see code and the scatter matrix plot). We see that displ and cty have a correlation of almost -0.80. This is a high negative correlation, in simple terms it means that cty and displ are related i.e. we can say something about one variable if we know the other and the negative means that when one of these variables goes up the other one goes down.

cty Vs displ plot
========================================================

We can plot these two varialbes using a scatter plot, we see that plot does look negatively correlated because as the displacement inreases the city mileage decreases. While the plot does not look linear completely (especially at the very low and very high values of displacement but lets try to model it and see how accurate can we get).

```r
library(dplyr)
library(ggplot2)
mpg %>%
  ggplot(aes(x=displ, y=cty)) +
  geom_point()
```

![plot of chunk unnamed-chunk-1](Lecture6-figure/unnamed-chunk-1-1.png)

Linear model for cty Vs displ
========================================================
We use the "lm" function provided by the stats library to create the linear model. The values of 'm' and 'b' in our linear equation are called 'coefficients' of the linear model. 

```r
lm_fit = lm(cty ~ displ, mpg)
coeff = coefficients(lm_fit)
coeff
```

```
(Intercept)       displ 
  25.991467   -2.630482 
```
We know the coefficients so we can now write down the linear model

```r
cat(sprintf("the linear model is cty = %.2f + (%.2f)*displ", coeff[1], coeff[2]))
```

```
the linear model is cty = 25.99 + (-2.63)*displ
```

Linear model for cty Vs displ - how accurate is it?
========================================================
In the previous slide we saw the equation of the straight line which can determine the value of cty given displ. This is very neat, but how accurate is our estimate? We determine this finding out what this values for cty does our freshly determined linear equation give us for displ values we already know about from the mpg dataset. 

Once we know the values for the what the linear model/equation says for already known data we can determine how far is this value from the *actual* value that we already have. We do this by simply subtracting what is known as the **fitted** value from the actual value. 

The difference between the fitted value and the actual value is called a *residual* or just error, simply put. The residualscan be positive or negative i.e. sometimes the linear model could determine values that are greater than actual values and sometimes smaller than the actual values. To be able to speak in terms of absolute values without worrying about the positive or negative sign we square the error.

It follows that there would be a residual/error value for each row/observation in the datset, so we then average out the squared errors and then take the square root of the mean squared error, This final quantity that we just derived is called a "root mean squared error". 

Lets see what is this value for our model.

Linear model for cty Vs displ - how accurate is it?
=======================================================

We can calculate the RMSE as follows.

```r
#root mean square error
rmse = sqrt(mean((lm_fit$fitted.values  - mpg$cty)^2))
cat(sprintf("the model has a root mean squared error of %.2f", rmse))
```

```
the model has a root mean squared error of 2.56
```

We can now express our result by saying that the equation cty = 25.99 + (-2.63)displ can determine the city mileage given displacement with an average error of 2.56 miles/gallon i.e. the mileage values we determine could be on an average within actual value - 2.56 and actual value  + 2.56.Note that it is possible that in some cases the error is higher than 2.56 but *on an average*  this is the error.

Things that we glossed over
=======================================================

In order to introduce the concept of a linear model as a practical use of a linear equation we glossed over a lot of things.

- There are statistical measures to determine if the independant variable we choose is significant or not i.e. can it be even used or not.

- The residuals should form  normal distribution.

- WE should have done a test/train split instead of using the entire dataset for creating the linear model we should have choosen sey 80% of the observations and kept the remaining 20% for testing to see if our model does well (low RMSE) on unseen i.e. new data.

- There are more.
