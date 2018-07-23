#make my dataframe w plot, spp, accname, and cover

setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/DATA")

#open up those csvs and put them in dataframes
dat.herb <- read.csv(file = "spp.herb.2018.csv", as.is = T)
dat.herb <- data.frame(dat.herb[3:6])
dat.shrub <- read.csv(file = "spp.shrub.2018.csv", as.is = T)
dat.shrub <- data.frame(dat.shrub[3:8])
dat.shrub[4:5] <- NULL
dat.tree <- read.csv(file = "spp.trees.2018.csv", as.is = T)
dat.tree <- data.frame(dat.tree[3:6])
dat.herb$X6.Letter.Code<-NULL
dat.shrub$X6.Letter.Code<-NULL
dat.tree$X6.Letter.Code<-NULL
names(dat.herb) <- c('plot', 'sp', 'cover')
names(dat.shrub) <- c('plot', 'sp', 'cover')
names(dat.tree) <- c('plot', 'sp', 'cover')

# convert DBH to basal area for the tree cover
# 0.005454 * DBH^2 = BA
dat.tree$cover <- as.double(dat.tree$cover)
BA <- c()
for (c in dat.tree$cover){
  BA <- c(BA, 0.005454 * c**2)
}
dat.tree$cover <- BA

dat.all <- rbind.data.frame(dat.herb, dat.shrub)
dat.all <- rbind.data.frame(dat.all, dat.tree)
dat.all$sp <- gsub(' ', '', dat.all$sp, fixed = T)

#translate all the names using the translation key
trans_key <- data.frame(read.csv('../DATA/translation_key_all_AH.v2.csv', as.is = T)[2:4])
trans_key$Original_name <- gsub(' ', '', trans_key$Original_name, fixed = T)
dat.all$accepted_name <- trans_key$acceptedMOR[match(dat.all$sp,
                                                     trans_key$Original_name)]

write.csv(dat.all, '../OUTPUTS/cover_18.csv')
