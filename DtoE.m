function [line]=DtoE(line)
weizhi=strfind(line,'D');
linechang = length(weizhi);
for i=1:linechang
    line(weizhi(i))='e';
end
end