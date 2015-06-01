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

function F=fitness(X, extPar)
% Ackley functions are classic multi-modal functions used to test global
% optimization routines.  They have MANY local minima, and the solution is
% is X(0,...0)=0.

n=2;
F=20+exp(1)-20*exp(-0.2*sqrt((1/n)*sum(X.^2,1)))-...
    exp((1/n)*sum(cos(2*pi*X),1));
