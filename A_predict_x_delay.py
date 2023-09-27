import numpy as np
import tensorflow as tf
from tensorflow.keras.layers import Dropout, Dense, LSTM
import matplotlib.pyplot as plt
import os
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error
import math

#定义参数
m=110
n=2

#读入数据
y_move = pd.read_table('A_x_move.txt',header = None)
training_set = y_move.iloc[0:2000-250].values  # 前3000个为训练集
test_set = y_move.iloc[2000-250:].values  # 后300为测试集

# 归一化
sc = MinMaxScaler(feature_range=(0, 1))  # 定义归一化：归一化到(0，1)之间
training_set_scaled = sc.fit_transform(training_set)  # 求得训练集的最大值，最小值这些训练集固有的属性，并在训练集上进行归一化
test_set = sc.transform(test_set)  # 利用训练集的属性对测试集进行归一化

x_train = []
y_train = []

x_test = []
y_test = []

x_exam = []
y_exam = []

pre_test = []
# 测试集：
# 利用for循环，遍历整个训练集，提取训练集中连续30天的开盘价作为输入特征x_train，第21天的数据作为标签，for循环共构建1700-30=1680组数据。
for i in range(30, len(training_set_scaled)):
    x_train.append(training_set_scaled[i - 30:i, 0])
    y_train.append(training_set_scaled[i, 0])
# 对训练集进行打乱
np.random.seed(7)
np.random.shuffle(x_train)
np.random.seed(7)
np.random.shuffle(y_train)
tf.random.set_seed(7)
# 将训练集由list格式变为array格式
x_train, y_train = np.array(x_train), np.array(y_train)

# 使x_train符合RNN输入要求：[送入样本数， 循环核时间展开步数， 每个时间步输入特征个数]。
# 此处整个数据集送入，送入样本数为x_train.shape[0]即180组数据；输入30个，预测出第21天的位置，循环核时间展开步数为30; 每个时间步送入的特征是某一天的位置，只有1个数据，故每个时间步输入特征个数为1
x_train = np.reshape(x_train, (x_train.shape[0], 30, 1))

#训练网络
for i in range(30, len(test_set)):
    x_test.append(test_set[i - 30:i, 0])
    y_test.append(test_set[i, 0])
# 测试集变array并reshape为符合RNN输入要求：[送入样本数， 循环核时间展开步数， 每个时间步输入特征个数]
x_test, y_test = np.array(x_test), np.array(y_test)
x_test = np.reshape(x_test, (x_test.shape[0], 30, 1))

# 测试集：
x_exam = test_set[0:30, 0]
y_exam = test_set[30, 0]
# 测试集变array并reshape为符合RNN输入要求：[送入样本数， 循环核时间展开步数， 每个时间步输入特征个数]
x_exam, y_exam = np.array(x_exam), np.array(y_exam)
x_exam = np.reshape(x_exam, (1, 30, 1))

model = tf.keras.Sequential([
    LSTM(50, return_sequences=True),
    Dropout(0.2),
    LSTM(100),
    Dropout(0.2),
    Dense(1)
])

model.compile(optimizer=tf.keras.optimizers.Adam(0.001),
              loss='mean_squared_error')  # 损失函数用均方误差
# 该应用只观测loss数值，不观测准确率，所以删去metrics选项，一会在每个epoch迭代显示时只显示loss值

checkpoint_save_path = "./checkpoint_a_x_delay/LSTM_x.ckpt"

if os.path.exists(checkpoint_save_path + '.index'):
    print('-------------load the model-----------------')
    model.load_weights(checkpoint_save_path)

cp_callback = tf.keras.callbacks.ModelCheckpoint(filepath=checkpoint_save_path,
                                                 save_weights_only=True,
                                                 save_best_only=True,
                                                 monitor='val_loss')

history = model.fit(x_train, y_train, batch_size=40, epochs=100, validation_data=(x_test, y_test), validation_freq=1, callbacks=[cp_callback])

# n是间隔
for i in range(m):
    for j in range(n):
        pre = model.predict(x_exam, batch_size=40)
        pre_test = np.append(pre_test, pre)
        x_exam1 = x_exam[0, 1:30, 0]
        x_exam1 = np.append(x_exam1, pre)
        x_exam = np.reshape(x_exam1, (1, 30, 1))
    x_exam[0,29,0] = test_set[34+n*i]
pre_test = np.reshape(pre_test, (m*n,1))


file = open('./A_predict_x_weights_x_delay.txt', 'w')  # 参数提取
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

################## predict ######################
# 测试集输入模型进行预测

# 对预测数据还原---从（0，1）反归一化到原始范围
predicted_move_y = sc.inverse_transform(pre_test)
# 对真实数据还原---从（0，1）反归一化到原始范围
real_move_y = sc.inverse_transform(test_set[30:251])



# 画出真实数据和预测数据的对比曲线
file = open('./A_x_pre_delay_2.txt', 'w')  # 参数提取
for m in range(len(predicted_move_y)):
    file.write(str(predicted_move_y[m][0]) + '\n')
file.close()
plt.plot(real_move_y, color='red', label='real move',linewidth='4')
plt.plot(predicted_move_y, color='blue', label='pre move',linewidth='4')
plt.title('move Prediction with delay')
plt.xlabel('Time')
plt.ylabel('move in x axis')
plt.legend()
plt.show()

##########evaluate##############
# calculate MSE 均方误差 ---> E[(预测值-真实值)^2] (预测值减真实值求平方后求均值)
mse = mean_squared_error(predicted_move_y, real_move_y)
# calculate RMSE 均方根误差--->sqrt[MSE]    (对均方误差开方)
rmse = math.sqrt(mean_squared_error(predicted_move_y, real_move_y))
# calculate MAE 平均绝对误差----->E[|预测值-真实值|](预测值减真实值求绝对值后求均值）
mae = mean_absolute_error(predicted_move_y, real_move_y)
print('均方误差: %.6f' % mse)
print('均方根误差: %.6f' % rmse)
print('平均绝对误差: %.6f' % mae)
