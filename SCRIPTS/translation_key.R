library(tidyverse)
library(readxl)
library(magrittr)
setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/DATA/")
# get unique and sorted species list from 2007 and 2018 data
#########
#2018
#########

dat.2018 <- lapply(dir(patt = '2018'), read.csv, as.is = T)
dat.2018.spp <- sapply(dat.2018, function(x) x$Species_Name) %>%
  unlist %>%
  trimws %>%
  unique %>%
  sort
#for some reason.... there is an empty line in this unique set that is screwing up when I try to compare
#to the Accepted tnrs list...I am just going to delete it. I have gone through all three datasets and cant find 
#where its coming from... maybe will try to fix more later
dat.2018.spp <- data.frame(dat.2018.spp)
dat.2018.spp <- dat.2018.spp[-1,]
dat.2018.spp <- data.frame(dat.2018.spp)
colnames(dat.2018.spp)[1] <- "Original_name"
write.csv(dat.2018.spp, '../OUTPUTS/unq_sort_all_18.csv')
########## 
#2007 
##########

dat.2007 <- lapply(dir(patt = '2007'), read.csv, as.is = T)
dat.2007.spp <- sapply(dat.2007, function(x) x$species) %>%
  unlist %>%
  trimws %>%
  unique %>%
  sort
dat.2007.spp <- data.frame(dat.2007.spp)
colnames(dat.2007.spp)[1] <- "Original_name"

write.csv(dat.2007.spp, '../OUTPUTS/unq_sort_all_07.csv')

#take these species lists and run through http://tnrs.iplantcollaborative.org/TNRSapp.html
#output downloaded as tnrs_XX.csv
##########################################################################
# make the translation key with original species name in one column and 
# accepted species name in another

tnrs_18 <- read.csv('../META/tnrs_18.csv', as.is = T)
tnrs_18 <- data.frame(tnrs_18)
# replaceme18 <- tnrs_18$Name_matched == "No suitable matches found."
# for (i in replaceme18){
#  if(i == TRUE){
#    tnrs_18$Accepted_name[i] <- tnrs_18$Name_submitted[i]
#  }
# }
dat.2018.spp$Accepted_name <- tnrs_18$Accepted_name
write.csv(dat.2018.spp, '../OUTPUTS/translation_key18.csv')

tnrs_07 <- read.csv('../META/tnrs_07.csv', as.is = T)
tnrs_07 <- data.frame(tnrs_07)
# replaceme07 <- tnrs_07$Name_matched == "No suitable matches found."
# for (i in replaceme07){
#   if(i == TRUE){
#     tnrs_07$Accepted_name[i] <- tnrs_07$Name_submitted[i] 
#   }  
# }
dat.2007.spp$Accepted_name <- tnrs_07$Accepted_name
write.csv(dat.2007.spp, '../OUTPUTS/translation_key07.csv')

