function[DA1CEP95,DA2CEP95,DA3CEP95] =ADSATS(da1,da2,correct1,da3,correct2)
% 姿态误差图以及误差的CEP95值

cep1 = sort(da1);
cep2 = sort(da2);
cep3 = sort(da3);

%% 误差da1、da2、da3的CEP95值
DA1CEP95 = cep1(floor(correct1*0.95));
DA2CEP95 = cep2(floor(correct1*0.95));
DA3CEP95 = cep3(floor(correct2*0.95));

fprintf('误差da1的CEP95值为%.8f\n',DA1CEP95);
fprintf('误差da2的CEP95值为%.8f\n',DA2CEP95);
fprintf('误差da3的CEP95值为%.8f\n',DA3CEP95);


%% 画固定后的误差曲线
figure(1)
subplot 311
plot(da1,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('航向角误差/°','Fontname','宋体','Fontsize',12)

subplot 312 
plot(da2,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('俯仰角误差/°','Fontname','宋体','Fontsize',14);

subplot  313
plot(da3,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('横滚角误差/°','Fontname','宋体','Fontsize',14);

figure(2)

plot(da1,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('历元','Fontname','宋体','Fontsize',12);
ylabel('航向角误差/°','Fontname','宋体','Fontsize',12)

figure(3)
plot(da2,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('俯仰角误差/°','Fontname','宋体','Fontsize',14);

figure(4)
plot(da3,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('历元','Fontname','宋体','Fontsize',14);
ylabel('横滚角误差/°','Fontname','宋体','Fontsize',14);



end