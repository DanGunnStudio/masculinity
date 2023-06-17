library(tidyverse)
library(dplyr)
library(readr)

masc_sur_raw <- read_csv("raw_data/masculinity-survey.csv")

#inspect
str(masc_sur_raw)
head(masc_sur_raw)

#changing column names
colnames(masc_sur_raw)[1] ="Question"
masc_sur_raw <-masc_sur_raw %>% rename("Response" = "...2",
                        "Age18_34" = "Age",
                        "Age35_64"= "...5",
                        "Age65_up"="...6",
                        "White" = "Race",
                        "Nonwhite"="...8",
                        "HasKids"= "Children",
                        "NoKids" = "...10",
                        "Straight"= "Sexual Orientation",
                        "Gay/Bisexual"= "...12")
#delete the first row
masc_sur_raw <- masc_sur_raw[-1,]

#copying questions into NA spaces in column 1
questions <- masc_sur_raw$Question[!is.na(masc_sur_raw$Question)==TRUE]
index <- which(masc_sur_raw$Question != 'NA') 

#need to select first question in the index
#then copy question into the following row 
#if space is 'NA' 
#and stop if it has the next question. 
#then move to the next number in the index

#create and preload question
q<- masc_sur_raw$Question[1]
#empty data frame
fixed_q <- data.frame(matrix(ncol = 1, nrow = 0))
# Loop over all elements
for (i in 1:nrow(masc_sur_raw)){ 
    if (is.na(masc_sur_raw$Question[i])){ 
        fixed_q[i,]<- q
     } else {
       q <- masc_sur_raw$Question[i]
       fixed_q[i,] <-masc_sur_raw$Question[i]
     }
}
#checking for match
head(fixed_q, n=20)
head(masc_sur_raw, n=20)

#sub fixed_q for first column of masc_sur_raw
masc_sur_raw$Question <- fixed_q[,1]
masc_sur <- masc_sur_raw
head(masc_sur, n=10)

#filter out NA rows
masc_sur_clean <- masc_sur %>% filter(!is.na(Response))

#clean csv file for Tableau
write_csv(masc_sur_clean, "data/masculinity_survey_clean.csv")
