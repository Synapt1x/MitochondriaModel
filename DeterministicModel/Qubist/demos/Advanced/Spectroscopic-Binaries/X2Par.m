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

function par=X2Par(X, par)
% Converts Ferret's "X" matrix to a parameter structure that is understood
% by binary.m.
%
par.phi=X(1,:); % Orbital phase
par.sini=X(2,:); % Inclination
par.e=X(3,:); % Eccentricity
par.m1=10.^X(4,:); % Mass of star #1
par.m2=10.^X(5,:); % Mass of star #2
par.a=10.^X(6,:); % Semi-major axis
