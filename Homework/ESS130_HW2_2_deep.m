H= 4000;%4000; %meters
a = 1;
lambda = 1000;
k = 2*pi/lambda;
g = 9.81;%9.81;%m/s
omega = sqrt(g*k);
A =a*omega;
%http://www.mathcentre.ac.uk/resources/workbooks/mathcentre/hyperbolicfunctions.pdf

x0 = 0;
z0 = 0;
za0 = -50;
zb0 = -100;

tf = 30;
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
z(2) = w(x(1),z(1),t(1),t(2),A,k,omega);
za(1)= za0;
za(2) = w(xa(1),za(1),t(1),t(2),A,k,omega);
zb(1)= zb0;
zb(2) = w(xb(1),zb(1),t(1),t(2),A,k,omega);

x(2) = u(x(1),z(1),t(1),t(2),A,k,omega);
xa(2) = u(xa(1),za(1),t(1),t(2),A,k,omega);
xb(2) = u(xb(1),zb(1),t(1),t(2),A,k,omega);

%x(2) = u(x(1),z(1),t(1),t(2));
for i = 3:(length(t))
x(i) = u(x(i-2),z(i-2),t(i-2),t(i),A,k,omega);
z(i) = w(x(i-2),z(i-2),t(i-2),t(i),A,k,omega);
za(i) = w(xa(i-2),za(i-2),t(i-2),t(i),A,k,omega);
zb(i) = w(xb(i-2),zb(i-2),t(i-2),t(i),A,k,omega);
xa(i) = u(xa(i-2),za(i-2),t(i-2),t(i),A,k,omega);
xb(i) = u(xb(i-2),zb(i-2),t(i-2),t(i),A,k,omega);
end

% figure(1)
% subplot(2,3,1)
% plot(x,z)
% ylabel('Heigth(m)')
% xlabel('Horizontal Distance')
% title('Deep Water: Right to Left, z0=0')
% 
% %figure(2)
% subplot(2,3,2)
% 
% plot(x,za);
% ylabel('Heigth(m)')
% xlabel('Horizontal Distance')
% title('Deep Water:Right to Left, z0=-1/k')
% 
% %figure(3)
% subplot(2,3,3)
% 
% plot(x,zb);
% ylabel('Heigth(m)')
% xlabel('Horizontal Distance')
% title('Deep Water: Right to Left, z0=-2/k')

figure(2)
subplot(3,2,2)
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
%title('z0=-5m')
str = num2str(z0);

title(['z0=' str]);

%figure(2)
subplot(3,2,4);
plot(xa,za,'b');
ylabel('Heigth(m)')
xlabel('X [m]')
%axis([-1 1  -501 -499])
%xlim([-1 1 ])
axis equal
stra = num2str(za0);

title(['z0=' stra]);
%figure(3)
subplot(3,2,6);
plot(xb,zb);
ylabel('Heigth(m)')
xlabel('X [m]')
%axis([-1 1  -1001 -999])
axis equal
%xlim([-1 1 ])

strb = num2str(zb0);

title(['z0=' strb]);

%title('z0=-2/k')
dim = [.75 .465 .773 .5];
str = 'Deep Water: Right to Left';
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%for i = 2:(tf+1)
%x(i) = u(x(i-1),z(i-1),t(i-1),t(i),A,k,H,omega);
%z(i) = w(x(i-1),z(i-1),t(i-1),t(i),A,k,H,omega);
%end


function [x2] = u(x1,z1,t1,t2,A,k,omega)
x2 =  abs(t2-t1)*A*exp(k*(z1))*cos(k*x1+omega*t1)+x1;
end

function [z2] = w(x1,z1,t1,t2,A,k,omega)
z2 = abs(t2-t1)*A*exp(k*(z1))*sin(k*x1+omega*t1)+z1;
end
