function[x1,Dtu]=SPiteration(eq,validnum)
% 进行牛顿迭代

Dtu=0;%钟差初始值设为0
x1=[0;0;0];
A=[1;0;0;0];
while(norm(A)>1e-6)
    for i=1:validnum
        r= sqrt((x1(1)-eq.equ(i).x)^2+(x1(2)-eq.equ(i).y)^2+(x1(3)-eq.equ(i).z)^2) ; %当前位置与卫星距离初始估计值
        G(i,1)=-(eq.equ(i).x-x1(1))/r;
        G(i,2)=-(eq.equ(i).y-x1(2))/r;
        G(i,3)=-(eq.equ(i).z-x1(3))/r;
        G(i,4)=1;
        b(i,1)=eq.equ(i).pc-r-Dtu;
        
    end
    A=(G'*G)\G'*b;
    x1=x1+[A(1);A(2);A(3)];
    Dtu=Dtu+A(4);
    
end


end
