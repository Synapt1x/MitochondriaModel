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

extPar.K0=defaultPar;
extPar.r=linspace(0.05, extPar.K0.rMax, extPar.K0.N);
extPar=fakeData(extPar);

% figure(1); plot(extPar.r,extPar.rho0, extPar.r,extPar.rho,'r+');

% ===========================================================================
% Specify directory names.`
% extPar.dataDir='/Users/fiege/Documents/junk/FerretData';
% extPar.scratchDir='/Users/fiege/Documents/junk/scratch';
