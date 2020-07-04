#loading required libraries
library("dummies")
library("dplyr")
library("Hmisc")
library(ggcorrplot)
library(caret)
library("car")
library(ggplot2)
library("mgcv")
library("readxl")

Data <- read_excel("FacebookAdsprep.xlsx",sheet = 2)

Data["ID"] <-substr(Data$ID,1,nchar(Data$ID)-2)

Data["Description"] <-substr(Data$Description,1,nchar(Data$Description)-2)
Data["Period"] <-substr(Data$Period,1,nchar(Data$Period)-2)
Data["AmountSpent"] <-substr(Data$AmountSpent,1,nchar(Data$AmountSpent)-2)
Data["Impressions"] <-substr(Data$Impressions,1,nchar(Data$Impressions)-2)
Data["Disclaimer"] <-substr(Data$Disclaimer,1,nchar(Data$Disclaimer)-2)
Data["Party"] <-substr(Data$Party,1,nchar(Data$Party)-2)

Data["ID"] <-substring(Data$ID,3)
Data["Description"] <-substring(Data$Description,3)
Data["Period"] <-substring(Data$Period,3)
Data["AmountSpent"] <-substring(Data$AmountSpent,3)
Data["Impressions"] <-substring(Data$Impressions,3)
Data["Disclaimer"] <-substring(Data$Disclaimer,3)
Data["Party"] <-substring(Data$Party,3)

Data["ID"] <-substring(Data$ID,4)
Data["AmountSpent"] <-substring(Data$AmountSpent,19)
Data["AmountSpent"] <-substring(Data$AmountSpent,2)
Data["Impressions"] <-substring(Data$Impressions,12)
Data["Impressions"] <-substring(Data$Impressions,2)


library(stringr)
#period
df <- within(Data, Date<-data.frame(do.call('rbind', strsplit(as.character(Data$Period), '-', fixed=TRUE))))

df$Date$X1 <- as.Date(df$Date$X1, format = "%d %B %Y")
df$Date$X2 <- as.Date(df$Date$X2, format = "%d %B %Y")

#impressions
df$Impressions = str_replace_all(df$Impressions,"ach: ","")
df <- within(df, Impre<-data.frame(do.call('rbind', strsplit(as.character(df$Impressions), '-', fixed=TRUE))))

library(stringr)
df$Impre$X2 = str_replace_all(df$Impre$X2," people","")
df$Impre$X2 = str_replace_all(df$Impre$X2,"K","000")
df$Impre$X2 = str_replace_all(df$Impre$X2,"M","000000")
df$Impre$X2 = str_replace_all(df$Impre$X2,">","")
df$Impre$X2 = str_replace_all(df$Impre$X2,"<","")

df$Impre$X1 = str_replace_all(df$Impre$X1,"K","000")
df$Impre$X1 = str_replace_all(df$Impre$X1,"M","000000")
df$Impre$X1 = str_replace_all(df$Impre$X1,">","")
df$Impre$X1 = str_replace_all(df$Impre$X1,"<","")

#amountspent
df <- within(df, Amount<-data.frame(do.call('rbind', strsplit(as.character(df$AmountSpent), '-', fixed=TRUE))))

df$Amount$X2 = str_replace_all(df$Amount$X2,"???","")
df$Amount$X2 = str_replace_all(df$Amount$X2,"1.5K","1500")
df$Amount$X2 = str_replace_all(df$Amount$X2,"2.5K","2500")
df$Amount$X2 = str_replace_all(df$Amount$X2,"4.5K","4500")
df$Amount$X2 = str_replace_all(df$Amount$X2,"K","000")
df$Amount$X2 = str_replace_all(df$Amount$X2,">","")
df$Amount$X2 = str_replace_all(df$Amount$X2,"<","")

df$Amount$X1 = str_replace_all(df$Amount$X1,"???","")
df$Amount$X1 = str_replace_all(df$Amount$X1,"1.5K","1500")
df$Amount$X1 = str_replace_all(df$Amount$X1,"2.5K","2500")
df$Amount$X1 = str_replace_all(df$Amount$X1,"4.5K","4500")
df$Amount$X1 = str_replace_all(df$Amount$X1,"K","000")
df$Amount$X1 = str_replace_all(df$Amount$X1,">","")
df$Amount$X1 = str_replace_all(df$Amount$X1,"<","")

#calculating average amount
df$Amount$X1 <- as.numeric(df$Amount$X1)
df$Amount$X2 <- as.numeric(df$Amount$X2)

df["AvgAmount"] = (df$Amount$X1 + df$Amount$X2 ) / 2

#calculating average impressions
df$Impre$X1 <- as.numeric(df$Impre$X1)
df$Impre$X2 <- as.numeric(df$Impre$X2)

df["AvgImpressions"] = (df$Impre$X1 + df$Impre$X2 ) / 2

write.csv(x=df, file="FiannaFail_Final.csv")

