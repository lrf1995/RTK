%% function[S,x,y,z]= rtkmain(data)
clear,clc
format long;

%{
--------------初始化-----------------
data = 1  ------ 选择数据             |
Global(1) -----  导航系统GPS          |
Global(2) -----  导航系统BDS          |
mode = 1  -----  意思为单频           |
mode = 2  -----  意思是双频           |
--------------初始化------------------
%}
%% 进行初始化
data = 10;
Global(2);
mode = 1 ;
%% 读取文件
% [navdata,navfilepath]=readnavfile;                              %得到卫星的星历文件nav
% [basedata,basefilepath]=readobsfile;                            %得到基站接收机星历文件base
% [obsdata,movefilepath]=readobsfile;                             %得到用户接收机星历文件obs

%% 选择数据
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
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1 = [-2364335.4220;4870281.4604;-3360816.7056];
        %         x2 = [-2364333.5346;4870287.3393;-3360809.5251];
        load('shuangpin16p16804_27cut0cuta.mat');
    case 10
        x0 = [-2364337.4414;4870285.6211;-3360809.6724];
        x1 = [-2364333.5346;4870287.3393;-3360809.5251];
        %         x2 = [-2364335.4220;4870281.4604;-3360816.7056];
        load('shuangpin16p16804_27cut0cutb.mat');
    case 11
        x0 = [-2364335.4220;4870281.4604;-3360816.7056];
        x1 = [-2364333.5346;4870287.3393;-3360809.5251];
        load('shuangpin16p16804_27cutacutb.mat');
end

%% 计算前的参数求取
global f a

e=sqrt(f*(2-f));
lambda=atan2(x0(2),x0(1));
phi=0;
for i=1:4
    N=a/sqrt(1-e^2*(sin(phi))^2);
    p=sqrt(x0(1)^2+x0(2)^2);
    h=p/cos(phi)-N;
    phi=atan(x0(3)/(p*(1-(N/(N+h))*e^2)));
end
S=[-sin(lambda) cos(lambda) 0;...
    -sin(phi)*cos(lambda) -sin(phi)*sin(lambda) cos(phi);...
    cos(phi)*cos(lambda) cos(phi)*sin(lambda) sin(phi)];

%% RTK

wrong=0;
correct=0;
h=waitbar(0,'请等待...');
group=2880;
for m=1:group
    for (mode ==1)
        [basesat,basenum]=SateposAndC1c(navdata,basedata,x0,S,m);
        [movesat,obsnum] =SateposAndC1c(navdata,obsdata,x0,S,m);
        [singaldiff,satnum,maxnum]=SD(basesat,basenum,movesat,obsnum,x0);
        [N,d,Qxn,Qn]=DD(singaldiff,satnum,maxnum);
        clear afixed sqnorm Ps Qzhat Z nfixed mu;
        [afixed,sqnorm,Ps,Qzhat,Z,nfixed,mu]= LAMBDA (N,Qn,6,'MU',1/3);
        proba(m)=(nfixed==(satnum-1));
        clear Nf;
        Nf =afixed(:,1);
        % --- 修正基线 --- %
        df=d-Qxn/Qn*(N-Nf);
        pos=x0+df;
        if(proba(m)==0)
            % --未固定的以真实坐标为结果-- %
            wrong=wrong+1;
            x(m) = x1(1);
            y(m) = x1(2);
            z(m) = x1(3);
        else
            % --修正后的坐标值-- %
            correct=correct+1;
            P(correct)=Ps;
            Dp(:,correct)=df;
            x(m) = pos(1);
            y(m) = pos(2);
            z(m) = pos(3);
        end
        dx(m) = x(m)-x1(1);
        dy(m) = y(m)-x1(2);
        dz(m) = z(m)-x1(3);
       
        % --- 求取CEP -- %
        env=S*[dx(m);dy(m);dz(m)];
        CEPL(m) = sqrt(env(1)^2+env(2)^2) ;
        CEPH(m) = env(3);
        
        % --- 卫星数目 --- %
        st(m) = satnum;
        string = ['正在运行中',num2str(floor(m/group*100)),'%'];
        waitbar(m/group,h,string);
    end
end
    close(h);

    %%
    
    
    
    %%
    
    
    %%
    
    
    
    
    
    
    
    
    %%
    
    
    
    
