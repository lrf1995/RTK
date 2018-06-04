
%% 求取cutb站WGS-84坐标
[S,xb,yb,zb]= rtkmain(10);
%% 求取基准角度
x0 = [-2364337.4414;4870285.6211;-3360809.6724];   %cut0坐标
x1 = [-2364333.5346;4870287.3393;-3360809.5251];   %cutb坐标
x2 = [-2364335.4220;4870281.4604;-3360816.7056];   %cuta坐标
[a10,a20]=datum(x0,x1,S);
s1=[1,0,0;0,cos(a20),sin(a20);0,-sin(a20),cos(a20)];
s2=[cos(a10),sin(a10),0;-sin(a10),cos(a10),0;0,0,1];
x2_LLSLLS =s1*s2*S*(x2-x0);
a30 = -atan(x2_LLSLLS(3)/x2_LLSLLS(1));
%% 求取航向角a10、俯仰角a20误差角度
for m1=1:2880
    x1L=[xb(m1);yb(m1);zb(m1)];
    [a1,a2]=datum(x0,x1L,S);
    a1(m1)=a1; %求取的航向角
    a2(m1)=a2; %求取的俯仰角
    da1(m1)=a1(m1)-a10;
    da2(m1)=a2(m1)-a20;
end

%% 求取cuta站WGS-84坐标
[S,xa,ya,za]= rtkmain(9);
%% 求取横滚角a30误差角度
for m2=1:2880
    x2L=[xa(m2);ya(m2);za(m2)];
    s1=[1,0,0;0,cos(a20),sin(a20);0,-sin(a20),cos(a20)];
    s2=[cos(a10),sin(a10),0;-sin(a10),cos(a10),0;0,0,1];
    x2_LLSLLS =s1*s2*S*(x2L-x0);
    a3(m2) = -atan(x2_LLSLLS(3)/x2_LLSLLS(1));
    da3(m2)=a3(m2)-a30;
end
figure (1) 
subplot 311     % 将画图区域分成3行1列，dx关于t的函数图像画在第三行第一列
plot(da1,'.r');
subplot 312     % 将画图区域分成3行1列，dy关于t的函数图像画在第三行第二列
plot(da2,'.b');
subplot  313    % 将画图区域分成3行1列，dz关于t的函数图像画在第三行第三列
plot(da3,'.y');




