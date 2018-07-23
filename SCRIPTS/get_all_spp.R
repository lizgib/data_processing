setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/DATA")

#open up those csvs and put them in dataframes
dat.herb <- read.csv(file = "spp.herb.2018.csv", as.is = T)
dat.herb <- data.frame(dat.herb[3:5])
dat.herb$X6.Letter.Code <- NULL
dat.shrub <- read.csv(file = "spp.shrub.2018.csv", as.is = T)
dat.shrub <- data.frame(dat.shrub[3:5])
dat.shrub$X6.Letter.Code <- NULL
dat.tree <- read.csv(file = "spp.trees.2018.csv", as.is = T)
dat.tree <- data.frame(dat.tree[3:5])
dat.tree$X6.Letter.Code <- NULL

dat.all <- rbind.data.frame(dat.herb, dat.shrub)
dat.all <- rbind.data.frame(dat.all, dat.tree)
dat.all$Species_Name <- gsub(' ', '', dat.all$Species_Name, fixed = T)
#translate all the names using the translation key
trans_key <- data.frame(read.csv('../DATA/translation_key_all_AH.v2.csv', as.is = T)[2:4])
trans_key$Original_name <- gsub(' ', '', trans_key$Original_name, fixed = T)
dat.all$Accepted_name <- trans_key$acceptedMOR[match(dat.all$Species_Name,
                                                     trans_key$Original_name)]

write.csv(dat.all, '../OUTPUTS/all_spp_18.csv')
