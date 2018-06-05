function[obsdata,epochnum]=SPreadobsFile(OBSfilepath)
% 单点定位读取观测文件

fid      = fopen(OBSfilepath);
while ~feof(fid)   %feof若未结束返回0值
    line = fgetl(fid);
    if strfind(line,'END OF HEADER'),break;end %% 跳过文件头
end
 %导航文件读取的数据为空
epo = 0;

%% 读取一次观测文件
while ~feof(fid)
gpsobs =0;     %导航文件中每个历元中的卫星总个数
% 读取接收时间 
line = fgetl(fid);
dataline = sscanf(line(2:end),'%f');
timeutc = dataline(1:6);
gpst = cal2gps(timeutc);
epo = epo+1;
shu = dataline(8);%该时刻卫星数目

    %% 根据卫星数目读取信息
 for a=1:shu
    %% 补充空余数据
    
    line = fgetl(fid);
    cl1=str2double(line(6:18));
    cada = line(1);
    if (cada=='G')
        if(isnan(cl1))
            continue;
        end
    end
    linechang=length(line);
    if linechang<193
        line(linechang+1:193)=0;
    end      
    
    %% 读取观测数据
    if line(1)=='G'
        gpsobs=gpsobs+1;
        obsdata.obs(epo).gps(gpsobs).dataline = dataline;
        obsdata.obs(epo).gps(gpsobs).gpst =(gpst(1)*604800+gpst(2));%tu接收机信号接收时间
        obsdata.obs(epo).gps(gpsobs).prn = str2double(line(2:3));
        obsdata.obs(epo).gps(gpsobs).CLC = str2double(line(5:17));
        %obsdata.gps(obsnum).L1C = str2double(line(20:33));
        %obsdata.gps(obsnum).C2W = str2double(line(53:65));
        %obsdata.gps(obsnum).L2W = str2double(line(68:81));
        %obsdata.gps(obsnum).S2W = str2double(line(91:97));
        %obsdata.gps(obsnum).C2X = str2double(line(101:113));
        %obsdata.gps(obsnum).L2X = str2double(line(117:129));
        %obsdata.gps(obsnum).S2X = str2double(line(139:145));
        %obsdata.gps(obsnum).C5Q = str2double(line(149:161));
        %obsdata.gps(obsnum).L5Q = str2double(line(165:177));
        %obsdata.gps(obsnum).S5Q = str2double(line(187:193));
        
    elseif line(1)=='R'
        
    elseif line(1)=='C'
        
    elseif line(1)=='E'
        
    elseif line(1)=='L'
       
    end

 end
end
epochnum = length(obsdata.obs);
end