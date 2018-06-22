function[MatrixSDD]=SDDDMatrix(singaldiff,satnum,maxnum)
% 单频双差函数

global   L1f  cs;

dnum=0;
lambda1 = cs/L1f;

Q = zeros(2*(satnum-1),2*(satnum-1)) ;
for id=1:(satnum-1)
    dnum=dnum+1;
    if(dnum==maxnum),dnum=dnum+1;end
    G(id,1)=-(singaldiff(dnum).Ix-singaldiff(maxnum).Ix);
    G(id,2)=-(singaldiff(dnum).Iy-singaldiff(maxnum).Iy);
    G(id,3)=-(singaldiff(dnum).Iz-singaldiff(maxnum).Iz);
    
    %%   单频LAMBDA算法的双差计算量（并非双差观测量）
    P1(id,1)=singaldiff(dnum).PC1-singaldiff(maxnum).PC1;
    F1(id,1)=singaldiff(dnum).FC1-singaldiff(maxnum).FC1;
    P2(id,1)=singaldiff(dnum).PC2-singaldiff(maxnum).PC2;
    F2(id,1)=singaldiff(dnum).FC2-singaldiff(maxnum).FC2;
    
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
     MatrixSDD.G  = G;
     MatrixSDD.P1 = P1;
     MatrixSDD.F1 = F1;

     MatrixSDD.Q  = Q;
     MatrixSDD.num = satnum-1;
     MatrixSDD.lambda1 = lambda1;
   
     


end
