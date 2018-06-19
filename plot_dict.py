'''
I want to get a list of each plot's UNIQUE species...
R doesn't have dictionaries so doing that here 
'''
import csv
import pandas as pd
from collections import OrderedDict


file = open('/Users/elizabethgibbons/Documents/morton arb/east_woods_phylogeny/data_processing/OUTPUTS/new_spp_all_plots.csv')
header = file.readline()
rows = file.readlines()

spp_in_plot = dict()
for x in rows:
    x = x.strip().split(',')
    plotid = x[1]
    spp = x[2]
    if plotid not in spp_in_plot.keys():
        spp_in_plot[plotid] = set()
    spp_in_plot.get(plotid).add(spp)
    
#print(spp_in_plot)  
ordered = OrderedDict(sorted(spp_in_plot.items(), key=lambda x: len(x[1])))
pd.DataFrame.from_dict(data=ordered, orient='index').to_csv('plot_dict.csv', header=False)

