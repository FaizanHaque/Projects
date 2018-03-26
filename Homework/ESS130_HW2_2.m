H= 4000;%4000; %meters
a = 1;
lambda = 100000;
k = 2*pi/lambda;
g = 9.81; %0.00981;%9.81;%m/s
omega = sqrt(g*k*tanh(k*H));
A = a*omega/sinh(k*H);




x0 = 0;
z0 = 0;
za0 = -1/k;
zb0 = -2/k;

tf = 3000;
t = 0:0.1:tf;
x = 0*t;
xa = x;
xb = x;
z= 0*t;
za = z;
zb = z;

x(1) = x0;
xa(1) = x0;
xb(1) = x0;

z(1)= z0;
z(2) = w(x(1),z(1),t(1),t(2),A,k,H,omega);
za(1)= za0;
za(2) = w(xa(1),za(1),t(1),t(2),A,k,H,omega);
zb(1)= zb0;
zb(2) = w(xb(1),zb(1),t(1),t(2),A,k,H,omega);

x(2) = u(x(1),z(1),t(1),t(2),A,k,H,omega);
xa(2) = u(xa(1),za(1),t(1),t(2),A,k,H,omega);
xb(2) = u(xb(1),zb(1),t(1),t(2),A,k,H,omega);

%x(2) = u(x(1),z(1),t(1),t(2));
for i = 3:(length(t))
x(i) = u(x(i-2),z(i-2),t(i-2),t(i),A,k,H,omega);
z(i) = w(x(i-2),z(i-2),t(i-2),t(i),A,k,H,omega);
za(i) = w(xa(i-2),za(i-2),t(i-2),t(i),A,k,H,omega);
zb(i) = w(xb(i-2),zb(i-2),t(i-2),t(i),A,k,H,omega);
xa(i) = u(xa(i-2),za(i-2),t(i-2),t(i),A,k,H,omega);
xb(i) = u(xb(i-2),zb(i-2),t(i-2),t(i),A,k,H,omega);
end

% z= 0*t;
% x(1) = x0;
% z(1)= z0;
% x(2) = u(x(1),z(1),t(1),t(2),A,k,H,omega);
% z(2) = w(x(1),z(1),t(1),t(2),A,k,H,omega);
% %x(2) = u(x(1),z(1),t(1),t(2));
% for i = 3:length(tf)
% x(i) = u(x(i-2),z(i-2),t(i-2),t(i),A,k,H,omega);
% z(i) = w(x(i-2),z(i-2),t(i-2),t(i),A,k,H,omega);
% 
% end
%figure(1)

%plot(x,z,'k');
%xlabel('Horizontal distance [m]');
%ylabel('Height [m]');
%x(t + 2dt) = x(t) + 2*dt*u(t+dt)
%x(t + 3dt) = x(t+dt) + 2*dt*u(t+2dt)
function [x2] = u(x1,z1,t1,t2,A,k,H,omega)
x2 =  abs(t2-t1)*A*cosh(k*(z1+H))*cos(k*x1-omega*t1)/sin(k*H)+x1;
end

function [z2] = w(x1,z1,t1,t2,A,k,H,omega)
z2 = abs(t2-t1)*A*sinh(k*(z1+H))*sin(k*x1-omega*t1)/sin(k*H)+z1;
end
