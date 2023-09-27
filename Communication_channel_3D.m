%% 3维条件下的通信信道搭建并计算通信速率(R)
% 首先导入数据，A的真实值与预测值，B的真实值与预测值
% 然后计算A预测B，B预测A时的水平角度cita与竖直角度fai
% 带入公式计算R
%% 导入数据
% A的真实值
fileID = fopen('A_x_move.txt','r');
A_x_move = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_y_move.txt','r');
A_y_move = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_z_move.txt','r');
A_z_move = fscanf(fileID, "%f");
fclose(fileID);

%A的预测值
fileID = fopen('A_x_pre.txt','r');
A_x_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_y_pre.txt','r');
A_y_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_z_pre.txt','r');
A_z_pre = fscanf(fileID, "%f");
fclose(fileID);

% B的真实值
fileID = fopen('B_x_move.txt','r');
B_x_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_y_move.txt','r');
B_y_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_z_move.txt','r');
B_z_move = fscanf(fileID,"%f");
fclose(fileID);

%B的预测值
fileID = fopen('B_x_pre.txt','r');
B_x_pre = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_y_pre.txt','r');
B_y_pre = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_z_pre.txt','r');
B_z_pre = fscanf(fileID,"%f");
fclose(fileID);

%延时LSTM方法
%A的预测值
fileID = fopen('A_x_pre_delay.txt','r');
A_x_pre_delay = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_y_pre_delay.txt','r');
A_y_pre_delay = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_z_pre_delay.txt','r');
A_z_pre_delay = fscanf(fileID, "%f");
fclose(fileID);

%B的预测结果
fileID = fopen('B_x_pre_delay.txt','r');
B_x_pre_delay = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_y_pre_delay.txt','r');
B_y_pre_delay = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_z_pre_delay.txt','r');
B_z_pre_delay = fscanf(fileID,"%f");
fclose(fileID);

%kalman filter预测A的结果
fileID = fopen('kalman_a_x.txt','r');
A_x_pre_kalman = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('kalman_a_y.txt','r');
A_y_pre_kalman = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('kalman_a_z.txt','r');
A_z_pre_kalman = fscanf(fileID,"%f");
fclose(fileID);

%kalman filter预测B的结果
fileID = fopen('kalman_b_x.txt','r');
B_x_pre_kalman = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('kalman_b_y.txt','r');
B_y_pre_kalman = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('kalman_b_z.txt','r');
B_z_pre_kalman = fscanf(fileID,"%f");
fclose(fileID);

%画图

% plot3(B_x_pre,B_y_pre,B_z_pre,'b');
% hold on
% plot3(A_x_pre_kalman,A_y_pre_kalman,A_z_pre_kalman,'r');
% hold on
% plot3(B_x_pre_kalman,B_y_pre_kalman,B_z_pre_kalman,'r');
% hold on 
% plot3(A_x_move(1781:2000),A_y_move(1781:2000),A_z_move(1781:2000),'LineWidth',4,'Color',[0.8500 0.3250 0.0980]);
% hold on
% plot3(A_x_pre,A_y_pre,A_z_pre,'LineWidth',4,'Color',[0 0.4470 0.7410]);
% hold on
% % plot3(B_x_move(1781:2000),B_y_move(1781:2000),B_z_move(1781:2000),'LineWidth',4,'Color',[240/255,100/255,73/255]);
% % hold on
% plot3(A_x_pre_delay,A_y_pre_delay,A_z_pre_delay,'LineWidth',4,'Color',[0.4660 0.6740 0.1880]);
% % hold on
% % plot3(B_x_pre_delay,B_y_pre_delay,B_z_pre_delay);
% title('UAV A三维空间中的实际轨迹和预测轨迹','FontSize',14);
% grid;
% legend('实际轨迹','基于实时反馈的LSTM模型的预测轨迹','基于非实时反馈的LSTM模型的预测轨迹','FontSize',12);
% xlabel('米','FontSize',12);
% ylabel('米','FontSize',12);
% zlabel('米','FontSize',12);





