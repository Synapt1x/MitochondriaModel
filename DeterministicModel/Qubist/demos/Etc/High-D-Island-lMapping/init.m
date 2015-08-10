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

% Dimensionality.
extPar.n=10;

% Number of islands.
extPar.NIslands=10;

% Defined centres, size, orientation, and depth.
extPar.X0=2*rand(extPar.n, extPar.NIslands)-1;
extPar.depth=0.5;
extPar.scale=0.1*abs(randn(1,extPar.NIslands));
