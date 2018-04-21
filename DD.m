function[N,d,Qxn,Qn]=DD(singaldiff,satnum,maxnum)
global  lamda;

dnum=0;
cs = 2.99792458e8;%光速
L1f=1575.42e6;
lamda = cs/L1f;       %波长λ
G = zeros(satnum-1,3) ;
H1 = zeros(satnum-1,1) ;
H2 = zeros(satnum-1,1) ;
Q1 =zeros(satnum-1,satnum-1) ;
Q2 =zeros(satnum-1,satnum-1) ;
for id=1:(satnum-1)
    dnum=dnum+1;
    if(dnum==maxnum),dnum=dnum+1;end
    G(id,1)=-(singaldiff(dnum).Ix-singaldiff(maxnum).Ix);
    G(id,2)=-(singaldiff(dnum).Iy-singaldiff(maxnum).Iy);
    G(id,3)=-(singaldiff(dnum).Iz-singaldiff(maxnum).Iz);
    H1(id,1)=singaldiff(dnum).pc-singaldiff(maxnum).pc; 
    H2(id,1)=singaldiff(dnum).FC-singaldiff(maxnum).FC;
     for j=1:satnum-1
        if(id==j)
            Q1(id,j) = 2*(singaldiff(id).pw+singaldiff(maxnum).pw);%伪距加权
            Q2(id,j) = 2*(singaldiff(id).fw+singaldiff(maxnum).fw);%载波相位
        else
            Q1(id,j) = 2*singaldiff(maxnum).pw;%伪距加权
            Q2(id,j) = 2*singaldiff(maxnum).fw;%载波相位
        end
     end
end
B=eye(satnum-1);
b=B*lamda;
G1=zeros(satnum-1);
Q=[Q1,G1;G1,Q2];
C=inv(Q); 
A=[G,G1;G,b];
H=[H1;H2];
X=(A'*C*A)\A'*C*H;
  d = X(1:3);
  N = X(4:satnum-1+3);
  Qx = inv(A'*C*A);        
  Qn = Qx(4:satnum-1+3,4:satnum-1+3);   %模糊度N的协方差矩阵
  Qxn = Qx(1:3,4:satnum-1+3);           %基线向量与模糊度N之间的相关系数阵



end