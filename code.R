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
r <- httr::GET(csv_api_end_point)

#lets see what we received as a response, we want to make sure we got a 200 as a status
#code indicating a successfull response. 200 is an HTTP (recall the "http" in front of a 
#URL in the browser's address bar..like http://www.google.com) the 200 comes from the HTTP
#standard and indicates everything went well and we should have got a good response
print(r)
if(httr::status_code(r) == 200) {
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
  par(mar=c(5, 15, 5, 5))
  barplot(table(df$city_in_md), horiz = T, las=2)
  
  
  #ok that was nice, what can we do to make it even better
  barplot(sort(table(df$city_in_md)), horiz = T, las=2,
          main="Enrollment count by city",
          xlab = "count")
  
  #almost perfect, what is missing??
  
  #also it is nice to store the downloaded csv content
  #in a file so that we can also see it in  excel
  #make sure you use the "setwd()" function on the R console
  #before you run this line to set the working directory to the
  #current directory to see the enrollments.csv in the same directory
  #as this code
  write.csv(df, "enrollments.csv")
  
  #lets read it back
  df = read.csv("enrollments.csv")
  
  par(mar=c(5, 15, 5, 5))
  barplot(sort(table(df$mc_program_description)), horiz=T, las=2)
  
  par(mar=c(5, 15, 5, 5))
  barplot(sort(table(df$race)), horiz=T, las=2)

  df2 = df %>%
    select(race, mc_program_description) %>%
    group_by(race, mc_program_description) %>%
    summarise(count = n()) %>%
    arrange(desc(count))
  write.csv(df2, "enrollments_by_race.csv")
    
  
} else {
  print("some error happened, we got the following error")
  print(status_code(r))
}

#Excercise, create a barplot with some other field in the dataset?

#class 4
library(dplyr)
#double group_by, we want to find out the frequency count of courses by gender..
#answer questions like : "which are themost popular courses amongst males or females"
#"are males more likely to choose a particular course over females?"
df_course_by_gender = df %>%
  group_by(gender, mc_program_description) %>%
  summarise(count = n()) %>% arrange(desc(count))
df_course_by_gender

#a much simpler example to illustrate dplyr..
#we want to use dplyr to do what we did with the table function earlier
df_enrollments_by_city= df %>%
  group_by(city_in_md) %>%
  summarise(count = n()) %>% arrange(desc(count))
df_enrollments_by_city

#how about using dplyr and ggplot2 together..dplyr to do the data wrangling
#ggplot2 to plot the results. Notice that we dont have to do the margin adjustment
#or tell the graphics package to to orient the axis labels (remember las=2 we used earlier)
library(ggplot2)
p <- df_course_by_gender %>%
  ggplot(aes(x=mc_program_description, y=count)) +
  geom_bar(stat="identity") + coord_flip() + 
  facet_wrap(~gender)
p

