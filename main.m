
x0=[-2364337.4414;4870285.6211;-3360809.6724];
% x1=[-2364335.4220;4870281.4604;-3360816.7056];
x1 = x0;
wrong=0;
correct=0;
% [navdata]=readnavfile;                              %得到卫星的星历文件nav
% [basedata]=readbasefile;                            %得到基站接收机星历文件base
% [obsdata]=readobsfile;                        %得到用户接收机星历文件obs

load('00394_19cut0cut2.mat');

a=6378137;
f=1/298.257223563;
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

h=waitbar(0,'请等待...');
group=2880;
for m=1:group
    [basesat,basenum]=SateposAndC1c(navdata,basedata,x0,S,m);
    [movesat,obsnum] =SateposAndC1c(navdata,obsdata,x0,S,m);
      
    [singaldiff,satnum,maxnum]=SD(basesat,basenum,movesat,obsnum,x0);
    [N,d,Qxn,Qn]=DD(singaldiff,satnum,maxnum);
    %%  模糊度固定
    clear afixed sqnorm Ps Qzhat Z nfixed mu;
    [afixed,sqnorm,Ps,Qzhat,Z,nfixed,mu]= LAMBDA (N,Qn,6,'MU',1/3);
    proba(m)=(nfixed==(satnum-1));
    clear Nf;
    Nf =afixed(:,1);
    %% 修正基线
    df=d-Qxn/Qn*(N-Nf);
    pos=x0+df;
    if(proba(m)==0)
        wrong=wrong+1;
        x(m) = pos(1);
        y(m) = pos(2);
        z(m) = pos(3);
    else
        correct=correct+1;
        P(correct)=Ps;
        Dp(:,correct)=df;
        %% 修正后的坐标值
        x(m) = pos(1);
        y(m) = pos(2);
        z(m) = pos(3);
    end
    %% 求取CEP
    dx(m) = pos(1)-x1(1);
    dy(m) = pos(2)-x1(2);
    dz(m) = pos(3)-x1(3);
%     Dx(correct)=df(1);
    env=S*[dx(m);dy(m);dz(m)];
    CEPL(m) = sqrt(env(1)^2+env(2)^2) ;
    CEPH(m) = env(3);
    
    st(m) = satnum;
    string = ['正在运行中',num2str(floor(m/group*100)),'%'];
    waitbar(m/group,h,string);
end
close(h);
cepl = sort(CEPL);
ceph = sort(CEPH);
CEPL95 = cepl(floor(2880*0.95));
CEPH95 = ceph(floor(2880*0.95));
figure(1)
plot(st,'black')

figure(2)
plot(dx,'.blue')
hold on;
plot(dy,'.green')
hold on;
plot(dz,'.red')