% dis_pre_delay = zeros(220,1);
% dis_pre = zeros(220,1);
% dis_A_to_B_pre_delay = zeros(220,1);
% dis_A_to_B_pre = zeros(220,1);
% dis_A_to_B_real = zeros(220,1);
% angle_error = zeros(220,1);
% angle_error_delay = zeros(220,1);
% sum_pre_dis = 0;
% sum_pre_dis_delay = 0;
% sum_pre_angle = 0;
% sum_pre_angle_delay = 0;
% for kk = 1:1:220
%     dis_pre_delay(kk,1) = sqrt((B_x_pre_delay(kk,1)-B_x_move(kk+1780,1)).^2+(B_y_pre_delay(kk,1)-B_y_move(kk+1780,1)).^2+(B_z_pre_delay(kk,1)-B_z_move(kk+1780,1)).^2);
%     dis_pre(kk,1) = sqrt((B_x_pre(kk,1)-B_x_move(kk+1780,1)).^2+(B_y_pre(kk,1)-B_y_move(kk+1780,1)).^2+(B_z_pre(kk,1)-B_z_move(kk+1780,1)).^2);
%     dis_A_to_B_pre_delay(kk,1) = sqrt((B_x_pre_delay(kk,1)-A_x_move(kk+1780,1)).^2+(B_y_pre_delay(kk,1)-A_y_move(kk+1780,1)).^2+(B_z_pre_delay(kk,1)-A_z_move(kk+1780,1)).^2);
%     dis_A_to_B_pre(kk,1) = sqrt((B_x_pre(kk,1)-A_x_move(kk+1780,1)).^2+(B_y_pre(kk,1)-A_y_move(kk+1780,1)).^2+(B_z_pre(kk,1)-A_z_move(kk+1780,1)).^2);
%     dis_A_to_B_real(kk,1) = sqrt((B_x_move(kk+1780,1)-A_x_move(kk+1780,1)).^2+(B_y_move(kk+1780,1)-A_y_move(kk+1780,1)).^2+(B_z_move(kk+1780,1)-A_z_move(kk+1780,1)).^2);
%     angle_error(kk,1) = 57.30*acos((dis_A_to_B_real(kk,1).^2+dis_A_to_B_pre(kk,1).^2-dis_pre(kk,1).^2)/(2*dis_A_to_B_pre(kk,1)*dis_A_to_B_real(kk,1)));
%     angle_error_delay(kk,1) = 57.30*acos((dis_A_to_B_real(kk,1).^2+dis_A_to_B_pre_delay(kk,1).^2-dis_pre_delay(kk,1).^2)/(2*dis_A_to_B_pre_delay(kk,1)*dis_A_to_B_real(kk,1)));
%     sum_pre_dis = sum_pre_dis + dis_pre(kk,1);
%     sum_pre_dis_delay = sum_pre_dis_delay + dis_pre_delay(kk,1);
%     sum_pre_angle = sum_pre_angle+angle_error(kk,1);
%     sum_pre_angle_delay = sum_pre_angle_delay+angle_error_delay(kk,1);
% end
% sum_pre_dis = sum_pre_dis/220;
% sum_pre_dis_delay =sum_pre_dis_delay/220;
% sum_pre_angle = sum_pre_angle/220;
% sum_pre_angle_delay = sum_pre_angle_delay/220;
% figure ;
% plot((1:220),dis_pre(1:220,1),'LineWidth',4,'Color',[0.8500 0.3250 0.0980]);
% hold on
% plot((1:220),dis_pre_delay(1:220,1),'LineWidth',4,'Color',[0 0.4470 0.7410]);
% title('UAV A的预测距离误差','FontSize',14);
% legend('基于实时反馈的LSTM模型的预测距离误差','基于非实时反馈的LSTM模型的预测距离误差','FontSize',12);
% xlabel('时刻','FontSize',12);
% ylabel('米','FontSize',12);
% hold off
% 
% figure ;
% plot((1:220),angle_error(1:220,1),'LineWidth',4,'Color',[0.8500 0.3250 0.0980]);
% hold on
% plot((1:220),angle_error_delay(1:220,1),'LineWidth',4,'Color',[0 0.4470 0.7410]);
% title('UAV A的预测角度误差','FontSize',14);
% legend('基于实时反馈的LSTM模型的预测角度误差','基于非实时反馈的LSTM模型的预测角度误差','FontSize',12);
% xlabel('时刻','FontSize',12);
% ylabel('度','FontSize',12);
% hold off






