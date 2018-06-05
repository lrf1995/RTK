function[CEPL95,CEPH95] =SATS(dx,dy,dz,rtker,m,CEPL,CEPH,sat)
% 计算CEP95值，画图，包括有效卫星数，DOOP值，误差结果等

cepl = sort(CEPL);
ceph = sort(CEPH);
CEPL95 = cepl(floor(m*0.95));
CEPH95 = ceph(floor(m*0.95));

%% 画可见卫星数
figure(1)
plot(sat,'.black');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('可见卫星数','Fontname','宋体','Fontsize',12);

%% 画整体误差曲线
figure(2)
subplot 311 %注：将画图区域分成2行1列，y1关于t的函数图像画在第一行第一列
plot(dx,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('x轴误差/m','Fontname','宋体','Fontsize',12)

subplot 312 %注：将画图区域分成2行1列，y2关于t的函数图像画在第二行第一列
plot(dy,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('y轴误差/m','Fontname','宋体','Fontsize',12);

subplot  313
plot(dz,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('z轴误差/m','Fontname','宋体','Fontsize',12);

%% 画固定后的误差曲线
figure(3)
subplot 311 %注：将画图区域分成2行1列，y1关于t的函数图像画在第一行第一列
plot(rtker.dxc,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('x轴误差/m','Fontname','宋体','Fontsize',12)

subplot 312 %注：将画图区域分成2行1列，y2关于t的函数图像画在第二行第一列
plot(rtker.dyc,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('y轴误差/m','Fontname','宋体','Fontsize',12);

subplot  313
plot(rtker.dzc,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('z轴误差/m','Fontname','宋体','Fontsize',12);



%% 输出CEP95值

fprintf('CEPH95为%.8f\n',CEPL95);
fprintf('CEPH95为%.8f\n',CEPH95);

end