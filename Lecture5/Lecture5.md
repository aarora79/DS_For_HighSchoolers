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

Lecture 5: Data Science for High Schoolers 
========================================================
author: Amit Arora
date: 2018-01-06
autosize: true

Data Cleaning
========================================================

So far we talked about how to download data, and basic exploratory analysis. There is an important part that we have not yet covered! What if the data we were analysing had problems??

 - What sort of problems?
  + Missing data
  + Incorrect data
  + Outliers

Why do these problems occur?

How do we handle these issues?

Why do we have bad data?
========================================================
 
Missing data happens for example if data was being collected in the form of a survey and someone did not answer a question and so there is some missing data.

Invalid data. Human error. Someone entered some data incorrectly, like a typo. But it could also be machine error, lke a sensor measuring data incorrectly (maybe that is also a form of human error?). For example a sensor measuing rainfal as -2mm!

Outlier. A data value that is too far away (too high or too low) from the rest of the values. This is not necessarily invalid, but something that introduces a "skew" and messes up plots. For example while measuring network age of students in a classroom (say graduate students) there is a 39 year old while the rest of the class is in the 22 to 25 age group.

 
 
How do we handle Missing data?
========================================================

Missing data. Handled in one of several ways, depends upon what makes more sense in the context of the dataset. <b>No matter how we handle missing data we need to clearly note the techniques used to handle missing data while presenting our findings. Full transparency.</b>

- Ignore observations with missing data. For example if there is say a 10,000 observation dataset and 5 of the observations have some fields missing then ignoring these observations with missing data <b>may not</b> be a problem.

- Impute the missing data, for example in case of continous data use the mean value for missing data. Another option is if the distribution of the data is known then a value can be picked from the distribution. 

Lets take an example

```r
library(dplyr)
#create some synthetic data, 100 values from the standard normal distribution
df = data.frame(x = rnorm(100))
#create a missing value in the dataset
df$x[10] = NA

#fix it using dplyr by replacing NA with the mean
#of the rest of the values
df = df %>%
  mutate(x = ifelse(is.na(x), mean(x, na.rm = TRUE), x))

#check if the missing value (NA) has been replaced
df$x[10]
```

```
[1] -0.06081081
```

How do we handle Incorrect data?
========================================================

Incorrect data. Typically handled by removing observation from dataset. <b>No matter how we handle incorrect data we need to clearly note the techniques used to handle missing data while presenting our findings. Full transparency.</b>

Lets take an example

```r
library(dplyr)
#create some synthetic data, 100 values 
#age in a population dataset consisting of 100 people, 
#avg age 20 years, std deviation 3 years
df = data.frame(age = rnorm(100, 20, 3))

#create an incorrect value in the dataset,
#age of -2 !
df$age[10] = -2

#fix it using dplyr by removing negative values
df = df %>%
  filter(age > 0)

#check rowcount
cat(sprintf("row count after removing negative values for age is %d", nrow(df)))
```

```
row count after removing negative values for age is 99
```

How do we handle Outliers?
========================================================

Outliers are to be handled very very carefully. If you must then you could ignore the outliers by only analysing observations excluding the outliers. For example, values between the 5th and 95th percentile, thereby ignoring outliers that are either too high or too low.

Important to note that outliers could represent genuine anomalies in the data that need to be understood, and maybe even analysed separately. 
 - For example consider a credit card transaction dataset.
 - Say we look at distance between the geographical location of the transaction and the billing address of the card holder.
 - Lets say all transactions usually are within 100 miles of the billing address but there are some transactions which are a 1000 miles from the billing address.
 - These transactions represent outliers and in this context may represent possibly fraudulent transactions so they cannot be ignored just because they are outliers.
