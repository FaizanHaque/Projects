
%Function
%function [w] = SimplifiedQGOmegaEquation(u,v,rho,f_0,)

%Constants
g = 9.81 ; %m/s^2
rho_0 = 1000; %kg/m^3

%termporary fake data

f_0 = ones(50,50);
v = ones(nphi,nlambda,nz);
u = ones(nphi,nlambda,nz);
rho = ones(nphi,nlambda,nz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Term A:
HorizontalGeostrophicVelocity =  [v , u];

%termA1 = CcurlH*HorizontalGeostrophicVelocity; %Cgradh * ( CcurlH * HorizontalGeostrophicVelocity);
termA1 = CcurlH(:,HorizontalGeostrophicVelocity);
%termA2 = HorizontalGeostrophicVelocity .* termA1;
termA2 = HorizontalGeostrophicVelocity(:,termA1);
termA3 = CDZ * termA2;
termA = f_0 .* termA3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Term B:
termBConst = g/rho_0;
termB1 = CgradH * rho;
termB2 = HorizontalGeostrophicVelocities * termB1;
%termB3 = 
 



%vertical velocity
rhsTerms = termA + termB