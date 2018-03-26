
t = 0:0.1:10;
U = 1;
A = 1;
k = 1;
c1 = -U;
c0 = 0;
c2 = U;
c3 = 3*U;
%(x,y) = (Ut, (Ak/c)*(sin[k(x-ct)] - sin[k(x)] )
x = 0*t;
y0 = 0*t;
y2 = y0; y1=y0; y3 = y0;

x(:) = t(:)*U;
%for c = U, x = Ut, y = Ak/U sin(k(x -U*t))= Ak/U * sin(k(Ut-Ut));
%c = ?U, 0, U, and 3U
y0(:) = (A*k/U)*cos(k*U*t(:));
y1(:) = (A*k/(U-c1))*(sin(k*(U-c1)*t(:))); 
y2(:) = (A*k^2*t(:)); 
y3(:) = (A*k/(U-c3))*(sin(k*(U-c3)*t(:)));

figure(1);
plot(x,y0, 'g');
hold on
plot(x,y1, 'r');
plot(x,y2, 'b');
plot(x,y3, 'k');
legend('c = 0', 'c = -U' , 'c = U', 'c = 3U');
legend boxoff
xlabel('x');
ylabel('y');
title(' Question 1 part d');
