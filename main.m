% function[S,x,y,z]= rtkmain(data)
clear,clc
format long;

%% 初始化
%{
--------------初始化-----------------
DOUBLESYS = 1 -- 选择双系统            |
DOUBLESYS = 2 -- 选择单系统            |
data = 1  ------ 选择数据              |
Global(1) -----  导航系统GPS           |
Global(2) -----  导航系统BDS           |
mode = 1  -----  意思为单频            |
mode = 2  -----  意思是双频            |
--------------初始化------------------
%}
prompt = '双系统选择    1=N   2=Y    : ';
DOUBLESYS = input(prompt);
if DOUBLESYS ==1
    %% 非双系统定位
    prompt = '系统选择     GPS=1  北斗=2 : ';
    sys = input(prompt);
    prompt = '模式选择     单频=1 双频=2 : ';
    mode = input(prompt);
    prompt = '数据选择                   : ';
    data = input(prompt);
    
    
    [x0,x1,dataname] = dataswitch(data);
    load(dataname);
    clear prompt ;
    
    %-----单频情况下利用单点定位求取未固定位置----%
    if (mode == 1)
        [SPx,SPy,SPz]=SP(x0,obsdata,navdata);
    end
    
    %-----RTK----%
    wrong=0;
    correct=0;
    h=waitbar(0,'请等待...');
    group=2880;
    
    %-----求取数据在不同系统间的转换矩阵S----%
    Global(sys);
    [S] = GetS(x0);
    
    for m=1:group
        [basesat,basenum]= SateposAndC1c(navdata,basedata,x0,S,m);
        [movesat,obsnum] = SateposAndC1c(navdata,obsdata,x0,S,m);
        [singaldiff,satnum,maxnum] = SD(basesat,basenum,movesat,obsnum,x0);
        if     (mode ==1)
            [N,d,Qxn,Qn,DDsatnum] = DDS(singaldiff,satnum,maxnum);
        elseif (mode ==2)
            [N,d,Qxn,Qn,DDsatnum] = DDD(singaldiff,satnum,maxnum);
        end
        %-----模糊度固定----%
        clear afixed sqnorm Ps Qzhat Z nfixed mu;
        [afixed,sqnorm,Ps,Qzhat,Z,nfixed,mu]= LAMBDA (N,Qn,6,'MU',1/3);
        proba(m)=(nfixed==DDsatnum);
        clear Nf;
        Nf =afixed(:,1);
        %------修正基线-----%
        df=d-Qxn/Qn*(N-Nf);
        pos=x0+df;
        if(proba(m)==0)
            wrong=wrong+1;
            if(mode == 1)
                totalpos.x(m) = SPx(m);
                totalpos.y(m) = SPy(m);
                totalpos.z(m) = SPz(m);
            else
                posDD = x0 + d ;
                totalpos.x(m) = posDD(1);
                totalpos. y(m) = posDD(2);
                totalpos.z(m) = posDD(3);
            end
        else
            correct=correct+1;
            P(correct)=Ps;
            Dp(:,correct)=df;
            %----修正后的坐标值----%
            totalpos.x(m) = pos(1);
            totalpos.y(m) = pos(2);
            totalpos.z(m) = pos(3);
            Corrpos.xc(correct) = pos(1);
            Corrpos.yc(correct) = pos(2);
            Corrpos.zc(correct) = pos(3);
        end
        %-----卫星数目----%
        st(m) = satnum;
        
        string = ['正在运行中',num2str(floor(m/group*100)),'%'];
        waitbar(m/group,h,string);
    end
    close(h);
    
else
    prompt = '模式选择     单频=1 双频=2 : ';
    mode = input(prompt);
    prompt = '数据选择                   : ';
    data = input(prompt);
    % 双系统下选择导航系统为3，既不是GPS,也不是北斗
    sys = 3 ;
    
    [x0,x1,dataname] = dataswitch(data);
    load(dataname);
    clear prompt ;
    
    %-----RTK----%
    wrong=0;
    correct=0;
    h=waitbar(0,'请等待...');
    group=2880;
    for m=1:group
        %% 双系统定位
        %-----求取数据在不同系统间的转换矩阵S----%
        Global(1);
        [S1] = GetS(x0);
        [basesatG,basenumG]= SateposAndC1c(navdata,basedata,x0,S1,m);
        [movesatG,obsnumG] = SateposAndC1c(navdata,obsdata,x0,S1,m);
        [singaldiffG,satnumG,maxnumG] = SD(basesatG,basenumG,movesatG,obsnumG,x0);
        [GMatrixDDD]=DDDDMatrix(singaldiffG,satnumG,maxnumG);
        %-----卫星数目----%
        st.stG(m) = GMatrixDDD.num;
        
        Global(2);
        [S2] = GetS(x0);
        [basesatC,basenumC]= SateposAndC1c(navdata,basedata,x0,S2,m);
        [movesatC,obsnumC] = SateposAndC1c(navdata,obsdata,x0,S2,m);
        [singaldiffC,satnumC,maxnumC] = SD(basesatC,basenumC,movesatC,obsnumC,x0);
        [CMatrixDDD]=DDDDMatrix(singaldiffC,satnumC,maxnumC);
        %-----卫星数目----%
        st.stC(m) = CMatrixDDD.num;
        
        if     (mode ==1)
            [N,d,Qxn,Qn,DDsatnum] = SILS(GMatrixDDD,CMatrixDDD);
        elseif (mode ==2)
            [N,d,Qxn,Qn,DDsatnum] = DILS(GMatrixDDD,CMatrixDDD);
        end
        clear afixed sqnorm Ps Qzhat Z nfixed mu;
        [afixed,sqnorm,Ps,Qzhat,Z,nfixed,mu]= LAMBDA (N,Qn,6,'MU',1/3);
        proba(m)=(nfixed==DDsatnum);
        clear Nf;
        Nf =afixed(:,1);
        %------修正基线-----%
        df=d-Qxn/Qn*(N-Nf);
        pos=x0+df;
        if(proba(m)==0)
            wrong=wrong+1;
            posDD = x0 + d ;
            totalpos.x(m) = posDD(1);
            totalpos.y(m) = posDD(2);
            totalpos.z(m) = posDD(3);
        else
            correct=correct+1;
            P(correct)=Ps;
            Dp(:,correct)=df;
            %----修正后的坐标值----%
            totalpos.x(m) = pos(1);
            totalpos.y(m) = pos(2);
            totalpos.z(m) = pos(3);
            Corrpos.xc(correct) = pos(1);
            Corrpos.yc(correct) = pos(2);
            Corrpos.zc(correct) = pos(3);
        end
        S = S1;
        string = ['正在运行中',num2str(floor(m/group*100)),'%'];
        waitbar(m/group,h,string);
    end
    close(h);
end
[CEPL95,CEPH95] =SATS(DOUBLESYS,sys,totalpos,Corrpos,x1,S,st);




