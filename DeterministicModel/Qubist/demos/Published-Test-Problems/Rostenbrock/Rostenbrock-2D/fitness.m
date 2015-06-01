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

function F=fitness(X)
% Rostenbrock functions are classic unimodal functions used to test global
% optimization routines.  They have a single minimum inside of a very narrow
% valley.  The solution is f(1,...1)=0.

Xi=X(1:end-1,:);
F=sum(100*(Xi.^2-X(2:end,:)).^2+(1-Xi).^2, 1);
