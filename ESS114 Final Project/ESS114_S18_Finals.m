%BData = xlsread('ESS114_Final_Bryan_Data.xlsx');
%CData = xlsread('ESS114_Final_Cesar_Data.xlsx');

figure(1)
title('Comparision of magnetic fields');
qScale = 0.2;
quiver3(BData(:,7),BData(:,6),BData(:,8),BData(:,2),BData(:,3),BData(:,4),qScale,'b');
hold on
quiver3(CData(:,7),CData(:,6),CData(:,8),CData(:,2),CData(:,3),CData(:,4), qScale, 'k');
zlabel('elevation (m)');
ylabel('latitude (°)');
xlabel('longitude (°)');

rotate3d on

figure(2)
plot(BData(:,8),BData(:,5),'b');
hold on
plot(CData(:,8),CData(:,5),'k');
title('Absolute Magnetic Fields vs Elevation');
legend('Bryan''s phone','Cesar''s Phone');
xlabel('elevation(m)');
ylabel('B_abs(micro Teslas)');

figure(3)

errorbar(1:4,BData(:,8),BData(:,9),'b');
hold on
errorbar(1:4,CData(:,8),CData(:,9),'k');
title('elevation detection comparision');
legend('Bryan''s phone','Cesar''s Phone');
xlabel('floor number');
ylabel('elevation (m)');
xlim([-0.5 5]);
ylim([-45 20]);