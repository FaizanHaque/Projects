
%W:-150 ,E: -100, S: 25, N:60
%Speed of sound in water:
%c = 1449 [m/s] + 4.6 [m/sC] T -0.055T^2 + 0.0003T^3 + (1.39 [m/s] -0.012[m/sC]T)(S -35)
%[c] = [m/s]
%[T] = C
%[S] = psu
fname = 'C:\Users\Faizan\Documents\GitHub\Projects\sound_waves\dataset-armor-3d-v4-cmems-v2_1517366329267.nc';
%ncdisp(fname);
TData = ncread(fname, 'temperature');
SData = ncread(fname, 'salinity');
Depth = ncread(fname, 'depth'); 
Depth = double(Depth);
LonData = ncread(fname, 'longitude');
LatData = ncread(fname, 'latitude');
TData = permute(TData,[2 1 3 4]);
SData = permute(SData,[2 1 3 4]);

cData = 0*TData;
c= zeros(33,1);

cDepth = 0*cData;
for a = 1:201
   for b = 1:141
       for j = 1:33
       cDepth(a,b,j,1) = Depth(j,1);
       end
   end
end
%cData2 =  a                                       zeros(size(TData(:,:,:,1)));
  
%cData(:,:,:) = TData(:,:,:,1).^2;
%c = 1449 [m/s] + 4.6 [m/sC] T -0.055T^2 + 0.0003T^3 + (1.39 [m/s]
%-0.012[m/sC]T)(S -35) 1.6*10(^-2)*Z
x0 = 50;
y0= 50;
c(:) = 1449 + 4.6*TData(x0,y0,:,1) -0.055*TData(x0,y0,:,1).^2 + 0.0003*TData(x0,y0,:,1).^3 + (1.39 - 0.012*TData(x0,y0,:,1)).*(SData(x0,y0,:,1) - 35) + 1.6*10^-2*cDepth(x0,y0,:,1);
%cData(i,j,:,1) = 1449 + 4.6*TData(i,j,:,1) -0.055*TData(x0,y0,:,1).^2 + 0.0003*TData(x0,y0,:,1).^3 + (1.39 - 0.012*TData(x0,y0,:,1)).*(SData(x0,y0,:,1) - 35) + 1.6*10^-2*cDepth(x0,y0,:,1);


cData(:,:,:,1) = 1449 + 4.6*TData(:,:,:,1) -0.055*TData(:,:,:,1).^2 + 0.0003*TData(:,:,:,1).^3 + 1.39*(SData(:,:,:,1) - 35) - 0.012*TData(:,:,:,1).*(SData(:,:,:,1) - 35);
%cMin = min(min(min(cData(:,:,:)))) ;
cMin = 1450;
cMax = max(max(max(cData(:,:,:))));

%cData = permute(cData,[2 1 3]);

%cDataZ = zeros(33,1);
%cDataZ2 = zeros(33,1);
%cDataZ(:)= cData(50,50,:);
raytrace(1,600,0:1:9,100,Depth(1:end-1),c(1:end-1),1);
%function [xxf, zzf, ttf, ddf] = raytrace(xo,zo, theta0,tt,zz,cc,plotflag)

keyboard;

% cDataConst = 0*cData;
% for a = 1:201
%     for b = 1:141
%         cDataConst(b,a,1:end,1) = cDataZ(:,1);
%     end
% end
% 

%cData2 = permute(cData2,[2 1 3]);
%cData3 = cData(:,:,:) - cData2(:,:,:);
% dMax= length(Depth);
% dMaxStr = num2str(dMax);
%cMin = min(cData;)
% cMin2 = min(min(min(cData2(:,:,:)))) ;
% cMax2 = max(max(max(cData2(:,:,:))));
% cMin3 = min(min(min(cData3(:,:,:)))) ;
% cMax3 = max(max(max(cData3(:,:,:))));







figure(1),
contourf(cData(:,:,1) - cData(:,:,31))
    hcb = colorbar;
set(get(hcb,'Title'),'String',' C [m/s]');
ylabel('Latitude')
xlabel('Longitude');
%caxis([cMin cMax]);
fNo = 100;
mySlidingFigure(cData, cMin, cMax,fNo);








%-------------------SOFAR Channel--------------------%
figure(2)
for y = 1:25:100
    for x = 1:35:105
cDataZ2(:)= cData(x,y,:);
plot(cDataZ2(:,1),-Depth(1:end,1))
ylabel(['height [m]']);
xlabel(['c [ms^-1]']);
drawnow
    end
end
        %cDataZ(:)= cData(50,50,:);

for z = 1:33
cDepth(:,:,z) = cDataZ(z,1);
end
%fNo2 = 200;
%mySlidingFigure(cDepth, cMin, cMax,fNo2);




























% 
% figure(1)
% contourf(LonData,LatData, cData(:,:,33), 'edgecolor', 'none');
% %colorbar
% title('Speed of Sound');
% hcb = colorbar;
% set(get(hcb,'Title'),'String',' C [m/s]');
% ylabel('Latitude')
% xlabel('Longitude');
% f = figure(2);
% %colorbar
% title('Speed of Sound');
% hcb = colorbar;
% set(get(hcb,'Title'),'String',' C [m/s]');
% ylabel('Latitude')
% xlabel('Longitude');
% hold on



%fNo2 = 200;
%mySlidingFigure(cData2, cMin2, cMax2,fNo2);
% fNo3 = 300;
% mySlidingFigure(cData3, cMin3, cMax3,fNo3);

% for d = 1:length(Depth);
% d = 1;
% h = contourf(LonData,LatData, cData(:,:,d), 'edgecolor', 'none');
% b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
%               'value',d, 'min',1, 'max',dMax);
% bgcolor = f.Color;
% bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
%                 'String','1','BackgroundColor',bgcolor);
% bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
%                 'String',dMaxStr,'BackgroundColor',bgcolor);
% bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
%                 'String','Depth Level','BackgroundColor',bgcolor);
% b.Callback = @(es,ed) updateSystem(h,cData(:,:,round(es.Value)))
            % end