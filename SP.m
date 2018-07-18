function[SPx,SPy,SPz,Dt]=SP(x0,obsdata,navdata,S,sys)
% 单点定位

% x0 = [-2364337.4414;4870285.6211;-3360809.6724];
% navfilepath = '.\cuta1680.16p';
% [navdata,gpsnav]=SPreadnavFile(SPnavfilepath);
% 
% % OBSfilepath = '.\cutb1680.16o';
% [obsdata,epochnum]=SPreadobsFile(SPobsfilepath);
epochnum = length(obsdata.system(1).epoch);

Global(sys);
for m=1:epochnum
    clear  eq validnum x1;
   
    [eq,validnum]=SPpositionandpc(obsdata,navdata,x0,S,m);
    [x1,Dtu]=SPiteration(eq,validnum);
    Dt(m)=Dtu;
    SPx(m)=x1(1); 
    SPy(m)=x1(2);
    SPz(m)=x1(3);

end
end