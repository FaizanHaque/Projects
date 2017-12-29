%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  Constants                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tau = 1;
U = 0.0;
L = 1;
k = 2*pi/L;
s = 0.001; %standard deviation
Nt = 2e3; %number of bugs
%Nt = 2e4;
q = 1/3; %bug dies
p = 1/3; %bug reproduces
niter = 100; %number of iterations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Create Initial Set of Bugs                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Generate original x and y positions for the brownian bugs with no
%correlations
x0 = rand(Nt,1);
y0 = rand(Nt,1);

%Create matrix to store updated x and y positions and initialize with
%original x and y positions
x = zeros(Nt,2);
x(:,1) = x0;
y = zeros(Nt,2);
y(:,1) = y0;
%Create colormap
cMap = zeros(Nt,6);
cMap(:,1:3) = flipud(jet(Nt)).*[(y0 - min(y0))/range(y0)*Nt + 1];
cMap = cMap/(max(max(cMap)));
cMap0 = cMap;
colorsMap  = [(y0 - min(y0))/range(y0)*Nt + 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Update Bug Position                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
%Create population count vector
populationCount = zeros(niter+1,1);
populationCount(1,1) = Nt;
%Create d vector by weighted sampling
bugStates = [0 1 2];
%probs = [p q 1-p-q];
probs = [q 1-p-q p];


%Code from: https://stackoverflow.com/questions/11308366/best-way-to-count-all-elements-in-a-cell-array
for iter = 1:niter
    pc = cumsum(probs) / sum(probs);
    r = rand(1,length(x));
    d = zeros(1,length(x));
    for i = length(pc):-1:1
        d(r<pc(i)) = bugStates(i);
    end
        
    %Find which bugs die, live or reproduce
    pos0 = find(d==0);
    pos1 = find(d==1);
    pos2 = find(d==2);
    
    %Update x position of dying and reproducing bugs
    x(pos0,1) = 0;
    x(pos2,2) = x(pos2,1);
    
    %Update y position of dying and reproducing bugs
    y(pos0,1) = 0;
    y(pos2,2) = y(pos2,1);
    
    %Update colors of dying and reproducing bugs
    cMap(pos2,4:6) = cMap(pos2,1:3);
    
    cMap(pos0,1:3) = 0;
    %cMap(pos0,:) = [];
    cMap2 = zeros(length(pos1)+2*length(pos2),3);
    for colr = 1:length(pos1)
        cMap2(colr,1:3) = cMap(pos1(colr),1:3);
    end
    for colr = 1:length(pos2)
        cMap2(colr+length(pos0),1:3) = cMap(pos2(colr),1:3);
    end
    for colr = 1:length(pos2)
        cMap2(colr+length(pos2)+length(pos0),1:3) = cMap(pos2(colr),1:3);
    end
    
    x2 = x(find(x>0));
    y2 = y(find(y>0));
    normalVecX = 0 + s * randn(length(x2),1);
    normalVecY = 0 + s * randn(length(y2),1);
    phi = rand(length(y2),1)*2*pi;
    
    x2(:) = mod((x2(:) + 0.5*U*tau*cos(k*y2(:) + phi(:)) + normalVecX(:)),1);
    y2(:) = mod((y2(:) + 0.5*U*tau*cos(k*x2(:) + phi(:)) + normalVecY(:)),1);
    
    %  y2(:)    <- (y + 0.5*U*tau*cos(k*x + phi) + rnorm(Nt,0,s)) %% 1
    
    x = zeros(length(x2),2);
    x(:,1) = x2;
    y = zeros(length(y2),2);
    y(:,1) = y2;
    
    cMap = zeros(length(cMap2),6);
    cMap(:,1:3) = cMap2(:,1:3);
    
    populationCount(iter+1,1) =  length(y2);
    clear pos0
    clear pos1
    clear pos2
end
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  Plotting                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
subplot(2,2,1);
plot(x0,y0, 'b.');
subplot(2,2,2);
imagesc(cMap0(:,1:3))
subplot(2,2,3);
plot(x2,y2, 'b.');
subplot(2,2,4);
imagesc(cMap(:,1:3))

figure(2);
plot(1:niter+1,populationCount(:,1));

%figure(3);
%rgbplot(cMap2)