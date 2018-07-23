library(tidyverse)
setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/")
#open data from 2018 and 2007
#########
#2018
#########
dat.herb18 <- read.csv(file = "DATA/spp.herb.2018.csv", as.is = T)
dat.herb18 <- data.frame(dat.herb18)

########## 
#2007 
##########
dat.herb07 <- read.csv(file = "DATA/spp.herb.2007.csv", as.is = T)
dat.herb07 <- data.frame(dat.herb07)

###################################################################################
#already have a table of all the species names with the tnrs spelling consensus (see translation_key.R)
#use the translation table to match the name in the original list to the accepted tnrs name
#accepted_spp <- translation_table$accepted_name[match(orig_spp_name, translation_table$original_name)]

trans_18 <- read.csv('OUTPUTS/edited_translation_key18.csv')
trans_18 <-data.frame(trans_18)
dat.herb18$Accepted_name <- trans_18$Accepted_name[match(dat.herb18$Species_Name, 
                                                         trans_18$Original_name)]


trans_07 <- read.csv('OUTPUTS/edited_translation_key07.csv')
trans_07 <-data.frame(trans_07)
dat.herb07$Accepted_name <- trans_07$Accepted_name[match(dat.herb07$species, 
                                                         trans_07$Original_name)]


###################################################################################
dat.herb07$cleanPlot <- gsub('[- ]', '', dat.herb07$plot)
dat.herb18$cleanPlot <- gsub('[- ]', '', dat.herb18$Plot.ID.Number)

plots <- unique(c(dat.herb07$cleanPlot, dat.herb18$cleanPlot))
new.list <- lapply(plots, function(x) {
  spp.18 <- dat.herb18[which(dat.herb18$cleanPlot == x), 'Accepted_name'] %>% as.character
  spp.07 <- dat.herb07[which(dat.herb07$cleanPlot == x), 'Accepted_name'] %>% as.character
  setdiff(spp.18, spp.07) %>% sort

})
names(new.list) <- plots

old.list <- lapply(plots, function(x) {
  spp.18 <- dat.herb18[which(dat.herb18$cleanPlot == x), 'Accepted_name'] %>% as.character
  spp.07 <- dat.herb07[which(dat.herb07$cleanPlot == x), 'Accepted_name'] %>% as.character
  setdiff(spp.07, spp.18) %>% sort
  
})
new.vector <- sapply(dat.herb18$Accepted_name %>% as.character %>% unique %>% sort, function(x) sapply(new.list, function(y) x %in% y) %>% sum) %>%
  sort(decreasing = TRUE)

write.csv(new.vector, 'OUTPUTS/most_freq_new_spp.csv')

old.vector <- sapply(dat.herb07$Accepted_name %>% as.character %>% unique %>% sort, function(x) sapply(old.list, function(y) x %in% y) %>% sum) %>%
  sort(decreasing = TRUE)
write.csv(old.vector, 'OUTPUTS/most_freq_lost_spp.csv')

plot_names <- NULL
for (i in plots){
  for (spp in new.list[[i]]){
    plot_names <- c(plot_names, i)
  }
}
all_spp <- NULL
for (i in new.list){
  for (spp in i){
    all_spp <- c(all_spp, spp)
  }
}

df <- data.frame()
df <- cbind(plot_names, all_spp)
sort(table(plot_names), decreasing = T)


write.csv(df, 'OUTPUTS/2_new_herbs18.csv',)

