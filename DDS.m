function[N,d,Qxn,Qn,DDsatnum]=DDS(singaldiff,satnum,maxnum)
% 单频双差函数

global   L1f  cs;
dnum=0;
lambda1 = cs/L1f;
G = zeros(satnum-1,3) ;
H= zeros(2*(satnum-1),satnum-1+3) ;
P1 = zeros(satnum-1,1) ;
F1 = zeros(satnum-1,1) ;
Q = zeros(2*(satnum-1),2*(satnum-1)) ;
for id=1:(satnum-1)
    dnum=dnum+1;
    if(dnum==maxnum)
        dnum=dnum+1;
    end
    G(id,1)=-(singaldiff(dnum).Ix-singaldiff(maxnum).Ix);
    G(id,2)=-(singaldiff(dnum).Iy-singaldiff(maxnum).Iy);
    G(id,3)=-(singaldiff(dnum).Iz-singaldiff(maxnum).Iz);

    %%   单频LAMBDA算法的双差计算量（并非双差观测量）
    P1(id,1)=singaldiff(dnum).PC1-singaldiff(maxnum).PC1;
    F1(id,1)=singaldiff(dnum).FC1-singaldiff(maxnum).FC1;
    for j=1:satnum-1
        if(id==j)
            Q(id,j) = 2*(singaldiff(dnum).pw+singaldiff(maxnum).pw);%伪距加权
            Q(satnum-1+id,satnum-1+j) = 2*(singaldiff(dnum).fw+singaldiff(maxnum).fw);%载波相位
        else
            Q(id,j) = 2*singaldiff(maxnum).pw;%伪距加权
            Q(satnum-1+id,satnum-1+j) = 2*singaldiff(maxnum).fw;%载波相位
        end
    end
end
zeromatrix = zeros(satnum-1);
eyematrix = eye(satnum-1);
eyematrix1 = eyematrix * lambda1;

H = [G,zeromatrix;G,eyematrix1];

QD=inv(Q);
C = QD;

X=(H'*C*H)\H'*C*[P1;F1];

DDsatnum = satnum-1;

d = X(1:3);
N = X(4:DDsatnum+3);
Qx = inv(H'*C*H);
Qxn = Qx(1:3,4:DDsatnum+3);           %基线向量与模糊度N之间的相关系数阵
Qn = Qx(4:DDsatnum+3,4:DDsatnum+3);   %模糊度N的协方差矩阵


end