%% 计算A发B收情况下：（1）完美对齐时的Rk  （2）LSTM方法预测时的Rk  （3）Kalman滤波方法预测时的Rk
% A发B收，A发射时需要去预测B的位置，B接受时需要去预测A的位置
% B发A收与A发B收有对称关系，Rk计算相同，只需计算一个方向即可

%% 基本参数设定
M = 48; %UAV A的天线数, UAV A为UPA，本代码把其垂直和水平的天线数都设为M 
N = 48; %UAV B的天线数，UAV B为UPA，本代码把其垂直和水平的天线数都设为N
c = 3*1e8; %光速
fc = 30*1e9; %中心速率，这里选择30Ghz

%% 计算A预测B与B预测A时的cita角与fai角情况
%计算完美对齐时cita角 
cita_perfect = zeros(1,220);
for i = 1:1:220
    dis_x = B_x_move(1780+i)-A_x_move(1780+i);
    dis = sqrt((B_x_move(1780+i)-A_x_move(1780+i))*(B_x_move(1780+i)-A_x_move(1780+i))+(B_y_move(1780+i)-A_y_move(1780+i))*(B_y_move(1780+i)-A_y_move(1780+i)));
    cita_perfect(1,i) = acos(dis_x/dis);
end

%计算LSTM预测时的cita角(A预测B)
A_pre_B_cita_lstm = zeros(1,220);
for i = 1:1:220
    dis_x = B_x_pre(i)-A_x_move(1780+i);
    dis = sqrt((B_x_pre(i)-A_x_move(1780+i))*(B_x_pre(i)-A_x_move(1780+i))+(B_y_pre(i)-A_y_move(1780+i))*(B_y_pre(i)-A_y_move(1780+i)));
    A_pre_B_cita_lstm(1,i) = acos(dis_x/dis);
end

%计算LSTM预测时的cita角(B预测A)
B_pre_A_cita_lstm = zeros(1,220);
for i = 1:1:220
    dis_x = A_x_pre(i)-B_x_move(1780+i);
    dis = sqrt((A_x_pre(i)-B_x_move(1780+i))*(A_x_pre(i)-B_x_move(1780+i))+(A_y_pre(i)-B_y_move(1780+i))*(A_y_pre(i)-B_y_move(1780+i)));
    B_pre_A_cita_lstm(1,i) = acos(dis_x/dis);
end

%计算LSTM预测时的cita角(A预测B)
A_pre_B_cita_lstm_delay = zeros(1,220);
for i = 1:1:220
    dis_x = B_x_pre_delay(i)-A_x_move(1780+i);
    dis = sqrt((B_x_pre_delay(i)-A_x_move(1780+i))*(B_x_pre_delay(i)-A_x_move(1780+i))+(B_y_pre_delay(i)-A_y_move(1780+i))*(B_y_pre_delay(i)-A_y_move(1780+i)));
    A_pre_B_cita_lstm_delay(1,i) = acos(dis_x/dis);
end

%计算LSTM延时预测时的cita角(B预测A)
B_pre_A_cita_lstm_delay = zeros(1,220);
for i = 1:1:220
    dis_x = A_x_pre_delay(i)-B_x_move(1780+i);
    dis = sqrt((A_x_pre_delay(i)-B_x_move(1780+i))*(A_x_pre_delay(i)-B_x_move(1780+i))+(A_y_pre_delay(i)-B_y_move(1780+i))*(A_y_pre_delay(i)-B_y_move(1780+i)));
    B_pre_A_cita_lstm_delay(1,i) = acos(dis_x/dis);
end

%计算kalman预测时的cita角(A预测B)
A_pre_B_cita_kalman = zeros(1,220);
for i = 1:1:220
    dis_x = B_x_pre_kalman(i)-A_x_move(1780+i);
    dis = sqrt((B_x_pre_kalman(i)-A_x_move(1780+i))*(B_x_pre_kalman(i)-A_x_move(1780+i))+(B_y_pre_kalman(i)-A_y_move(1780+i))*(B_y_pre_kalman(i)-A_y_move(1780+i)));
    A_pre_B_cita_kalman(1,i) = acos(dis_x/dis);
end

