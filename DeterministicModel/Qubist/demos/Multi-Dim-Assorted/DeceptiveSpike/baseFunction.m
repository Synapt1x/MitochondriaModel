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

function F=baseFunction(X)

A=3; X0=0.1; sigma=0.05;
NDim=size(X,1);
rsq=sum(X.^2,1); rsq0=NDim*X0^2;
G=A*rsq0*exp(-sum((X-X0).^2/sigma^2,1));
F=rsq-G;
