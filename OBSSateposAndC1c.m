function[OBSprn,FCu,pcu,obsnum,Utheta,xus,yus,zus,ru]=OBSSateposAndC1c(navdata,obsdata,x0,S,m)
a1=m;
OMEGAdote = 7.2921151467e-5;%地球自转角速度
obsnum=0;
for a2=1:obsdata.epoch(a1).gpsobs
        for a3=1:length(navdata.gps)
         if(obsdata.epoch(a1).gps(a2).prn==navdata.gps(a3).prn)
            if abs(obsdata.epoch(a1).gps(a2).gpst-navdata.gps(a3).gpst)<7200,break;end
         end
        end    
        toe=navdata.gps(a3).toe;
        t=obsdata.epoch(a1).gps(a2).gpst-obsdata.epoch(a1).gps(a2).CLC/299792458;
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
     %  1.计算归化时间tk
        tk  = t - toe;
          while(tk > 302400||tk < -302400)
              if(tk > 302400)
                  tk = tk - 604800;
               else
                  tk = tk + 604800;
               end
           end
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
        dw = OMEGAdote*(obsdata.epoch(a1).gps(a2).CLC/299792458);%传播时间转过的角度
        cw = cos(dw);sw = sin(dw);
        anglepos=[cw sw 0;-sw cw 0;0 0 1]*[X;Y;Z];
       % 计算高度角 thet 
            D=anglepos-x0;
            E=S*D;
            theta=asin(E(3)/sqrt(E(1)^2+E(2)^2+E(3)^2));
    
           if theta>(pi/18)
             obsnum = obsnum+1; 
             lamda = 0.1903;       %波长λ
            % 计算FCub(ρu)即在概略点处据卫星的距离与基站与卫星距离差、Ru、卫星角度theta
             Utheta(obsnum) =theta;
             xus(obsnum)=X;        %根据用户接收机计算得到的卫星坐标(xus,yus,zus)
             yus(obsnum)=Y;
             zus(obsnum)=Z;
             OBSprn(obsnum) = obsdata.epoch(a1).gps(a2).prn;
             ru(obsnum)=sqrt((xus(obsnum)-x0(1))^2+(yus(obsnum)-x0(2))^2+(zus(obsnum)-x0(3))^2); 
             FCu(obsnum)=obsdata.epoch(a1).gps(a2).L1C*lamda-ru(obsnum);   
             pcu(obsnum) =obsdata.epoch(a1).gps(a2).CLC-ru(obsnum);
            end
                
            
end
end    



