#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 19 09:04:40 2017

@author: xujiahua
"""

import hddm
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
# Load data from csv file into a NumPy structured array
data = hddm.load_csv('Input.csv')
#data = hddm.load_csv('bd_wm_hddm_byload_2B.csv')
data=data[data['rt']!=0]
data=data[data['group']!=40]
data=data[data['group']!=50]

for i in range(10):   
    model = hddm.HDDM(data, p_outlier=0.05,depends_on={'v':'group','a':'group','t':'group'},is_group_model=True)
    model.find_starting_values()
    model.sample(12000, burn=2000)#10000,5000
    print('Test is done')
    model_stat= model.gen_stats()
    print(model_stat)
    model_stat.to_csv('Run'+str(i)+'_all.csv') 
    
import pandas as pd
pieces = []
for i in range(10):   
    data = pd.read_csv('Run'+str(i)+'_all.csv',index_col=0)
    print(data)
    data = data.loc[:,'mean']
    pieces.append(data)
Two_model_stats_all = pd.concat(pieces,axis=1)
Two_model_stats_all.to_csv('Two_Run1to10_all1.csv')
