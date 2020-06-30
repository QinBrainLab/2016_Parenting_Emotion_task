# -*- coding: utf-8 -*-
"""
Created on Thu Mar 23 21:36:32 2017
Xu Jiahua
xujiahuapsy@gmail.com

"""

import pandas as pd

row_data = pd.read_table('CBDPC262.txt')
data = row_data.set_index(['Subject'])

res = pd.DataFrame()

data_11 = data[data['type']==11]
res['ACC_11_mean'] = data_11['Slide1.ACC'].mean(level = ['Subject'])
res['ACC_11_std'] = data_11['Slide1.ACC'].std(level = ['Subject'])
data_11 = data_11[data_11['Slide1.RT']!=0]
res['RT_11_mean'] = data_11['Slide1.RT'].mean(level = ['Subject'])
res['RT_11_std'] = data_11['Slide1.RT'].std(level = ['Subject'])

data_22 = data[data['type']==22]
res['ACC_22_mean'] = data_22['Slide1.ACC'].mean(level = ['Subject'])
res['ACC_22_std'] = data_22['Slide1.ACC'].std(level = ['Subject'])
data_22 = data_22[data_22['Slide1.RT']!=0]
res['RT_22_mean'] = data_22['Slide1.RT'].mean(level = ['Subject'])
res['RT_22_std'] = data_22['Slide1.RT'].std(level = ['Subject'])

res = res.reset_index()
res.to_excel('CBDPC262.xlsx')
