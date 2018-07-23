library(tidyverse)
library(readxl)
setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/")
#open data from 2018 and 2007
#########
#2018
#########
dat.herb18 <- read.csv(file = "spp.herb_test.2018.csv", as.is = T)
dat.herb18 <- data.frame(dat.herb18)
write.csv(dat.herb18, 'WHAT_IS_WRONG/1_original_dataframe_18.csv')

########## 
#2007 
##########
dat.herb07 <- read.csv(file = "spp.herb_test.2007.csv", as.is = T)
dat.herb07 <- data.frame(dat.herb07)
write.csv(dat.herb07, 'WHAT_IS_WRONG/1_original_dataframe_07.csv')

###################################################################################
#already have a table of all the species names with the tnrs spelling consensus (see translation_key.R)
#use the translation table to match the name in the original list to the accepted tnrs name
# accepted_spp <- translation_table$accepted_name[match(orig_spp_name, translation_table$original_name)]

trans_18 <- read.csv('OUTPUTS/edited_translation_key18.csv')
trans_18 <-data.frame(trans_18)
dat.herb18$Accepted_name <- trans_18$Accepted_name[match(dat.herb18$Species_Name, 
                                                          trans_18$Original_name)]

write.csv(dat.herb18, 'WHAT_IS_WRONG/2_dat.herb18_with_acc_names_added.csv')

trans_07 <- read.csv('OUTPUTS/edited_translation_key07.csv')
trans_07 <-data.frame(trans_07)
dat.herb07$Accepted_name <- trans_07$Accepted_name[match(dat.herb07$species, 
                                                          trans_07$Original_name)]
write.csv(dat.herb07, 'WHAT_IS_WRONG/2_dat.herb07_with_acc_names_added.csv')

###NO NAMES ARE LOST HERE BUT THE TRANSLATION MISSES THINGS IT SHOULDN'T (DECLARES THEM NA)

###################################################################################
#compare the two dataframes (2007 and 2018) look for new species in 2018
## I THINK MY PROBLEM IS WITH CHANGING PLOTS... IT IS CONSIDERING THINGS THAT WERE 
## IN PREVIOUS PLOTS AS PART OF THE CURRENT PLOT??
#### nooo i dont think thats it! if you look at the original output newherbs18.csv there are species repeats across plots..
#### and looking at the translation key errors...first of all i dont know why some of them are outputting NA, and secondly, 
#### the species being excluded dont necessarily seems to match with the NAs..

#### HERE I WAS TRYING TO ITERATE THROUGH THE PLOTS AND CREATE A SPECIES LIST DISTINCT FOR EACH PLOT (OPPOSED TO EVALUATING THE 
#### DIFFERENCES ALL TOGETHER)
# current_plot = ""
# for (plot_num in dat.herb18$Plot.ID.Number){
#   print(plot_num)
#   if (plot_num != current_plot){
#     print('condition')
#     plot_spp <- NULL
#   }
#   current_plot = plot_num
#   plot_spp <- c(which(!dat.herb18[current_plot,] %in% dat.herb07[current_plot,]))
#   print(plot_spp)
# }

spp_new <- c(which(!dat.herb18$Accepted_name %in% dat.herb07$Accepted_name))
old_spp <- c(which(dat.herb18$Accepted_name %in% dat.herb07$Accepted_name))
for (i in old_spp){
  print(dat.herb18[i,])
}

#### HERE I WAS TRYING TO RECREATE THE STEP UP ABOVE WITH WHICH IN A DIFFERENT WAY
#### THIS IS THE DIRECTION IVE DECIDED TO KEEP WORKING ON CURRENTLY BUT IM NOT VERY HAPPY WITH IT
#### BECAUSE I FEEL ITS OVERCOMPLICATING THINGS (LEADING TO MORE ROOM FOR ERROR)
# in_2007 <- NULL
# not_in_2007 <- NULL
# current_plot = ""
# for (plot_num in dat.herb18$Plot.ID.Number){
#   if (plot_num != current_plot){
#     in_2007 <- NULL
#     not_in_2007 <- NULL
#   }
#   current_plot = plot_num
# }
# for (i in dat.herb18$Accepted_name){
#     print(paste("i is: ", i))
#      if (i %in% dat.herb07$Accepted_name){
#       print(paste("is in 2007: ", i ))
#       in_2007 <- c(in_2007, i)
#     }
#     else {
#       print(paste("is NOT in 2007: ", i))
#       not_in_2007 <- c(not_in_2007, i)
#     }
# }

newdf <- NULL
for (i in spp_new){
   newdf <- rbind(newdf,dat.herb18[i,])
 }

write.csv(newdf, format(Sys.time(), 'WHAT_IS_WRONG/3_new_herbs18.csv'))

