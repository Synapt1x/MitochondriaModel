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

function binaryPar=getBinaryPar(X,extPar)
% Uses the n'th parameter set to generate the structure required by
% binary.m to produce a single model.

% Extract binary star parameters and convert to cgs units:
binaryPar.phi=X.phi; % Orbital phase
binaryPar.m1=10^X.log_m1; % Mass or star #1
binaryPar.m2=10^X.log_m2; % Mass of star #2
binaryPar.a=10^X.log_a; % Semi-major axis
binaryPar.e=X.e;
binaryPar.sini=X.sini;
