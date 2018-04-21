function Global(systype)
global flag f cs lamda u OMEGAdote ;
flag = systype;              %判断系统为GPS(1)还是北斗(2)
cs = 2.99792458e8;           %光速

if(flag == 1)
   f = 1/1/298.257223563;
   L1f=1575.42e6;
   lamda = cs/L1f; 
   u = 3.986005e14;           %GM
   OMEGAdote = 7.2921151467e-5;%地球自转角速度
elseif(flag == 2)
    f=1/298.257222101;
    L1f=1561.098e6;
    lamda = cs/L1f; 
    u = 3.986004418e+14;     %GM
    OMEGAdote = 7.2921150e-5;%地球自转角速度

end



end