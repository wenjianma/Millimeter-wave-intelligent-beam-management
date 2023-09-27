#  Paper：Location-Aware Predictive Beamforming for UAV Communications: A Deep Learning Approach
#  目标：复现 Deep Learning-based Location Prediction

import numpy as np
import tensorflow as tf
from tensorflow.keras.layers import Dropout, Dense, LSTM
import matplotlib.pyplot as plt
import os
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error
import math

# 数据
UAVDATA = pd.read_csv('./UAVdata.csv')  # 读取UAV运动模型文件

# 20个数据预测1个 （分别做y轴和x轴的预测）
training_setx = UAVDATA.iloc[0:2000, 1:2].values
training_sety = UAVDATA.iloc[0:2000, 2:3].values


# 归一化
sc = MinMaxScaler(feature_range=(0, 1))  # 定义归一化：归一化到(0，1)之间
training_set_scaledx = sc.fit_transform(training_setx)  # 求得训练集中x坐标的最大值，最小值这些训练集固有的属性，并在训练集上进行归一化
training_set_scaledy = sc.fit_transform(training_sety)  # 求得训练集中y坐标的最大值，最小值这些训练集固有的属性，并在训练集上进行归一化

x_train = []
y_train = []

x_pre = []
y_pre = []

# 利用for循环 预测x值 预测值记录到x_pre中 提取训练集中UAV连续20天的移动坐标作为输入特征x_train，第21天的坐标做为标签
for i in range(20, len(training_set_scaledx)):
    x_train.append(training_set_scaledx[i - 20:i, 0])
    y_train.append(training_set_scaledy[i, 0])
# 对训练集进行打乱
np.random.seed(7)
np.random.shuffle(x_train)
np.random.seed(7)
np.random.shuffle(y_train)

# 将训练集由list格式变为array格式
tf.random.set_seed(7)
x_train, y_train = np.array(x_train), np.array(y_train)

# 使x_train符合RNN输入要求：[送入样本数， 循环核时间展开步数， 每个时间步输入特征个数]。
# 此处整个数据集送入，送入样本数为x_train.shape[0]即2066组数据；输入60个开盘价，预测出第61天的开盘价，循环核时间展开步数为60; 每个时间步送入的特征是某一天的开盘价，只有1个数据，故每个时间步输入特征个数为1
x_train = np.reshape(x_train, (x_train.shape[0], 60, 1))


model = tf.keras.Sequential([
    LSTM(50, return_sequences=True),
    Dropout(0.2),
    LSTM(100, return_sequences=True),
    Dropout(0.2),
    Dense(1)
])

model.compile(optimizer=tf.keras.optimizers.Adam(0.001),
              loss='mean_squared_error')  # 损失函数用均方误差
# 该应用只观测loss数值，不观测准确率，所以删去metrics选项，一会在每个epoch迭代显示时只显示loss值

checkpoint_save_path = "./checkpoint/LSTM_stock.ckpt"

if os.path.exists(checkpoint_save_path + '.index'):
    print('-------------load the model-----------------')
    model.load_weights(checkpoint_save_path)

cp_callback = tf.keras.callbacks.ModelCheckpoint(filepath=checkpoint_save_path,
                                                 save_weights_only=True,
                                                 save_best_only=True,
                                                 monitor='val_loss')

history = model.fit(x_train, y_train, batch_size=64, epochs=50, validation_data=(x_test, y_test), validation_freq=1,
                    callbacks=[cp_callback])

model.summary()

file = open('./weights.txt', 'w')  # 参数提取
for v in model.trainable_variables:
    file.write(str(v.name) + '\n')
    file.write(str(v.shape) + '\n')
    file.write(str(v.numpy()) + '\n')
file.close()

loss = history.history['loss']
val_loss = history.history['val_loss']

plt.plot(loss, label='Training Loss')
plt.plot(val_loss, label='Validation Loss')
plt.title('Training and Validation Loss')
plt.legend()
plt.show()

