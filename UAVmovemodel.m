
%% UAV Movement Model According to paper
%% 生成数据说明：
%速度在一个区间内（服从20-35m/s之间的均匀分布), 时刻的delta_T比原论文小一个数量级
%不断变换运动方向，纵向方向的角度在-pi/12到pi/12之间均匀分布，水平面方向的角度在-pi/6和pi/6之间均匀分布
%生成T_number个时刻的图像，用于训练
% UAV A的运动轨迹
T_number = 2000; %%时刻数
Loc = zeros(T_number,3); %% 第一列表示x坐标，第二列表示y坐标，第三列表示z坐标
Loc(1,1) = 150; Loc(1,2) = 150; Loc(1,3) = 300; %第一个时刻
angle_now_v = 0; angle_now_h = 0;
rng(4);
for i = 2:1:T_number
    velo_i_1 = 0.03*rand+0.04; % 上一时刻的速度 
    angle_i_1_h = (2/6)*pi*rand-(1/6)*pi; % 上一时刻的水平运动的角度 
    angle_now_h = angle_now_h+angle_i_1_h;
    
    angle_i_1_v = (2/12)*pi*rand-(1/12)*pi; % 上一时刻的垂直运动的角度 
    angle_now_v = angle_now_v+angle_i_1_v;
    
    random_i_1 = 0.001*randn; %上一时刻的随机量
    Loc(i,1) = Loc(i-1,1)+velo_i_1*cos(angle_now_v)*cos(angle_now_h)+random_i_1;
    Loc(i,2) = Loc(i-1,2)+velo_i_1*cos(angle_now_v)*sin(angle_now_h)+random_i_1;
    Loc(i,3) = Loc(i-1,3)+velo_i_1*sin(angle_now_v)+random_i_1;
end
% plot3(Loc(101:1850,1),Loc(101:1850,2),Loc(101:1850,3))

plot3(Loc(1751:2000,1), Loc(1751:2000,2), Loc(1751:2000,3), 'g')
hold on

 filename = 'UAVdata_A.xlsx';
 writematrix(Loc(1:2000,:),filename,'Sheet',1)
 
fileID = fopen('A_x_move.txt','w');
fprintf(fileID,"%f\n",Loc(:,1));
fclose(fileID);

fileID = fopen('A_y_move.txt','w');
fprintf(fileID,"%f\n",Loc(:,2));
fclose(fileID);

fileID = fopen('A_z_move.txt','w');
fprintf(fileID, "%f\n", Loc(:,3));
fclose(fileID);

%% UAV B的运动轨迹

T_number = 2000; %%时刻数
Loc1 = zeros(T_number,3); %% 第一列表示x坐标，第二列表示y坐标，第三列表示z坐标
Loc1(1,1) = 150; Loc1(1,2) = 150; Loc1(1,3) = 300; %第一个时刻
angle_now_v = 0; angle_now_h = 0;
rng(2);
for i = 2:1:T_number
    velo_i_1 = 0.03*rand+0.04; % 上一时刻的速度
    angle_i_1_h = (2/6)*pi*rand-(1/6)*pi; % 上一时刻的水平运动的角度
    angle_now_h = angle_now_h+angle_i_1_h;
    
    angle_i_1_v = (2/12)*pi*rand-(1/12)*pi; % 上一时刻的垂直运动的角度
    angle_now_v = angle_now_v+angle_i_1_v;
    
    random_i_1 = 0.001*randn; %上一时刻的随机量
    Loc1(i,1) = Loc1(i-1,1)+velo_i_1*cos(angle_now_v)*cos(angle_now_h)+random_i_1;
    Loc1(i,2) = Loc1(i-1,2)+velo_i_1*cos(angle_now_v)*sin(angle_now_h)+random_i_1;
    Loc1(i,3) = Loc1(i-1,3)+velo_i_1*sin(angle_now_v)+random_i_1;
end
%  plot3(Loc(101:1850,1),Loc(101:1850,2),Loc(101:1850,3))

plot3(Loc1(1751:2000,1), Loc1(1751:2000,2), Loc1(1751:2000,3),'r')

 filename = 'UAVdata_B.xlsx';
 writematrix(Loc1(1:2000,:),filename,'Sheet',1)
 
 fileID = fopen('B_x_move.txt','w');
fprintf(fileID,"%f\n",Loc1(:,1));
fclose(fileID);

fileID = fopen('B_y_move.txt','w');
fprintf(fileID,"%f\n",Loc1(:,2));
fclose(fileID);

fileID = fopen('B_z_move.txt','w');
fprintf(fileID, "%f\n", Loc1(:,3));
fclose(fileID);

dis = zeros(1,250);
for i = 1:1:250
    dis(1,i) = sqrt((Loc(i+1750,1)-Loc1(i+1750,1)).^2+(Loc(i+1750,2)-Loc1(i+1750,2)).^2+(Loc(i+1750,3)-Loc1(i+1750,3)).^2);
end

figure
plot(1:250,dis);




