function[singaldiff,satnum,maxsat]=SD(basesat,basenum,movesat,obsnum,x0)
satnum=0;
for  i=1:obsnum
    for  j=1:basenum
        if(movesat(i).prn==basesat(j).prn)
            satnum=satnum+1;
            r=sqrt((movesat(satnum).xs-x0(1))^2+(movesat(satnum).ys-x0(2))^2+(movesat(satnum).zs-x0(3))^2);
            singaldiff(satnum).Ix = (movesat(i).xs - x0(1))/r;
            singaldiff(satnum).Iy = (movesat(i).ys - x0(2))/r;
            singaldiff(satnum).Iz = (movesat(i).zs - x0(3))/r;
            singaldiff(satnum).theta= movesat(i).theta;
            
            singaldiff(satnum).FC = movesat(i).FC-basesat(j).FC;
            singaldiff(satnum).fw = 0.005^2*(1+(1/movesat(i).theta)^2);
            singaldiff(satnum).pc = movesat(i).pc-basesat(j).pc;
            singaldiff(satnum).pw = 0.5^2*(1+(1/movesat(i).theta)^2);
            singaldiff(satnum).prn = movesat(i).prn;
            break;
        end
    end
    
end

%% 求取高度角最大的卫星
maxthet=0;
maxsat =1;
for i1=1:satnum
    if(singaldiff(i1).theta>maxthet)
        maxsat=i1;
        maxthet=singaldiff(i1).theta;
    end
end
end