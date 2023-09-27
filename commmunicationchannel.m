%% 首先计算信道矩阵
% 基本参数：signal propagation speed  c = 3*e8  center carrier frequency fc = 30ghz 
 
%先仿真A (M=16) 与 B (N=16) 

fileID = fopen('A_x_pre.txt','r');
A_x_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('A_y_pre.txt','r');
A_y_pre = fscanf(fileID, "%f");
fclose(fileID);

fileID = fopen('B_x_move.txt','r');
B_x_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('B_y_move.txt','r');
B_y_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('A_x_move.txt','r');
A_x_move = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('A_y_move.txt','r');
A_y_move = fscanf(fileID,"%f");
fclose(fileID);

%kalman filter的结果
fileID = fopen('kalmanx.txt','r');
A_x_pre1 = fscanf(fileID,"%f");
fclose(fileID);

fileID = fopen('kalmany.txt','r');
A_y_pre1 = fscanf(fileID,"%f");
fclose(fileID);

plot(A_x_pre,A_y_pre,'b');
hold on
plot(A_x_pre1(1781:2000),A_y_pre1(1781:2000),'r');
hold on 
plot(A_x_move(1781:2000),A_y_move(1781:2000),'y');
hold on
plot(B_x_move(1781:2000),B_y_move(1781:2000));
hold on

%%
c = 3*1e8; 
fc = 30*1e9;
M = 16;
N = 16;
dc = fc/(2*c);
numda = 2*dc;

cita = zeros(1,220);
cita_est = zeros(1,220);
cita_est1 = zeros(1,220);
for i = 1:1:220
    %真实的cita
    dis = sqrt((B_x_move(i+1780)-A_x_move(i+1780))*(B_x_move(i+1780)-A_x_move(i+1780))+(B_y_move(i+1780)-A_y_move(i+1780))*(B_y_move(i+1780)-A_y_move(i+1780)));
    dis_x = B_x_move(i+1780)-A_x_move(i+1780);
    cita(1,i) = acos(dis_x/dis);
    
    %估计的cita
    dis = sqrt((B_x_move(i+1780)-A_x_pre(i))*(B_x_move(i+1780)-A_x_pre(i))+(B_y_move(i+1780)-A_y_pre(i))*(B_y_move(i+1780)-A_y_pre(i)));
    dis_x = B_x_move(i+1780)-A_x_pre(i);
    cita_est(1,i) = acos(dis_x/dis);
    
    %估计的cita1
    dis = sqrt((B_x_move(i+1780)-A_x_pre1(i+1780))*(B_x_move(i+1780)-A_x_pre1(i+1780))+(B_y_move(i+1780)-A_y_pre1(i+1780))*(B_y_move(i+1780)-A_y_pre1(i+1780)));
    dis_x = B_x_move(i+1780)-A_x_pre1(i+1780);
    cita_est1(1,i) = acos(dis_x/dis);
end

%构建a_cita和b_cita
a_cita = zeros(M,1);
b_cita = zeros(N,1);
b_cita_est = zeros(N,1);
b_cita_est1 = zeros(N,1);
for times=1:1:M
    a_cita(times,1) = sqrt(1/M)*exp(-1i*2*pi*dc*(times-1)*cos(cita(1,i))/numda);
end
for times=1:1:N
    b_cita(times,1) = sqrt(1/N)*exp(-1i*2*pi*dc*(times-1)*cos(cita(1,i))/numda);
end

for times=1:1:N
    b_cita_est(times,1) = sqrt(1/N)*exp(-1i*2*pi*dc*(times-1)*cos(cita_est(1,i))/numda);
end

for times=1:1:N
    b_cita_est1(times,1) = sqrt(1/N)*exp(-1i*2*pi*dc*(times-1)*cos(cita_est1(1,i))/numda);
end
%计算A与B之间的角度

%计算每个点的信道矩阵 每个点均为N*M
Hk = zeros(N,M,220);
for i = 1:1:220
    dis = sqrt((B_x_move(i+1780)-A_x_move(i+1780))*(B_x_move(i+1780)-A_x_move(i+1780))+(B_y_move(i+1780)-A_y_move(i+1780))*(B_y_move(i+1780)-A_y_move(i+1780)));
    Hk(:,:,i) = c/(4*pi*fc*dis)*b_cita*(a_cita');
end

%% 计算SNR,然后计算Rk
snr = zeros(1,220);
Rk = zeros(1,220);
snr_perfect = zeros(1,220);
Rk_perfect = zeros(1,220); %%perfect alignment 即cita_est = cita
snr_kalman = zeros(1,220); %kalman滤波出的情况
Rk_kalman = zeros(1,220);
signal_power = 100; %传递的信号功率为1
noise_power = 1e-9;
for i = 1:1:220
    dis = sqrt((B_x_move(i+1780)-A_x_move(i+1780))*(B_x_move(i+1780)-A_x_move(i+1780))+(B_y_move(i+1780)-A_y_move(i+1780))*(B_y_move(i+1780)-A_y_move(i+1780)));
    hk = c/(4*pi*fc*dis);
    snr(1,i) = signal_power*abs(hk*b_cita_est'*b_cita)*abs(hk*b_cita_est'*b_cita)/1e-9;
    Rk(1,i) = log2(1+snr(1,i));
    
    snr_perfect(1,i) = signal_power*abs(hk*(b_cita)'*b_cita)*abs(hk*(b_cita)'*b_cita)/1e-9;
    Rk_perfect(1,i) = log2(1+snr_perfect(1,i));
    
    snr_kalman(1,i) = signal_power*abs(hk*(b_cita_est1)'*b_cita)*abs(hk*(b_cita_est1)'*b_cita)/1e-9;
    Rk_kalman(1,i) = log2(1+snr_kalman(1,i));
end

figure
plot((1:220),Rk,'r');
axis([0 220 1 1.3]);
hold on
plot((1:220),Rk_perfect,'b');
hold on
plot((1:220),Rk_kalman,'g');
legend("LSTM","Perfect Alignment","Kalman");

dist= zeros(1,220);
for i =1:1:220
     dist(1,i) = sqrt((B_x_move(i+1780)-A_x_move(i+1780))*(B_x_move(i+1780)-A_x_move(i+1780))+(B_y_move(i+1780)-A_y_move(i+1780))*(B_y_move(i+1780)-A_y_move(i+1780)));
end

