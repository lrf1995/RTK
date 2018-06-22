function[N,d,Qxn,Qn,DDsatnum]=DILS(GMatrixDDD,CMatrixDDD)
% 双系统双频的最小二乘法之前的组合矩阵

zeros1 = zeros(GMatrixDDD.num);
zeros2 = zeros(GMatrixDDD.num,CMatrixDDD.num);
zeros3 = zeros(CMatrixDDD.num);
zeros4 = zeros(CMatrixDDD.num,GMatrixDDD.num);

IG1 = eye(GMatrixDDD.num)*GMatrixDDD.lambda1;
IG2 = eye(GMatrixDDD.num)*GMatrixDDD.lambda2;
IC1 = eye(CMatrixDDD.num)*CMatrixDDD.lambda1;
IC2 = eye(CMatrixDDD.num)*CMatrixDDD.lambda2;

G = [GMatrixDDD.G,zeros1,zeros1,zeros2,zeros2;
     GMatrixDDD.G,IG1,   zeros1,zeros2,zeros2;
     GMatrixDDD.G,zeros1,zeros1,zeros2,zeros2;
     GMatrixDDD.G,zeros1,IG2,   zeros2,zeros2;
     CMatrixDDD.G,zeros4,zeros4,zeros3,zeros3;
     CMatrixDDD.G,zeros4,zeros4,IC1,   zeros3;
     CMatrixDDD.G,zeros4,zeros4,zeros3,zeros3;
     CMatrixDDD.G,zeros4,zeros4,zeros3,IC2   ; ];

H = [GMatrixDDD.P1 ;
     GMatrixDDD.F1 ;
     GMatrixDDD.P2 ;
     GMatrixDDD.F2 ;
     CMatrixDDD.P1 ;
     CMatrixDDD.F1 ;
     CMatrixDDD.P2 ;
     CMatrixDDD.F2 ;];
 
QDG=inv(GMatrixDDD.Q); 
QDC=inv(CMatrixDDD.Q); 
zeros5 = zeros(2*GMatrixDDD.num,2*GMatrixDDD.num); 
zeros6 = zeros(2*CMatrixDDD.num,2*CMatrixDDD.num);
zeros7 = zeros(2*GMatrixDDD.num,2*CMatrixDDD.num); 
zeros8 = zeros(2*CMatrixDDD.num,2*GMatrixDDD.num);

C = [QDG,zeros5,zeros7,zeros7;
     zeros5,QDG,zeros7,zeros7;
     zeros8,zeros8,QDC,zeros6;            
     zeros8,zeros8,zeros6,QDC]; 
 
X=(G'*C*G)\G'*C*H;
DDsatnum = 2*(GMatrixDDD.num+CMatrixDDD.num);
d = X(1:3);
N = X(4:(2*GMatrixDDD.num+2*CMatrixDDD.num+3)); 

Qx = inv(G'*C*G);
Qxn = Qx(1:3,4:(2*GMatrixDDD.num+2*CMatrixDDD.num+3));           %基线向量与模糊度N之间的相关系数阵
Qn =  Qx(4:(2*GMatrixDDD.num+2*CMatrixDDD.num+3),4:(2*GMatrixDDD.num+2*CMatrixDDD.num+3));     %模糊度N的协方差矩阵

end
