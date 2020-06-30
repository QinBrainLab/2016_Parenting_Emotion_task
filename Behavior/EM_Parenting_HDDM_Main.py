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
data=data[data['rt']!=0]
data=data[data['group']!=40]
data=data[data['group']!=50]
model = hddm.HDDM(data,p_outlier=0.05,depends_on={'v':'group','a':'group','t':'group'},is_group_model=True) 

model.find_starting_values()
model.sample(120000, burn=20000,dbname='traces.db',db='pickle')
model.save('mymodel_all__120000_20000Burnin')

print('Test is done')

model_stat= model.gen_stats()
model_stat.to_csv(r'mymodel_all_120000_20000Burnin.csv')
model.plot_posterior_predictive()
model.print_stats()
