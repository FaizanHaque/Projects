tic
B_k = xlsread('bryandata_neat.xlsx');
toc
tEnd = 3;
B_k(:,5) = (B_k(:,5)+23)/23;
B_k(:,6) = (B_k(:,6))/23;
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
X(i,:) = i*23;
Y(:,i) = i*23;
end


for time = 1:tEnd
zlim([-3 3])
quiver3(X,Y,Z,Bx(:,:,time),By(:,:,time),Bz(:,:,time),0.3);
%hold on
rotate3d on
drawnow

end
