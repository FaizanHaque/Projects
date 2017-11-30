%Radius of the earth
a = 6371; % in km

tic

%dzero returns a sparse matrix (?)
d0 = @(x) spdiags(x(:),0,length(x(:)),length(x(:)));




% setup the multiplying factors for the operators
zt = [0;5;10;15;20;25;30;35;40;45;50;55;60;65;70;75;80;85;90;95;100;125;...
    150;175;200;225;250;275;300;325;350;375;400];


nz = length(zt);
lambda_beg = 0.5;
lambda_end = 49.5;

phi_beg = 0.5;
phi_end = 49.5;
lambdat = [lambda_beg:1:lambda_end]';
phit = [phi_beg:1:phi_end]';
nlambda = length(lambdat);
nphi = length(phit);

elambda = ones(nlambda,1);
ephi = ones(nphi,1);
ez = ones(nz,1);

dphit = phit([2:end,1]) - phit; 
dphi = zeros( nphi,1,1); 
dphi(:,1,1)= dphit; 
dphi = dphi(:,elambda,ez);


dlambdat = lambdat([2:end,1]) - lambdat; 
dlambda = zeros(1, nlambda,1); 
dlambda(1,:,1)= dlambdat; 
dlambda = dlambda(ephi,:,ez);


dzt = zt([2:end,1]) - zt; 
dz = zeros(1,1, nz); 
dz(1,1,:) =dzt; 
dz = dz(ephi,elambda,:);


Difactor = d0(1./ (a.*dphi));
Djfactor =  d0(1./(a.*(cos(dphit).*dlambda))); %is this the correct dphit?
Dkfactor = d0(1./dz);


%Initialize nmax
%ny = 5;
%nx =4 ;
%nz = 102;

%Ii = zeros(ny,1,1);
%Ii = 1:ny;
%Ii (:,ones (nx,1),ones(nz,1));

%[Ij,Ii,Ik] = meshgrid(1:nx,1:ny,1:nz


%II = zeros (ny,nx,nz);
%II(:) = 1:ny*nx*nz;

II = zeros (nphi,nlambda,nz);
II(:) = 1:nphi*nlambda*nz;


%The lower case are the indices
iE = II (:, [ 2:end,1],:);
iW = II (:, [ end, 1:end-1],:);
iN = II ( [ 2:end,1],:,:);
iS = II ( [ end, 1:end-1],:,:);
iD = II (:,:, [ 2:end,1]);
iU = II (:,:, [ end, 1:end-1]);

%Need an sparse identity matrix (only stores the nonzero values
%I = speye(ny*nx*nz);
I = speye(nphi*nlambda*nz);
%
IE= I(iE(:),:);
IW= I(iW(:),:);
IN= I(iN(:),:);
IS= I(iS(:),:);
IU= I(iU(:),:);
ID= I(iD(:),:);


%
%a= 6371 e3;
%Latitude
%phi = -89.5:1:89.5;
%Longitude

%Derivatives with respect to the indices
FDj = IE - I;
FDi = IN - I;
FDk = ID - I;


%Derivatives with respect to the indices
BDj = abs(IW - I);
BDi = abs(IS - I);
BDk = abs(IU - I);


%Derivatives

BddPhi = BDi.*Difactor;
BddLambda = BDj.*Difactor;
BddZ = BDk.*Dkfactor;

FddPhi = FDi.*Difactor;
FddLambda = FDj.*Difactor;
FddZ = BDk.*Dkfactor;

%Central Derivatives:

CDPhi = 0.5*(BddPhi+FddPhi);
CDLambda = 0.5*(BddPhi+FddLambda);
CDZ = 0.5*(BddZ + FddZ);


%Secondorder Derivatives
D2Phi = FddPhi*BddPhi;
D2Lambda = FddPhi*BddLambda;
D2Z = FddZ*BddZ;

D2PhiBF = BddPhi*FddPhi;
D2LambdaBF = BddPhi*FddLambda;
D2Z = BddZ*FddZ;


%nabla-operators
FgradH = [FddPhi, FddLambda]';
BgradH = [BddPhi, BddLambda]';
CgradH = [CDPhi, CDLambda]';



FcurlH = [-FddPhi, FddLambda];
BcurlH = [-BddPhi, BddLambda];
CcurlH = [-CDPhi, CDLambda];


[CcurlHn,CcurlHm] = size(CcurlH)
%CcurlHField = repmat(CcurlH,nz);

% CcurlHField = spalloc(CcurlHn,CcurlHm,nz);
% for i = 1:nz
%     CcurlHField(:,:,i) = CcurlH;%[-CDPhi, CDLambda];
% end



LaplacianH = D2Phi + D2Lambda;
Laplacian3D = D2Phi + D2Lambda + D2Z;
