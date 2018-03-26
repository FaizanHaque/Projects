x = -2*pi:0.1:2*pi;
y = -4:0.1:4;
y = y';
U = 1;
k = 1;
A = 1;
psi = zeros(length(y),length(x));
for i = 1:length(y)
    for j = 1:length(x)
        psi(i,j) = -U*y(i) + A*sin(k*x(j));
    end
end
figure(2)
contour(x,y,psi);
xlabel('x');
ylabel('y');
title(' Question 1 part b');
