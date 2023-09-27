import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf
from tensorflow.keras.layers import Dropout, Dense, LSTM
from pylab import *
import os
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error
import math

file = open("./x_pre.txt", "r")
xdata = file.read()
file.close()
#print(xdata)

file = open("./y_pre.txt", "r")
ydata = file.read()
file.close()
#print(ydata)
