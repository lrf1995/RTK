function[N,d,Qxn,Qn,DDsatnum]=SILS(GMatrixDDD,CMatrixDDD)
% 双系统单频的最小二乘法之前的组合矩阵

zeros1 = zeros(GMatrixDDD.num);
zeros2 = zeros(GMatrixDDD.num,CMatrixDDD.num);
zeros3 = zeros(CMatrixDDD.num);
zeros4 = zeros(CMatrixDDD.num,GMatrixDDD.num);

I1 = eye(GMatrixDDD.num)*GMatrixDDD.lambda1;
I2 = eye(CMatrixDDD.num)*CMatrixDDD.lambda1;


G = [GMatrixDDD.G,zeros1,zeros2;
     GMatrixDDD.G,I1,    zeros2;
     CMatrixDDD.G,zeros4,zeros3;
     CMatrixDDD.G,zeros4,    I2;];

 
H = [GMatrixDDD.P1 ;
     GMatrixDDD.F1 ;
     CMatrixDDD.P1 ;
     CMatrixDDD.F1 ; ];
 
QDG=inv(GMatrixDDD.Q); 
QDC=inv(CMatrixDDD.Q); 
zeros5 = zeros(2*GMatrixDDD.num,2*CMatrixDDD.num); 
zeros6 = zeros(2*CMatrixDDD.num,2*GMatrixDDD.num);

C = [QDG,zeros5;
     zeros6,QDC]; 
X=(G'*C*G)\G'*C*H;
DDsatnum = GMatrixDDD.num+CMatrixDDD.num;
d = X(1:3);
N = X(4:(GMatrixDDD.num+CMatrixDDD.num+3)); 

Qx = inv(G'*C*G);
Qxn = Qx(1:3,4:(GMatrixDDD.num+CMatrixDDD.num+3));           %基线向量与模糊度N之间的相关系数阵
Qn =  Qx(4:(GMatrixDDD.num+CMatrixDDD.num+3),4:(GMatrixDDD.num+CMatrixDDD.num+3));     %模糊度N的协方差矩阵

end
