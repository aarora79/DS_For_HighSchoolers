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
  par(mar=c(5, 10, 5, 5))
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

#class 3
#load the quantmod library, this library
#provides APIs for downloading stock market data
library('quantmod')

#ok that did not work, why?
#we use the "getSymbols" (symbols as in stock market symbols)
#for downloading data for a particular stock..We use Apple stock for
#this example
getSymbols("AAPL")

#the data gets "automatically" stored in a variable called "AAPL"
#which is the name of the symbol we downloaded, notice that there is
#no assignment statement where we say AAPL=<some expression or function>
#this part is done behind the scenese by the quantmod library when we call
#the getSymbols function

#ok, lets "subset" the data for a particular timeframe and store it in a vaiable
#we can call it "x", what would be a better name?
x = AAPL['2017-06-01::2017-12-26']

#remember "data.frame" from last class, we like to get (mostly) everything
#in a dataframe so that we can easily do operations on it..
df = as.data.frame(x)

#lets print out the data.frame, 5 rows
print(head(df))

#the dataframe does not have the name for the first column, we see dates
#in the first column, this type of usage is called "rownames" so each row
#can have a name..here the name is the date..lets store the rowname
#as a separate field, called "Date"
df$Date = row.names(df)

#lets write the dataframe to a file, in our favorite format..CSV
#we say row.names = F (for FALSE) because we have stored the Date 
#in a separate column so we dont need it as a rowname anymore
write.csv(df, "aapl.csv", row.names = F)

#now lets read it back, we can use the same variable name "df"
df = read.csv("aapl.csv")

#lets plot it..so "plot" is a generic function which is used here to 
#sraw what is called as a scatter plot
plot(x = df$Date, y = df$AAPL.Close)

#ok that did not look so good..why?
#because R cannot tell that the Date variable is a "Date", it thinks it
#is a "string". Several graphical libraries will do that for you automatically
#i.e. they will treat a string that looks like a date as a date automatically..
#ok lets help base R plot function by telling it that this is a date
plot(x = as.Date(df$Date), y = df$AAPL.Close, col="red")

#ok that looks much better..can we do even better...
#we sure can, iving an example of special timeseries library called
#dygraph, we dont want to spend too much time on this but this is an example
#f an interactive chart
library(dygraphs)
symbol = "AAPL"
getSymbols(symbol)

#extract the closing stock price using a quantmod function called "Cl"
close_prices_aapl = Cl(get(symbol))
dateWindow <- c("2007-01-01", "2017-12-31")

chart_title = paste0("Closing value of ", symbol, " stock")
dygraph(close_prices_aapl, main = chart_title) %>%
  dyRangeSelector(dateWindow = dateWindow)
