library("dummies")
library("dplyr")
library("Hmisc")
library(ggcorrplot)
library(caret)
library("car")
library(ggplot2)
library("mgcv")
library("readxl")

dfA <- read.csv("SinnFien1.csv")

dfB <- read.csv("SinnFien2.csv")

#avg impressions and amount spent in version data
dfB$Impressions_2[is.na(dfB$Impressions_2) == TRUE] = 0
dfB["AvgImpressions"] = (dfB$Impressions_1 + dfB$Impressions_2 ) / 2
dfB["AvgAmount"] = (dfB$AmountSpent_1 + (ifelse(dfB$AmountSpent_2 == 0,dfB$AmountSpent_1,dfB$AmountSpent_2))) / 2

#Aggregating Impressions and Amount spent
install.packages("sqldf")
library(sqldf)

new <- as.data.table(dfB)[, sum(AvgImpressions), by = .(Ad.Number)]
new1 <- as.data.table(dfB)[, sum(AvgAmount), by = .(number)]

new <- as.data.frame(new)

colnames(new)[1] <- "number"

ad <- sqldf("select dfA.X, dfA.AvgImpressions +new.V1 as AggregatedImpressions  from dfA join new on dfA.X = new.number")

colnames(dfB)[3] <- "number"
colnames(ad)[1] <- "number"
b <- sqldf("SELECT dfB.number, dfB.Description, COUNT(*) occurrences FROM dfB GROUP BY dfB.number, dfB.Description")

res <- merge(ad, b, by.x="number", by.y="number")
resfinal <- merge(res,new1, by.x="number", by.y="number")
write.csv(x=resfinal, file="AggImp_SF.csv")

