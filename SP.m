function[SPx,SPy,SPz]=SP(x0,SPnavfilepath,SPobsfilepath)
% 单点定位主程序

% x0 = [-2364337.4414;4870285.6211;-3360809.6724];
% navfilepath = '.\cuta1680.16p';
[navdata,gpsnav]=SPreadnavFile(SPnavfilepath);

% OBSfilepath = '.\cutb1680.16o';
[obsdata,epochnum]=SPreadobsFile(SPobsfilepath);


for m=1:epochnum
    clear  eq validnum x1;
    [eq,validnum]=SPpositionandpc(obsdata,navdata,x0,gpsnav,m);
    [x1]=SPiteration(eq,validnum);
    SPx(m)=x1(1); 
    SPy(m)=x1(2);
    SPz(m)=x1(3);

end
end