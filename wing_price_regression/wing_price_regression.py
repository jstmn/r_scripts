#!/usr/bin/env python
"""wing_price_regression.py: polynomial regression to model ppw. see https://www.buzzfeednews.com/article/juliareinstein/that-math-you-said-youd-never-use-in-real-life-is-now-being?fbclid=IwAR2UlTi3FBEuzbT4gqFhsvZ8gYYYmZhM5RZiPBGQZasEWd3uegGW5PhUZzM"""
__author__      = "Jeremy Morgan"
__date__   = "Nov 15th, 2018"
# oc ordercount, p price, ppw price per wing
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pylab

def polyfit(x, y, degree):
	# 'borrowed' from @leif (https://stackoverflow.com/questions/893657/how-do-i-calculate-r-squared-using-python-and-numpy)
    
    coeffs = np.polyfit(x, y, degree)
    p = np.poly1d(coeffs)
    yhat = p(x)                         # or [p(z) for z in x]
    ybar = np.sum(y)/len(y)          # or sum(y)/len(y)
    ssreg = np.sum((yhat-ybar)**2)   # or sum([ (yihat - ybar)**2 for yihat in yhat])
    sstot = np.sum((y - ybar)**2)    # or sum([ (yi - ybar)**2 for yi in y])
    R_squared = ssreg/sstot
    poly1d = np.poly1d(p)
    return coeffs, poly1d, R_squared

if __name__ == "__main__":
	n = 50

	df = pd.read_csv("data.csv", sep=',', names=['oc','p','ppw','_'], index_col=None)
	oc = np.array(df.oc)
	price = np.array(df.p)
	ppw = np.array(df.ppw)

	_, f_p, r_squared_p = polyfit(oc, price, 2)

	ppw_squared_vals = []
	for i in range(50):
		_, f_ppw, r_squared_ppw = polyfit(oc, ppw, i)
		ppw_squared_vals.append(r_squared_ppw)
	
	for i in range(len(ppw_squared_vals)):
		print i," R^2:",ppw_squared_vals[i]
	print max(ppw_squared_vals)
	#print r_squared_ppw, r_squared_p



	# oc_range = np.linspace(oc[0], oc[-1], 50)
	# ppw_regressed = f_ppw(oc_range)
	# p_regressed = f_p(oc_range)

	# plt.figure(1)
	# plt.subplot(211)
	# ax = plt.gca()
	# pylab.title('Price vs Order Count')
	# plt.plot(oc_range, p_regressed)
	# plt.plot(oc, price,'r^')

	# plt.subplot(212)
	# ax = plt.gca()
	# pylab.title('Price Per Wing vs Order Count')
	# plt.plot(oc_range, ppw_regressed)
	# plt.plot(oc, ppw, 'r^')
	# plt.show()