%计算kalman预测时的cita角(B预测A)
B_pre_A_cita_kalman = zeros(1,220);
for i = 1:1:220
    dis_x = A_x_pre_kalman(i)-B_x_move(1780+i);
    dis = sqrt((A_x_pre_kalman(i)-B_x_move(1780+i))*(A_x_pre_kalman(i)-B_x_move(1780+i))+(A_y_pre_kalman(i)-B_y_move(1780+i))*(A_y_pre_kalman(i)-B_y_move(1780+i)));
    B_pre_A_cita_kalman(1,i) = acos(dis_x/dis);
end

%计算完美对齐时的fai角 
fai_perfect = zeros(1,220);
for i = 1:1:220
    dis_x = B_z_move(1780+i)-A_z_move(1780+i);
    dis = sqrt((B_x_move(1780+i)-A_x_move(1780+i))*(B_x_move(1780+i)-A_x_move(1780+i))+(B_y_move(1780+i)-A_y_move(1780+i))*(B_y_move(1780+i)-A_y_move(1780+i))+(B_z_move(1780+i)-A_z_move(1780+i))*(B_z_move(1780+i)-A_z_move(1780+i)));
    fai_perfect(1,i) = asin(dis_x/dis);
end

%计算LSTM预测时的fai角(A预测B)
A_pre_B_fai_lstm = zeros(1,220);
for i = 1:1:220
    dis_x = B_z_pre(i)-A_z_move(1780+i);
    dis = sqrt((B_x_pre(i)-A_x_move(1780+i))*(B_x_pre(i)-A_x_move(1780+i))+(B_y_pre(i)-A_y_move(1780+i))*(B_y_pre(i)-A_y_move(1780+i))+(B_z_pre(i)-A_z_move(1780+i))*(B_z_pre(i)-A_z_move(1780+i)));
    A_pre_B_fai_lstm(1,i) = asin(dis_x/dis);
end

%计算LSTM预测时的fai角(B预测A)
B_pre_A_fai_lstm = zeros(1,220);
for i = 1:1:220
    dis_x = A_z_pre(i)-B_z_move(1780+i);
    dis = sqrt((A_x_pre(i)-B_x_move(1780+i))*(A_x_pre(i)-B_x_move(1780+i))+(A_y_pre(i)-B_y_move(1780+i))*(A_y_pre(i)-B_y_move(1780+i))+(A_z_pre(i)-B_z_move(1780+i))*(A_z_pre(i)-B_z_move(1780+i)));
    B_pre_A_fai_lstm(1,i) = asin(dis_x/dis);
end

%计算LSTM延时预测时的fai角(A预测B)
A_pre_B_fai_lstm_delay = zeros(1,220);
for i = 1:1:220
    dis_x = B_z_pre_delay(i)-A_z_move(1780+i);
    dis = sqrt((B_x_pre_delay(i)-A_x_move(1780+i))*(B_x_pre_delay(i)-A_x_move(1780+i))+(B_y_pre_delay(i)-A_y_move(1780+i))*(B_y_pre_delay(i)-A_y_move(1780+i))+(B_z_pre_delay(i)-A_z_move(1780+i))*(B_z_pre_delay(i)-A_z_move(1780+i)));
    A_pre_B_fai_lstm_delay(1,i) = asin(dis_x/dis);
end

%计算LSTM延时预测时的fai角(B预测A)
B_pre_A_fai_lstm_delay = zeros(1,220);
for i = 1:1:220
    dis_x = A_z_pre_delay(i)-B_z_move(1780+i);
    dis = sqrt((A_x_pre_delay(i)-B_x_move(1780+i))*(A_x_pre_delay(i)-B_x_move(1780+i))+(A_y_pre_delay(i)-B_y_move(1780+i))*(A_y_pre_delay(i)-B_y_move(1780+i))+(A_z_pre_delay(i)-B_z_move(1780+i))*(A_z_pre_delay(i)-B_z_move(1780+i)));
    B_pre_A_fai_lstm_delay(1,i) = asin(dis_x/dis);
end

%计算kalman预测时的fai角(A预测B)
A_pre_B_fai_kalman = zeros(1,220);
for i = 1:1:220
    dis_x = B_z_pre_kalman(i)-A_z_move(1780+i);
    dis = sqrt((B_x_pre_kalman(i)-A_x_move(1780+i))*(B_x_pre_kalman(i)-A_x_move(1780+i))+(B_y_pre_kalman(i)-A_y_move(1780+i))*(B_y_pre_kalman(i)-A_y_move(1780+i))+(B_z_pre_kalman(i)-A_z_move(1780+i))*(B_z_pre_kalman(i)-A_z_move(1780+i)));
    A_pre_B_fai_kalman(1,i) = asin(dis_x/dis);
