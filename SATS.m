function[CEPL95,CEPH95] =SATS(DOUBLESYS,sys,totalpos,Corrpos,x1,S,sat)
% 计算CEP95值，画图，包括有效卫星数，DOOP值，误差结果等

%--- 求取误差--%
dx = totalpos.x-x1(1);
dy = totalpos.y-x1(2);
dz = totalpos.z-x1(3);

rtker.dxc = Corrpos.xc-x1(1);
rtker.dyc = Corrpos.yc-x1(2);
rtker.dzc = Corrpos.zc-x1(3);
%-----求取CEP95(固定后的)----%
for m =1:length(rtker.dxc)
    env=S*[rtker.dxc(m);rtker.dyc(m);rtker.dzc(m)];
    CEPL(m) = sqrt(env(1)^2+env(2)^2) ;
    CEPH(m) = env(3);
end
cepl = sort(CEPL);
ceph = sort(CEPH);
CEPL95 = cepl(floor(m*0.95));
CEPH95 = ceph(floor(m*0.95));
fprintf('CEPH95为%.8fm\n',CEPL95);
fprintf('CEPH95为%.8fm\n',CEPH95);

%% 画整体误差曲线
figure(1)
subplot 311 %注：将画图区域分成2行1列，y1关于t的函数图像画在第一行第一列
plot(dx,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('x轴误差/m','Fontname','宋体','Fontsize',14)

subplot 312 %注：将画图区域分成2行1列，y2关于t的函数图像画在第二行第一列
plot(dy,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('y轴误差/m','Fontname','宋体','Fontsize',14);

subplot  313
plot(dz,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('z轴误差/m','Fontname','宋体','Fontsize',14);

%% 画固定后的误差曲线
figure(2)
subplot 311 %注：将画图区域分成2行1列，y1关于t的函数图像画在第一行第一列
plot(rtker.dxc,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('x轴误差/m','Fontname','宋体','Fontsize',14)

subplot 312 %注：将画图区域分成2行1列，y2关于t的函数图像画在第二行第一列
plot(rtker.dyc,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('y轴误差/m','Fontname','宋体','Fontsize',14);

subplot  313
plot(rtker.dzc,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('z轴误差/m','Fontname','宋体','Fontsize',14);

if (DOUBLESYS==1)
    %% 画单系统可见卫星数
    if (sys==1)
        figure(3)
        plot(sat,'.black');
        set(0,'defaultfigurecolor','w')
        set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
        xlabel('历元','Fontname','宋体','Fontsize',14);
        ylabel('GPS可见卫星数','Fontname','宋体','Fontsize',14);
    else
        figure(3)
        plot(sat,'.black');
        set(0,'defaultfigurecolor','w')
        set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
        xlabel('历元','Fontname','宋体','Fontsize',14);
        ylabel('北斗可见卫星数','Fontname','宋体','Fontsize',14);
    end
else
    %% 画双系统可见卫星数
    figure(3)
    plot(sat.stG,'.black');
    set(0,'defaultfigurecolor','w')
    set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
    xlabel('历元','Fontname','宋体','Fontsize',14);
    ylabel('GPS可见卫星数','Fontname','宋体','Fontsize',14);
    figure(4)
    plot(sat.stC,'.black');
    set(0,'defaultfigurecolor','w')
    set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
    xlabel('历元','Fontname','宋体','Fontsize',14);
    ylabel('北斗可见卫星数','Fontname','宋体','Fontsize',14);
end
end