library(tidyverse)
library(magrittr)
setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/DATA/")
#################################################################################################

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

collection_priority <- read.csv('../collection_priority.csv', as.is = T)
collection_priority <- data.frame(collection_priority)
spp_to_collect <- collection_priority[which(collection_priority[9] == 'x'),]

cool_spp18 <- dat.all18[which(dat.all18$Species_Name %in% spp_to_collect$Original_name),]
cool_spp07 <- dat.all07[which(dat.all07$species %in% spp_to_collect$Original_name),]

write.csv(cool_spp18, '../OUTPUTS/vouchers_18.csv')
write.csv(cool_spp07, '../OUTPUTS/vouchers_07.csv')

#################################################################################################

most_freq_new18 <- sort(table(cool_spp18$Species_Name), decreasing = T)
most_freq_new07 <- sort(table(cool_spp07$species), decreasing = T)

#################################################################################################

spp <- unique(c(cool_spp07$species, cool_spp18$Species_Name))
spp_plots <- lapply(spp, function(x) {
  plots18 <- cool_spp18[which(cool_spp18$Species_Name == x), 'Plot.ID.Number'] %>% as.character
  plots07 <- cool_spp07[which(cool_spp07$species == x), 'plot'] %>% as.character
  c(plots18, plots07) %>% sort
})
names(spp_plots) <- spp

spp_names <- NULL
for (i in spp){
  for (spp in spp_plots[[i]]){
    spp_names <- c(spp_names, i)
  }
}
all_plots <- NULL
for (i in spp_plots){
  for (p in i){
    all_plots <- c(all_plots, p)
  }
}

df <- data.frame()
df <- cbind(spp_names, all_plots)
top_plots <- sort(table(spp_names), decreasing = T)
write.csv(top_plots, '../OUTPUTS/cool_spp_top_plots.csv')

write.csv(df, '../OUTPUTS/cool_spp_voucher_plots.csv')

