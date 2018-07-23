library(tidyverse)
library(readxl)
setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/SCRIPTS/")
#open data from 2018 and 2007
#########
#2018
#########
dat.shrub18 <- read.csv(file = "../DATA/spp.shrub.2018.csv", as.is = T)
dat.shrub18 <- data.frame(dat.shrub18)

########## 
#2007 
##########
dat.shrub07 <- read.csv(file = "../DATA/spp.shrub.2007.csv", as.is = T)
dat.shrub07 <- data.frame(dat.shrub07)

###################################################################################
#already have a table of all the species names with the tnrs spelling consensus (see translation_key.R)
#use the translation table to match the name in the original list to the accepted tnrs name
# accepted_spp <- translation_table$accepted_name[match(orig_spp_name, translation_table$original_name)]

trans_18 <- read.csv('../OUTPUTS/edited_translation_key18.csv')
trans_18 <-data.frame(trans_18)
dat.shrub18$Accepted_name <- trans_18$Accepted_name[match(dat.shrub18$Species_Name, 
                                                          trans_18$Original_name)]

trans_07 <- read.csv('../OUTPUTS/translation_key07.csv')
trans_07 <-data.frame(trans_07)
dat.shrub07$Accepted_name <- trans_07$Accepted_name[match(dat.shrub07$species, 
                                                          trans_07$Original_name)]

###################################################################################
#compare the two dataframes (2007 and 2018) look for new species in 2018
spp_new <- c(which(!dat.shrub18$Accepted_name %in% dat.shrub07$Accepted_name))
new_rows <- length(spp_new) + 1
newdf <- NULL
for (i in spp_new){
  newdf <- rbind(newdf,dat.shrub18[i,])
}

write.csv(newdf, format(Sys.time(), '../OUTPUTS/newshrubs18_nozeros.csv'))

