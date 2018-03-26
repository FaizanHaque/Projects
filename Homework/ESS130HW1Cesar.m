clear, clc
% U, A, k, c are contants, and t = 0
U = 4;
A = 1;%[1 2 3 4 5]; 
k = 2*pi/1;%[1000 200 100 20 4];
t = 0; 
c = 3;
x = -2*pi:1:2*pi;
y = 0:3:15;
sinewave = A*sin(k*x);
figure(1);
plot(x,sinewave), grid on
%psi = U*y + sinewave;
figure(2);
plot (psi)
%contour (x,y,psi);