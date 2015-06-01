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

function extPar=init
% Initialization function for the spectroscopic binary modeling demo.
%
% Load physical constants.
extPar.K=const;
%
% Prepare artificial data using the following parameters:
extPar.binaryPar.phi=60; % orbital phase (degrees): rotates the orbital plane
extPar.binaryPar.sini=sin(pi/180*45); % inclination (degrees): tilt wrt. plane of the sky.  i=0 ==> orbit in the sky plane.
extPar.binaryPar.e=0.5; % eccentricity: how elliptical are the orbits?
extPar.binaryPar.m1=1; % mass of star #1 (solar mass units)
extPar.binaryPar.m2=2; % mass of star #2 (solar mass units)
extPar.binaryPar.a=1; % semi-major axis of the orbits in AU (astronomical units):
%   --> 1/2 of the long dimension of the elliptical orbits.
%
% Options for the numerical integrator:
extPar.int.absTol=1e-8; % Absolute tolerance
extPar.int.relTol=1e-8; % Relative tolerance
%
% Captions for plotting:
extPar.etc.tCaption='t (yr)'; % x-axis
extPar.etc.vCaption='v (km/s)'; % y-axis
%
% Convert orbital parameters to cgs units:
a=extPar.binaryPar.a*extPar.K.AU; % semi-major axis
m1=extPar.binaryPar.m1*extPar.K.Msol; % Mass #1
m2=extPar.binaryPar.m2*extPar.K.Msol; % Mass #2
%
% Period (from Kepler's Law):
extPar.etc.P=sqrt( 4*pi^2*a^3/extPar.K.G/(m1+m2) ); % Period (seconds)
%
% Prepare artificial data.
extPar.data.Npt=100; % Number of data points requested
extPar.data.t=linspace(0,extPar.etc.P,extPar.data.Npt); % Times at which data are taken
extPar.data.relErr=0.05; % Relative error for added noise
[extPar.data.t, extPar.data.V]=binary(extPar); % Creates the "data"
[extPar.data.V, extPar.data.dV]=addNoise(extPar.data.V, extPar.data.relErr); % Add some Gaussian noise

extPar.dataDir='FerretData3';
extPar.scratchDir='/ramdisk/demo3';
