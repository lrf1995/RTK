function[obsdata,movefilepath]=readobsfile
% 读取观测文件（用户接收机）
movefilepath = '.\cutb1680.16o';
fid      = fopen(movefilepath);
while ~feof(fid)   %feof若未结束返回0值
    line = fgetl(fid);
    %     if strfind(line,'APPROX POSITION XYZ')
    %         xfloat0=sscanf(line(2:end),'%e'); %% 初始化坐标x0
    %     end
    if strfind(line,'END OF HEADER'),break;end %% 跳过文件头
end
%end
obsdata = NaN; %导航文件读取的数据为空
epochnum = 0;
% 读取接收时间
while ~feof(fid)
    line = fgetl(fid);
    epochnum = epochnum +1;
    dataline = sscanf(line(2:end),'%f');
    timeutc = dataline(1:6);
    gpst = cal2gps(timeutc);
    obsdata.system(1).epoch(epochnum).gpst =gpst; % GPS用户接收机接收机信号接收时间tu
    gpst(2)=gpst(2)-14;                               %北斗时
    obsdata.system(2).epoch(epochnum).gpst =gpst; % BDS用户接收机接收机信号接收时间tu
    shu = dataline(8);%该时刻卫星数目
    gpsobs = 0; %观测文件中GPS每个历元中的卫星总个数
    bdsobs = 0; %观测文件中BDS每个历元中的卫星总个数
    
    % 根据卫星数目读取信息
    for a=1:shu
        % 补充空余数据
        line = fgetl(fid);
        linechang=length(line);
        if linechang<193
            line(linechang+1:193)=0;
        end
        %%      判断不同卫星系统不同频率下是否存在相应的载波和伪距
% %         cada = line(1);
% %         C1C = str2double(line(5:17));
% %         L1C = str2double(line(21:34));
% %         C2C = str2double(line(54:66));
% %         L2C = str2double(line(69:82));
% %         %         C3I = str2double(line(102:114));
% %         %         L3I = str2double(line(117:130));
% %         if ((cada=='C')||(cada=='G'))
% %             if(isnan(C1C)||isnan(L1C)||isnan(C2C)||isnan(L2C))%||isnan(C3I)||isnan(L3I))
% %                 continue;
% %             end
% %         end
        
        %% 读取观测数据       
        if line(1)=='G'
            flag = 1 ;
            C1C = str2double(line(5:17));
            L1C = str2double(line(21:34));
            C2C = str2double(line(54:66));
            L2C = str2double(line(69:82));
            if(isnan(C1C)||isnan(L1C)||isnan(C2C)||isnan(L2C))%||isnan(C3I)||isnan(L3I))
                continue;
            end
            gpsobs=gpsobs+1;
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).timeutc=timeutc;
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).gpst =gpst;                    % 用户接收机接收机信号接收时间tu
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).prn = str2double(line(2:3));   % 用户接收的卫星prn号
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).C1C = C1C;  % 用户接收的卫星伪距量C1L
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).L1C = L1C; % 用户接受的卫星载波相位L1C
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).C2C = C2C;  % 用户接收的卫星伪距量C2L
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).L2C = L2C; % 用户接受的卫星载波相位L2C
            
        elseif line(1)=='R'
            
        elseif line(1)=='C'
            flag = 2 ;
            C1C = str2double(line(5:17));
            L1C = str2double(line(21:34));
            C2C = str2double(line(54:66));
            L2C = str2double(line(69:82));
             if(isnan(C1C)||isnan(L1C)||isnan(C2C)||isnan(L2C))%||isnan(C3I)||isnan(L3I))
                continue;
            end
            bdsobs=bdsobs+1;
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).timeutc=timeutc;
            gpst(2)=gpst(2)-14; %北斗时
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).gpst =gpst;                    % 用户接收机接收机信号接收时间tu
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).prn = str2double(line(2:3));   % 用户接收的卫星prn号
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).C1C = C1C;  % 用户接收的卫星伪距量C1L
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).L1C = L1C; % 用户接受的卫星载波相位L1C
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).C2C = C2C;  % 用户接收的卫星伪距量C2L
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).L2C = L2C; % 用户接受的卫星载波相位L2C
        elseif line(1)=='E'
            
        elseif line(1)=='L'
            
        end
        obsdata.system(1).epoch(epochnum).satnum = gpsobs;
        obsdata.system(2).epoch(epochnum).satnum = bdsobs;
    end
end
fclose(fid);
end