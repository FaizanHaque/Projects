%
% CDDiscretize creates vectors which will be used to create spherical
% derivative operators in cartesian coordinates
%
% Author: 
%   - Syed Faizanul Haque
%
% Use as:
%
% Inputs:
%
% begX      =   first value for x
% endX      =   last value for x
% resX      =   resolution for x
% begY   =   first value for y
% endY   =   last value for y
% resY   =   resolution for y
% begZ      =   first value for z
% endZ      =   last value for z
% resZ      =   resolution for z


%--------------------------------------------------------------------------
%                                  Constants                              %
%--------------------------------------------------------------------------



%Create x, y and z vectors
Xt = [begX:resX:endX]';
Yt = [begY:resY:endY]';
Zt = [begZ:resZ:endZ]';
nX = length(Xt); %length of x vector
nY = length(Yt); %length of y vector
nZ = length(Zt); %length of y vector

%Create ones vectors of the length as the dimensions
eX = ones(nX,1);
eY = ones(nY,1);
eZ = ones(nZ,1);

%--------------------------------------------------------------------------
%                       Sparse Matrice Operator                           %
%--------------------------------------------------------------------------

%d0 returns a sparse matrix with x down the main diagnol
d0 = @(x) spdiags(x(:),0,length(x(:)),length(x(:)));

%--------------------------------------------------------------------------
%                       Discretized derivative vectors                     %
%--------------------------------------------------------------------------

%dX
dXt = Xt([2:end,1]) - Xt; 
dX = zeros( nX,1,1); 
dX(:,1,1)= dXt; 
dX = dX(:,eY,eZ);

%dX
dYt = Yt([2:end,1]) - Yt; 
dY = zeros(1, nY,1); 
dY(1,: ,1)= dYt; 
dY = dY(eX,:,eZ);


%dz
dZt = Zt([2:end,1]) - Zt; 
dZ = zeros(1,1, nZ); 
dZ(1,1,:) = dZt; 
dZ = dZ(eX,eY,:);

%Gradient factors
DiFactor = d0(1./(dX));
DjFactor = d0(1./ (dY));
DkFactor = d0(1./dZ);


%Setup the multiplying factors for the operators
II = zeros (nX,nY,nZ);
II(:) = 1:nX*nY*nZ;

%The lower case are the indices
iE = II (:, [ 2:end,1],:);
iW = II (:, [ end, 1:end-1],:);
iN = II ( [ 2:end,1],:,:);
iS = II ( [ end, 1:end-1],:,:);
iD = II (:,:, [ 2:end,1]);
iU = II (:,:, [ end, 1:end-1]);

%Create a sparse identity matrix (only stores the nonzero values)
I = speye(nX*nY*nZ); %

%
IE= I(iE(:),:);
IW= I(iW(:),:);
IN= I(iN(:),:);
IS= I(iS(:),:);
IU= I(iU(:),:);
ID= I(iD(:),:);

%Derivatives with respect to the indices
FDj = IE - I;
FDi = IN - I;
FDk = ID - I;

%Derivatives with respect to the indices
BDj = abs(IW - I);
BDi = abs(IS - I);
BDk = abs(IU - I);


%Backward derivative
BDX = BDi.*DiFactor;
BDY = BDj.*DjFactor;
BDZ = BDk.*DkFactor;

%Forward derivative
FDX = FDi.*DiFactor;
FDY = FDj.*DjFactor;
FDZ = FDk.*DkFactor;

%Central Derivatives:
CDX = 0.5*[FDX - BDX];
CDY = 0.5*[FDY - BDY];
CDZ = 0.5*[FDZ - BDZ];

%Double Derivatives
FDDZ = FDk.*DkFactor.*DkFactor;
BDDZ = BDk.*DkFactor.*DkFactor;
CDDZ = 0.5* [FDDZ - BDDZ];


%------------------------Derivatives------------------%
CGradH = [CDX; CDY];
CGrad3D = [CDX; CDY; CDZ];
CDivH = [CDX, CDY];
CDiv3D = [CDX, CDY, CDZ];
CCurlH = [CDY,-CDX]';
%CLapH = CDivH*CGradH;
%CLap3D = CDiv3D*CGrad3D;
