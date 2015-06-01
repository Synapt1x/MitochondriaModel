%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2015. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function [t,V]=binary(extPar)
global binaryPar2
% Function to compute velocity curves for a spectroscopic binary star
% system, for orbital parameters given in extPar.  This function is called
% by init when preparing an artificial data set, to which noise is added.
% It is also called by binaryFitness for each parameter set evaluated by
% Ferret.

% Extract binary star parameters and convert to cgs units:
binaryPar=extPar.binaryPar;
binaryPar.phi=binaryPar.phi*extPar.K.deg; % Orbital phase
binaryPar.m1=binaryPar.m1*extPar.K.Msol; % Mass or star #1
binaryPar.m2=binaryPar.m2*extPar.K.Msol; % Mass of star #2
binaryPar.a=binaryPar.a*extPar.K.AU; % Semi-major axis
%
% Standard treatment of a 2-body orbit problems converts it mathematically
% to an efective 1-body problem, where the masses are replaced by an
% "reduced mass" equal to binary.mu below:
binaryPar.M=binaryPar.m1+binaryPar.m2; % Sum of masses (convenience variable)
binaryPar.mu=binaryPar.m1*binaryPar.m2/binaryPar.M; % Effective mass
binaryPar.L=binaryPar.mu*sqrt(extPar.K.G*binaryPar.M*binaryPar.a*(1-binaryPar.e^2)); % Angular momentum
binaryPar2=binaryPar;

% Call the integrator.  We request output at the times in the vector
% extPar.data.t, which was prepared in the init file.
options=odeset('Vectorized','on','AbsTol',extPar.int.absTol,'RelTol',extPar.int.relTol);
[t,theta]=ode45(@derivs,extPar.data.t,0,options,binaryPar);
theta=theta';
r=binaryPar.a*(1-binaryPar.e^2)./(1+binaryPar.e*cos(theta));

% Calculate the velocities.
vtheta=binaryPar.L/binaryPar.mu./r;
dr_dtheta=binaryPar.a*(1-binaryPar.e^2)*binaryPar.e*sin(theta)./...
    (1+binaryPar.e*cos(theta)).^2;
dtheta=binaryPar.L/binaryPar.mu./r.^2;
vr=dr_dtheta.*dtheta;

% Convert to Cartesian.
vx=vr.*cos(theta)-vtheta.*sin(theta);
vy=vr.*sin(theta)+vtheta.*cos(theta);
vz=zeros(size(vx));
V=[vx;vy;vz];

% Rotate the plane.
Rz=[[cos(binaryPar.phi),-sin(binaryPar.phi),0];[sin(binaryPar.phi),cos(binaryPar.phi),0];[0,0,1]];
cosi=sqrt(1-binaryPar.sini^2);
Rx=[[1,0,0];[0,cosi,-binaryPar.sini];[0,binaryPar.sini,cosi]];
V=Rx*Rz*V;

% Determine the "z" component of the velocity for the 2 stars, which is observable
% by the Doppler effect.  Note that we must convert back from our effective 1-body
% system to the actual 2-body system that is observed.
vz=V(3,:); % Effective y velocity for 1-body system
vz1=-binaryPar.mu/binaryPar.m1*vz; % Real vlocity of star #1 
vz2=binaryPar.mu/binaryPar.m2*vz; % Real velocity of star #2
V=[vz1;vz2]; % Combine these into a matrix.


function dtheta=derivs(t, Y, binaryPar)
% Derivatives function for the numerical integrator.
%
theta=Y(1,:);  % Angle in radians
r=binaryPar.a*(1-binaryPar.e^2)./(1+binaryPar.e*cos(theta)); % Radius
dtheta=binaryPar.L./(binaryPar.mu*r.^2); % dtheta/dt