end

%计算kalman预测时的fai角(B预测A)
B_pre_A_fai_kalman = zeros(1,220);
for i = 1:1:220
    dis_x = A_z_pre_kalman(i)-B_z_move(1780+i);
    dis = sqrt((A_x_pre_kalman(i)-B_x_move(1780+i))*(A_x_pre_kalman(i)-B_x_move(1780+i))+(A_y_pre_kalman(i)-B_y_move(1780+i))*(A_y_pre_kalman(i)-B_y_move(1780+i))+(A_z_pre_kalman(i)-B_z_move(1780+i))*(A_z_pre_kalman(i)-B_z_move(1780+i)));
    B_pre_A_fai_kalman(1,i) = asin(dis_x/dis);
end

%% 计算A发B收时，完美、LSTM、kalman分别的通信速率R
R_perfect = zeros(1,220);
R_lstm = zeros(1,220);
R_kalman = zeros(1,220);
R_lstm_delay = zeros(1,220);
path_loss_gain = zeros(1,220);

 for iter = 1:1:220

% b(cita,fai)属于是B对A的预测，应采用B_pre_A_....
% a(cita,fai)属于是A对B的预测，应采用A_pre_B_....

% 计算完美情况下的b_cita_fai_perfect
% 先计算b_az_perfect, 再计算b_el_perfect，则b_cita_fai_perfect = kron(b_az_perfect, b_el_perfect)
b_az_perfect = zeros(N,1);
b_el_perfect = zeros(N,1);
for times = 1:1:N
    b_az_perfect(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(cita_perfect(1,iter))*sin(fai_perfect(1,iter)));
    b_el_perfect(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(fai_perfect(1,iter)));
end
b_cita_fai_perfect = kron(b_az_perfect,b_el_perfect);
b_cita_fai_perfect = b_cita_fai_perfect.';

%计算LSTM预测情况下的b_cita_fai_lstm
b_az_lstm = zeros(N,1);
b_el_lstm = zeros(N,1);
for times = 1:1:N
    b_az_lstm(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(B_pre_A_cita_lstm(1,iter))*sin(B_pre_A_fai_lstm(1,iter)));
    b_el_lstm(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(B_pre_A_fai_lstm(1,iter)));
end
b_cita_fai_lstm = kron(b_az_lstm,b_el_lstm);
b_cita_fai_lstm = b_cita_fai_lstm.';

%计算LSTM延时预测情况下的b_cita_fai_lstm
b_az_lstm_delay = zeros(N,1);
b_el_lstm_delay = zeros(N,1);
for times = 1:1:N
    b_az_lstm_delay(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(B_pre_A_cita_lstm_delay(1,iter))*sin(B_pre_A_fai_lstm_delay(1,iter)));
    b_el_lstm_delay(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(B_pre_A_fai_lstm_delay(1,iter)));
end
b_cita_fai_lstm_delay = kron(b_az_lstm_delay,b_el_lstm_delay);
b_cita_fai_lstm_delay = b_cita_fai_lstm_delay.';

%计算kalman预测情况下的b_cita_fai_kalman
b_az_kalman = zeros(N,1);
b_el_kalman = zeros(N,1);
for times = 1:1:N
    b_az_kalman(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(B_pre_A_cita_kalman(1,iter))*sin(B_pre_A_fai_kalman(1,iter)));
    b_el_kalman(times,1) = sqrt(1/N)*exp(-1i*pi*(times-1)*cos(B_pre_A_fai_kalman(1,iter)));
end
b_cita_fai_kalman = kron(b_az_kalman,b_el_kalman);
b_cita_fai_kalman = b_cita_fai_kalman.';

%计算完美情况下的a_cita_fai_perfect
a_az_perfect = zeros(M,1);
a_el_perfect = zeros(M,1);
for times = 1:1:M
    a_az_perfect(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(cita_perfect(1,iter))*sin(fai_perfect(1,iter)));
    a_el_perfect(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(fai_perfect(1,iter)));
end
a_cita_fai_perfect = kron(a_az_perfect,a_el_perfect);
a_cita_fai_perfect =a_cita_fai_perfect.';

