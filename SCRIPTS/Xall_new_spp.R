library(tidyverse)
library(magrittr)
setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/DATA/")
#################################################################################################
# read in the survey csvs

dat.trees18 <- read.csv(file = "spp.trees.2018.csv", as.is = T)
dat.trees18 <- data.frame(dat.trees18[3:5])
dat.herb18 <- read.csv(file = "spp.herb.2018.csv", as.is = T)
dat.herb18 <- data.frame(dat.herb18[3:5])
dat.shrub18 <- read.csv(file = "spp.shrub.2018.csv", as.is = T)
dat.shrub18 <- data.frame(dat.shrub18[3:5])

dat.all18 <- rbind(dat.trees18, dat.herb18)
dat.all18 <- rbind(dat.all18, dat.shrub18)

dat.trees07 <- read.csv(file = "spp.trees.2007.csv", as.is = T)
dat.trees07 <- data.frame(dat.trees07[1:3])
dat.herb07 <- read.csv(file = "spp.herb.2007.csv", as.is = T)
dat.herb07 <- data.frame(dat.herb07[1:3])
dat.shrub07 <- read.csv(file = "spp.shrub.2007.csv", as.is = T)
dat.shrub07 <- data.frame(dat.shrub07[1:3])

dat.all07 <- rbind(dat.trees07, dat.herb07)
dat.all07 <- rbind(dat.all07, dat.shrub07)

#################################################################################################
# read in the translation key 

trans_18 <- read.csv('../OUTPUTS/edited_translation_key18.csv')
trans_18 <-data.frame(trans_18)
dat.all18$Accepted_name <- trans_18$Accepted_name[match(dat.all18$Species_Name, 
                                                         trans_18$Original_name)]

trans_07 <- read.csv('../OUTPUTS/edited_translation_key07.csv')
trans_07 <-data.frame(trans_07)
dat.all07$Accepted_name <- trans_07$Accepted_name[match(dat.all07$species, 
                                                         trans_07$Original_name)]

#################################################################################################
dat.all07$cleanPlot <- gsub('[- ]', '', dat.all07$plot)
dat.all18$cleanPlot <- gsub('[- ]', '', dat.all18$Plot.ID.Number)

plots <- unique(c(dat.all07$cleanPlot, dat.all18$cleanPlot))
new.list <- lapply(plots, function(x) {
  spp.18 <- dat.all18[which(dat.all18$cleanPlot == x), 'Accepted_name'] %>% as.character
  spp.07 <- dat.all07[which(dat.all07$cleanPlot == x), 'Accepted_name'] %>% as.character
  setdiff(spp.18, spp.07) %>% sort
  
})
names(new.list) <- plots

old.list <- lapply(plots, function(x) {
  spp.18 <- dat.all18[which(dat.all18$cleanPlot == x), 'Accepted_name'] %>% as.character
  spp.07 <- dat.all07[which(dat.all07$cleanPlot == x), 'Accepted_name'] %>% as.character
  setdiff(spp.07, spp.18) %>% sort
  
})
new.vector <- sapply(dat.all18$Accepted_name %>% as.character %>% unique %>% sort, function(x) sapply(new.list, function(y) x %in% y) %>% sum) %>%
  sort(decreasing = TRUE)

write.csv(new.vector, '../OUTPUTS/most_freq_new_spp.csv')

old.vector <- sapply(dat.all07$Accepted_name %>% as.character %>% unique %>% sort, function(x) sapply(old.list, function(y) x %in% y) %>% sum) %>%
  sort(decreasing = TRUE)
write.csv(old.vector, '../OUTPUTS/most_freq_lost_spp.csv')

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
new_spp_where <- sort(table(plot_names), decreasing = T)
write.csv(new_spp_where, '../OUTPUTS/new_spp_where.csv')


write.csv(df, '../OUTPUTS/2_new_spp_all18.csv',)


