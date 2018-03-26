%cookbook finite difference SWM for gravity waves
N = 200; %number of mesh points in the domain
L = 1e7; %(m) size of the domain
x = linspace(0,L,N+1);
x = x(1:end-1);
dx = x(2) - x(1);

% 
g = 9.8;% N/Kg gravitational force constant
H = 4e3;% the depth of othe ocean
A= 1e6;%m^2/s eddy diffusivity

%finite difference operators
e = ones(N,1);
%forward difference
Df =spdiags([-e e],[0 1],N,N);
Df(end,1) = 1;
Df = Df/dx;
%backward difference
Db = spdiags([-e e], [-1 0],N,N);
Db(1,end) = -1;
Db = Db/dx;

%2nd Order 2nd derivative
D2 = Df*Db;
I = speye(N);
dt = 60*60; %s time step;
B = I - (dt/2)*A*D2;
C = I + (dt/2)*A*D2;

%Initial condition
h = (x>L/6).*(x<2*L/6); h =h(:);
t = 0;
for i = 1:1000
    t = t+dt;
    h = B\(C*h);%Solve the linear system of equations B*h(n+1) = C*h(n)
    plot(x,h);
    title(num2str(t)); 
    axis([ 0 L 0 1]);
drawnow

end
