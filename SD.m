function[singaldiff,satnum,maxsat]=SD(basesat,basenum,movesat,obsnum,x0)
global mode
satnum=0;
for  i=1:obsnum
    for  j=1:basenum
        if(movesat(i).prn==basesat(j).prn)
            satnum=satnum+1;
            r=sqrt((movesat(i).xs-x0(1))^2+(movesat(i).ys-x0(2))^2+(movesat(i).zs-x0(3))^2);
            singaldiff(satnum).Ix = (movesat(i).xs - x0(1))/r;
            singaldiff(satnum).Iy = (movesat(i).ys - x0(2))/r;
            singaldiff(satnum).Iz = (movesat(i).zs - x0(3))/r;
            singaldiff(satnum).theta= movesat(i).theta;
            %%   双频LAMBDA算法的单差计算量（并非单差观测量）
            if (mode == 1)
                singaldiff(satnum).FC1 = movesat(i).FC1-basesat(j).FC1;
                singaldiff(satnum).PC1 = movesat(i).PC1-basesat(j).PC1;
            elseif(mode == 2)
                singaldiff(satnum).FC1 = movesat(i).FC1-basesat(j).FC1;
                singaldiff(satnum).PC1 = movesat(i).PC1-basesat(j).PC1;
                singaldiff(satnum).FC2 = movesat(i).FC2-basesat(j).FC2;
                singaldiff(satnum).PC2 = movesat(i).PC2-basesat(j).PC2;
            end
            singaldiff(satnum).fw = 0.005^2*(1+(1/movesat(i).theta)^2);
            singaldiff(satnum).pw = 0.5^2*(1+(1/movesat(i).theta)^2);
            singaldiff(satnum).prn = movesat(i).prn;
            
            %%            使用Casading rounding 算法得到的单差观测量
            % %             singaldiff(satnum).FC1 = movesat(i).F1-basesat(j).F1;
            % %             singaldiff(satnum).PC1 = movesat(i).P1-basesat(j).P1;
            % %             singaldiff(satnum).FC2 = movesat(i).F2-basesat(j).F2;
            % %             singaldiff(satnum).PC2 = movesat(i).P2-basesat(j).P2;
            % %             singaldiff(satnum).FC3 = movesat(i).F3-basesat(j).F3;
            % %             singaldiff(satnum).PC3 = movesat(i).P3-basesat(j).P3;
            %%
            
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