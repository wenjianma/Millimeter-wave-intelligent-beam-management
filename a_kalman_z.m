%% 生成数据说明：
%速度在一个区间内（服从20-35m/s之间的均匀分布）
%不断变换运动方向，纵向方向的角度在-pi/12到pi/12之间均匀分布，水平面方向的角度在-pi/6和pi/6之间均匀分布
%生成T_number个时刻的图像，用于训练
% UAV A的运动轨迹
T_number = 2000; %%时刻数
Loc = zeros(T_number,3); %% 第一列表示x坐标，第二列表示y坐标，第三列表示z坐标
Loc(1,1) = 150; Loc(1,2) = 150; Loc(1,3) = 300; %第一个时刻
angle_now_v = 0; angle_now_h = 0;
store_velo = zeros(1,T_number);
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
    store_velo(1,i) = velo_i_1*cos(angle_now_v)*cos(angle_now_h);
end

%% Kalman滤波
X = [300;0]; %状态矩阵，记录UAV A的x方向位置与x方向速度
P = [1 0 ; 0 1]; %状态协方差矩阵
F = [1 1; 0 1]; %状态转移矩阵
Q = [1 0; 0 1]; %状态协方差转移噪声矩阵
H = [1 0]; %观察矩阵
noise = 5*randn(1,T_number);
Pre_kalman = zeros(1,T_number);
for i = 6:1:T_number
    X_ = F*X;
    P_ = F*P*F'+Q;
    K = P_*H'/(H*P_*H');
    X = X_+K*(Loc(i-5,3)+noise(1,i)-H*X_);
    P = (eye(2)-K*H)*P_;
    Pre_kalman(1,i) = X(1);
end
plot(1:T_number,Pre_kalman);
hold on;
plot(1:T_number,Loc(:,3));
fileID = fopen("kalman_a_z.txt","w");
fprintf(fileID,"%f\n",Pre_kalman(1781:2000));
fclose(fileID);