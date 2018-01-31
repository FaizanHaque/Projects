
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
LonData = ncread(fname, 'longitude');
LatData = ncread(fname, 'latitude');
cData = zeros(size(TData(:,:,:,1)));
cData2 = zeros(size(TData(:,:,:,1)));

%cData(:,:,:) = TData(:,:,:,1).^2;
%c = 1449 [m/s] + 4.6 [m/sC] T -0.055T^2 + 0.0003T^3 + (1.39 [m/s] -0.012[m/sC]T)(S -35)

cData(:,:,:) = 1449 + 4.6*TData(:,:,:,1) -0.055*TData(:,:,:,1).^2 + 0.0003*TData(:,:,:,1).^3 + (1.39 - 0.012*TData(:,:,:,1)).*(SData(:,:,:,1) - 35);
%cData2(:,:,:) = 1449 + 4.6*TData(:,:,:,1) -0.055*TData(:,:,:,1).^2 + 0.0003*TData(:,:,:,1).^3 + 1.39*(SData(:,:,:,1) - 35) - 0.012*TData(:,:,:,1).*(SData(:,:,:,1) - 35);

cData = permute(cData,[2 1 3]);
%cData2 = permute(cData2,[2 1 3]);
%cData3 = cData(:,:,:) - cData2(:,:,:);
dMax= length(Depth);
dMaxStr = num2str(dMax);
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
cMin = min(min(min(cData(:,:,:)))) ;
cMax = max(max(max(cData(:,:,:))));
cMin2 = min(min(min(cData2(:,:,:)))) ;
cMax2 = max(max(max(cData2(:,:,:))));
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
fNo2 = 200;
mySlidingFigure(cData2, cMin2, cMax2,fNo2);
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