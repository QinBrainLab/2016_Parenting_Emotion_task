# -*- coding: utf-8 -*-
"""
Created on Thu Jul 11 15:53:05 2019

@author: xujiahua
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.linear_model import LinearRegression
from scipy.stats import pearsonr
data = pd.read_csv('C:\\Users\\xujiahua\\Desktop\\R_regression_revise.csv')    # TV、Radio、Newspaper、Sales
x = np.array([data['USEP']]).reshape(-1,1)
y = np.array([data['USEP_2']]).reshape(-1,1)
model =LinearRegression()
predicted=sklearn.model_selection.cross_val_predict(model,x,y,cv=4)
ab=pearsonr(predicted,y)
fig, ax=plt.subplots()
ax.scatter(y,predicted,edgecolor=(0,0,0))
ax.plot([y.min(),y.max()],[y.min(),y.max()],'k--',lw=4)
ax.set_xlabel("Measured")
ax.set_ylabel("Predicted")
plt.show()
