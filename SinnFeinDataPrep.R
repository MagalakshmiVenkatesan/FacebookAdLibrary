library("dummies")
library("dplyr")
library("Hmisc")
library(ggcorrplot)
library(caret)
library("car")
library(ggplot2)
library("mgcv")
library("readxl")

Data <- read_excel("FacebookAdsprep.xlsx",sheet = 3)

Vdata <- read_excel("VersionsAds.xlsx")

#Vdataprep

Vdata["ID"] <-substr(Vdata$ID,1,nchar(Vdata$ID)-2)

Vdata["Description"] <-substr(Vdata$Description,1,nchar(Vdata$Description)-2)
Vdata["Period"] <-substr(Vdata$Period,1,nchar(Vdata$Period)-2)
Vdata["AmountSpent"] <-substr(Vdata$AmountSpent,1,nchar(Vdata$AmountSpent)-2)
Vdata["Impressions"] <-substr(Vdata$Impressions,1,nchar(Vdata$Impressions)-2)
Vdata["Disclaimer"] <-substr(Vdata$Disclaimer,1,nchar(Vdata$Disclaimer)-2)
Vdata["Party"] <-substr(Vdata$Party,1,nchar(Vdata$Party)-2)

Vdata["ID"] <-substring(Vdata$ID,3)
Vdata["Description"] <-substring(Vdata$Description,3)
Vdata["Period"] <-substring(Vdata$Period,3)
Vdata["AmountSpent"] <-substring(Vdata$AmountSpent,3)
Vdata["Impressions"] <-substring(Vdata$Impressions,3)
Vdata["Disclaimer"] <-substring(Vdata$Disclaimer,3)
Vdata["Party"] <-substring(Vdata$Party,3)

Vdata["ID"] <-substring(Vdata$ID,4)
Vdata["AmountSpent"] <-substring(Vdata$AmountSpent,19)
Vdata["AmountSpent"] <-substring(Vdata$AmountSpent,2)
Vdata["Impressions"] <-substring(Vdata$Impressions,12)
Vdata["Impressions"] <-substring(Vdata$Impressions,2)


library(stringr)
#period

#install.packages("splitstackshape")
library(splitstackshape)
df2 <- cSplit(Vdata, "Period", "-")


df2$Period_1 <- as.Date(df2$Period_1, format = "%d %B %Y")
df2$Period_2 <- as.Date(df2$Period_2, format = "%d %B %Y")

#impressions
df2$Impressions = str_replace_all(df2$Impressions,"ach: ","")
df2 <- cSplit(df2, "Impressions", "-")

library(stringr)
df2$Impressions_1 = str_replace_all(df2$Impressions_1,"ach: ","")
df2$Impressions_1 = str_replace_all(df2$Impressions_1," people","")
df2$Impressions_1 = str_replace_all(df2$Impressions_1,"K","000")
df2$Impressions_1 = str_replace_all(df2$Impressions_1,"M","000000")
df2$Impressions_1 = str_replace_all(df2$Impressions_1,">","")
df2$Impressions_1 = str_replace_all(df2$Impressions_1,"<","")

df2$Impressions_2 = str_replace_all(df2$Impressions_2,"ach: ","")
df2$Impressions_2 = str_replace_all(df2$Impressions_2," people","")
df2$Impressions_2 = str_replace_all(df2$Impressions_2,"K","000")
df2$Impressions_2 = str_replace_all(df2$Impressions_2,"M","000000")
df2$Impressions_2 = str_replace_all(df2$Impressions_2,">","")
df2$Impressions_2 = str_replace_all(df2$Impressions_2,"<","")

#amountspent
df2 <- cSplit(df2, "AmountSpent", "-")

df2$AmountSpent_2 = str_replace_all(df2$AmountSpent_2,"???","")
df2$AmountSpent_2 = str_replace_all(df2$AmountSpent_2,"1.5K","1500")
df2$AmountSpent_2 = str_replace_all(df2$AmountSpent_2,"2.5K","2500")
df2$AmountSpent_2 = str_replace_all(df2$AmountSpent_2,"4.5K","4500")
df2$AmountSpent_2 = str_replace_all(df2$AmountSpent_2,"K","000")
df2$AmountSpent_2 = str_replace_all(df2$AmountSpent_2,">","")
df2$AmountSpent_2 = str_replace_all(df2$AmountSpent_2,"<","")

df2$AmountSpent_1 = str_replace_all(df2$AmountSpent_1,"???","")
df2$AmountSpent_1 = str_replace_all(df2$AmountSpent_1,"1.5K","1500")
df2$AmountSpent_1 = str_replace_all(df2$AmountSpent_1,"2.5K","2500")
df2$AmountSpent_1 = str_replace_all(df2$AmountSpent_1,"4.5K","4500")
df2$AmountSpent_1 = str_replace_all(df2$AmountSpent_1,"K","000")
df2$AmountSpent_1 = str_replace_all(df2$AmountSpent_1,">","")
df2$AmountSpent_1 = str_replace_all(df2$AmountSpent_1,"<","")

#updating NA values

df2$AmountSpent_2[is.na(df2$AmountSpent_2)] = 0

#calculating average amount
df2$AmountSpent_1 <- as.numeric(df2$AmountSpent_1)
df2$AmountSpent_2 <- as.numeric(df2$AmountSpent_2)

df2["AvgAmount"] = (df2$AmountSpent_1 + df2$AmountSpent_2 ) / 2

#calculating average impressions
df2$Impressions_1 <- as.numeric(df2$Impressions_1)
df2$Impressions_2 <- as.numeric(df2$Impressions_2)


df2["AvgImpressions"] = (df2$Impressions_1 + df2$Impressions_2 ) / 2

dfres <- df2

a <- as.table(dfres)
require(data.table) # v1.9.0+
d <- setDT(dfres)

dd <- subset(d, select = -Impre)

write.csv(x=df, file="SinnFien1.csv")
write.csv(x=dd, file="SinnFien2.csv")

