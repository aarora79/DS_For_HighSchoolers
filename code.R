#class 1
library(dplyr)

hist(rnorm(1000), main="Hello Statistics")

#EXCERCISE: change the title, axis labels..

#Class 2

#the following lines check if the package httr is already installed..
#this is done by finding if "httr" is in the list of currently installed
#packages procided by the "installed.package()" function which returns a 
#list of all installed pacakges..
#installs it if not already installed
list.of.packages <- c("httr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

#load the library, so that the functions we need become available
library(httr)

#API endpoint for the montgomery county college enrollment dataset
csv_api_end_point = "https://data.montgomerycountymd.gov/resource/qaet-tgxg.csv"

#use the GET function provided by httr to get the data from the API end point
r <- GET(csv_api_end_point)

#lets see what we received as a response, we want to make sure we got a 200 as a status
#code indicating a successfull response. 200 is an HTTP (recall the "http" in front of a 
#URL in the browser's address bar..like http://www.google.com) the 200 comes from the HTTP
#standard and indicates everything went well and we should have got a good response
print(r)
if(status_code(r) == 200) {
  print("we got a 200 ok response, lets proceed...")
  
  #read the data we got into a text buffer
  text_content <- content(r, 'text')
  
  #convert the raw text we got into CSV
  csv_content <- textConnection(text_content)
  
  #read the CSV content into a dataframe
  df <- read.csv(csv_content)
  
  #how many rows in this dataframe?
  cat(sprintf("there are %d rows in this dataframe", nrow(df)))
  
  #can we take a quick look at what we got?
  print(head(df))
  
  #ok but these are just the first 5 rows, is there a way to get some more information
  #about the structure of the data itself
  library(dplyr)
  glimpse(df)
  
  #what simple questions can we ask of this data?
  #for example: which city sends how many students to montgomery colleges?
  table(df$city_in_md)
  
  #ok but this is hard to quickly make sense of..can we plot it?
  barplot(table(df$city_in_md))
  
  #maybe better to flip the axis for better readability?
  barplot(table(df$city_in_md), horiz = T)
  
  #ok, that did not work so good..can we make the text labels also horizontal?
  barplot(table(df$city_in_md), horiz = T, las=2)
  
  #better, but the margins need to be adjusted...
  par(mar=c(5, 10, 5, 5))
  barplot(table(df$city_in_md), horiz = T, las=2)
  
  
  #ok that was nice, what can we do to make it even better
  barplot(sort(table(df$city_in_md)), horiz = T, las=2)
  
  #almost perfect, what is missing??
} else {
  print("some error happened, we got the following error")
  print(status_code(r))
}

#Excercise, create a barplot with some other field in the dataset?

