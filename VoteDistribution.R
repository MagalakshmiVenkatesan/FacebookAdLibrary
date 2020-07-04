library("dummies")
library("dplyr")
library("Hmisc")
library(ggcorrplot)
library(caret)
library("car")
library(ggplot2)
library("mgcv")
library("readxl")
library(sqldf)

DF <- read_excel("FineGael_Final.xlsx")
vote <- read_excel("VotesIrish2020.xlsx")

DF$StartDate <- as.Date(DF$StartDate,format="%Y/%m/%d")

install.packages("birk")
library(birk)


class(vote$Date)
class(DF$Start.Date)

sample$Start.Date <- as.Date(sample$Start.Date)
dfdate <- lapply(DF$StartDate, which.closest, vec=vote$Date)


dfdate <- data.frame(dfdate)

write.csv(x=dfdate, file="temp2.csv")




