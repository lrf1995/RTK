    function[satdata,satnum]=SateposAndC1c(navdata,initdata,x0,S,m)
% 计算卫星的坐标及接收机伪距
OMEGAdote = 7.2921151467e-5;%地球自转角速度
a1=m;
satnum=0;
for a2=1:initdata.epoch(a1).gpsobs
     P = initdata.epoch(a1).gps(a2).CLC;
     F = initdata.epoch(a1).gps(a2).L1C;
     if (isnan(P)||isnan(F)||(F==0)||(P==0)),continue;end      %判断数据的伪距和载波是否有数 
        for a3=1:length(navdata.gps)           
         if(initdata.epoch(a1).gps(a2).prn==navdata.gps(a3).prn)
            tk = (initdata.epoch(a1).gps(a2).gpst(1)-navdata.gps(a3).gpst(1))*604800 + ...
                  initdata.epoch(a1).gps(a2).gpst(2)-navdata.gps(a3).toe - P/299792458;
              if (tk > 302400)
                  tk = tk - 604800;
              elseif (tk<-302400)
                  tk = tk + 604800;
              end
              if (abs(tk)<7200),break;end  
         end
        end
        toe=navdata.gps(a3).toe;
%         t=basedata.epoch(a1).gps(a2).gpst-basedata.epoch(a1).gps(a2).CLC/299792458;
        as=(navdata.gps(a3).sqrtas)^2;
        es=navdata.gps(a3).es;
        io=navdata.gps(a3).io;
        OMGAo=navdata.gps(a3).OMGAo;
        w=navdata.gps(a3).w;
        Mo=navdata.gps(a3).Mo;
        deltn=navdata.gps(a3).deltn;
        dti=navdata.gps(a3).dti;
        dtOMGA=navdata.gps(a3).dtOMGA;
        Cuc=navdata.gps(a3).Cuc;
        Cus=navdata.gps(a3).Cus;
        Crc=navdata.gps(a3).Crc;
        Crs=navdata.gps(a3).Crs;
        Cic=navdata.gps(a3). Cic;
        Cis=navdata.gps(a3).Cis;
        dtOMGAe=7.2921151467*10^-5;
        GM=3.986005e+14;
%      %  1.计算归化时间tk
%         tk  = t - toe;
%           while(tk > 302400||tk < -302400)
%               if(tk > 302400)
%                   tk = tk - 604800;
%                else
%                   tk = tk + 604800;
%                end
%            end
       %  2.计算卫星的平均角速度
          no=sqrt(GM/(as^3));   
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
           Eo=Mk+es*sin(Mk);
           E1=Mk+es*sin(Eo);
           E2=Mk+es*sin(E1);
           Ek=Mk+es*sin(E2);
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
            OMGAk=OMGAo+(dtOMGA-dtOMGAe)*tk-dtOMGAe*toe;
        %   11.计算卫星在WGS-84地心地固直角坐标系（Xt,Yt,Zt）中的坐标（X,Y,Z）
            X=xk1*cos(OMGAk)-yk1*cos(ik)*sin(OMGAk);
            Y=xk1*sin(OMGAk)+yk1*cos(ik)*cos(OMGAk);
            Z=yk1*sin(ik);
       % 从发射时间转换到接收时间坐标系
        dw = OMEGAdote*(initdata.epoch(a1).gps(a2).CLC/299792458);%传播时间转过的角度
        cw = cos(dw);sw = sin(dw);
        anglepos=[cw sw 0;-sw cw 0;0 0 1]*[X;Y;Z];
       % 计算高度角 thet
       
       %我的改变
            D=anglepos-x0;
            E=S*D;
            theta=asin(E(3)/sqrt(E(1)^2+E(2)^2+E(3)^2));
    
           if theta>(pi/18)
             satnum = satnum+1; 
             lamda = 0.1903;       %波长λ
            % 计算即在概略点处据卫星的距离与基站与卫星距离差、Ru、卫星角度theta
             satdata(satnum).theta =theta;
             satdata(satnum).xs=X;        %根据用户接收机计算得到的卫星坐标(xus,yus,zus)
             satdata(satnum).ys=Y;
             satdata(satnum).zs=Z;
             satdata(satnum).prn = initdata.epoch(a1).gps(a2).prn;
             sbr=sqrt((X-x0(1))^2+(Y-x0(2))^2+(Z-x0(3))^2); 
             satdata(satnum).FC=initdata.epoch(a1).gps(a2).L1C*lamda-sbr;   
             satdata(satnum).pc = initdata.epoch(a1).gps(a2).CLC-sbr;
           end
                
            
      
end    



