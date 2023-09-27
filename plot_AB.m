%% 读取A预测值
fileID = fopen('A_x_pre.txt','r');
A_x_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_y_pre.txt','r');
A_y_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_z_pre.txt','r');
A_z_pre = fscanf(fileID, "%f");
fclose(fileID);

plot3(A_x_pre,A_y_pre,A_z_pre);

%% 读取A真实值
fileID = fopen('A_x_move.txt','r');
A_x_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('A_y_move.txt','r');
A_y_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('A_z_move.txt','r');
A_z_move = fscanf(fileID,"%f");
fclose(fileID);

hold on
plot3(A_x_move(1781:2000,1), A_y_move(1781:2000,1), A_z_move(1781:2000,1));

%% 读取B预测值
fileID = fopen('B_x_pre.txt','r');
B_x_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('B_y_pre.txt','r');
B_y_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('B_z_pre.txt','r');
B_z_pre = fscanf(fileID, "%f");
fclose(fileID);

plot3(B_x_pre,B_y_pre,B_z_pre);

%% 读取B真实值
fileID = fopen('B_x_move.txt','r');
B_x_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_y_move.txt','r');
B_y_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_z_move.txt','r');
B_z_move = fscanf(fileID,"%f");
fclose(fileID);

hold on
plot3(B_x_move(1781:2000,1), B_y_move(1781:2000,1), B_z_move(1781:2000,1));
title("A与B的轨迹图");
legend("A的预测值","A的真实值","B的预测值","B的真实值");
xlabel("米")
ylabel("米")
zlabel("米")


%% 计算角度误差估计和距离误差估计
%只计算了A的
%(1)角度误差—>空间中的角度问题->余弦定理求出
dis_a = zeros(1,220);
dis_b = zeros(1,220);
dis_c = zeros(1,220);
cta = zeros(1,220);
val = zeros(1,220);
beamwidth = zeros(1,220);
for i = 1:1:220
    dis_a(1,i) =  sqrt((A_x_pre(i)-A_x_move(1780+i))*(A_x_pre(i)-A_x_move(1780+i))+ (A_y_pre(i)-A_y_move(1780+i))*(A_y_pre(i)-A_y_move(1780+i)) + (A_z_pre(i)-A_z_move(1780+i))*(A_z_pre(i)-A_z_move(1780+i)));
    dis_b(1,i) =  sqrt((A_x_pre(i)-B_x_move(1780+i))*(A_x_pre(i)-B_x_move(1780+i))+ (A_y_pre(i)-B_y_move(1780+i))*(A_y_pre(i)-B_y_move(1780+i)) + (A_z_pre(i)-B_z_move(1780+i))*(A_z_pre(i)-B_z_move(1780+i)));
    dis_c(1,i) =  sqrt((A_x_move(1780+i)-B_x_move(1780+i))*(A_x_move(1780+i)-B_x_move(1780+i))+ (A_y_move(i+1780)-B_y_move(1780+i))*(A_y_move(1780+i)-B_y_move(1780+i)) + (A_z_move(1780+i)-B_z_move(1780+i))*(A_z_move(1780+i)-B_z_move(1780+i)));
    val(1,i) = abs((dis_a(1,i)*dis_a(1,i)-dis_b(1,i)*dis_b(1,i)-dis_c(1,i)*dis_c(1,i))/(2*dis_b(1,i)*dis_c(1,i)));
    cta(1,i) = acos(val(1,i))*57.295;
    beamwidth(1,i) = dis_c(1,i)*sin(cta(1,i));
end
figure
plot(1:220,cta);
title("A的误差角度");
ylabel("角度");
xlabel("时刻");
% figure
% plot(1:220,beamwidth);
% title("beamwidth")

%（2）距离误差—>A: A的真实路径与预测路径的距离差与真实路径到对应时刻B的距离的比值
dis_rate = zeros(1,220);
dis = zeros(1,220);
err_dis = zeros(1,220);
for i = 1:1:220
    err_dis(1,i) = sqrt((A_x_pre(i)-A_x_move(1780+i))*(A_x_pre(i)-A_x_move(1780+i))+ (A_y_pre(i)-A_y_move(1780+i))*(A_y_pre(i)-A_y_move(1780+i)) + (A_z_pre(i)-A_z_move(1780+i))*(A_z_pre(i)-A_z_move(1780+i)));
    dis(1,i) = sqrt((A_x_move(1780+i)-B_x_move(1780+i))*(A_x_move(1780+i)-B_x_move(1780+i)) + (A_y_move(1780+i)-B_y_move(1780+i))*(A_y_move(1780+i)-B_y_move(1780+i)) + (A_z_move(1780+i)-B_z_move(1780+i))*(A_z_move(1780+i)-B_z_move(1780+i)));
    dis_rate(1,i) = err_dis/dis;
end
figure
plot(1:220,err_dis)
title("A的绝对距离误差")

figure
plot(1:220,dis_rate)
title("A相对距离误差")



