H= 4000;%4000; %meters
a = 1;
lambda = 100000;
k = 2*pi/lambda;
g = 9.81;%9.81;%m/s
omega = -sqrt(g*(k^2)*H);
A = -omega*a/(k*H);
x0 = 0;
z0 = 0;
za0 = -50;
zb0 = -100;
tf = 10000;
dt = 0.001;
t = 0:tf;
x = 0*t;
z= 0*t;
za = z;
zb = z;

x(1) = x0;
z(1)= z0;
x(2) = u(x(1),z(1),t(1),t(2),A,k,H,omega);
z(2) = w(x(1),z(1),t(1),t(2),A,k,H,omega);
za(1)= za0;
za(2) = w(x(1),za(1),t(1),t(2),A,k,H,omega);
zb(1)= zb0;
zb(2) = w(x(1),zb(1),t(1),t(2),A,k,H,omega);

%x(2) = u(x(1),z(1),t(1),t(2));
for i = 3:(length(t))
x(i) = u(x(i-2),z(i-2),t(i-2),t(i),A,k,H,omega);
z(i) = w(x(i-2),z(i-2),t(i-2),t(i),A,k,H,omega);
za(i) = w(x(i-2),za(i-2),t(i-2),t(i),A,k,H,omega);
zb(i) = w(x(i-2),zb(i-2),t(i-2),t(i),A,k,H,omega);
end
figure(1)
subplot(3,2,1)
plot(x,z,'b')
ylabel('Heigth(m)')
xlabel('X [m]')
axis equal

hold on
%hold on
%plot(x,za);
%plot(x,zb);
%ylabel('Heigth(m)')
%xlabel('Horizontal Distance')
%title('Shallow Water: Left to Right, z0=0')
str = num2str(z0);

title(['z0=' str]);

%title('z0=0')

%figure(2)
subplot(3,2,3);
plot(x,za,'b');
ylabel('Heigth(m)')
xlabel('X [m]')
stra = num2str(za0);
title(['z0=' stra]);
%title('z0=-1/k')
axis equal
%figure(3)
subplot(3,2,5);
plot(x,zb);
ylabel('Heigth(m)')
xlabel('X [m]')

strb = num2str(zb0);

title(['z0=' strb]);
%title('z0=-2/k')
axis equal
dim = [.15 .465 .175 .5];
str = 'Shallow Water: Left to Right';
annotation('textbox',dim,'String',str,'FitBoxToText','on');
function [x2] = u(x1,z1,t1,t2,A,k,H,omega)
x2 =  abs(t2-t1)*A*cos(k*x1-omega*t1) + x1;
end

function [z2] = w(x1,z1,t1,t2,A,k,H,omega)
z2 = abs(t2-t1)*A*(k*(z1+H))*sin(k*x1-omega*t1)+ z1;
end

