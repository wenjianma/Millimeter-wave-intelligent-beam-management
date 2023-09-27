x0 = 0;
y0 = 0;
vx0 = 0;
vy0 = 0;
t0 =0;
tf = 100000; %结束时间
ax = randi([-1,1],1,tf+1)/10; %产生-1到1之间的均匀随机数作为运动加速度
ay = randi([-1,1],1,tf+1)/10;
x=[0];
y=[0];
for tx= t0:tf
   vx=ax(tx+1)+vx0;
   vx0 = vx;
   x=[x vx+x0];
   x0 = x(end);
end

for ty= t0:tf
   vy=ay(ty+1)+vy0;
   vy0 = vy;
   y=[y vy+y0];
   y0 = y(end);
end

figure(1)%x方向位移和时间关系
plot([0:tf+1],x)
box off

figure(2)
plot([0:tf+1],y)
box off

figure(3)%运动轨迹
scatter(x,y)
box off

   