function[S]=GetS(x0)
% 获取WGS-84与ENU坐标系转换矩阵

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
    


end