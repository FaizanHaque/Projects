fname = 'TSC_with_latitude.nc';
 
TData = ncread(fname, 'temperature');
SData = ncread(fname, 'salinity');

Depth = ncread(fname, 'depth'); 
Depth = double(Depth);
LonData = ncread(fname, 'longitude');
LatData = ncread(fname, 'latitude');
cData = zeros(33,6);
cTemp = cData*0;
cSal = cData*0;
l = 1:50:260;
cLat = LatData(l(:),1);
%Depth = Depth(1,l,:);
for i = 1:length(l)
cSal(:,i) = SData(5,l(i),:);
cTemp(:,i) = TData(5,l(i),:);
cData(:,i) = 1449 + 4.6*cTemp(:,i) -0.055*cTemp(:,i).^2 + 0.0003*cTemp(:,i).^3 + (1.39 - 0.012*cTemp(:,i)).*(cSal(:,i) - 35) + 1.6*10^-2*Depth(:);
end

figure(1)
%ylabel('depth');
figure(2)
%ylabel('depth');

for j = 1:length(l)
latVal = num2str(LatData(l(j)));
figure(1)
subplot(1,length(l),j);

plot(cTemp(:,j),-Depth, 'r');
hold on;
plot(cSal(:,j),-Depth, 'b');
title([' lat =' latVal])
ylim([-5000 0]);

figure(2)
subplot(1,length(l),j);
plot(cData(:,j),-Depth);
xlim([1450 1550]);
ylim([-5000 0]);
title( [' lat =' latVal]);
xlabel('c [m/s]');
end
figure(1)
subplot(1,length(l),1)
ylabel('height (m)')
legend('Temperature','Salinity');
legend boxoff

figure(2)
subplot(1,length(l),1)
ylabel('height (m)')

%cData(:,i) = 1449 + 4.6*TData(1,i,:) -0.055*TData(1,i,:).^2 + 0.0003*TData(1,i,:).^3 + (1.39 - 0.012*TData(1,i,:)).*(SData(1,i,:) - 35) + 1.6*10^-2*Depth(:);
% end
