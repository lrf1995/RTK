function[E]=PictENU(x1,Corrpos,S)
% 画出ENU图，在相对定位的过程中


rtker.dxc = Corrpos.xc-x1(1);
rtker.dyc = Corrpos.yc-x1(2);
rtker.dzc = Corrpos.zc-x1(3);
for m =1:length(rtker.dxc)
    env=S*[rtker.dxc(m);rtker.dyc(m);rtker.dzc(m)];
    E(m)=env(1);
    N(m)=env(2);
    U(m)=env(3);
    
end
plot(E,N,'r');


end