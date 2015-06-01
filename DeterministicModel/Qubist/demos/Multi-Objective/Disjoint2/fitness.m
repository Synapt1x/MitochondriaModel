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
% Qubist demo fitness function.

[NGenes,N]=size(X);
F1=zeros(1,N);
%
index=(X <= 1); F1(index)=-X(index);
index=(X > 1) & (X <= 3); F1(index)=-2+X(index);
index=(X > 3) & (X <= 4); F1(index)=4-X(index);
index=(X > 4); F1(index)=-4+X(index);

F2=(X-5).^2;

F=[F1;F2];
