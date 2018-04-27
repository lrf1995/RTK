function Global(systype,sysmode)
global flag mode f a cs L1f L2f L3f u OMEGAdote ;
flag = systype;              %判断系统为GPS(1)还是北斗(2)
mode = sysmode;
cs = 2.99792458e8;           %光速

if(flag == 1)
   f = 1/1/298.257223563;
   a = 6378137;%地球椭圆长半轴
   L1f=1575.42e6;
   L2f=1227.60e6;
   L3f=1176.45e6;
   u = 3.986005e14;           %GM
   OMEGAdote = 7.2921151467e-5;%地球自转角速度
elseif(flag == 2)
    a = 6378137.0;%地球椭圆长半轴
    f = 1/298.257222101;
    L1f = 1561.098e6;
    L2f = 1207.14e6;
    L3f = 1268.52e6;
    u = 3.986004418e+14;     %GM
    OMEGAdote = 7.2921150e-5;%地球自转角速度
end


end