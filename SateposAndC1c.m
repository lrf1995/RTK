function[satdata,satnum]=SateposAndC1c(navdata,initdata,x0,S,m)
% 计算卫星的坐标及接收机伪距
global flag lamda u OMEGAdote cs ; %地球自转角速度
a1=m;
satnum=0;
match = 0;%判断星历是否匹配
gpsnav = length(navdata.system(flag).gps) ;%星历的个数
for a2=1:initdata.system(flag).epoch(a1).satnum
    P = initdata.system(flag).epoch(a1).gps(a2).C1C;
    F = initdata.system(flag).epoch(a1).gps(a2).L1C;
    if (isnan(P)||isnan(F)||(F==0)||(P==0)),continue;end      %判断数据的伪距和载波是否有数 
    for a3=1:gpsnav
        %   计算规划时间tk
        if(initdata.system(flag).epoch(a1).gps(a2).prn==navdata.system(flag).gps(a3).prn)
            
            tk = (initdata.system(flag).epoch(a1).gpst(1)-navdata.system(flag).gps(a3).gpst(1))*604800 + ...
                initdata.system(flag).epoch(a1).gpst(2)-navdata.system(flag).gps(a3).toe - P/299792458;
            if (tk > 302400)
                tk = tk - 604800;
            elseif (tk<-302400)
                tk = tk + 604800;
            end
            if (abs(tk)<7200),break;end
        end
        
        %% 无匹配导航文件
         if(a3 == gpsnav),match = 1;end
    end
     if(match==1)
        match=0;
        continue;
    end

    num = navdata.system(flag).gps(a3).prn;
    toe=navdata.system(flag).gps(a3).toe;
    %         t=basedata.epoch(a1).gps(a2).gpst-basedata.epoch(a1).gps(a2).CLC/299792458;
    as=(navdata.system(flag).gps(a3).sqrtas)^2;
    es=navdata.system(flag).gps(a3).es;
    io=navdata.system(flag).gps(a3).io;
    OMGAo=navdata.system(flag).gps(a3).OMGAo;
    w=navdata.system(flag).gps(a3).w;
    Mo=navdata.system(flag).gps(a3).Mo;
    deltn=navdata.system(flag).gps(a3).deltn;
    dti=navdata.system(flag).gps(a3).dti;
    dtOMGA=navdata.system(flag).gps(a3).dtOMGA;
    Cuc=navdata.system(flag).gps(a3).Cuc;
    Cus=navdata.system(flag).gps(a3).Cus;
    Crc=navdata.system(flag).gps(a3).Crc;
    Crs=navdata.system(flag).gps(a3).Crs;
    Cic=navdata.system(flag).gps(a3). Cic;
    Cis=navdata.system(flag).gps(a3).Cis;
    
    %  2.计算卫星的平均角速度
    no=sqrt(u/(as^3));
    n=no+deltn;
    %  3.计算信号发射时的平近角Mk
    Mk=Mo+n*tk;
    while(Mk<0||Mk>2*pi)
        if(Mk<0)
            Mk=Mk+2*pi;
        else
            Mk=Mk-2*pi;
        end
    end
    %  4.计算信号发射时刻的偏近角E
    Ek = Mk;
    while(1)
        E0 = Ek;
        Ek = Mk+es*sin(E0);
        if(abs(Ek-E0)<1e-12),break;end
    end
    
    %  5.计算信号发射时刻的真近点角vk
    cosvk=((cos(Ek)-es)/(1-es*cos(Ek)));
    sinvk=(sqrt(1-es^2))*sin(Ek)/(1-es*cos(Ek));
    vk=atan2(sinvk,cosvk);
    %  6.计算信号发射时刻的升交点角距Faik
    Faik=vk+w;
    %  7.计算信号发射时刻的摄动校正项Deltuk,Deltrk,Deltik
    Deltuk=Cus*sin(2*Faik)+Cuc*cos(2*Faik);
    Deltrk=Crs*sin(2*Faik)+Crc*cos(2*Faik);
    Deltik=Cis*sin(2*Faik)+Cic*cos(2*Faik);
    %  8.计算摄动校正后的升交点角距uk、卫星矢径长度rk、ik
    uk=Faik+Deltuk;
    rk=as*(1-es*cos(Ek))+Deltrk;
    ik=io+dti*tk+Deltik;
    %   9.计算信号发射时刻卫星在轨道平面的位置（xk1,yk1）
    xk1=rk*cos(uk);
    yk1=rk*sin(uk);
        %   10.计算信号发射时刻的升交点赤经OMGAk
        OMGAk=OMGAo+(dtOMGA-OMEGAdote)*tk-OMEGAdote*toe;
        %   11.计算卫星在WGS-84地心地固直角坐标系（Xt,Yt,Zt）中的坐标（X,Y,Z）
        X=xk1*cos(OMGAk)-yk1*cos(ik)*sin(OMGAk);
        Y=xk1*sin(OMGAk)+yk1*cos(ik)*cos(OMGAk);
        Z=yk1*sin(ik);
%% BDS进行GEO/MEO、IGSO的判断，从而求取位置
    if  (flag == 2)
        %% 判断卫星是GEO卫星还是MEO/IGSO卫星
        if num<6
         n1 = 5/180*pi;  %geo旋转角度弧度
         pos = [cos(OMEGAdote*tk)  sin(OMEGAdote*tk)  0;....
                -sin(OMEGAdote*tk) cos(OMEGAdote*tk)  0;
                0   0  1 ]*[1 0 0;0 cos(-n1)  sin(-n1);0 -sin(-n1) cos(-n1)] ...
                *[cos(-OMEGAdote*tk)  sin(-OMEGAdote*tk)  0;....
                -sin(-OMEGAdote*tk) cos(-OMEGAdote*tk)  0;0   0  1 ]*[X;Y;Z];
            X=pos(1);
            Y=pos(2);
            Z=pos(3);
            
        end
    end
    
    % 从发射时间转换到接收时间坐标系
    dw = OMEGAdote*(initdata.system(flag).epoch(a1).gps(a2).C1C/cs);%传播时间转过的角度
    cw = cos(dw);sw = sin(dw);
    anglepos=[cw sw 0;-sw cw 0;0 0 1]*[X;Y;Z];
    % 计算高度角 thet
    
    %我的改变
    D=anglepos-x0;
    E=S*D;
    theta=asin(E(3)/sqrt(E(1)^2+E(2)^2+E(3)^2));
    
    if theta>(5*pi/180)
        satnum = satnum+1;
        % 计算即在概略点处据卫星的距离与基站与卫星距离差、Ru、卫星角度theta
       
        satdata(satnum).xs=X;        %根据用户接收机计算得到的卫星坐标(xus,yus,zus)
        satdata(satnum).ys=Y;
        satdata(satnum).zs=Z;
        satdata(satnum).prn = initdata.system(flag).epoch(a1).gps(a2).prn;
        satdata(satnum).theta =theta;
        sbr=sqrt((X-x0(1))^2+(Y-x0(2))^2+(Z-x0(3))^2);
        satdata(satnum).pc = P-sbr;
        satdata(satnum).FC = F*lamda-sbr;
        
    end
    
    
    
end



