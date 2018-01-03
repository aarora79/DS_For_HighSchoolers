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
