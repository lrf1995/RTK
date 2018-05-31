function[navdata,navfilepath]=readnavfile
% 读取导航[navdata]=readnavfile文件
navfilepath = '.\cut00280.16n';
fid      = fopen(navfilepath);
gpsnav = 0;    % GPS导航文件中的卫星总个数
bdsnav = 0;   % BDS导航文件中的卫星总个数
navdata = NaN; %导航文件读取的数据为空
% 跳过头文件
while ~feof(fid)                             %feof若未结束返回0值
    line = fgetl(fid);
    if strfind(line,'END OF HEADER'),break;end %% 跳过文件头
end
% 逐行读取正文内容
while ~feof(fid) %判断是否读到文件尾时
    line = fgetl(fid);
    [line]=DtoE(line);
    if line(1) == 'G' %判断是否是GPS卫星的初始行
        flag = 1;
        gpsnav = gpsnav+1;
        % 读取卫星数据第一行
        dataline = sscanf(line(2:end),'%e'); %将第一行按照字符串读取
        navdata.system(flag).gps(gpsnav).prn = dataline(1); %读取卫星序号
        utctime = dataline(2:7); %读取公历时间
        gpst = cal2gps(utctime); %将公历GPS时间转换到GPS周和周内的秒
        navdata.system(flag).gps(gpsnav).utctime = utctime;
        navdata.system(flag).gps(gpsnav).gpst = gpst; %卫星发射信号时间转换的UTC时间 (发射时间)
        navdata.system(flag).gps(gpsnav).af0 = dataline(8); %偏差svClkBias=af0
        navdata.system(flag).gps(gpsnav).af1 = dataline(9); %漂移svClkDrf=af1
        navdata.system(flag).gps(gpsnav).af2 = dataline(10); %漂移速度svDrfRate=af2
        % 读取卫星数据第二行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(gpsnav).idoe = dataline(1); %数据、星历发布时间
        navdata.system(flag).gps(gpsnav).Crs = dataline(2); %Crs
        navdata.system(flag).gps(gpsnav).deltn =dataline(3); %deltn
        navdata.system(flag).gps(gpsnav).Mo = dataline(4);%Mo
        % 读取卫星数据第三行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(gpsnav).Cuc = dataline(1); %Cuc
        navdata.system(flag).gps(gpsnav).es = dataline(2); %es
        navdata.system(flag).gps(gpsnav).Cus =dataline(3); %Cus
        navdata.system(flag).gps(gpsnav).sqrtas = dataline(4); %sqrtas
        % 读取卫星数据第四行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(gpsnav).toe = dataline(1); %星历参考时间toe
        navdata.system(flag).gps(gpsnav).Cic = dataline(2); %Cic
        navdata.system(flag).gps(gpsnav).OMGAo =dataline(3); %OMGAo
        navdata.system(flag).gps(gpsnav).Cis = dataline(4); %Cis
        % 读取卫星数据第五行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(gpsnav).io = dataline(1); %io
        navdata.system(flag).gps(gpsnav).Crc = dataline(2); %Crc
        navdata.system(flag).gps(gpsnav).w =dataline(3); %w
        navdata.system(flag).gps(gpsnav).dtOMGA = dataline(4); %dtOMGA
        % 读取卫星数据第六行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(gpsnav).dti = dataline(1); %dti
        navdata.system(flag).gps(gpsnav).L2 = dataline(2); %L2上的码
        navdata.system(flag).gps(gpsnav).GPSWeek =dataline(3); %GPS周数
        navdata.system(flag).gps(gpsnav).L2P = dataline(4); %L2P数据标志
        % 读取卫星数据第七行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(gpsnav).SVaccuracy = dataline(1);%卫星精度
        navdata.system(flag).gps(gpsnav).SVhealth= dataline(2);%卫星健康状态
        navdata.system(flag).gps(gpsnav).TGD = dataline(3); %TGD
        navdata.system(flag).gps(gpsnav).IODC= dataline(4);%IODC钟的数据龄期
        % 读取卫星数据第八行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(gpsnav).Ttime = dataline(1);%电文发送时间
        if(navdata.system(flag).gps(gpsnav).SVhealth == 1),gpsnav=gpsnav-1;end
    elseif line(1) == 'C' %判断是否是BDS卫星的初始行
        flag = 2;
        bdsnav = bdsnav+1;
        % 读取卫星数据第一行
        dataline = sscanf(line(2:end),'%e'); %将第一行按照字符串读取
        navdata.system(flag).gps(bdsnav).prn = dataline(1); %读取卫星序号
        utctime = dataline(2:7); %读取公历时间
        gpst = cal2gps(utctime); %将公历GPS时间转换到GPS周和周内的秒
        gpst(2)=gpst(2)-14; %北斗时
        navdata.system(flag).gps(bdsnav).utctime = utctime;
        navdata.system(flag).gps(bdsnav).gpst = gpst; %卫星发射信号时间转换的UTC时间 (发射时间)
        navdata.system(flag).gps(bdsnav).af0 = dataline(8); %偏差svClkBias=af0
        navdata.system(flag).gps(bdsnav).af1 = dataline(9); %漂移svClkDrf=af1
        navdata.system(flag).gps(bdsnav).af2 = dataline(10); %漂移速度svDrfRate=af2
        % 读取卫星数据第二行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(bdsnav).idoe = dataline(1); %数据、星历发布时间
        navdata.system(flag).gps(bdsnav).Crs = dataline(2); %Crs
        navdata.system(flag).gps(bdsnav).deltn =dataline(3); %deltn
        navdata.system(flag).gps(bdsnav).Mo = dataline(4);%Mo
        % 读取卫星数据第三行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(bdsnav).Cuc = dataline(1); %Cuc
        navdata.system(flag).gps(bdsnav).es = dataline(2); %es
        navdata.system(flag).gps(bdsnav).Cus =dataline(3); %Cus
        navdata.system(flag).gps(bdsnav).sqrtas = dataline(4); %sqrtas
        % 读取卫星数据第四行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(bdsnav).toe = dataline(1); %星历参考时间toe
        navdata.system(flag).gps(bdsnav).Cic = dataline(2); %Cic
        navdata.system(flag).gps(bdsnav).OMGAo =dataline(3); %OMGAo
        navdata.system(flag).gps(bdsnav).Cis = dataline(4); %Cis
        % 读取卫星数据第五行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(bdsnav).io = dataline(1); %io
        navdata.system(flag).gps(bdsnav).Crc = dataline(2); %Crc
        navdata.system(flag).gps(bdsnav).w =dataline(3); %w
        navdata.system(flag).gps(bdsnav).dtOMGA = dataline(4); %dtOMGA
        % 读取卫星数据第六行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %将该行按照字符串读取
        navdata.system(flag).gps(bdsnav).dti = dataline(1); %dti
        navdata.system(flag).gps(bdsnav).L2 = dataline(2); %L2上的码
        navdata.system(flag).gps(bdsnav).GPSWeek =dataline(3); %GPS周数
        navdata.system(flag).gps(bdsnav).L2P = dataline(4); %L2P数据标志
        % 读取卫星数据第七行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(bdsnav).SVaccuracy = dataline(1);%卫星精度
        navdata.system(flag).gps(bdsnav).SVhealth= dataline(2);%卫星健康状态
        navdata.system(flag).gps(bdsnav).TGD = dataline(3); %TGD
        navdata.system(flag).gps(bdsnav).IODC= dataline(4);%IODC钟的数据龄期
        % 读取卫星数据第八行
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(bdsnav).Ttime = dataline(1);%电文发送时间
        if(navdata.system(flag).gps(bdsnav).SVhealth == 1),bdsnav=bdsnav-1;end
    end
end
fclose(fid);
end