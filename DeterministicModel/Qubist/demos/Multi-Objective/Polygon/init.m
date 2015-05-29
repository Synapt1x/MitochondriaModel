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

ND=10; % The maximum number of dimensions.

extPar.vertices{1}=10*(rand(ND,1)-0.5);
extPar.vertices{2}=10*(rand(ND,1)-0.5);
extPar.vertices{3}=10*(rand(ND,1)-0.5);
extPar.vertices{4}=10*(rand(ND,1)-0.5);
extPar.vertices{5}=10*(rand(ND,1)-0.5);