%计算LSTM预测情况下的a_cita_fai_lstm
a_az_lstm = zeros(M,1);
a_el_lstm = zeros(M,1);
for times = 1:1:M
    a_az_lstm(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(A_pre_B_cita_lstm(1,iter))*sin(A_pre_B_fai_lstm(1,iter)));
    a_el_lstm(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(A_pre_B_fai_lstm(1,iter)));
end
a_cita_fai_lstm = kron(a_az_lstm,a_el_lstm);
a_cita_fai_lstm = a_cita_fai_lstm.';

%计算LSTM延时预测情况下的a_cita_fai_lstm
a_az_lstm_delay = zeros(M,1);
a_el_lstm_delay = zeros(M,1);
for times = 1:1:M
    a_az_lstm_delay(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(A_pre_B_cita_lstm_delay(1,iter))*sin(A_pre_B_fai_lstm_delay(1,iter)));
    a_el_lstm_delay(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(A_pre_B_fai_lstm_delay(1,iter)));
end
a_cita_fai_lstm_delay = kron(a_az_lstm_delay,a_el_lstm_delay);
a_cita_fai_lstm_delay = a_cita_fai_lstm_delay.';

%计算Kalman预测情况下的a_cita_fai_kalman
a_az_kalman = zeros(M,1);
a_el_kalman = zeros(M,1);
for times = 1:1:M
   a_az_kalman(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(A_pre_B_cita_kalman(1,iter))*sin(A_pre_B_fai_kalman(1,iter)));
   a_el_kalman(times,1) = sqrt(1/M)*exp(-1i*pi*(times-1)*cos(A_pre_B_fai_kalman(1,iter)));
end
a_cita_fai_kalman = kron(a_az_kalman,a_el_kalman);
a_cita_fai_kalman = a_cita_fai_kalman.';

%计算R_perfect
signal_power = 100;
noise_power = 1e-9;

%path_loss_gain以实际运动情况为准
path_loss_gain(1,iter) =c/(4*pi*fc*sqrt((A_x_move(1780+iter)-B_x_move(1780+iter))*(A_x_move(1780+iter)-B_x_move(1780+iter))+(A_y_move(iter+1780)-B_y_move(1780+iter))*(A_y_move(iter+1780)-B_y_move(1780+iter))+(A_z_move(iter+1780)-B_z_move(1780+iter))*(A_z_move(iter+1780)-B_z_move(1780+iter))));

R_perfect(1,iter) = log2(1+signal_power*abs((path_loss_gain(1,iter)*b_cita_fai_perfect*(b_cita_fai_perfect')*a_cita_fai_perfect*(a_cita_fai_perfect)')^2)/noise_power);

R_lstm(1,iter) = log2(1+signal_power*abs((path_loss_gain(1,iter)*b_cita_fai_perfect*(b_cita_fai_lstm')*a_cita_fai_perfect*(a_cita_fai_lstm)')^2)/noise_power);

R_kalman(1,iter) = log2(1+signal_power*abs((path_loss_gain(1,iter)*b_cita_fai_perfect*(b_cita_fai_kalman')*a_cita_fai_perfect*(a_cita_fai_kalman)')^2)/noise_power);

R_lstm_delay(1,iter) = log2(1+signal_power*abs((path_loss_gain(1,iter)*b_cita_fai_perfect*(b_cita_fai_lstm_delay')*a_cita_fai_perfect*(a_cita_fai_lstm_delay)')^2)/noise_power);
end

%画图
figure;
plot(1:200,R_perfect(1,1:200),'LineWidth',4,'Color',[0.8500 0.3250 0.0980]);
hold on
plot(1:200,R_lstm(1,1:200),'LineWidth',4,'Color',[0 0.4470 0.7410],'LineStyle','--');
hold on
plot(1:200,R_lstm_delay(1,1:200),'LineWidth',4,'Color',[0.4940 0.1840 0.5560],'LineStyle','--');
%hold on
%plot(1:200,R_kalman(1,1:200),'LineWidth',2,'Color',[0.4660 0.6740 0.1880],'LineStyle','--');
legend("完美对齐","基于实时反馈的LSTM模型","基于非实时反馈的LSTM模型");
xlabel("时刻");
ylabel("通信速率(bits/s/Hz)");
title("UAV A与UAV B通信时的通信速率")