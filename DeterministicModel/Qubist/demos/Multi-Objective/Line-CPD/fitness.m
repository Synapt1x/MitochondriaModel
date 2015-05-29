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

function F=fitness(X,extPar)
% Qubist demo fitness function.

activeGenes=[1,2];

x=X(activeGenes(1),:);
y=X(activeGenes(2),:);

q=2;
F1=((abs(x+8).^q+abs(y-5).^q)).^(1/q);
F2=((abs(x-8).^q+abs(y+3).^q)).^(1/q);

F=[F1;F2];

F(isnan(F))=Inf;
