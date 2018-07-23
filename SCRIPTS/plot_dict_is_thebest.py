'''
I want to get a list of each plot's UNIQUE species...
R doesn't have dictionaries so doing that here 
'''
import csv
import pandas as pd
from collections import OrderedDict


file18 = open('/Users/elizabethgibbons/Documents/morton arb/east_woods_phylogeny/data_processing/OUTPUTS/all_spp_18.csv')
header18 = file18.readline()
rows18 = file18.readlines()

spp_in_plot18 = dict()
for x in rows18:
    x = x.strip().split(',')
    plotid = x[1]
    spp = x[2]
    if plotid not in spp_in_plot18.keys():
        spp_in_plot18[plotid] = set()
    spp_in_plot18.get(plotid).add(spp)
    
#print(spp_in_plot)  
ordered = OrderedDict(sorted(spp_in_plot18.items(), key=lambda x: len(x[1])))
#pd.DataFrame.from_dict(data=ordered, orient='index').to_csv('plot_species_18.csv', header=False)



file07 = open('/Users/elizabethgibbons/Documents/morton arb/east_woods_phylogeny/data_processing/OUTPUTS/all_spp_07.csv')
header07 = file07.readline()
rows07 = file07.readlines()

spp_in_plot07 = dict()
for x in rows07:
    x = x.strip().split(',')
    plotid = x[1]
    spp = x[2]
    #print(plotid)
    if plotid not in spp_in_plot07.keys():
        spp_in_plot07[plotid] = set()
    spp_in_plot07.get(plotid).add(spp)
    
#print(spp_in_plot)  
ordered = OrderedDict(sorted(spp_in_plot07.items(), key=lambda x: len(x[1])))
#pd.DataFrame.from_dict(data=ordered, orient='index').to_csv('plot_species_07.csv', header=False)

for plot in spp_in_plot18.keys():
    if plot in spp_in_plot07.keys():
        print('yas')


