%
% Simulation of a graviwave packet
% How it works:
%  (1) start with an initial sea surface heigh as function of x
%  (2) Fourier transform it to get the amplitudes of the sines
%      and cosines as a function of wave number (k)
%  (3) Multiply each wave by a phase shift according to its
%      phase speed and a time increment (dt)
%  (4) Inverse Fourier transform the result to get back the 
%      sea surface height 
%  (5) Plot the new sea surface height
% If the animation is too slow or too fast adjust the
% number of meshpoints (N) or the time step size (dt)
% making N smaller and dt bigger will make the movie faster
% making N bigger and dt smaller will make the movie faster 
%  (and more accurate)
% deep water wave dispersion relation
H = 0.01;
g = 9.8; % (N/kg)
         
%omega = @(k) sqrt(g*H)*k; % (1/s) shallow water limit
omega = @(k) sqrt(g*k); % (1/s)

% make a mesh in real space
N = 2^9+1; % number of mesh points
x = linspace(0,2*pi,N); % position (m)
x = x(1:end-1);
%
dt = 0.002;  % time step (s)
k = 1:(N-1)/2; % wave numbers

% initial hump of water
eta = exp(-(x-pi).^2/0.025^2); % (m)
k = k(1:end-1);
% phase shift in a time step of dt as a function of wave 
% number arranged to conform with Matlab's fft output
G = exp([0,-i*omega(k),0,...
          -i*fliplr(omega(k))]*dt);

% Fourier transform the initial sea surface
etahat = fft(eta);
n = (N-1)/2;
ir = 2:n;
il = (N-1):-1:(N-1)/2+1;
for ii = 1:5000
    % propagate the wave numbers at their own speed
    etahat = etahat.*G;
    eta = real(ifft(etahat));
    % plot the new sea surface height
    plot(x,eta);
    axis([0 2*pi -1 1])
    drawnow    
end
