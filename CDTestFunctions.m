begX      =   0;
endX      =   1;
resX      =   1;
begY      =   0;
endY      =   1;
resY      =   1;
begZ      =   0;
endZ      =   1;
resZ      =   1;

CDDiscretize;

%A = x + y + z;
A = zeros(nX,nY,nZ);
gradAnA =A;
%AH = zeros(nX,nY);
%gradAnAH =AH;
for x = 1:nX
	  for y=1:nY
%		  A(x,y,:) = (Xt(x) + Yt(y) );
%		  gradAnA(x,y,:) = 2;


	  	  for z=1:nZ
		  A(x,y,z) = (Xt(x)*Xt(x) + Yt(y)* Yt(y) + Zt(z)*Zt(z));
		  gradAnA(x,y,z) = 2*(Xt(x) + Yt(y) + Zt(z));
end
end
end
A2 = [A(:),A(:),A(:)];
%AH2 = repmat(AH2,1,1,nZ);
%gradNumAH = 0*AH2;
gradNumA =CGrad3D*A2;
%gradNumAH(:)=CGradH*AH2(:);
%gradNumAH = repmat(gradNumAH,1,1,1,nz);

figure(1)
contourf(Xt(:),Yt(:),A(:,:,1),'edgecolor' ,'none');
colorbar
title('Function A');

figure(2);
subplot(2,1,1);
contourf(gradAnA(:,:,1),'edgecolor' ,'none');
title('Analytical gradient');
colorbar

subplot(2,1,2);
contourf(gradNumA(:,:,1),'edgecolor' ,'none');
title('Numerical gradient');
colorbar






