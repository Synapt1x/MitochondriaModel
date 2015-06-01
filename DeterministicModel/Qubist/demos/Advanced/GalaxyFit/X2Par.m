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

function K=X2Par(X,extPar)

% Disk parameters:
K.logI0=X(1);
K.Rd=X(2);
%
% Sersic bulge parameters:
K.logIe=X(3);
K.Re=X(4);
K.n=X(5);
K.bn = 1.9992*K.n - 0.3271;
