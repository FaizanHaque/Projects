tic
B_k = xlsread('bryandata_neat.xlsx');
toc
tic
tEnd = 4;
yDis= 23 ;
xDis= 23;

%yDis= 22.5 ;
%xDis= 14.5;
B_k(:,5) = (B_k(:,5)+23)/xDis;
B_k(:,6) = (B_k(:,6))/yDis;
Bx = zeros(5,5,tEnd);
By = zeros(5,5,tEnd);
Bz = zeros(5,5,tEnd);
Babs = zeros(5,5,tEnd);
for t = 1:tEnd
    
Bx_temp = accumarray([B_k(((t-1)*25+1):t*25,5),B_k(((t-1)*25+1):t*25,6)],B_k(((t-1)*25+1):t*25,2),[5,5]);
Bx(:,:,t)= Bx_temp;

By_temp = accumarray([B_k(((t-1)*25+1):t*25,5),B_k(((t-1)*25+1):t*25,6)],B_k(((t-1)*25+1):t*25,3),[5,5]);
By(:,:,t)= By_temp;


Bz_temp = accumarray([B_k(((t-1)*25+1):t*25,5),B_k(((t-1)*25+1):t*25,6)],B_k(((t-1)*25+1):t*25,3),[5,5]);
Bz(:,:,t)= Bz_temp;


Babs_temp = accumarray([B_k(((t-1)*25+1):t*25,5),B_k(((t-1)*25+1):t*25,6)],B_k(((t-1)*25+1):t*25,1),[5,5]);
Babs(:,:,t)= Babs_temp;

end
%B_k(:,5) = (B_k(:,5)+23)/23;
X = ones(5,5);
Y = ones(5,5);
Z = zeros(5,5);
for i = 1:5
X(i,:) = i*xDis;
Y(:,i) = i*yDis;
end

cTitles = ["Absolute Magnetic Field Strength at 11:12pm Sunday 78F ","Absolute Magnetic Field Strength at 2:04pm Monday 77F"," Absolute Magnetic Field Strength at 11:11pm Monday 75F","Absolute Magnetic Field Strength at 3:20 pm 77 F"];
qTitles = ["Magnetic Field at 11:12pm Sunday 78F ","Magnetic Field at 2:04pm Monday 77F","Magnetic Field at 11:11pm Monday 75F","Magnetic Field at 3:20 pm 77 F"];

cLayers = 60:125;
for time = 1:tEnd
figure(time)
%    zlim([-3 3])

quiver3(X,Y,Z,Bx(:,:,time),By(:,:,time),Bz(:,:,time),0.3);
zticks([]);
xlabel('cm');
ylabel('cm');

%hold on
rotate3d on
title(qTitles(time));

%drawnow

figure(time + 4)
[C,h]=contourf(X,Y,Babs(:,:,time),cLayers ,'edgecolor','none');
C_bar = colorbar;
colormap(flipud(hot));
xlabel('cm');
ylabel('cm');
clabel(C,h);
ylabel(C_bar,'Magnetic field strenght (?Tesla)')
%ylabel(C,'Magnetic field strenght (?Tesla)', 'FontSize',15);

title(cTitles(time));

end

toc