library(tinyverse)
library(stringr)
setwd("~/Documents/morton arb/east_woods_phylogeny/data_processing/OUTPUTS/")

shrubs <- read.csv(file = "newshrubs18_nozeros.csv", as.is = T)
herbs <- read.csv(file = "newherbs18_nozeros.csv", as.is = T)
trees <- read.csv(file = "newtrees18_nozeros.csv", as.is = T)

shrubs <- data.frame(shrubs)
herbs <- data.frame(herbs)
trees <- data.frame(trees)

shrubs <- shrubs[, -c(5:11)]
shrubs <- shrubs[, -c(1:3)]

trees <- trees[, -c(5:10)]
trees <- trees[, -c(1:3)]

herbs <- herbs[, -c(5:15)]
herbs <- herbs[, -c(1:3)]

all_new_spp <- rbind(shrubs, trees)
all_new_spp <- rbind(all_new_spp, herbs)
#all_new_spp <- sort(all_new_spp$Plot.ID.Number, decreasing = FALSE, na.last = FALSE, partial = NULL)

spp_per_plot <-table(all_new_spp$Plot.ID.Number)
spp_per_plot <- sort(spp_per_plot, decreasing = T)

write.csv(spp_per_plot, 'spp_per_plot.csv')
write.csv(all_new_spp, 'new_spp_all_plots.csv')
