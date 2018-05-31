function[CEPL95,CEPH95] =SATS(m,CEPL,CEPH,st)
% 计算CEP95值，画图，包括有效卫星数，DOOP值，误差结果等

cepl = sort(CEPL);
ceph = sort(CEPH);
CEPL95 = cepl(floor(m*0.95));
CEPH95 = ceph(floor(m*0.95));
figure(1)
plot(st,'black')

figure(2)
plot(dx,'.blue')
hold on;
plot(dy,'.green')
hold on;
plot(dz,'.red')

figure (3)
subplot 311     % 将画图区域分成3行1列，dx关于t的函数图像画在第三行第一列
plot(dx,'.r');
subplot 312     % 将画图区域分成3行1列，dy关于t的函数图像画在第三行第二列
plot(dy,'.b');
subplot  313    % 将画图区域分成3行1列，dz关于t的函数图像画在第三行第三列
plot(dz,'.y');

figure (4)
subplot 211     % 将画图区域分成3行1列，dx关于t的函数图像画在第三行第一列
plot(da1,'.r');
subplot 212     % 将画图区域分成3行1列，dy关于t的函数图像画在第三行第二列
plot(da2,'.r');


end