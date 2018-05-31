
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
=======
format long


%% 进行初始化，选择数据，选择导航系统
data = 10;    %选择数据
Global(2,1);   %全局变量判断导航系统GPS(1),BDS(2)


% [navdata,navfilepath]=readnavfile;                              %得到卫星的星历文件nav
% [basedata,basefilepath]=readobsfile;                            %得到基站接收机星历文件base
% [obsdata,movefilepath]=readobsfile;                             %得到用户接收机星历文件obs


switch (data)
    case 1
        x0=[-2364337.3977;4870285.6075;-3360809.7103];
        x1 = x0;
        load('14p16804_21cut0cut2.mat');
    case 2
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1 = x0;
        load('16p16804_24cut0cut2.mat');
    case 3
        x0= [-2364335.4220;4870281.4604;-3360816.7056];
        x1= [-2364337.4414;4870285.6211;-3360809.6724];
        load('16p16804_24cutacut0.mat');
    case 4
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1 = x0;
        load('14p04504_24cut0cut2.mat');
    case 5
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1 = [-2364335.4220;4870281.4604;-3360816.7056];
        load('14p04504_24cut0cuta.mat');
    case 6
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1= x0;
        load('16p32404_25cut1cut3.mat');
    case 7
        x0=[-2364337.3977;4870285.6075;-3360809.7103];
        x1 = x0;
        load('shuangpin14p16804_21cut0cut2.mat');
    case 8
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1 = x0;
        load('shuangpin15p03904_27cut0cut2.mat');
    case 9
        x1=[-2364335.4220;4870281.4604;-3360816.7056];
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        load('shuangpin16p16804_27cut0cuta.mat');
    case 10
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1 = [-2364333.5346;4870287.3393;-3360809.5251];
%         x2 = [-2364335.4220;4870281.4604;-3360816.7056];
        load('shuangpin16p16804_27cut0cutb.mat');    
        
        
end

global f a
e=sqrt(f*(2-f));
lambda=atan2(x0(2),x0(1));
phi=0;
for i=1:4
    N=a/sqrt(1-e^2*(sin(phi))^2);
    p=sqrt(x0(1)^2+x0(2)^2);
    h=p/cos(phi)-N;
    phi=atan(x0(3)/(p*(1-(N/(N+h))*e^2)));
>>>>>>> 6f5807de520a9ca214bad1d746416bfd79fdf586
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




